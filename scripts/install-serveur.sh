#!/usr/bin/env bash
# =============================================================================
# Installation de TicketStore sur un serveur Ubuntu 22.04 / 24.04 vierge.
#
# A lancer depuis le dossier du projet, sur le serveur :
#   sudo bash scripts/install-serveur.sh <domaine> <email>
# Exemples :
#   sudo bash scripts/install-serveur.sh ticketstore.mondomaine.fr moi@mail.fr
#   sudo bash scripts/install-serveur.sh 51.210.10.20.sslip.io moi@mail.fr
# =============================================================================
set -euo pipefail

DOMAIN="${1:-}"
EMAIL="${2:-}"

if [[ -z "$DOMAIN" || -z "$EMAIL" ]]; then
  echo "Usage : sudo bash scripts/install-serveur.sh <domaine> <email>"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
  echo "Ce script doit être lancé avec sudo."
  exit 1
fi

if [[ ! -f docker-compose.prod.yml ]]; then
  echo "Lance ce script depuis la racine du projet (là où se trouve docker-compose.prod.yml)."
  exit 1
fi

echo "==> 1/5 Installation de Docker (si absent)"
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
fi
systemctl enable --now docker

echo "==> 2/5 Pare-feu : seuls SSH, HTTP et HTTPS sont ouverts"
if command -v ufw >/dev/null 2>&1; then
  ufw allow OpenSSH
  ufw allow 80/tcp
  ufw allow 443/tcp
  ufw --force enable
fi

echo "==> 3/5 Création du fichier .env"
if [[ -f .env ]]; then
  echo "    .env existe déjà, il est conservé."
else
  gen() { openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c 24; }
  GRAFANA_PWD="$(gen)"
  cat > .env <<EOF
DOMAIN=${DOMAIN}
ACME_EMAIL=${EMAIL}
POSTGRES_USER=ticketstore_user
POSTGRES_PASSWORD=$(gen)
REDIS_PASSWORD=$(gen)
GRAFANA_ADMIN_PASSWORD=${GRAFANA_PWD}
BACKEND_MAX_HEAP=512m
EOF
  chmod 600 .env
  echo "    Mot de passe admin Grafana : ${GRAFANA_PWD}"
  echo "    (il est aussi enregistré dans le fichier .env)"
fi

echo "==> 4/5 Construction et démarrage (plusieurs minutes la première fois)"
docker compose -f docker-compose.prod.yml up -d --build

echo "==> 5/5 Vérification"
sleep 20
docker compose -f docker-compose.prod.yml ps

cat <<EOF

Terminé. Le premier démarrage insère 10 000 événements en base :
compte encore 1 à 3 minutes avant que l'application réponde.

  Application : https://${DOMAIN}
  Grafana     : https://grafana.${DOMAIN}   (lecture seule sans compte, admin/<mot de passe du .env>)

Logs     : docker compose -f docker-compose.prod.yml logs -f
Arrêt    : docker compose -f docker-compose.prod.yml down
EOF

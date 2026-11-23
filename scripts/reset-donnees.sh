#!/usr/bin/env bash
# =============================================================================
# Remet la base de TicketStore à zéro (événements + commandes) et vide le cache,
# sans toucher aux certificats HTTPS ni aux données Grafana/Prometheus.
# Utile si les étudiants ont faussé les stocks (commandes négatives, survente...).
#
#   sudo bash scripts/reset-donnees.sh
# =============================================================================
set -euo pipefail

COMPOSE="docker compose -f docker-compose.prod.yml"
source .env

# backend-2 n'existe qu'avec le profil load-balancing (Partie 3)
BACKENDS="backend-1"
if $COMPOSE ps --services | grep -qx backend-2; then
  BACKENDS="backend-1 backend-2"
fi

echo "==> Arrêt des backends ($BACKENDS)"
$COMPOSE stop $BACKENDS

echo "==> Vidage des tables"
$COMPOSE exec -T postgres psql -U "$POSTGRES_USER" -d ticketstore \
  -c "TRUNCATE TABLE orders, events CASCADE;"

echo "==> Vidage du cache Redis"
$COMPOSE exec -T redis redis-cli -a "$REDIS_PASSWORD" --no-auth-warning FLUSHALL

echo "==> Redémarrage des backends (réinsertion des 10 000 événements)"
$COMPOSE start $BACKENDS

echo "Terminé. Compte 1 à 3 minutes avant que l'application réponde de nouveau."

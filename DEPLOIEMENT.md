# Mettre TicketStore en ligne

Ce guide met l'application à disposition des étudiants sur Internet, en HTTPS, avec :

- l'application sur `https://<domaine>`
- Grafana en lecture seule sur `https://grafana.<domaine>`

Le **code de l'application n'est pas modifié** : les défauts volontaires du TP restent visibles.
Seule l'infrastructure est sécurisée (fichier `docker-compose.prod.yml`).

---

## 1. Louer un serveur (VPS)

N'importe quel hébergeur convient (OVH, Scaleway, Hetzner, etc.).

| Besoin | Minimum conseillé |
|---|---|
| Système | Ubuntu 24.04 (ou 22.04) |
| Mémoire | 4 Go de RAM (jusqu'à 2 backends Java + Postgres + Redis + monitoring) |
| Processeur | 2 vCPU |
| Disque | 20 Go |

Note l'**adresse IP** du serveur et connecte-toi en SSH :

```bash
ssh root@<IP-du-serveur>      # ou ubuntu@<IP> selon l'hébergeur
```

## 2. Choisir l'adresse web

**Option A : un nom de domaine à toi.** Chez ton registrar, crée deux enregistrements DNS de type `A` vers l'IP du serveur :

| Nom | Type | Valeur |
|---|---|---|
| `ticketstore.mondomaine.fr` | A | `<IP-du-serveur>` |
| `grafana.ticketstore.mondomaine.fr` | A | `<IP-du-serveur>` |

**Option B : sans nom de domaine (gratuit).** Utilise le service sslip.io, qui transforme l'IP en nom de domaine sans aucune configuration :
`51.210.10.20.sslip.io` et `grafana.51.210.10.20.sslip.io` pointent automatiquement vers `51.210.10.20`.
Si l'obtention du certificat HTTPS échoue avec sslip.io, passe à l'option A.

## 3. Copier le projet sur le serveur

Le plus simple est de passer par un dépôt Git (il servira aussi plus tard pour donner le code aux étudiants).
Le dépôt peut rester privé pour l'instant.

Sur ton PC, dans le dossier du projet :

```bash
git remote set-url origin https://github.com/<ton-compte>/ticketstore.git
git add .
git commit -m "Ajout de la configuration de production"
git push -u origin master
```

Sur le serveur :

```bash
git clone https://github.com/<ton-compte>/ticketstore.git
cd ticketstore
```

(Pour un dépôt privé, GitHub demande un *personal access token* à la place du mot de passe.)

## 4. Installer et démarrer

Toujours sur le serveur, dans le dossier `ticketstore` :

```bash
sudo bash scripts/install-serveur.sh <domaine> <ton-email>
```

Le script :

1. installe Docker ;
2. ferme tous les ports sauf SSH (22), HTTP (80) et HTTPS (443) ;
3. crée le fichier `.env` avec des mots de passe aléatoires (et affiche celui de Grafana) ;
4. construit et démarre les conteneurs (7 par défaut, 8 avec le second backend de la Partie 3) ;
5. affiche leur état.

La première construction prend plusieurs minutes. Ensuite, le premier backend insère 10 000 événements :
compter encore 1 à 3 minutes avant que le site réponde.

## 5. Vérifier

- `https://<domaine>` affiche la liste des événements.
- `https://grafana.<domaine>` affiche le dashboard TicketStore.
- `docker compose -f docker-compose.prod.yml ps` : tous les services sont `running` / `healthy`.

## 6. Au quotidien

| Action | Commande (dans le dossier `ticketstore` du serveur) |
|---|---|
| Voir les logs | `docker compose -f docker-compose.prod.yml logs -f backend-1` |
| Mettre à jour après un `git push` | `git pull && docker compose -f docker-compose.prod.yml up -d --build` |
| Remettre les données à zéro | `sudo bash scripts/reset-donnees.sh` |
| Tout arrêter | `docker compose -f docker-compose.prod.yml down` |

## Partie 3 du TP : activer le second backend

Par défaut, un seul backend tourne (version de départ du TP). Pour la Partie 3 (Load Balancing) :

```bash
echo "COMPOSE_PROFILES=load-balancing" | sudo tee -a .env
sudo docker compose -f docker-compose.prod.yml up -d --build
```

Traefik répartit alors automatiquement les requêtes `/api` entre `backend-1` et `backend-2`.
Pour revenir à un seul backend : retirer la ligne `COMPOSE_PROFILES` du `.env`, puis
`sudo docker compose -f docker-compose.prod.yml rm -sf backend-2`.

## Ce qui est exposé, et ce qui ne l'est pas

| Composant | Accessible depuis Internet ? |
|---|---|
| Application (front + `/api`) | Oui, en HTTPS |
| Grafana | Oui, en lecture seule sans compte |
| `/actuator`, Prometheus, dashboard Traefik | Non |
| PostgreSQL, Redis | Non (réseau interne Docker uniquement, avec mot de passe) |

## Points d'attention pour le cours

- **Les failles du TP sont accessibles à tous.** Par exemple, une commande avec une quantité négative
  augmente le stock pour tout le monde. Le script `reset-donnees.sh` remet la base à zéro.
- **Les tests de charge des étudiants visent tous le même serveur.** Si 30 étudiants lancent k6 ou JMeter
  en même temps, les résultats se perturbent les uns les autres et le serveur peut saturer.
  Pour les tests de charge, il vaut mieux qu'ils travaillent sur leur propre copie en local.
- Le fichier `.env` contient les mots de passe : il ne doit jamais être commité (il est dans `.gitignore`).

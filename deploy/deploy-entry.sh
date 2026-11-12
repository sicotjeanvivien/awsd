#!/usr/bin/env bash
# deploy/deploy-entry.sh — la seule commande que la clé de déploiement peut lancer.
#
# La clé du workflow .github/workflows/deploy.yml est déclarée sur le serveur
# avec ce script comme commande forcée : ce que le client demande arrive dans
# SSH_ORIGINAL_COMMAND, et seules deux formes passent vers deploy/update.sh :
# un commit (40 caractères hexadécimaux) et `--check`. Tout le reste est
# refusé avant que quoi que ce soit ne tourne. Le compte est dans le groupe
# `docker`, équivalent root : c'est cette liste, pas le compte, qui borne la clé.
#
# Mise en place (hors dépôt, une fois)
# ------------------------------------
# 1. Une clé dédiée, sans phrase de passe (seul GitHub la gardera) :
#      ssh-keygen -t ed25519 -N "" -C github-deploy-awsd -f ~/.ssh/awsd_deploy_ed25519
# 2. Sur le serveur, une ligne dans ~/.ssh/authorized_keys du compte qui
#    déploie (le même que pour Yog-Scope) :
#      restrict,command="/srv/awsd/deploy/deploy-entry.sh" ssh-ed25519 AAAA… github-deploy-awsd
#    `restrict` retire pty, redirections de ports, agent et X11 ; la commande
#    fait de ce script le seul programme que la clé démarre.
# 3. Un environnement `production` du dépôt, que seule `main` peut utiliser,
#    avec trois secrets. DEPLOY_HOST et DEPLOY_KNOWN_HOSTS ont les mêmes
#    valeurs que pour Yog-Scope (même serveur, même compte ; l'hôte est l'IP,
#    pas un nom derrière le proxy Cloudflare) :
#      gh api -X PUT repos/sicotjeanvivien/awsd/environments/production \
#        -F 'deployment_branch_policy[protected_branches]=false' \
#        -F 'deployment_branch_policy[custom_branch_policies]=true'
#      gh api -X POST repos/sicotjeanvivien/awsd/environments/production/deployment-branch-policies -f name=main
#      gh secret set DEPLOY_SSH_KEY     --env production -R sicotjeanvivien/awsd < ~/.ssh/awsd_deploy_ed25519
#      gh secret set DEPLOY_KNOWN_HOSTS --env production -R sicotjeanvivien/awsd < known_hosts
#      gh secret set DEPLOY_HOST        --env production -R sicotjeanvivien/awsd --body 'jv@<ip>'
#    puis supprimer la clé privée en local : seul le workflow en a besoin.
# 4. Après la première image poussée : rendre le paquet GHCR `awsd` public
#    (GitHub → Packages → awsd → Package settings → Change visibility), pour
#    que le serveur le tire sans se connecter à GHCR.
#
# La commande forcée pointe sur ce fichier dans la copie de travail
# /srv/awsd, qui suit `main` : il change avec elle. Déplacer la copie de
# travail oblige à corriger la ligne authorized_keys à la main.
set -euo pipefail

# La chaîne entière est comparée, ancrée aux deux bouts, et les arguments
# sont reconstruits depuis la correspondance, jamais découpés depuis ce que
# le client a envoyé. Dans une regex bash, `$` ancre la fin de la chaîne :
# un retour à la ligne ne peut pas glisser une seconde commande.
cmd=${SSH_ORIGINAL_COMMAND:-}
if [[ $cmd == "--check" ]]; then
  args=(--check)
elif [[ $cmd =~ ^([0-9a-f]{40})$ ]]; then
  args=("${BASH_REMATCH[1]}")
else
  echo "deploy-entry : refusé : « ${cmd} » (admis : un commit de 40 caractères, --check)" >&2
  exit 2
fi

repo=$(dirname "$(dirname "$(readlink -f "$0")")")

# Un déploiement met d'abord la copie de travail à jour (compose.yml, ces
# scripts), puis lance la version de update.sh qui vient d'arriver. git
# remplace les fichiers au lieu de les réécrire : ce script, déjà lu par
# bash, n'est pas modifié sous ses pieds.
if [[ ${args[0]} != --check ]]; then
  git -C "$repo" pull -q --ff-only origin main \
    || { echo "deploy-entry : git pull impossible dans $repo (pas sur main, ou modifications locales ?)" >&2; exit 1; }
fi

exec "$repo/deploy/update.sh" "${args[@]}"

#!/usr/bin/env bash
# deploy/update.sh — met le site en production à un commit de `main`.
#
#   deploy/update.sh <commit>   tire l'image ghcr.io/…/awsd:sha-<commit>,
#                               relance le conteneur, vérifie le site ;
#   deploy/update.sh --check    vérifie seulement ce qui tourne.
#
# Appelé par deploy-entry.sh (la clé de déploiement), ou à la main sur le
# serveur depuis /srv/awsd. Le commit doit être sur origin/main et son image
# avoir été construite par le workflow deploy. Revenir en arrière = relancer
# ce script avec un commit plus ancien (onglet Actions → deploy → rollback).
#
# L'image en service est écrite dans .env (ignoré par git), que compose lit
# tout seul : un `docker compose up -d` à la main garde la même version.
# Si le nouveau conteneur ne répond pas, l'image précédente est remise.
set -euo pipefail

cd "$(dirname "$(dirname "$(readlink -f "$0")")")"

# Surchargeable pour un essai contre un registre local.
IMAGE_REPO=${AWSD_IMAGE_REPO:-ghcr.io/sicotjeanvivien/awsd}
REVISION_LABEL=org.opencontainers.image.revision

log() { printf '%s  %s\n' "$(date -u +%H:%M:%SZ)" "$*"; }
die() { log "ÉCHEC : $*" >&2; exit 1; }

revision_of() { docker inspect -f "{{ index .Config.Labels \"$REVISION_LABEL\" }}" "$1" 2>/dev/null || true; }

# Attend que le conteneur soit sain (healthcheck de compose.yml) : 0 si oui.
wait_healthy() {
  local cid state
  for _ in $(seq 1 30); do
    cid=$(docker compose ps -q awsd)
    if [[ -n $cid ]]; then
      state=$(docker inspect -f '{{ if .State.Health }}{{ .State.Health.Status }}{{ else }}{{ .State.Status }}{{ end }}' "$cid")
      [[ $state == healthy ]] && return 0
    fi
    sleep 2
  done
  return 1
}

check() {
  local cid
  cid=$(docker compose ps -q awsd)
  [[ -n $cid ]] || die "aucun conteneur awsd en service"
  wait_healthy || die "le conteneur awsd n'est pas sain"
  docker compose exec -T awsd wget -q -O /dev/null http://127.0.0.1/ \
    || die "le site ne répond pas dans le conteneur"
  log "en ligne : commit $(revision_of "$cid")"
}

case ${1:-} in
  --check) check; exit 0 ;;
  *) sha=${1:-} ;;
esac
[[ $sha =~ ^[0-9a-f]{40}$ ]] || die "commit invalide : « $sha »"

git fetch -q origin main
git merge-base --is-ancestor "$sha" origin/main 2>/dev/null \
  || die "le commit $sha n'est pas sur origin/main"

image="$IMAGE_REPO:sha-$sha"
log "image $image"
docker pull -q "$image" >/dev/null || die "image introuvable : $image (le workflow l'a-t-il construite ?)"
[[ $(revision_of "$image") == "$sha" ]] || die "l'image ne porte pas le commit $sha"

previous=$(sed -n 's/^AWSD_IMAGE=//p' .env 2>/dev/null || true)
up=(docker compose up -d --no-build --pull never)
# Même image qu'avant (relance d'un déploiement) : compose ne recréerait rien.
[[ $previous == "$image" ]] && up+=(--force-recreate)

printf 'AWSD_IMAGE=%s\n' "$image" > .env.tmp && mv .env.tmp .env
log "remplacement du conteneur"
"${up[@]}"

if ! wait_healthy; then
  if [[ -n $previous && $previous != "$image" ]]; then
    log "le nouveau conteneur n'est pas sain : retour à $previous"
    printf 'AWSD_IMAGE=%s\n' "$previous" > .env.tmp && mv .env.tmp .env
    docker compose up -d --no-build --pull never
    wait_healthy || die "l'image précédente ne repart pas non plus"
  fi
  die "le conteneur de $image n'est pas sain"
fi
check

# Ménage : images awsd inutilisées de plus de 30 jours. Le filtre sur la
# source ne vise que les images de ce dépôt, jamais celles des autres projets.
docker image prune -af \
  --filter "label=org.opencontainers.image.source=https://github.com/sicotjeanvivien/awsd" \
  --filter "until=720h" >/dev/null || true
log "déployé : commit $sha"

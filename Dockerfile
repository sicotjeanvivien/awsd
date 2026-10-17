# Image du site awsd.fr : build Zola, puis Caddy qui sert public/.
#
# Le conteneur ne parle qu'en HTTP sur le port 80 et n'expose aucun port :
# le TLS et l'aiguillage par domaine sont faits par le Caddy d'entrée du
# serveur (dépôt edge), qui le joint par le réseau Docker « edge ».
#
# Versions épinglées : changer de version est une décision, pas l'effet
# d'un pull. Zola doit rester celle utilisée en local (zola --version).
#
# BASE_URL : l'adresse du site, écrite dans tous les liens. Pour tester
# l'image en local :
#   docker build --build-arg BASE_URL=http://127.0.0.1:8080 -t awsd .
#   docker run --rm -p 127.0.0.1:8080:80 awsd

FROM ghcr.io/getzola/zola:v0.23.6 AS zola

# L'image Zola n'a pas de shell, donc pas de variable dans un RUN : le
# binaire (lié à musl) est lancé depuis Alpine, la base de l'image Caddy.
FROM alpine:3.23.6 AS build
ARG BASE_URL=https://awsd.fr
COPY --from=zola /zola /usr/local/bin/zola
WORKDIR /site
COPY . .
RUN zola build --base-url "$BASE_URL"

FROM caddy:2.11.4-alpine
COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=build /site/public /srv

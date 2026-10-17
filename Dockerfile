# Image du site awsd.fr : build Zola, puis Caddy qui sert public/.
#
# Le conteneur ne parle qu'en HTTP sur le port 80 et n'expose aucun port :
# le TLS et l'aiguillage par domaine sont faits par le Caddy d'entrée du
# serveur (dépôt edge), qui le joint par le réseau Docker « edge ».
#
# Versions épinglées : changer de version est une décision, pas l'effet
# d'un pull. Zola doit rester celle utilisée en local (zola --version).

FROM ghcr.io/getzola/zola:v0.23.6 AS build
WORKDIR /site
COPY . .
# Image sans shell : forme exec obligatoire.
RUN ["/zola", "build"]

FROM caddy:2.11.4-alpine
COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=build /site/public /srv

+++
title = "Yog-Scope"
description = "Analyse de liquidité en temps réel pour les pools Meteora sur Solana."
weight = 1

[extra]
summary = "Analyse de liquidité en temps réel pour les pools Meteora sur Solana : indexation on-chain, historique et alertes, dans un dashboard public et gratuit."
status = "production"            # production | development | paused
status_label = "En production"
since = "oct. 2026"
url = "https://yog-scope.xyz"
source = "https://github.com/sicotjeanvivien/yog-sothoth"
platform = "Web"
app_category = "FinanceApplication"   # schema.org
price = 0                        # gratuit (schema.org Offer, en EUR)
kicker = ["Rust", "Solana"]
stack = ["Rust", "Solana", "TimescaleDB"]
crates = ["yog-core", "yog-persistence", "yog-api"]
access = "Gratuit · code public"
flow = ["RPC Solana", "indexeur", "API", "dashboard"]
flow_caption = "flux de données"
# Articles liés : pages du blog portant ce terme dans cette taxonomie.
blog_taxonomy = "categories"
blog_term = "Yog-Sothoth"
facts = [
    { label = "Captation", value = "Temps réel, WebSocket" },
    { label = "Historique", value = "Depuis le 6 oct. 2026" },
    { label = "Signaux", value = "3 détecteurs" },
    { label = "Accès", value = "Gratuit · code public" },
]
features_title = "Ce que fait Yog-Scope"
features = [
    { title = "Observer", text = "Suivi des pools, des changements de liquidité et de l'activité de marché sur Meteora." },
    { title = "Reconstituer", text = "Historique horaire de la liquidité : ajouts et retraits, heure par heure." },
    { title = "Analyser", text = "Détection d'anomalies : déséquilibres de flux, écarts de prix, fuites de TVL." },
    { title = "Signaler", text = "Alertes en temps réel sur les événements clés, classées par niveau de gravité." },
]
pipeline_title = "De la chaîne à l'écran"
pipeline_note = "un indexeur par protocole"
pipeline = [
    { step = "Écouter", text = "Connexion WebSocket permanente à un RPC Solana." },
    { step = "Décoder", text = "Swaps, liquidité, fees, positions, verrous." },
    { step = "Enrichir", text = "Métadonnées des tokens et prix en dollars." },
    { step = "Stocker", text = "Base de données temporelle (TimescaleDB), interrogeable." },
    { step = "Exposer", text = "API HTTP typée et dashboard public, FR / EN." },
]
cta_title = "Le dashboard est public et gratuit."
cta_text = "Aucun compte nécessaire."
+++

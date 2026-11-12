+++
title = "Nova Preem"
description = "Gestionnaire de collection pour le jeu de cartes Cyberpunk TCG, hors ligne et sans compte."
weight = 2

[extra]
summary = "Gestionnaire de collection pour le Cyberpunk TCG : chaque impression d'une carte suivie séparément, complétion par set et par langue. Fonctionne hors ligne, sans compte ni serveur."
status = "production"            # production | development | paused
status_label = "En production"
since = "oct. 2026"
url = "https://nova-preem.app"
source = "https://github.com/sicotjeanvivien/nova-preem"
platform = "Web (PWA) · Android, iPhone, PC"
app_category = "UtilitiesApplication"   # schema.org
price = 0                        # gratuit (schema.org Offer, en EUR)
kicker = ["TypeScript", "PWA"]
stack = ["React", "TypeScript", "Vite", "Dexie", "Cloudflare Pages"]
access = "Gratuit · sans compte"
flow = ["catalogue", "CDN", "app (PWA)", "appareil"]
flow_caption = "flux de données"
facts = [
    { label = "Langues", value = "FR / EN" },
    { label = "Impressions", value = "Retail, Beta, promos, FR / EN" },
    { label = "Réseau", value = "Hors ligne, sans serveur" },
    { label = "Accès", value = "Gratuit · sans compte" },
]
features_title = "Ce que fait Nova Preem"
features = [
    { title = "Recenser", text = "Chaque impression est suivie séparément : Retail, Beta, decks de démarrage et de démo, promos, arts Iconic, en anglais et en français." },
    { title = "Saisir", text = "À l'ouverture d'un booster, un appui sur + par carte. L'annulation tient en un appui." },
    { title = "Compléter", text = "Complétion par set, par sortie et par langue : set jouable, master set, liste des manquantes prête à coller sur Discord, doubles." },
    { title = "Parcourir", text = "La collection en galerie, avec filtres, tris et une vue 3D de chaque carte." },
]
pipeline_title = "Du catalogue à l'appareil"
pipeline_note = "aucune donnée utilisateur hébergée"
pipeline = [
    { step = "Construire", text = "Un pipeline Node normalise les données publiques des cartes : sets, sorties, impressions, traductions." },
    { step = "Publier", text = "Catalogue en JSON statique et images, servis par un CDN." },
    { step = "Installer", text = "L'application web s'installe sur le téléphone ou le PC et garde le catalogue en cache, images comprises au choix." },
    { step = "Enregistrer", text = "La collection reste sur l'appareil (IndexedDB) : identifiants d'impression et quantités. Une mise à jour du catalogue n'y touche pas." },
    { step = "Synchroniser", text = "Export dans un fichier, ou synchronisation facultative avec le Google Drive de l'utilisateur." },
]
cta_title = "Nova Preem s'installe depuis le navigateur."
cta_text = "Aucun compte nécessaire. Android, iPhone et PC."
notice = "Projet de fan, non officiel : ni approuvé ni soutenu par WeirdCo ou CD PROJEKT RED."
+++

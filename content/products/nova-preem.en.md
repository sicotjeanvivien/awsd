+++
title = "Nova Preem"
description = "Collection manager for the Cyberpunk TCG card game, offline and with no account."
weight = 2

[extra]
summary = "Collection manager for the Cyberpunk TCG: every printing of a card tracked separately, completion by set and by language. Works offline, with no account and no server."
status = "production"
status_label = "In production"
since = "Oct. 2026"
url = "https://nova-preem.app"
source = "https://github.com/sicotjeanvivien/nova-preem"
platform = "Web (PWA) · Android, iPhone, PC"
app_category = "UtilitiesApplication"   # schema.org
price = 0                        # gratuit (schema.org Offer, en EUR)
kicker = ["TypeScript", "PWA"]
stack = ["React", "TypeScript", "Vite", "Dexie", "Cloudflare Pages"]
access = "Free · no account"
flow = ["catalog", "CDN", "app (PWA)", "device"]
flow_caption = "data flow"
facts = [
    { label = "Platforms", value = "Android, iPhone, PC" },
    { label = "Printings", value = "Retail, Beta, promos, EN / FR" },
    { label = "Network", value = "Offline, no server" },
    { label = "Access", value = "Free · no account" },
]
features_title = "What Nova Preem does"
features = [
    { title = "Track", text = "Every printing is tracked separately: Retail, Beta, starter and demo decks, promos, Iconic arts, in English and in French." },
    { title = "Enter", text = "Opening a booster: one tap on + per card. Undo is one tap away." },
    { title = "Complete", text = "Completion by set, by release and by language: playable set, master set, missing cards as a list ready to paste on Discord, duplicates." },
    { title = "Browse", text = "The collection as a gallery, with filters, sorting and a 3D view of each card." },
]
pipeline_title = "From catalog to device"
pipeline_note = "no user data hosted"
pipeline = [
    { step = "Build", text = "A Node pipeline normalizes public card data: sets, releases, printings, translations." },
    { step = "Publish", text = "Catalog as static JSON and images, served by a CDN." },
    { step = "Install", text = "The web app installs on a phone or PC and caches the catalog, card images included if wanted." },
    { step = "Record", text = "The collection stays on the device (IndexedDB): printing IDs and quantities. A catalog update never touches it." },
    { step = "Sync", text = "Export to a file, or optional sync with the user's own Google Drive." },
]
cta_title = "Nova Preem installs from the browser."
cta_text = "No account needed. Android, iPhone and PC."
notice = "Fan-made, unofficial project: not approved or endorsed by WeirdCo or CD PROJEKT RED."
+++

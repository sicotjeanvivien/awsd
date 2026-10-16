# Refonte awsd.fr — brief de mise en œuvre (Hugo → Zola)

Ce document est le brief pour l'agent qui réalise la refonte du site awsd.fr.
Les maquettes de référence sont dans `design/maquettes/` (HTML autonome, à ouvrir dans un navigateur).
Lis ce document en entier avant de commencer, puis travaille par étapes (section 8) en t'arrêtant à chaque checkpoint.

---

## 1. Contexte

AWSD (Artisan Web Software Development) est une SASU qui développe et maintient **ses propres produits logiciels**.
Le site actuel présente AWSD comme un prestataire freelance (services, « Nous contacter »). La refonte change l'orientation :

- AWSD = **société logicielle indépendante, orientée produits**. Les produits sont au centre.
- Le freelance est une activité secondaire : **aucune page dédiée**, seulement une ligne dans le pied de page vers Contact.
- Le blog est conservé (ton personnel, à la première personne : ne pas réécrire les articles).
- Produits actuels : **Yog-Scope** (en production, https://yog-scope.xyz) et **Otia** (en développement, app Android).

Le site doit se distinguer nettement de Yog-Scope (dashboard sombre, violet, monospace, ambiance mystique).
La nouvelle identité est **claire, chaude, matérielle** : direction « Atelier + Plan d'architecte ».

## 2. Décisions prises

| Sujet | Décision |
|---|---|
| Générateur | **Zola** (binaire unique, templates Tera). Pas de npm, pas de Tailwind, pas d'Alpine, pas de sous-module de thème. |
| Thème | Thème maison **isolé** dans `themes/atelier/` (pour pouvoir le publier un jour). Ce qui est propre à AWSD (accueil, contenus) reste dans le site. |
| CSS | Un seul fichier Sass compilé par Zola (`sass/`), aucune dépendance. |
| Polices | **Auto-hébergées** (woff2, licence OFL) : Young Serif, Instrument Sans, IBM Plex Mono, Caveat. Aucune requête vers Google Fonts (CSP `font-src 'self'` + RGPD). |
| JavaScript | Aucun, sauf nécessité absolue (menu mobile en HTML/CSS : `<details>` ou checkbox). |
| Ton des textes | **Direct et sobre**, AWSD parle à la **3e personne** (« AWSD développe… »). Pas de métaphore d'atelier dans les textes (pas d'« établi », de « planches », de « règles de la maison »). Exception : les articles du blog restent dans la voix de l'auteur. |
| Langues | FR (défaut, à la racine) + EN (sous `/en/`). |
| Hébergement | Docker multi-stage (build Zola → image Caddy) sur le VPS Scaleway. `sws.toml` (Clever Cloud) est remplacé par un `Caddyfile`. |
| Mode sombre | **Oui, automatique uniquement** : suit `prefers-color-scheme`, sans bouton, sans JavaScript, sans `localStorage`. Palette « papier de nuit » (section 6). |

## 3. Contraintes d'URL (référencement — impératif)

Toutes les URL existantes doivent rester **identiques** (avec slash final). FR à la racine, EN sous `/en/`.

| URL FR | URL EN | Note |
|---|---|---|
| `/` | `/en/` | |
| `/blog/` | `/en/blog/` | |
| `/blog/conductor-not-coder/` | `/en/blog/conductor-not-coder/` | |
| `/blog/yog-sothoth-pool-centric-to-protocol-centric/` | `/en/blog/yog-sothoth-pool-centric-to-protocol-centric/` | |
| `/about-me/` | `/en/about-me/` | page « À propos » |
| `/contact/` | `/en/contact/` | |
| `/mentions-legales/` | `/en/mentions-legales/` | |
| `/politique-de-confidentialite/` | `/en/politique-de-confidentialite/` | |
| `/tags/<tag>/` | `/en/tags/<tag>/` | ex. `/tags/rust/`, vérifier le slug de chaque tag |
| `/categories/yog-sothoth/` | `/en/categories/yog-sothoth/` | |
| `/services/` | `/en/services/` | **supprimée** → redirection 301 vers la page produits (dans le Caddyfile) |

Nouvelles pages : section produits. **Recommandation : slug `products`** (`/products/`, `/products/yog-scope/`, `/products/otia/` et `/en/products/…`), par cohérence avec `/about-me/` déjà en anglais. Libellé affiché « Produits » / « Products ».

Flux et sitemap : le site Hugo exposait `/index.xml` (RSS). Configurer Zola (`feed_filenames`) pour que le flux reste à la même URL, ou ajouter une redirection. Vérifier `/sitemap.xml` et `/robots.txt`.

## 4. Structure cible

```
.
├── config.toml
├── content/
│   ├── _index.md / _index.en.md              (accueil)
│   ├── blog/_index.md / _index.en.md
│   ├── blog/conductor-not-coder.md / .en.md
│   ├── blog/yog-sothoth-pool-centric-to-protocol-centric.md / .en.md
│   ├── products/_index.md / _index.en.md
│   ├── products/yog-scope.md / .en.md
│   ├── products/otia.md / .en.md
│   ├── about-me/_index.md / _index.en.md
│   ├── contact/_index.md / _index.en.md
│   ├── mentions-legales/_index.md / _index.en.md
│   └── politique-de-confidentialite/_index.md / _index.en.md
├── static/images/…                           (images reprises de assets/images et static/images)
├── templates/                                (spécifique AWSD : index.html, surcharges éventuelles)
├── themes/atelier/
│   ├── theme.toml
│   ├── templates/  base.html, macros.html, section.html, page.html,
│   │               blog.html, blog-page.html, products.html, product.html,
│   │               legal.html, 404.html, taxonomy_list.html, taxonomy_single.html
│   ├── sass/main.scss
│   └── static/fonts/*.woff2
├── Dockerfile
└── Caddyfile
```

À supprimer à la fin (pas avant que le site Zola soit validé) : `themes/TailBliss` (sous-module + `.gitmodules`), `layouts/`, `assets/`, `config/`, `hugo.yaml`, `i18n/`, `package.json`, `package-lock.json`, `vite.config.mjs`, `install.js`, `scripts/gen-og.js`, `sws.toml`, `.hugo_build.lock`, `archetypes/`.

## 5. Migration du contenu

Règles de conversion Hugo → Zola :

- Front matter YAML (`---`) → **TOML** (`+++`).
- Nommage : `page.fr.md` → `page.md` (langue par défaut), `page.en.md` reste `page.en.md`.
- `title`, `description`, `date` : inchangés. `lastmod` → `updated`. `draft` : inchangé.
- `tags` / `categories` → `[taxonomies] tags = [...] categories = [...]` (déclarer les deux taxonomies dans `config.toml`, pour chaque langue).
- `layout: blog` / `layout: single` → `template = "…"` (pages) ou `page_template` (sections).
- `summary`, `author`, `featured_image`, et tout champ propre au site → `[extra]`.
- `featured_image: ../assets/images/x.png` → copier l'image dans `static/images/blog/` et `extra.featured_image = "/images/blog/x.png"`.
- Shortcode Hugo `imgc` (utilisé dans `about-me`) → shortcode Zola `templates/shortcodes/img.html` simple (`<figure><img loading="lazy" …></figure>`), ou image Markdown standard.
- Les textes des pages About, Contact, Mentions et Confidentialité sont **réécrits** selon les maquettes (ton sobre, 3e personne). Partir des textes Hugo existants pour les faits.
- Politique de confidentialité, section Cookies : « Aucun cookie et aucun stockage dans le navigateur. » L'ancienne mention du `localStorage` pour le thème disparaît, puisque le mode sombre est automatique.
- Le contenu de l'accueil (`config/_default/params.*.toml`) ne se migre pas : l'accueil est construit à partir de la section produits et des derniers articles.

### Schéma des produits (`content/products/*.md`)

```toml
+++
title = "Yog-Scope"
description = "Analyse de liquidité en temps réel pour les pools Meteora sur Solana."
weight = 1

[extra]
status = "production"            # production | development | paused
status_label = "En production"
since = "oct. 2026"
url = "https://yog-scope.xyz"
source = "https://github.com/sicotjeanvivien/yog-sothoth"
platform = "Web"
stack = ["Rust", "Solana", "base temporelle"]
access = "Gratuit · code public"
flow = ["RPC Solana", "indexeur", "API", "dashboard"]
flow_caption = "flux de données"
blog_tag = "yog-sothoth"         # articles liés : catégorie ou tag correspondant
facts = [
  { label = "Captation", value = "Temps réel, WebSocket" },
  { label = "Historique", value = "Depuis le 6 oct. 2026" },
  { label = "Signaux", value = "3 détecteurs" },
  { label = "Accès", value = "Gratuit · code public" },
]
features = [
  { title = "Observer", text = "Suivi des pools, des changements de liquidité et de l'activité de marché sur Meteora." },
  { title = "Reconstituer", text = "Historique horaire de la liquidité : ajouts et retraits, heure par heure." },
  { title = "Analyser", text = "Détection d'anomalies : déséquilibres de flux, écarts de prix, fuites de TVL." },
  { title = "Signaler", text = "Alertes en temps réel sur les événements clés, classées par niveau de gravité." },
]
pipeline = [
  { step = "Écouter", text = "Connexion WebSocket permanente à un RPC Solana." },
  { step = "Décoder", text = "Swaps, liquidité, fees, positions, verrous." },
  { step = "Enrichir", text = "Métadonnées des tokens et prix en dollars." },
  { step = "Stocker", text = "Base de données temporelle, interrogeable." },
  { step = "Exposer", text = "API HTTP typée et dashboard public, FR / EN." },
]
crates = ["yog-core", "yog-persistence", "yog-api"]
+++
```

Otia : même schéma, `status = "development"`, `platform = "Android"`, `stack = ["React Native"]`, `flow = ["pensée du jour", "explication", "carnet"]`, `flow_caption = "parcours quotidien"`, champs inconnus laissés vides (le template doit masquer les blocs vides). Les articles liés d'un produit sont retrouvés via la taxonomie (`blog_tag`).

### Chaînes d'interface

Les chaînes de `i18n/fr.toml` / `en.toml` encore utiles passent dans `config.toml` (`[translations]` pour le FR, `[languages.en.translations]` pour l'EN), utilisées avec `trans(key=…, lang=lang)`. Supprimer celles du positionnement freelance (« Disponible pour de nouvelles missions », « Découvrir les services »…).

## 6. Design

Référence visuelle : `design/maquettes/*.html`. Les maquettes sont écrites en styles inline : **ne pas copier les styles inline**, les traduire en classes dans `sass/main.scss`.

### Tokens

```scss
// couleurs
--paper:        #F1EADC;  // fond de page
--paper-light:  #FAF5EA;  // cartes, encarts
--paper-dark:   #EDE4D2;  // emplacements d'image
--code-bg:      #E6DCC8;  // code en ligne
--ink:          #2A2622;  // texte, traits, fond des bandes sombres
--ink-2:        #5A524A;  // texte secondaire
--ink-3:        #6A6159;  // étiquettes mono, traits pointillés
--accent:       #A2482A;  // terre cuite : tampons, annotations, hover, soulignés
--on-dark:      #F1EADC;  // texte sur bande sombre
--on-dark-2:    #CBBFAE;  // texte secondaire sur bande sombre
--accent-on-dark: #E59C7E;
// fond de page : quadrillage 40px
background-image: linear-gradient(rgba(42,38,34,.055) 1px, transparent 1px),
                  linear-gradient(90deg, rgba(42,38,34,.055) 1px, transparent 1px);
background-size: 40px 40px;
```

### Mode sombre « papier de nuit »

Référence : `design/maquettes/accueil-sombre.html`. Même design, mêmes composants : seules les variables changent.
Principe : un brun-charbon **chaud**. Jamais de noir bleuté ni de violet (c'est le territoire de Yog-Scope).

```scss
:root { color-scheme: light dark; /* tokens clairs ci-dessus */ }

@media (prefers-color-scheme: dark) {
  :root {
    --paper:          #1F1A16;  // fond de page
    --paper-light:    #28221D;  // cartes, encarts, planches
    --paper-dark:     #2E2721;  // emplacements d'image
    --code-bg:        #332B24;
    --ink:            #ECE4D4;  // texte, traits, bordures
    --ink-2:          #B9AD9C;
    --ink-3:          #9C9080;
    --accent:         #D9805E;  // terre cuite éclaircie
    --band-bg:        #14110E;  // bandes sombres : plus profondes que le fond
    --on-dark:        #ECE4D4;
    --on-dark-2:      #CBBFAE;
    --accent-on-dark: #E59C7E;
    --grid-line:      rgba(236,228,212,.045);
  }
}
```

Règles :

- **Aucune couleur en dur** dans les templates ou le CSS : tout passe par les variables, y compris la grille de fond (`--grid-line`, `rgba(42,38,34,.055)` en clair) et le fond des bandes (`--band-bg`, `#2A2622` en clair). Les bandes ne doivent **pas** utiliser `--ink` comme fond, sinon elles deviennent claires en mode sombre.
- Les boutons primaires s'inversent naturellement : fond `--ink` (papier en sombre), texte `--paper` (charbon en sombre).
- Logo : le SVG inline de l'en-tête utilise `currentColor` pour le A (`--ink`) et `var(--accent)` pour l'anneau et la barre. Il bascule tout seul. Les variantes `-sombre` du kit servent aux usages hors site.
- Images : pas d'inversion automatique. Les images d'articles restent telles quelles.
- `<meta name="theme-color">` en double : `#F1EADC` avec `media="(prefers-color-scheme: light)"`, `#1F1A16` avec `media="(prefers-color-scheme: dark)"`.
- Contrastes : vérifier le niveau AA dans les deux modes, en particulier `--ink-3` sur `--paper-light` et `--accent` sur `--paper`.
- **Pas de bouton clair/sombre.** S'il est demandé plus tard, ce sera une décision séparée (JS, `localStorage`, mention dans la politique de confidentialité).

### Typographie

| Rôle | Police | Usage |
|---|---|---|
| Titres | Young Serif 400 | h1 72–104px, h2 48–56px, h3 24–34px, line-height ~1.02–1.15 |
| Texte | Instrument Sans 400/500/600 (+ italique 400) | corps 17px / 1.55, chapô 19–22px, article 19px / 1.7 |
| Étiquettes | IBM Plex Mono 400/500 | 12px, MAJUSCULES, letter-spacing .05em, couleur `--ink-3` |
| Annotations | Caveat 600 | 22–30px, couleur `--accent`, légère rotation (-3° à -4°) |

### Composants (voir maquettes)

- **En-tête** : mot-symbole « AWSD » (serif) + « société logicielle » (mono) · menu Produits / Blog / À propos (élément courant souligné en terre cuite) · sélecteur FR / EN (mono) · bouton « Contact » (pilule bordée).
- **Boutons** : pilule `border-radius: 999px`, hauteur min. 52px. Primaire : fond `--ink`, texte `--paper`, hover fond `--accent`. Secondaire : bordure 1.5px `--ink`.
- **Planche produit** : carte `--paper-light`, bordure 1.5px `--ink`, coins droits ; ligne mono « 01 —— STACK » avec pointillés ; titre serif ; **tampon de statut** en haut à droite (bordure 2px, majuscules, légère rotation, terre cuite pour « En production », encre pour les autres).
- **Schéma de flux** : nœuds mono bordés reliés par des flèches CSS, dans un cadre pointillé, légende en Caveat.
- **Bande sombre** (Principes, Valeurs, CTA final) : fond `--ink`, titres serif `--on-dark`, numéros mono `--accent-on-dark`.
- **Listes d'articles** : séparateurs 1.5px, date mono, titre serif, chapô `--ink-2`.
- **Puces de tags** : pilules mono bordées, fond `--paper-light`, actif = fond `--ink`.
- **Article** : colonne de lecture ~700px + marge latérale (sommaire généré par Zola via `page.toc`, sujets), code en ligne `--code-bg`, blocs de code fond `--ink`, citations en serif 34px, encart « Produit associé » en fin d'article si l'article est lié à un produit.
- **Pages légales** : sommaire latéral + sections séparées par des pointillés, listes `dl` (libellé mono / valeur).
- **Pied de page** : « AWSD » serif + ligne freelance (« Pour une mission d'accompagnement technique : contact. »), navigation en 2 colonnes, © en mono.

### Logo et favicon

Fichiers prêts dans `design/identite/` (voir son `LISEZMOI.md`). Logo retenu : **« Tampon »**, un cachet circulaire incliné de −8° avec un A au centre.

- En-tête : `logo-compact.svg` (~38 px) à gauche du mot « AWSD », intégré **en SVG inline** pour hériter des couleurs, comme dans les maquettes.
- Favicon et icônes : copier `favicon.svg`, `favicon.ico`, `favicon-32.png`, `apple-touch-icon.png`, `icon-192.png`, `icon-512-maskable.png` et `site.webmanifest` à la racine de `static/` (ils remplacent `static/favicon/` et l'ancien manifest). Les balises `<head>` sont dans le `LISEZMOI.md`.
- Open Graph : `og-default.png` remplace `static/images/og/og-default.png`.
- Grands formats (À propos, 404…) : `logo-tampon.svg`. Bande sombre : variantes `-sombre`.

### Mise en page et accessibilité

- Conteneur `max-width: 1260px`, padding latéral 40px (20px sous 760px). Grilles en `repeat(auto-fit, minmax(min(Xpx, 100%), 1fr))`.
- Sous 760px : menu replié, titres h1 ~48–56px, une colonne.
- Cibles cliquables ≥ 44px, contrastes AA, vrais `<a>` / `<button>`, `aria-current` sur l'élément de menu actif, `lang` correct par langue, `hreflang` + liens alternatifs FR/EN dans `<head>`.
- Pas d'emoji, pas de dégradés, pas d'images décoratives lourdes.

## 7. Déploiement

- **Dockerfile** multi-stage : étape 1 image officielle Zola (`ghcr.io/getzola/zola:<version>`) → `zola build` ; étape 2 `caddy:<version>-alpine` qui copie `public/` vers `/srv`.
- **Caddyfile** : reprendre `sws.toml` — redirection 301 `www.awsd.fr` → `awsd.fr`, en-têtes de sécurité (HSTS, Referrer-Policy, X-Content-Type-Options, Permissions-Policy, CSP `default-src 'self'; img-src 'self' data:; style-src 'self'; font-src 'self'; frame-ancestors 'self'` — retirer `'unsafe-inline'` si plus aucun style/script inline), cache long sur assets versionnés, `no-cache` sur HTML, `no-store` sur 404, redirection `/services/` → page produits.
- Ne pas toucher au DNS : la bascule est faite manuellement après validation.

## 8. Étapes (s'arrêter et faire valider à chaque checkpoint)

1. **Socle** — branche `refonte-zola`. `config.toml` (base_url, langues FR/EN, taxonomies, Sass, feeds), thème `themes/atelier` avec `base.html`, en-tête, pied, `main.scss`, polices locales.
   ✅ *Checkpoint* : `zola build` passe sans erreur.
2. **Accueil + blog en FR/EN** — migration des articles, templates accueil, liste du blog, article, tags.
   ✅ *Checkpoint* : comparer la liste des URL générées (`find public -name index.html`) au tableau de la section 3. Aucune URL existante ne doit manquer.
3. **Produits** — section + fiches Yog-Scope et Otia selon le schéma de la section 5, accueil alimenté par la section.
4. **Pages secondaires** — À propos, Contact, Mentions légales, Confidentialité (FR + EN), 404.
5. **Finitions** — balises meta / Open Graph (reprendre `static/images/og/og-default.png`), sitemap, robots, flux, `hreflang`, favicon.
   ✅ *Checkpoint* : Lighthouse ≥ 90 en performance, accessibilité et SEO, **dans les deux modes** (émulation `prefers-color-scheme: dark` des DevTools) ; aucune requête externe dans l'onglet réseau ; aucun JavaScript ni stockage navigateur.
6. **Déploiement** — Dockerfile + Caddyfile, test local du conteneur (`docker build` + `docker run`, vérifier redirections et en-têtes avec `curl -I`).
7. **Nettoyage** — suppression des fichiers Hugo listés en section 4, mise à jour du README.

## 9. Points ouverts (à demander à l'utilisateur, ne pas trancher seul)

- Adresse e-mail de contact : garder `jeanvivien.sicot@lapiscine.pro` ou passer à une adresse `@awsd.fr` ?
- Mentions légales : adresse de l'hébergeur Scaleway à compléter, à publier seulement après la migration.
- Slug de la section produits : `products` (recommandé) ou `produits` ?
- Textes à valider : sur À propos, « travaille aujourd'hui principalement en Rust » et l'activité « Édition de logiciels et accompagnement technique ».
- Contenus manquants : portrait, image d'en-tête des articles si absente, lien Otia, année de création d'AWSD.
- Stack Yog-Scope : nom exact de la « base temporelle ».

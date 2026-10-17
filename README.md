# awsd.fr

Site de [AWSD](https://awsd.fr), société logicielle indépendante qui développe et maintient ses propres produits (Yog-Scope, Otia).

Site statique généré avec [Zola](https://www.getzola.org/), bilingue FR (racine) / EN (`/en/`), sans JavaScript, sans dépendance npm, polices auto-hébergées. Mode sombre automatique (suit `prefers-color-scheme`).

## Prérequis

- [Zola](https://www.getzola.org/documentation/getting-started/installation/) **0.23** ou plus récent (le thème utilise Tera 2). Rien d'autre.

## Développement

```sh
zola serve          # http://127.0.0.1:1111, rechargement automatique
zola build          # génère le site dans public/
zola check          # vérifie aussi les liens externes
```

`public/` et `static/processed_images/` (cache des images redimensionnées) sont régénérés à chaque build et ne sont pas versionnés.

## Arborescence

```
config.toml            configuration, langues, chaînes d'interface FR/EN, menus
content/               contenus Markdown (page.md = FR, page.en.md = EN)
  blog/                articles
  products/            fiches produits
templates/             surcharges propres à AWSD (accueil, À propos, Contact)
static/                images, logos, favicons, manifest
themes/atelier/        thème maison, indépendant du site
  templates/           base, blog, produits, pages légales, taxonomies, 404, flux RSS
  sass/                styles (un seul main.css compilé par Zola)
  static/fonts/        polices woff2 (licences OFL incluses)
design/
  maquettes/           maquettes HTML de référence (à ouvrir dans un navigateur)
  identite/            logo « Tampon », favicons, image de partage (voir LISEZMOI.md)
REFONTE.md             brief de la refonte Hugo → Zola
```

## Contenus

### Ajouter un article

Créer `content/blog/<slug>.md` (FR) et `content/blog/<slug>.en.md` (EN) avec le même nom de fichier, pour que les deux versions soient liées :

```toml
+++
title = "Titre"
description = "Résumé pour les moteurs de recherche et le partage."
date = 2026-10-17
updated = 2026-10-17
draft = false

[taxonomies]
categories = ["Yog-Sothoth"]
tags = ["Rust", "Solana"]

[extra]
summary = "Chapô affiché dans la liste des articles."
author = "Jean-Vivien Sicot"
featured_image = "images/blog/mon-image.png"   # dans static/images/blog/
+++
```

### Ajouter un produit

Créer `content/products/<slug>.md` et `.en.md`, en partant de `yog-scope.md` (schéma complet) ou `otia.md` (produit en développement). Les principaux champs de `[extra]` :

- `status` : `production`, `development` ou `paused`, avec son libellé `status_label` ;
- `url`, `source`, `platform`, `stack`, `facts`, `features`, `pipeline` : les blocs laissés vides ne sont pas affichés ;
- `blog_tag` : catégorie ou tag des articles liés au produit.

L'ordre d'affichage (page produits et accueil) suit `weight`.

### Chaînes d'interface et menus

Les libellés de l'interface sont dans `config.toml` : `[translations]` pour le FR, `[languages.en.translations]` pour l'EN. Les menus (en-tête, pied de page) et les informations de la société (données schema.org) sont dans `[extra]`.

## Conventions

- **Pas de JavaScript** ni de stockage navigateur (ni cookie, ni `localStorage`).
- **Aucune requête externe** : polices, images et styles sont servis par le site.
- **URL stables** : les URL héritées du site Hugo (articles, tags, catégories, pages légales, flux `/index.xml`) sont conservées à l'identique, avec slash final. Voir REFONTE.md §3 avant de renommer une page.
- **Liens externes** : ils s'ouvrent dans un nouvel onglet (`external_links_target_blank` pour le Markdown, composant `ui.external` dans les templates).
- **Ton** : AWSD s'exprime à la 3e personne, de façon directe et sobre. Les articles du blog restent dans la voix de leur auteur.
- Le thème `atelier` ne contient rien de propre à AWSD : ce qui est spécifique au site va dans `templates/` et `config.toml`.

## Déploiement

Cible : image Docker multi-stage (build Zola → Caddy) sur un VPS Scaleway, le `Caddyfile` portant les redirections et les en-têtes de sécurité (voir REFONTE.md §7). **Pas encore en place** : la production awsd.fr est servie, en attendant la bascule, par l'ancien site Hugo ([`awsd_hugo`](https://github.com/sicotjeanvivien/awsd_hugo)).

## Licence

Le thème `themes/atelier` est sous licence MIT. Les polices sont sous licence SIL OFL (fichiers `LICENSE-*.txt` dans `themes/atelier/static/fonts/`). Les contenus (textes, images, logos) restent la propriété d'AWSD.

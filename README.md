# awsd.fr

Website of [AWSD](https://awsd.fr), an independent software company that builds and maintains its own products (Yog-Scope, Otia).

Static site generated with [Zola](https://www.getzola.org/), bilingual FR (root) / EN (`/en/`), no JavaScript, no npm dependency, self-hosted fonts. Automatic dark mode (follows `prefers-color-scheme`).

## Requirements

- [Zola](https://www.getzola.org/documentation/getting-started/installation/) **0.23** or later (the theme uses Tera 2). Nothing else.

## Development

```sh
zola serve          # http://127.0.0.1:1111, live reload
zola build          # builds the site into public/
zola check          # also checks external links
```

`public/` and `static/processed_images/` (resized image cache) are regenerated on every build and are not versioned.

## Layout

```
config.toml            configuration, languages, FR/EN UI strings, menus
content/               Markdown content (page.md = FR, page.en.md = EN)
  blog/                posts
  products/            product pages
templates/             AWSD-specific overrides (home, About, Contact)
static/                images, logos, favicons, manifest
themes/atelier/        in-house theme, independent from the site
  templates/           base, blog, products, legal pages, taxonomies, 404, RSS feed
  sass/                styles (a single main.css compiled by Zola)
  static/fonts/        woff2 fonts (OFL licenses included)
design/
  maquettes/           reference HTML mockups (open in a browser)
  identite/            "Tampon" logo, favicons, share image (see LISEZMOI.md)
REFONTE.md             brief for the Hugo → Zola rewrite (in French)
```

## Content

### Adding a post

Create `content/blog/<slug>.md` (FR) and `content/blog/<slug>.en.md` (EN) with the same file name, so both versions are linked:

```toml
+++
title = "Title"
description = "Summary for search engines and social sharing."
date = 2026-10-17
updated = 2026-10-17
draft = false

[taxonomies]
categories = ["Yog-Sothoth"]
tags = ["Rust", "Solana"]

[extra]
summary = "Lead shown in the post list."
author = "Jean-Vivien Sicot"
featured_image = "images/blog/my-image.png"   # in static/images/blog/
+++
```

### Adding a product

Create `content/products/<slug>.md` and `.en.md`, starting from `yog-scope.md` (full schema) or `otia.md` (product in development). Main `[extra]` fields:

- `status`: `production`, `development` or `paused`, with its `status_label`;
- `url`, `source`, `platform`, `stack`, `facts`, `features`, `pipeline`: empty blocks are not displayed;
- `blog_tag`: category or tag of the posts related to the product.

Display order (products page and home page) follows `weight`.

### UI strings and menus

UI labels live in `config.toml`: `[translations]` for FR, `[languages.en.translations]` for EN. Menus (header, footer) and company details (schema.org data) live in `[extra]`.

## Conventions

- **No JavaScript** and no browser storage (no cookies, no `localStorage`).
- **No external requests**: fonts, images and styles are all served by the site.
- **Stable URLs**: URLs inherited from the Hugo site (posts, tags, categories, legal pages, `/index.xml` feed) are kept identical, with a trailing slash. See REFONTE.md §3 before renaming a page.
- **External links** open in a new tab (`external_links_target_blank` for Markdown, `ui.external` component in templates).
- **Tone**: AWSD speaks in the third person, plainly and soberly. Blog posts keep their author's voice.
- The `atelier` theme holds nothing AWSD-specific: anything site-specific goes in `templates/` and `config.toml`.

## Deployment

Target: multi-stage Docker image (Zola build → Caddy) on a Scaleway VPS, with the `Caddyfile` handling redirects and security headers (see REFONTE.md §7). **Not in place yet**: until the switch, awsd.fr is served by the old Hugo site ([`awsd_hugo`](https://github.com/sicotjeanvivien/awsd_hugo)).

## License

The `themes/atelier` theme is MIT-licensed. Fonts are under the SIL OFL (`LICENSE-*.txt` files in `themes/atelier/static/fonts/`). Content (texts, images, logos) remains the property of AWSD.

# awsd.fr

Site statique **Hugo + PaperMod** de Jean-Vivien Sicot (AWSD).

## 🚀 Développement
- Prérequis : Hugo Extended (>= 0.118)
- Lancer en local :
  ```bash
  hugo server
  ````

* Build :

  ```bash
  hugo --minify
  ```

## 🧱 Structure

* `content/` : pages & articles (bundles recommandés)
* `layouts/` : overrides (partials extend_head, 404, list blog/services)
* `assets/css/extended/` : styles étendus (cards, 404, …)
* `static/` : images OG par défaut, favicons, etc.
* `sws.toml` : headers sécurité + cache (Clever Cloud)

## 🔒 Sécurité (prod)

* HSTS, CSP, Referrer, Permissions-Policy, nosniff
* HTTP→HTTPS forcé, www→apex

## 🧭 Conventions

* Commits : Conventional Commits (feat/fix/docs/…)
* Branches : main (prod), dev (option), feature/*

## 🏷️ Releases

* Tags datés `vYYYY.MM.DD` (ou semver)
* Voir “Releases” pour les notes

## 📄 Licence

© 2025 Jean-Vivien Sicot — Tous droits réservés.
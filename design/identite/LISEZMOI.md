# Identité AWSD — logo « Tampon »

## Fichiers

| Fichier | Usage |
|---|---|
| `logo-tampon.svg` / `-sombre.svg` | Logo complet (anneau « ARTISAN · WEB · SOFTWARE · DEVELOPMENT »). Grands formats : À propos, image OG, documents. Taille min. ~96 px. |
| `logo-compact.svg` / `-sombre.svg` | Anneau + A, sans texte. En-tête du site (~40 px), pied de page. |
| `logo-horizontal.svg` / `-sombre.svg` | Marque compacte + « AWSD » + « SOCIÉTÉ LOGICIELLE ». Signature e-mail, documents, réseaux. |
| `favicon.svg` | Favicon vectoriel (pastille terre cuite + A). |
| `favicon.ico` | 16/32/48 px, anciens navigateurs. |
| `favicon-32.png` | Repli PNG. |
| `apple-touch-icon.png` | 180 px, iOS (fond papier). |
| `icon-192.png`, `icon-512-maskable.png` | Android / manifest. |
| `site.webmanifest` | Manifest. |
| `og-default.png` | Image de partage Open Graph, 1200×630. |

Tous les textes des SVG sont vectorisés : aucune police requise pour les afficher.

## Couleurs

Terre cuite `#A2482A` · Encre `#2A2622` · Papier `#F1EADC` / `#FAF5EA`.
Sur fond sombre : terre cuite claire `#E59C7E`, papier `#F1EADC`.

## Règles

- Le tampon est incliné de −8° : ne pas le redresser ni le tourner davantage.
- Ne pas recolorer hors de la palette, ne pas ajouter d'ombre ni de dégradé.
- Sous 32 px, utiliser uniquement le favicon (pastille pleine).

## Intégration (dans `<head>`)

```html
<link rel="icon" href="/favicon.ico" sizes="48x48">
<link rel="icon" href="/favicon.svg" type="image/svg+xml">
<link rel="apple-touch-icon" href="/apple-touch-icon.png">
<link rel="manifest" href="/site.webmanifest">
<meta name="theme-color" content="#F1EADC">
<meta property="og:image" content="https://awsd.fr/og-default.png">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
```

Placer les fichiers d'icônes et le manifest à la racine de `static/`, les logos dans `static/images/logo/`.

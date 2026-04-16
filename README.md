# Migration YAML → TOML + Multilingue FR/EN

## Structure des fichiers

```
config/
  _default/
    hugo.toml           ← config principale (remplace hugo.yaml)
    menus.fr.toml       ← menus en français
    menus.en.toml       ← menus en anglais
    params.fr.toml      ← tous les params de la homepage en français
    params.en.toml      ← tous les params de la homepage en anglais

i18n/
  fr.toml               ← chaînes UI en français
  en.toml               ← chaînes UI en anglais
```

## Étapes d'installation

### 1. Remplacer les anciens fichiers de config
- Supprimer `hugo.yaml`, `menus.yaml`, `params.yaml` à la racine
- Créer le dossier `config/_default/` et y copier les fichiers `.toml`
- Créer le dossier `i18n/` et y copier les fichiers `.toml`

### 2. Dupliquer le contenu markdown
Pour chaque page, créer une version anglaise :

```
content/
  _index.fr.md          ← homepage FR (ou _index.md si FR est la langue par défaut)
  _index.en.md          ← homepage EN
  services/
    _index.fr.md
    _index.en.md
  about-me/
    _index.fr.md
    _index.en.md
  contact/
    _index.fr.md
    _index.en.md
```

### 3. URLs générées automatiquement par Hugo
- Français : `monsite.com/` (langue par défaut, pas de préfixe)
- Anglais  : `monsite.com/en/`

### 4. Ajouter le sélecteur de langue dans TailBliss
Dans le template de header (`layouts/partials/header.html`), ajouter :

```html
{{ range .Site.Languages }}
  <a href="{{ .Lang | relLangURL }}">{{ .LanguageName }}</a>
{{ end }}
```

## Notes importantes

- Le français est la langue par défaut (pas de `/fr/` dans les URLs)
- L'anglais sera accessible sous `/en/`
- Les `darkmode_js` et `postCSS` ont été retirés de la config principale
  car ils étaient spécifiques à TailBliss et probablement gérés par le thème
- Vérifier que TailBliss supporte les params multilingues (certains thèmes
  ne lisent que le bloc `[params]` global)

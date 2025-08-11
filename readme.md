# 🌐 Site Hugo — Portfolio & Blog

Ce site est construit avec [Hugo](https://gohugo.io/) et utilise le thème [PaperMod](https://github.com/adityatelange/hugo-PaperMod).  
Il sert à la fois de **portfolio professionnel** et de **blog technique / journal de développement**.

---

## 📂 Structure des contenus

```

content/
│
├── \_index.md                 # Page d'accueil (facultatif, si personnalisée)
│
├── projets/                  # Section portfolio
│   ├── \_index.md              # Page liste "Tous les projets"
│   ├── projet-orm.md          # Exemple fiche projet
│   └── projet-symfony.md      # Exemple fiche projet
│
├── posts/                    # Section blog/journal
│   ├── \_index.md              # Page liste "Blog"
│   ├── orm-avancement.md      # Exemple article
│   └── symfony-fiche.md       # Exemple fiche technique
│
├── competences/              # Page compétences (statique)
│   └── \_index.md
│
├── a-propos/                 # Page à propos (statique)
│   └── \_index.md
│
└── contact/                  # Page contact (statique)
└── \_index.md

````

---

## 🚀 Installation

### 1. Cloner le projet
```bash
git clone https://github.com/toncompte/tonrepo.git
cd tonrepo
````

### 2. Installer Hugo Extended

Vérifie que tu utilises **Hugo Extended** :

```bash
hugo version
```

Si besoin, télécharge la dernière version sur [GitHub Hugo Releases](https://github.com/gohugoio/hugo/releases).

---

## 🛠 Commandes de base

### Lancer en local

```bash
hugo server -D
```

* `-D` inclut les contenus en brouillon (`draft: true`)
* Accès via : [http://localhost:1313](http://localhost:1313)

### Créer un nouveau projet

```bash
hugo new projets/nom-du-projet.md
```

### Créer un nouvel article

```bash
hugo new posts/mon-article.md
```

---

## ⚙️ Configuration

La configuration est définie dans `config/` et gère :

* `baseURL` : URL du site (localhost en dev, domaine en prod)
* `pagination` : nombre d’éléments par page
* `permalinks` : structure des URLs
* `taxonomies` : catégories et tags
* `params` : options du thème PaperMod
* `menu` : navigation principale

---

## 📦 Build de production

```bash
hugo --environment production --minify
```

* Les fichiers statiques sont générés dans `public/`
* Prêt à être déployé (Clever Cloud, Netlify, GitHub Pages, etc.)

---

## 📌 Notes

* Le blog est pensé comme **journal technique** : pas nécessairement destiné à être lu par un large public.
* Le portfolio est la priorité : il doit toujours comporter **au moins deux projets représentatifs**.
* Structure optimisée pour PaperMod, mais facilement adaptable à d’autres thèmes.

---

---
title: "Comprendre les différents types d’ORM"
date: 2025-08-25
lastmod: 2025-08-25
description: "Comparatif critique des principaux types d’ORM (Active Record, Data Mapper, Repository Pattern, Micro-ORM) avec exemples de code et analyse des compromis."
summary: "Active Record, Data Mapper, Repository, Micro-ORM : découvrez leurs forces, limites et exemples pratiques pour choisir la bonne approche ORM selon votre projet."
categories: ["Articles"]
tags: ["ORM", "PHP", "Doctrine", "Laravel", "Architecture", "DDD"]
author: "Jean-Vivien Sicot"
draft: false
showToc: true
tocOpen: false
cover:
  image: "images/articles/orm-types-cover.png"
  alt: "Schéma comparatif des différents types d’ORM"
  caption: "Active Record, Data Mapper, Repository et Micro-ORM comparés."
---

Les **ORM** (Object–Relational Mappers) facilitent la manipulation des bases SQL via des objets.  
Ils promettent de réduire la "distance" entre code et données, mais chaque approche vient avec des compromis.  
Certains développeurs adorent les ORM pour leur rapidité, d’autres les fuient pour garder le contrôle total sur leurs requêtes.  

👉 Alors, quels sont les différents types d’ORM ? Quels avantages réels offrent-ils, et quelles illusions faut-il éviter ?  

---

## 1. 🔗 Active Record

### Définition
Le modèle **Active Record** couple directement l’objet métier à la persistance.  
Chaque entité sait se sauvegarder (`save()`), se mettre à jour (`update()`), se supprimer (`delete()`).

### Exemple de code (PHP / Eloquent)
```php
class User extends Model {
    // Hérite de save(), update(), delete()
}

$user = new User();
$user->name = "Alice";
$user->save(); // INSERT INTO users ...
````

### ✅ Avantages

* Rapide à prendre en main (idéal pour un CRUD)
* Syntaxe expressive : `User::where('email', $mail)->first()`
* Parfait pour un MVP ou un projet court

### ❌ Inconvénients

* Couplage fort entre métier et base
* Tests unitaires compliqués
* Devient vite un frein dans des domaines complexes

### Opinion

Active Record est séduisant pour **démarrer vite**, mais il **vieillit mal** dès que le projet grossit.
À long terme, la logique métier finit piégée dans les modèles.

---

## 2. 🧠 Data Mapper

### Définition

Le **Data Mapper** sépare totalement les entités métier de la base.
L’entité est pure (sans `save()`), et un **Mapper / Repository** gère la persistance.

### Exemple de code (PHP / Doctrine)

```php
#[Entity]
class User {
    public function __construct(
        private string $email,
        private string $name
    ) {}
}

$user = new User("alice@mail.com", "Alice");
$entityManager->persist($user);
$entityManager->flush();
```

### ✅ Avantages

* Respect du SRP : entités **testables** et **métier pur**
* Compatible avec une approche DDD
* Gestion avancée : relations, UnitOfWork, lazy loading

### ❌ Inconvénients

* Mise en place complexe
* Mapping souvent verbeux (annotations, YAML, XML)
* Demande une architecture claire

### Opinion

Le Data Mapper est l’approche la plus **robuste et scalable**, mais aussi la plus **lourde**.
C’est un investissement rentable si le projet vise le **long terme**.

---

## 3. 🏛️ Repository Pattern (au-delà des ORM)

### Définition

Le **Repository Pattern** n’est pas un ORM, mais une **surcouche architecturale (DDD)**.
Il permet de cacher totalement la persistance derrière des **repositories métiers**.

### Exemple de code (PHP / sur Doctrine)

```php
class UserRepository {
    public function findByEmail(string $email): ?User {
        // la requête Doctrine est encapsulée ici
    }
}
```

### ✅ Avantages

* Méthodes métier lisibles : `UserRepository::findByEmail()`
* Encapsulation forte → ORM invisible pour le domaine
* Facile à tester / mocker

### ❌ Inconvénients

* Demande une vraie discipline d’équipe
* Plus lent à mettre en œuvre qu’un Active Record

### Opinion

Le Repository Pattern est une **bonne pratique DDD**, mais ce n’est pas un ORM.
C’est une **couche d’abstraction supplémentaire**, à ajouter uniquement si le métier le justifie.

---

## 4. 🔧 Micro-ORM

### Définition

Les **Micro-ORM** offrent un mapping minimaliste (objets ↔ SQL), sans surcouche complexe.
Ils laissent au développeur le contrôle des requêtes.

### Exemple de code (PHP / Medoo)

```php
$database = new Medoo(['database_type' => 'mysql', ...]);

$database->insert("users", ["name" => "Alice", "email" => "alice@mail.com"]);
$user = $database->get("users", "*", ["id" => 1]);
```

### ✅ Avantages

* Ultra rapide, léger
* Pas de magie cachée
* Idéal pour microservices ou scripts CLI

### ❌ Inconvénients

* Relations gérées à la main
* Pas adapté aux gros projets métier
* Peu d’automatisation

### Opinion

Un Micro-ORM est parfait si tu veux **maîtriser ton SQL** tout en gagnant un peu de confort.
Mais il ne protège pas des erreurs de conception côté métier.

---

## 🔚 Synthèse comparative

| Type              | Couplage entité–ORM | Friendly DDD | Complexité | Exemples             |
| ----------------- | ------------------- | ------------ | ---------- | -------------------- |
| **Active Record** | 🔴 Très fort         | ❌            | 🟢 Faible   | Eloquent, Rails      |
| **Data Mapper**   | 🟢 Faible            | 🟡 Moyen      | 🔴 Élevée   | Doctrine, Hibernate  |
| **Repository**    | 🟢 Très faible       | ✅ ✅ ✅        | 🔴 Élevée   | Surcouche DDD        |
| **Micro-ORM**     | 🟢 Faible            | ❌            | 🟢 Faible   | Dapper, Medoo, Atlas |

---

## 🚀 Conclusion

👉 **Active Record** : parfait pour démarrer vite, mais dangereux à long terme.  
👉 **Data Mapper** : lourd mais robuste, le choix des projets ambitieux.  
👉 **Repository Pattern** : pas un ORM, mais une bonne pratique DDD.  
👉 **Micro-ORM** : idéal si tu veux garder le SQL sous contrôle, sans magie inutile.  

🔎 **Mon conseil** : choisis l’ORM **en fonction de ton horizon projet** :

* Prototype ou side-project → Active Record / Micro-ORM
* Application métier durable → Data Mapper + Repository Pattern

En clair : **il n’y a pas de solution universelle**, seulement des compromis.
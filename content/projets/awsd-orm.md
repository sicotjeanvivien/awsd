---
title: "AWSD-ORM (PHP 8.4, Data Mapper)"
date: 2025-09-10
summary: "ORM Data Mapper PostgreSQL-first en PHP 8.4, avec architecture modulaire, TDD et génération SQL dialect-aware."
tags: ["PHP", "ORM", "PostgreSQL", "TDD", "Architecture"]
showToc: false
tocOpen: false
cover:
  image: "images/portfolio/awsd-orm-cover.png"
  alt: "Schéma UML de l’ORM AWSD"
status: "En cours de développement"
links:
  - title: "GitHub"
    url: "https://github.com/sicotjeanvivien/AWSD-ORM"
  - title: "Articles"
    url: "/blog/"
---
## Contexte
Un ORM maison basé uniquement sur le pattern **Data Mapper**, pensé pour PostgreSQL comme SGBD principal avec dégradations contrôlées pour MySQL et SQLite.  

## Stack & techniques
- **Langage** : PHP 8.4  
- **Paradigme** : Data Mapper, SRP, TDD  
- **Tests** : PHPUnit  
- **Base cible** : PostgreSQL (first-class)  

## Points clés
- QueryBuilder modulaire (Where, Join, Order, Limit, etc.).  
- Génération SQL spécifique au dialecte (PG/MySQL/SQLite).  
- Système de migrations intégré.  
- Roadmap structurée : MVP → CRUD solide → production.  

## Exemple
```php
$select = (new SelectQuery('users'))
    ->setWhere(WhereDefinition::eq('status', 'active'))
    ->setOrderBy(OrderByDefinition::asc('created_at'))
    ->setLimit(50);

// $select->toSql($dialect)
````

## Liens

* [GitHub](https://github.com/sicotjeanvivien/AWSD-ORM)
* [Articles associés](/blog/)


---
title: "Mes premiers pas avec Rust - Jour 1"
date: 2025-08-25T10:30:00+02:00
draft: false
categories: ["Journal"]
tags: ["rust", "apprentissage", "développement"]
description: "Mes premières impressions et ressentis en découvrant le langage Rust."
cover:
  image: "images/journal/rust-cover.png"
  alt: "Logo Rust stylisé sur fond beige"
  caption: "Mes premiers pas avec Rust"
---

## Pourquoi Rust ?  
Je suis développeur PHP depuis plusieurs années. J’ai aussi travaillé avec JavaScript et Ruby dans un cadre professionnel.  
Mais depuis quelque temps, je ressentais le besoin d’élargir mes compétences et d’aller vers un langage plus bas niveau, plus exigeant.  

Je me suis donc demandé : quel langage pourrait vraiment me bousculer dans ma façon de coder, tout en m’apportant quelque chose de solide, à la fois personnellement et professionnellement ?  
C’est comme ça que je suis tombé sur **Rust**.  

Rust m’a séduit pour plusieurs raisons :  
- Son exigence, qui en fait un langage formateur.  
- Sa promesse de **sécurité mémoire**, une dimension que je n’ai pas vraiment rencontrée avec PHP.  
- Sa **montée en popularité** et son rôle grandissant dans des domaines qui m’intéressent, comme la cryptomonnaie.  

En clair : Rust semblait être exactement ce que je cherchais, un langage différent de tout ce que je connais déjà.

---

## Premières impressions  
L’installation a été plutôt simple. Si on est déjà un peu à l’aise avec le terminal, **rustup** facilite vraiment la vie : il permet de mettre à jour facilement son environnement et de rester sur la dernière version.  
Ensuite il y a **Cargo**, qui gère la création de projets, la compilation, les tests… un vrai petit couteau suisse.  

J’ai aussi installé les extensions VS Code. Pour l’instant elles sont encore limitées, mais ça suffit largement pour commencer à coder sereinement.  

Côté langage, la **syntaxe** est claire, mais quand on vient de PHP, ça demande un temps d’adaptation. Ce qui me perturbe le plus, ce n’est pas tant la syntaxe que la **structure des applications**.  
Je passe d’un monde très orienté **POO (classes, héritage, interfaces)** à quelque chose de beaucoup plus sobre, basé sur des `struct` et des `trait`. C’est une autre manière de penser son code.

---

## Le typage fort : une claque  
Un autre point qui m’a marqué, c’est le **typage fort** de Rust.  
Là où en PHP on a longtemps été habitués à une certaine souplesse (voire du "laisser-faire" côté types), Rust ne pardonne rien. Chaque variable, chaque retour de fonction, chaque conversion doit être clair et explicite.  

Au début, c’est un peu violent : je me retrouve à bloquer sur des choses toutes simples, comme additionner deux valeurs qui ne sont pas exactement du même type numérique (`i32` vs `u32`, par exemple).  
Mais je comprends que cette rigueur est volontaire : elle force à réfléchir dès maintenant à la cohérence des données, plutôt que de découvrir des bugs plus tard à l’exécution.  

C’est déroutant, oui, mais c’est aussi formateur. Ça me fait revoir des habitudes de développeur que j’avais un peu trop prises pour acquises.

---

## Entre excitation et frustration  
Beaucoup de notions restent floues pour moi pour l’instant : ownership, borrowing, lifetimes… je comprends les grandes lignes, mais pas encore en profondeur.  

C’est à la fois **grisant et frustrant**. Grisant, parce que j’ai l’impression d’ouvrir une nouvelle porte dans ma façon de concevoir le code. Frustrant, parce que parfois je bloque sur des choses qui me semblent "évidentes" dans d’autres langages.  

Mais je sais que ce genre de difficultés fait partie du processus. Et je sens que Rust va m’obliger à être plus rigoureux, plus attentif à la logique de mon code.

---

👉 Voilà mon **jour 1 avec Rust**.  
Un mélange de curiosité, de doute et de motivation. La suite, ce sera de continuer à me confronter au langage, petit projet après petit projet, pour voir comment toutes ces notions s’imbriquent vraiment.

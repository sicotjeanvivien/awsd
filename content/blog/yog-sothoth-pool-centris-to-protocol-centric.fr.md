---
title: "Yog-Sothoth : comment une question simple a changé la nature du produit"
date: 2026-05-01
lastmod: 2026-05-01
description: "Cela fait deux semaines que je construis Yog-Sothoth quand, un dimanche soir, je me pose une question simple : est-ce que ça existe déjà ? Vingt-quatre heures plus tard, l'architecture du projet a changé de nature."
summary: "Cela fait deux semaines que je construis Yog-Sothoth quand, un dimanche soir, je me pose une question simple : est-ce que ça existe déjà ? Vingt-quatre heures plus tard, l'architecture du projet a changé de nature."
categories: ["Yog-Sothoth"]
tags: ["Solana", "DeFi", "Meteora", "Rust"]
author: "Jean-Vivien Sicot"
draft: false
layout: blog
featured_image: ../assets/images/yog_sothoth_project_saas_fr.png
---

### Le projet de départ

Yog-Sothoth est un moteur d'analyse de liquidité en temps réel sur les pools de Meteora, un protocole d'échange décentralisé sur Solana. L'outil ingère le flux de transactions on-chain, reconstruit l'état des pools, calcule des métriques financières, et exposera à terme alertes et visualisations via un dashboard web. Ce n'est pas un explorateur de blocs comme Solscan : c'est un outil d'analyse et de signal, entre Dune Analytics et Nansen, focalisé sur la liquidité Meteora.
Au moment où je me pose la question, j'ai deux semaines de code derrière moi : le pipeline d'ingestion fonctionne, le décodage des swaps DAMM v2 est en place, la persistance PostgreSQL aussi. Ce que je n'ai jamais fait, en revanche, c'est vérifier sérieusement si d'autres outils occupaient déjà cet espace.

### La revue

Je commence par ce que j'aurais dû faire au démarrage : taper "Meteora analytics", "Meteora LP tracker", "Solana DEX flow analyzer" et lire ce que renvoient les résultats. En une heure, j'ai une cartographie raisonnable.

Le premier groupe est dense. Ultra LP, TrackLP, MetLab, Tokleo, MetEngine, Cleopetra, Liquid Nova, Starseed. Tous construits autour de la même proposition : _mes positions, mon P&L, mon copy trading_. L'utilisateur arrive avec un wallet, l'outil suit ce que ce wallet fait dans les pools. Le pool est l'unité de souscription, la position est l'unité d'analyse.

Le second groupe est plus disparate. Bitquery propose des flux Solana spécifiques aux DEX, avec un support explicite de Meteora et plusieurs canaux de livraison (WebSocket, Kafka, gRPC). C'est puissant, mais leur produit reste un service de données structurées : on souscrit à des paires, des wallets, des trades agrégés. L'utilisateur reste celui qui définit ce qu'il veut observer. Shyft, lui, vend du streaming Yellowstone gRPC avec des exemples DAMM v2 en Rust — techniquement très proche de ce que je construis, mais positionné en fournisseur d'infrastructure. Ils vendent le tuyau, pas ce qui passe dans le tuyau. À côté de ces deux-là, Blockworks Research expose des tableaux de bord agrégés sur Meteora (fees par pool, volumes), mais sur de la donnée historique consolidée à usage de recherche, pas du flux live.

Ce que je cherche dans cette liste, c'est un outil qui observe Meteora dans son ensemble. Qui ne demande pas à l'utilisateur de désigner les pools à surveiller. Qui ne raisonne pas en termes de positions individuelles mais en termes de flux de protocole — quels pools concentrent l'activité, où se déplace la liquidité, quels patterns émergent à l'échelle du protocole entier.

Je ne le trouve pas. Les outils LP sont centrés utilisateur. Les fournisseurs d'infrastructure sont centrés transport. Personne, dans cette liste, ne se positionne comme observateur analytique du protocole.

C'est suffisant pour me convaincre qu'il y a un espace. Pas un marché géant, peut-être pas un marché du tout — mais un angle qui n'est pas pris.

### Le pivot

Yog-Sothoth n'est pas un outil LP. C'est un observateur de flux qui surveille Meteora dans son ensemble.
Cette phrase paraît anodine. Elle change tout.

Dans la version précédente, l'unité de base était le pool. L'utilisateur déclarait les pools qu'il voulait suivre, le système s'abonnait à chacun, et toute l'analyse se construisait pool par pool. Le pool était la clé d'entrée du domaine — la chose qu'on souscrit, qu'on indexe, qu'on stocke.

Dans la nouvelle version, l'unité de base est le protocole. On s'abonne à Meteora dans son entier. Les pools deviennent une donnée émise par le flux : ils sont découverts au fil des transactions, enregistrés au passage, jamais déclarés à l'avance. L'analyse se fait à l'échelle du protocole, et les pools individuels ne sont qu'une dimension parmi d'autres pour découper ce flux.

Le nom prend son sens à ce moment-là. Yog-Sothoth, dans la cosmogonie de Lovecraft, est l'entité qui voit tout simultanément — passé, présent, futur, tous les plans d'existence en même temps. Si l'outil porte ce nom, il doit voir tout ce qui se passe sur Meteora, pas une sélection. Le pivot rend le projet cohérent avec son propre nom.

Et il l'inscrit dans un espace que la revue concurrentielle a montré peu occupé.

### Ce que ça change dans le code

J'avais deux semaines de code derrière moi, écrites avec le pool comme clé partout. La traduction conceptuelle dans le code n'a pas été un détail — elle a touché la colonne vertébrale du domaine. Quatre changements concentrent l'essentiel.

**Le point d'entrée du pipeline.** `RpcListener` stockait jusque-là un ensemble de pools surveillés et ouvrait une souscription WebSocket par pool. Il stocke maintenant un `HashSet<Protocol>` et ouvre une souscription par programme Meteora. Concrètement, on passe de N souscriptions (une par pool configurée) à une poignée de souscriptions stables (une par variante du protocole). Le système ne demande plus à l'utilisateur ce qu'il faut surveiller : il surveille Meteora.

**La donnée qui circule entre ingestion et indexation.** Le channel typé qui relie le `RpcListener` à l'`IndexerService` passait `(WatchedPool, Signature)` — la pool était nécessaire pour savoir quoi décoder. Il passe maintenant `(Protocol, Signature)`. C'est une ligne de code, et c'est la frontière entre les deux versions du projet : avant, l'identifiant du pool précédait la transaction ; maintenant, c'est la transaction qui le révèle.

**Les parsers, qui découvrent les pools au lieu de les recevoir.** Avant, les parsers étaient instanciés avec `pool_address` en argument — on leur disait à l'avance quelle pool ils allaient décoder. Maintenant, ils sont instanciés sans aucune adresse, et un helper `extract_pool_address` lit la position 1 dans les comptes de l'instruction outer DAMM v2 pour la déduire de la transaction elle-même. C'est le renversement complet du flot : la pool n'est plus une entrée du parser, c'est une sortie.

**Un nouveau modèle de domaine, `Pool`, comme registre de découverte.** Là où on avait `WatchedPool` (déclaratif, créé par l'utilisateur), on a maintenant `Pool` (descriptif, upserté à chaque événement entrant). C'est la trace, en base de données, du fait qu'on ne configure plus rien : on enregistre ce qui passe.
Le reste du refactor s'enchaîne mécaniquement à partir de ces quatre points. Migration SQL refaite from scratch sans clé étrangère pour aligner le schéma sur le nouveau domaine. Renommage de `reserve_a/b` en `reserve_in/out` dans `SwapEvent` parce que la direction du swap compte maintenant plus que la convention stable de l'ancien modèle. Suppression de `WatchedPool`, `WatchedPoolService`, `PgWatchedPoolRepository` — toute la machinerie de l'ancien monde, devenue morte. Le diff complet est sur le repo pour qui voudrait regarder.

### Test contre mainnet, le soir même

Le refactor s'est étalé sur une journée. À la fin, il restait à savoir si le pipeline tenait debout sous données réelles. Connexion WebSocket sur `api.mainnet-beta.solana.com`, souscription au programme DAMM v2 (`cpamdpZCGKUy5JxQXB4dcpGPiikHawvSWAd6mEn1sGG`), exécution. Les signatures arrivent en temps réel.

Premier comportement observé : aucun swap décodé. Le détecteur d'instructions DAMM v2 reste systématiquement à `false`. Diagnostic : `program_id_str` passait la chaîne `"meteora_damm_v2"` au lieu du vrai identifiant on-chain — vestige du modèle pool-centric où le label suffisait. Correction d'une ligne, le détecteur reprend.

Deuxième comportement : le détecteur reconnaît bien les transactions DAMM v2, mais l'extraction des transferts associés échoue à tous les coups. `extract_swap_transfers` cherchait l'instruction DAMM v2 _à l'intérieur_ des inner instructions, alors que dans le nouveau modèle protocol-centric c'est une instruction outer qu'il faut identifier comme telle, puis lire les transferts dans son groupe d'inner. Correction en suivant l'index de l'outer plutôt qu'en faisant du matching aveugle. L'extraction passe.

Après ces deux corrections, des swaps DAMM v2 sont décodés en direct contre mainnet. Les montants sortent justes, les mints sortent justes, les pools apparaissent dans la table de découverte au fil des transactions reçues — sans qu'aucune n'ait été déclarée à l'avance. Le pipeline tient bout en bout.

Tout n'est pas réglé pour autant. Le RPC public est sévèrement throttlé sur `getTransaction` : acceptable pour valider l'architecture, intenable pour un usage continu — il faudra basculer sur du Yellowstone gRPC (Shyft, Helius, Triton) avant de prétendre à la production. Les événements de liquidité, eux, ne se persistent pas encore correctement en base ; le décodage des swaps fonctionne, celui des liquidity events demande encore du travail. Et la machinerie pool-centric n'est pas entièrement supprimée — il reste des structs zombies à nettoyer.

Mais l'essentiel est validé. Le pivot n'est pas resté un schéma sur le papier : il tourne contre mainnet le soir même.

### Ce que cette journée a déplacé

La leçon que je tire de cette journée n'est pas "vérifier ses concurrents avant de coder". Si je l'avais fait à J-zéro, je n'aurais eu rien de concret à comparer — pas de domaine en tête, pas d'architecture esquissée, pas d'intuition de ce qui était facile ou difficile à construire. La revue serait restée abstraite.

Ce que cette journée a déplacé, c'est ma compréhension du _moment_ où la question se pose utilement. Vérifier que ce qu'on construit a un angle n'est pas une étape de business plan, à cocher avant d'écrire la première ligne. C'est une étape d'architecture : elle se pose au moment où on a assez de code pour comprendre ce qu'on est en train de faire, et pas encore assez pour que pivoter coûte trop cher. Deux semaines, pour ce projet, étaient à peu près le bon moment. Trois mois auraient été trop tard.

Le coût brut du pivot est facile à compter : une journée de refactor, deux bugs en cours de run, du code zombie à nettoyer. Le coût d'avoir continué sans le faire est plus difficile à chiffrer mais plus important. J'aurais terminé un produit qui existait déjà sous huit autres noms, mieux financés et mieux distribués. Yog-Sothoth aurait été un exercice de portfolio, pas une tentative de produit.

La question que je laisse en suspens, et qui n'a pas de réponse propre, est celle de la fréquence. À quel rythme faut-il rouvrir cette question sur un projet en cours ? Tous les mois ? À chaque changement de phase ? Quand on sent que quelque chose ne colle plus, sans savoir quoi ? Je n'ai pas la réponse. Mais je sais maintenant que la poser un dimanche soir, presque par ennui, peut changer la nature d'un projet en vingt-quatre heures.
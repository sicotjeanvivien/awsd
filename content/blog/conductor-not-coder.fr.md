---
title: "Conducteur, pas codeur"
date: 2026-06-07
lastmod: 2026-06-07
description: "Deux mois sur Yog-Sothoth, des centaines de commits, presque aucune ligne de code écrite de ma main. Et pourtant je continue à appeler ça mon projet. Voici pourquoi."
summary: "Deux mois sur Yog-Sothoth, des centaines de commits, presque aucune ligne de code écrite de ma main. Et pourtant je continue à appeler ça mon projet. Voici pourquoi."
categories: ["Yog-Sothoth"]
tags: ["Rust", "Solana", "Meteora", "IA"]
author: "Jean-Vivien Sicot"
draft: false
layout: blog
featured_image: ../assets/images/conductor_not_coder.png
---

Je n'ai jamais autant produit que depuis que j'utilise l'IA. Et pourtant, certains jours, après six commits et sept heures de travail, j'ai l'impression de n'avoir rien fait.

Depuis deux mois, je développe seul Yog-Sothoth, un outil d'analyse et d'observation du protocole DeFi Meteora sur Solana. Architecture, backend Rust, frontend Next.js, base de données, CI/CD, Docker, UX, contenu, documentation — c'est moi sur tout. Normalement, un projet de cette complexité demande une équipe : un développeur backend, un frontend, un DevOps, un product manager, ponctuellement un designer ou un data analyste. Le coût peut monter à 10 000 € par mois.

Et pourtant je le fais seul. Est-ce que l'IA remplace une équipe ? Après deux mois de développement intensif, ma réponse est non. Mais elle modifie profondément la taille de l'équipe nécessaire et le rôle de chacun.

### Comment ça se passe concrètement

Au démarrage du projet, Claude me propose une architecture en trois pièces : un daemon Rust pour l'indexeur, un Next.js pour le frontend, un Node.js pour l'API. C'est cohérent, je valide, j'avance.

Puis vient le jour où je commence l'API. Je code, et je m'aperçois que je vais devoir réécrire en Node tout ce qui existe déjà dans `yog-core`, mon crate commun Rust : schémas, requêtes SQL, repositories, contrats. Tout est déjà fait, proprement séparé entre le domaine et la persistance dans un crate `yog-persistence` indépendant. Et je m'apprête à maintenir deux implémentations du même domaine.

Je m'arrête. Je reprends la discussion avec Claude. Sa réponse initiale : faire l'API en Rust va demander beaucoup plus de travail. C'est faux — il ne voit pas que la factorisation du domaine dans `yog-core` rend l'opération triviale. Je tranche : ce sera un crate `yog-api` en Rust. Deux jours plus tard, l'API est en place.

Une semaine après, rebelote. L'API fonctionne mais elle est artisanale. Je redémarre la conversation, j'identifie le problème, Claude propose, je choisis : passage à axum. L'implémentation prend une journée. Acceptable, parce que j'ai passé du temps en amont à découper le projet selon les principes DDD et SRP, et que chaque morceau peut être remplacé sans toucher au reste.

### Ce que l'IA fait mieux que moi

Je n'écris presque plus aucune ligne de code. Mais aucune ligne n'est ajoutée sans que je l'aie validée. Claude code et propose ; j'approuve, refuse, redirige.

En codage pur, l'IA est meilleure que moi. Elle produit un code de meilleure qualité, plus rapidement, sans erreurs de syntaxe. Les tâches répétitives deviennent une formalité : schémas Zod, DTO, tests unitaires. Elle code, je vérifie.

Avant, produire une fonctionnalité prenait du temps : lecture de documentation, recherche sur StackOverflow ou GitHub, puis essais et erreurs. Aujourd'hui, le cycle est différent : j'expose le problème et le contexte, je discute techniquement avec Claude, on explore plusieurs pistes en évaluant complexité et pertinence, le code est généré une fois le contexte solide, je vérifie, j'intègre.

C'est beaucoup moins sexy que le fantasme du vibe-coding. C'est aussi beaucoup plus efficace.

### Alors à quoi je sers ?

Si Claude écrit le code, à quoi je sers ?

Quelle que soit la nature exacte de ce que fait l'IA, elle ne porte pas les conséquences de ses propositions. Elle ne sait pas quel problème est important et quel problème peut attendre. Elle ne sait pas ce qui apporte réellement de la valeur au produit. Elle propose, je vis avec.

Exemple concret. Au démarrage, Yog-Sothoth était pool-centric : le projet s'articulait autour des pools, comme la plupart des outils d'observation DeFi. C'est ce que les mots "DeFi" et "observabilité" évoquent naturellement, et c'est exactement ce qu'une IA propose — pondération de probabilités sur du vocabulaire associé.

Une IA n'aurait jamais pris la décision de basculer en protocol-centric. Et pourtant c'est la meilleure décision du projet, celle qui lui donne tout son intérêt. Parce que ce n'est pas un problème technique : c'est un problème de compréhension du marché et de positionnement produit.

Pour l'IA, option A ou option B sont deux distributions de probabilités. Pour moi, ce sont des choix qui m'engagent — c'est moi qui vais payer le coût de la mauvaise option. Je suis le seul à garantir la cohérence à long terme du projet. Je suis le seul à avoir la vision complète : produit, architecture, contraintes, évolutions futures.

Et avant qu'on me dise "tu ne donnes pas assez de contexte" : Yog-Sothoth est un projet complexe découpé en plusieurs sous-ensembles. Le contexte n'est pas complexe en soi — ce sont les différents contextes et leurs interactions qui le sont. Aucune IA ne peut encore tenir cette charge.

### Est-ce encore mon produit ?

Si je ne fais que diriger, sans rien produire moi-même, est-ce que Yog-Sothoth est mon produit, ou un assemblage de fragments écrits par d'autres et recyclés par l'IA ?

Question retournée : un développeur qui copie un bout de code depuis StackOverflow et le colle dans son projet en est-il toujours propriétaire ? Oui — parce que la valeur d'un projet n'a jamais été dans la syntaxe du code. Elle est dans la compréhension du domaine, dans la capacité à transposer un besoin métier en programme.

La valeur de Yog-Sothoth n'est pas dans la syntaxe Rust, les composants React ou les requêtes SQL. Elle est dans le choix des données observées, des métriques calculées, de l'architecture, des compromis acceptés. Ce sont mes choix, mes responsabilités.

### Conclusion

Le métier évolue. Je code moins, je produis plus, je suis fatigué cognitivement. L'indicateur de satisfaction n'est plus le nombre de lignes produites mais le nombre de décisions prises correctement. Je ne suis plus codeur — je suis chef d'orchestre, et c'est beaucoup plus prenant.

Je ne sais pas à quoi ressemblera le métier de développeur dans cinq ou dix ans. En revanche, je suis convaincu d'une chose : l'IA ne remplace pas la responsabilité. Quelqu'un doit toujours définir la direction, arbitrer les choix, comprendre pourquoi le produit existe et assumer les conséquences.

L'IA ne m'a pas transformé en équipe de dix. Elle m'a permis de concentrer mon temps sur les décisions qui comptent, en déléguant l'exécution.

Pour l'instant, celui qui décide reste le développeur.
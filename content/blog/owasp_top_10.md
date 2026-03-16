---
title: "OWASP Top 10 (2021)"
date: 2025-09-03
description: "Top 10 OWASP avec définitions, mécanismes, exemples concrets, impacts et solutions."
tags: ["OWASP", "AppSec", "Sécurité applicative", "Top 10", "Cheat Sheet"]
categories: ["Cybersécurité"]
author: "Jean-Vivien Sicot"
draft: true
showToc: true
tocOpen: false
cover:
  image: "images/articles/owasp-top10-cover.png"
  alt: "OWASP Top 10 - Logo officiel de la guêpe"
  caption: "Illustration avec le symbole OWASP pour l’article sur le Top 10"
  relative: true
---

Le **OWASP Top 10** est le classement des risques de sécurité applicative les plus critiques.  
Il sert de référence aux développeurs, pentesters et responsables sécurité.  

---

## **A01: Broken Access Control**
- **Définition** : Les contrôles d’accès sont absents, mal implémentés ou contournables.
- **Mécanisme** :
  - Contrôles uniquement côté client.
  - Références directes non sécurisées (`/user?id=124`).
  - Bypass de contrôles via paramètres cachés.
- **Exemples** :
  - Accès à `/admin` sans être administrateur.
  - Téléchargement de fichiers appartenant à d’autres utilisateurs.
- **Impacts** :
  - Exposition de données sensibles.
  - Escalade de privilèges.
- **Mitigation** :
  - Vérifications **côté serveur** obligatoires.
  - Politiques d’accès centralisées.
  - Principe du **moindre privilège**.
  - Tests automatiques sur les autorisations.

---

## **A02: Cryptographic Failures**
- **Définition** : Mauvaise protection des données sensibles.
- **Mécanisme** :
  - Stockage en clair.
  - Protocole faible (MD5, SHA1, SSLv3).
  - Mauvaise gestion des clés ou certificats.
- **Exemples** :
  - Mots de passe stockés en MD5.
  - Site en HTTP intercepté (attaque *Man-in-the-Middle*).
  - Clés API dans un repo GitHub public.
- **Impacts** :
  - Fuite d’identifiants, données médicales ou bancaires.
  - Responsabilité légale (RGPD, PCI DSS).
- **Mitigation** :
  - TLS 1.2+ obligatoire (HSTS).
  - Hashage fort des mots de passe (bcrypt, Argon2).
  - Rotation et protection des clés.
  - Ne jamais stocker plus de données que nécessaire.

---

## **A03: Injection**
- **Définition** : L’application interprète les données utilisateur comme du code.
- **Mécanisme** :
  - Entrées concaténées dans des requêtes.
  - Absence de validation/échappement.
- **Exemples** :
  - **SQL Injection** :  
    ```sql
    SELECT * FROM users WHERE name = ' ' OR '1'='1';
    ```
  - **Command Injection** :  
    `ping 8.8.8.8 && rm -rf /`
  - **LDAP Injection**.
- **Impacts** :
  - Fuite massive de données.
  - Exécution de commandes arbitraires.
  - Contrôle total de l’application.
- **Mitigation** :
  - Requêtes préparées.
  - Validation stricte des entrées.
  - Principe "deny by default".
  - WAF en complément.

---

## **A04: Insecure Design**
- **Définition** : Vulnérabilités liées à la conception de l’application.
- **Mécanisme** :
  - Pas de *threat modeling*.
  - Règles métier insuffisantes.
  - Pas de limite d’utilisation des ressources.
- **Exemples** :
  - API bancaire sans limite de virement journalier.
  - Application sans MFA prévue dès le design.
- **Impacts** :
  - Attaques exploitables même avec du code “propre”.
  - Défauts structurels impossibles à corriger rapidement.
- **Mitigation** :
  - **Security by design**.
  - Scénarios d’attaque dès la phase projet.
  - Revues d’architecture.
  - Défense en profondeur.

---

## **A05: Security Misconfiguration**
- **Définition** : Paramétrage non sécurisé ou défaut par défaut.
- **Mécanisme** :
  - Services inutiles activés.
  - Erreurs trop verbeuses.
  - Ports ou consoles admin exposés.
- **Exemples** :
  - Tomcat Manager accessible sans restriction.
  - Stack-trace affichée en production.
- **Impacts** :
  - Attaques automatisées faciles.
  - Compromission rapide d’un serveur.
- **Mitigation** :
  - **Hardening** des environnements.
  - Configurations standardisées (infrastructure as code).
  - Suppression des services inutiles.
  - Tests de configuration réguliers.

---

## **A06: Vulnerable and Outdated Components**
- **Définition** : Utilisation de composants tiers vulnérables ou non maintenus.
- **Mécanisme** :
  - Dépendances obsolètes.
  - Libs open-source non mises à jour.
- **Exemples** :
  - Faille Apache Struts → Equifax.
  - jQuery 1.x vulnérable à XSS.
- **Impacts** :
  - Exploitation de failles connues publiques.
  - Chaîne de dépendances compromise.
- **Mitigation** :
  - Inventaire des dépendances.
  - Outils SCA (OWASP Dependency-Check, Snyk).
  - Mises à jour régulières.
  - Suppression des dépendances inutiles.

---

## **A07: Identification and Authentication Failures**
- **Définition** : Failles dans l’authentification et gestion de session.
- **Mécanisme** :
  - Sessions non sécurisées.
  - MFA absent.
  - Identifiants par défaut laissés.
- **Exemples** :
  - Attaque brute force sans limite de tentatives.
  - JWT sans expiration.
  - Cookies sans `HttpOnly` ni `Secure`.
- **Impacts** :
  - Compromission de comptes utilisateurs/admin.
  - Usurpation d’identité.
- **Mitigation** :
  - MFA obligatoire.
  - Politique de mots de passe robustes.
  - Expiration/renouvellement des sessions.
  - Tokens signés et vérifiés.

---

## **A08: Software and Data Integrity Failures**
- **Définition** : Données ou code non protégés contre modification.
- **Mécanisme** :
  - Dépendances non vérifiées.
  - CI/CD non sécurisé.
- **Exemples** :
  - Dépendance npm compromise (`event-stream`).
  - Update non signée d’un logiciel.
- **Impacts** :
  - Exécution de code malveillant.
  - Supply Chain Attack.
- **Mitigation** :
  - Signatures numériques obligatoires.
  - CI/CD sécurisé avec contrôle d’intégrité.
  - Contrôle d’origine des dépendances.
  - Séparation des environnements.

---

## **A09: Security Logging and Monitoring Failures**
- **Définition** : Manque de surveillance et de journalisation efficace.
- **Mécanisme** :
  - Absence de logs.
  - Logs insuffisants ou non surveillés.
- **Exemples** :
  - Attaques brute force non détectées.
  - Absence d’alerte sur des accès critiques.
- **Impacts** :
  - Détection tardive (voire inexistante) des attaques.
  - Investigation impossible.
- **Mitigation** :
  - Centralisation des logs (ELK, Splunk).
  - SIEM avec alertes.
  - Tests de *incident response*.
  - Rétention des logs sécurisée.

---

## **A10: Server-Side Request Forgery (SSRF)**
- **Définition** : L’application récupère des ressources externes sans contrôle.
- **Mécanisme** :
  - L’attaquant fournit une URL malveillante.
  - Le serveur fait la requête à sa place.
- **Exemples** :
  - App qui va chercher `http://localhost:8080/admin`.
  - Accès aux métadonnées AWS via `http://169.254.169.254/`.
- **Impacts** :
  - Accès non autorisé aux services internes.
  - Mouvement latéral dans le réseau.
- **Mitigation** :
  - **Whitelist** des domaines.
  - Bloquer les plages IP internes.
  - Timeout stricts.
  - Filtrage DNS et proxy.

---

# 🚨 Synthèse
- Le **Top 10 OWASP est une base minimale** pour toute organisation.
- Il couvre 3 grands axes :
  1. **Failles techniques** (injection, SSRF, crypto).
  2. **Failles humaines/organisationnelles** (config, logs, design).
  3. **Chaîne logicielle** (dépendances, CI/CD, supply chain).
- C’est une **référence mondiale** utilisée dans les normes (ISO, PCI DSS, etc.).

![Schéma OWASP Top 10](/images/articles/owasp-top10-mindmap.png "OWASP Mindmap")

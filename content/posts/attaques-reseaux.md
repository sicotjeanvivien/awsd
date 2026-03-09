---
title: "🌐 Attaques Réseau : comprendre et se protéger"
date: 2025-08-28
lastmod: 2025-08-28
description: "Panorama des attaques ciblant les communications réseau (sniffing, MITM, DDoS, DNS spoofing, BGP hijacking, etc.) et des contre-mesures pour assurer confidentialité, intégrité et disponibilité."
summary: "Sniffing, MITM, DDoS, DNS spoofing, BGP hijacking : découvrez les attaques qui visent directement la circulation des données et les solutions pour protéger vos réseaux."
categories: ["Cybersécurité"]
tags: ["réseau", "cybersécurité", "MITM", "DDoS", "DNSSEC", "BGP"]
author: "Jean-Vivien Sicot"
draft: false
showToc: true
tocOpen: false
cover:
  image: "images/articles/chat-cyberhacker-network-attacks.png"
  alt: "Illustration abstraite de la cybersécurité réseau"
  caption: "Les attaques réseau visent la circulation des données entre systèmes."
---

# Attaques Réseau

Les attaques réseau ciblent les communications entre machines, services et utilisateurs.  
Elles exploitent les faiblesses des protocoles (ARP, DNS, BGP…), l’absence de chiffrement ou la 
confiance implicite entre équipements pour **intercepter, modifier ou perturber le trafic**.  

Elles peuvent être passives (sniffing, écoute), actives (MITM, spoofing) ou massives (DoS/DDoS, 
hijacking). Leur point commun est de s’attaquer à la **circulation des données**, qu’il s’agisse 
de voler des identifiants, détourner une connexion ou rendre un service indisponible.  

Comprendre ces attaques est essentiel pour appliquer des contre-mesures efficaces : 
chiffrement bout à bout, segmentation réseau, surveillance des protocoles, 
et adoption de standards sécurisés comme DNSSEC, WPA3 ou RPKI.

---

## 1. Sniffing (écoute réseau)

### 1. Situation de départ
Un utilisateur se connecte à un réseau partagé (Wi-Fi public, hub).  
Le trafic circule en clair (HTTP, FTP, Telnet).

### 2. Ce que fait l’attaquant
Il met sa carte réseau en mode “promiscuous” et capture tout ce qui passe.  
Les paquets contiennent des identifiants, mails, formulaires.

### 3. Conséquence
L’attaquant peut lire directement des mots de passe ou données sensibles.

### 4. Pourquoi c’est possible
- Certains protocoles ne chiffrent pas les données.  
- Sur des réseaux partagés, plusieurs machines peuvent voir le même trafic.  

### 5. Contre-mesures

#### 🔒 Chiffrement bout à bout (HTTPS, TLS, SSH)
- **Comment ça marche** : les données sont chiffrées côté client et déchiffrées uniquement côté serveur.  
- **Pourquoi ça protège** : même si l’attaquant intercepte les paquets, il ne voit que du texte illisible.

#### 📶 Wi-Fi sécurisé (WPA2/WPA3)
- **Comment ça marche** : chaque client obtient une clé de session unique après authentification.  
- **Pourquoi ça protège** : un attaquant qui “écoute” n’a pas la clé et ne peut pas déchiffrer le trafic.

#### 🌐 VPN
- **Comment ça marche** : chiffre tout le trafic de la machine avant de le faire sortir sur Internet.  
- **Pourquoi ça protège** : même si le Wi-Fi est compromis, le contenu reste caché.

---

## 2. Man-in-the-Middle  "MITM" via ARP Spoofing (usurpation )

### 1. Situation de départ
Un PC communique avec Internet via une passerelle.  
Le protocole ARP gère l’association IP ↔ PC.

### 2. Ce que fait l’attaquant
Il envoie de fausses réponses ARP :  
- au PC : “la passerelle, c’est moi”  
- à la passerelle : “le PC, c’est moi”  
Résultat : tout le trafic passe par lui.

### 3. Conséquence
- Espionnage, modification, coupure de connexion.  

### 4. Pourquoi c’est possible
- ARP ne vérifie pas l’identité des annonces.  
- Les LAN ne bloquent pas par défaut ces faux messages.  

### 5. Contre-mesures

#### 🔒 TLS / HTTPS
- Empêche l’attaquant de lire/modifier les données même s’il les intercepte.

#### 🛡️ Dynamic ARP Inspection (DAI)
- Vérifie chaque réponse ARP sur le switch.  
- Les annonces falsifiées sont rejetées.

#### 🧩 Segmentation réseau (VLAN)
- Sépare les utilisateurs en zones distinctes.  
- Un attaquant invité ne peut pas intercepter le trafic interne.

#### 🌐 VPN
- Chiffre le trafic dès la sortie du PC.  
- L’attaquant voit passer les paquets, mais ils sont illisibles.

---

## 3. IP Spoofing (Usurpation d'adresse IP)

### 1. Situation de départ
Un serveur reçoit du trafic IP.

### 2. Ce que fait l’attaquant
Il falsifie l’adresse IP source dans ses paquets.  
Le serveur croit recevoir du trafic d’un hôte légitime.

### 3. Conséquence
- Détournement de session TCP vulnérable.  
- Amplification d’attaques DDoS.  

### 4. Pourquoi c’est possible
- Le champ “IP source” n’est pas authentifié.  
- Les routeurs acceptent souvent les paquets sans contrôle.  

### 5. Contre-mesures

#### 🛑 Filtrage anti-spoofing (BCP 38)
- Les routeurs vérifient que les paquets sortants appartiennent bien au sous-réseau local.  
- Les paquets usurpés sont bloqués dès leur sortie.

#### 🔒 Protocoles avec authentification (TLS, VPN)
- Un paquet peut prétendre venir d’une IP, mais sans les bons certificats, il n’est pas accepté.

#### 🔍 IDS/IPS
- Détectent incohérences entre IP source et chemin réseau (ex. IP censée venir de France mais en réalité captée en Asie).

---

## 4. Denial of Service (DoS / DDoS)

### 1. Situation de départ
Un site web est en ligne, exposé à tous.

### 2. Ce que fait l’attaquant
Il envoie un volume énorme de requêtes via un botnet.  
Le serveur ne peut pas traiter le flux.

### 3. Conséquence
Le service devient indisponible.  

### 4. Pourquoi c’est possible
- Les serveurs ont des ressources limitées.  
- Les protocoles (HTTP, TCP) traitent toute requête comme honnête.  

### 5. Contre-mesures

#### ☁️ CDN / Anycast
- Répartit les requêtes sur plusieurs serveurs géographiquement dispersés.  
- Pourquoi ça protège : le trafic est dilué, aucun serveur n’est saturé.

#### 🚦 Rate limiting
- Bloque ou ralentit une IP après X requêtes/s.  
- Pourquoi ça protège : réduit l’impact d’un attaquant isolé, force le botnet à se disperser.

#### 🧱 Firewalls anti-DDoS
- Filtrent les paquets suspects (ex. requêtes incomplètes).  
- Pourquoi ça protège : le serveur final reçoit uniquement du trafic “valide”.

---

## 5. DNS Spoofing / Cache Poisoning (Empoisonnement du cache DNS)

### 1. Situation de départ
Un utilisateur demande l’IP de `banque.fr` à un résolveur DNS.

### 2. Ce que fait l’attaquant
Il envoie une fausse réponse DNS avec une IP malveillante.  
Le résolveur met cette IP en cache.

### 3. Conséquence
L’utilisateur est redirigé vers un faux site (phishing).  

### 4. Pourquoi c’est possible
- DNS classique ne vérifie pas la légitimité des réponses.  
- Le résolveur fait confiance à la première réponse reçue.  

### 5. Contre-mesures

#### 🔑 DNSSEC
- Chaque réponse DNS est signée cryptographiquement.  
- Pourquoi ça protège : le résolveur rejette les réponses non signées ou modifiées.

#### 🛡️ Résolveurs fiables
- Google DNS, Cloudflare ou Quad9 appliquent des protections renforcées.  
- Pourquoi ça protège : moins exposés aux empoisonnements que de petits serveurs.

#### 🔍 Monitoring DNS
- Détecter anomalies : un domaine soudain pointant vers une IP étrangère.  

---

## 6. DHCP Spoofing (Dynamic Host Configuration Protocol)

### 1. Situation de départ
Un client demande sa config IP à un serveur DHCP.

### 2. Ce que fait l’attaquant
Il se fait passer pour un serveur DHCP et répond plus vite.  
Il attribue de fausses infos (ex. passerelle = machine de l’attaquant).

### 3. Conséquence
Tout le trafic du client passe par l’attaquant.  

### 4. Pourquoi c’est possible
- DHCP fait confiance à toute réponse reçue.  
- Aucun mécanisme d’authentification.  

### 5. Contre-mesures

#### 🔒 DHCP Snooping
- Le switch surveille les réponses DHCP.  
- Seuls les ports “autorisés” peuvent agir comme serveur DHCP.  
- Pourquoi ça protège : le faux serveur est bloqué.

#### 🧩 Segmentation réseau
- Isoler les réseaux clients et serveurs.  
- Pourquoi ça protège : l’attaquant n’est pas sur le même segment.  

---

## 7. BGP Hijacking (détournement IP/prefix/route)

### 1. Situation de départ
Les opérateurs utilisent BGP pour annoncer les routes IP.

### 2. Ce que fait l’attaquant
Il annonce une route plus spécifique que la légitime.  
Le trafic mondial est redirigé vers lui.

### 3. Conséquence
- Interception de trafic à grande échelle.  
- Coupure de services.  

### 4. Pourquoi c’est possible
- BGP fonctionne sur la confiance entre opérateurs.  
- Pas d’authentification native.  

### 5. Contre-mesures

#### 🔑 RPKI (Resource Public Key Infrastructure)
- Chaque route annoncée est signée et vérifiable.  
- Pourquoi ça protège : les fausses annonces sont rejetées.

#### 🔍 Monitoring BGP
- Outils comme RIPE RIS ou MANRS surveillent les annonces anormales.  
- Pourquoi ça protège : permet de réagir rapidement.

#### 📏 Filtrage strict
- Les opérateurs filtrent les routes de leurs clients.  
- Pourquoi ça protège : un client ne peut pas annoncer un préfixe qui ne lui appartient pas.  

---

## 8. Attaques Wi-Fi (Evil Twin)

### 1. Situation de départ
Un utilisateur cherche à se connecter à un Wi-Fi public.

### 2. Ce que fait l’attaquant
Il crée un point d’accès avec le même SSID (nom) qu’un réseau légitime.  
L’utilisateur s’y connecte automatiquement.

### 3. Conséquence
Tout le trafic passe par l’attaquant.  

### 4. Pourquoi c’est possible
- Les clients Wi-Fi font confiance aux SSID connus.  
- Pas de vérification que le point d’accès est “le vrai”.  

### 5. Contre-mesures

#### 🔒 WPA3-Enterprise
- Authentification forte avec certificats.  
- Pourquoi ça protège : impossible pour l’attaquant de se faire passer pour le vrai réseau sans les bons certificats.

#### 📶 Désactiver la reconnexion automatique
- Forcer l’utilisateur à choisir manuellement le réseau.  
- Pourquoi ça protège : l’ordi ne saute pas automatiquement sur le faux AP.

#### 🌐 VPN
- Le trafic est chiffré dès le départ.  
- Pourquoi ça protège : même sur un AP malveillant, les données restent illisibles.

#### 🔍 WIDS (Wireless Intrusion Detection System)
- Surveille l’air et détecte les SSID suspects.  
- Pourquoi ça protège : alerte si un “clone” du réseau apparaît.

---
# Conclusion

Les attaques réseau illustrent à quel point l’Internet repose sur la **confiance entre équipements 
et protocoles**. Une simple absence de chiffrement ou de vérification d’identité permet à un attaquant 
d’intercepter ou de manipuler des communications sensibles.  

Trois axes majeurs ressortent :  

- **Confidentialité** → protéger les échanges par du chiffrement (TLS, VPN, WPA3).  
- **Intégrité** → empêcher la modification ou l’usurpation (DNSSEC, DAI, RPKI).  
- **Disponibilité** → résister aux saturations massives (CDN, filtrage anti-DDoS).  

En résumé, sécuriser les réseaux ne se limite pas à déployer des firewalls : il s’agit d’un 
ensemble de pratiques combinant **protocoles robustes, supervision active et conception 
résiliente** des infrastructures.
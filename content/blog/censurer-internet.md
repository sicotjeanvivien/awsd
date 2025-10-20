---
title: "Peut-on vraiment censurer Internet ?"
date: 2025-08-25
tags: ["internet", "censure", "réseau", "liberté"]
categories: ["Articles"]
summary: "On parle souvent de censure d’Internet. Mais techniquement, est-elle seulement possible ?"
cover:
  image: "images/articles/censurer-internet-cover.png"
  alt: "Illustration sur la censure d’Internet"
  caption: "Peut-on vraiment censurer Internet ?"
---

## Introduction
On entend régulièrement que certains pays « censurent Internet ». Le terme fait peur, il évoque un réseau coupé, des contenus effacés, une liberté supprimée.  
Mais est-ce seulement possible sur le plan technique ? Internet a été conçu dès son origine comme un réseau décentralisé, pensé pour résister aux coupures, aux pannes et même à la guerre.  

En réalité, ce que l’on appelle « censure d’Internet » n’est pas une censure du réseau lui-même, mais un contrôle **de l’accès** à certaines ressources. Et même là, ces tentatives sont rarement efficaces à long terme.

---

## Censure vs. limitation d’accès
Il faut distinguer deux notions :  
- **Censure totale** : l’information n’existe plus, elle est supprimée à la source.  
- **Limitation d’accès** : l’information existe toujours, mais l’utilisateur est empêché d’y accéder par des barrières techniques.  

👉 Sur Internet, seule la seconde est possible. On ne peut pas « effacer » une page du web mondial. Au mieux, on peut empêcher un internaute d’y accéder depuis un point donné du réseau.

---

## Comment les États tentent de contrôler Internet
Plusieurs techniques existent :  

- **Blocage DNS** : rediriger ou neutraliser les requêtes de résolution de nom (par ex. empêcher `discord.com` de répondre).  
- **Blocage IP ou filtrage BGP** : couper l’accès à certaines adresses ou détourner le routage.  
- **Inspection profonde des paquets (DPI)** : analyser le trafic en détail pour bloquer des protocoles ou services.  
- **Coupures massives** : désactiver des réseaux mobiles ou des câbles sous-marins (ex. Égypte 2011).  

Toutes ces méthodes ont en commun une chose : elles agissent au niveau **national**, pas sur Internet dans son ensemble.

---

## Exemple : la censure ratée de Discord en Russie
En 2017, la Russie a tenté de bloquer Discord, l’application de messagerie prisée par les communautés de joueurs.  
Le blocage a été mis en place via des restrictions d’adresses IP et des filtrages DNS. Mais le résultat a été… un échec.  

Les utilisateurs russes ont très vite trouvé des moyens de contournement : VPN, proxies, et même de simples changements de DNS publics (comme ceux de Google ou Cloudflare).  
Au bout de quelques mois, la mesure a été abandonnée, car elle était devenue inefficace et impopulaire.  

Cet épisode illustre bien la réalité : **empêcher l’accès à une plateforme est temporaire**, et la résilience des utilisateurs finit toujours par gagner.

---

## Les moyens de contournement
Internet étant conçu comme un réseau résilient et distribué, chaque tentative de blocage trouve rapidement une parade. Parmi les plus utilisées :  

### 1. Les VPN (Virtual Private Network)
Les VPN chiffrent la connexion et la redirigent via un serveur situé dans un autre pays.  
- Ils contournent les blocages DNS et IP.  
- Ils rendent difficile l’analyse du trafic (DPI).  
- Leur usage est devenu massif dans les pays soumis à des restrictions (Russie, Turquie, Iran).  

### 2. Le réseau Tor
Tor (« The Onion Router ») repose sur un routage en couches chiffrées.  
- Permet d’accéder à Internet de manière anonyme.  
- Contourne la plupart des filtrages nationaux.  
- Souvent ciblé par les États… mais il continue de fonctionner grâce à ses **nœuds relais cachés**.

### 3. Les DNS publics et chiffrés
Changer de serveur DNS (Google, Cloudflare, Quad9…) permet de contourner les blocages locaux.  
- Avec **DoH (DNS over HTTPS)** ou **DoT (DNS over TLS)**, même l’opérateur ne peut plus filtrer les requêtes de noms de domaine.  

### 4. Les proxies et tunnels
Des serveurs intermédiaires ou des outils comme **SSH tunneling** permettent de rediriger le trafic et de masquer son origine.  
- Moins sécurisés qu’un VPN, mais rapides à mettre en place.  

### 5. Les réseaux alternatifs
En cas de coupure totale, des solutions émergent :  
- **Internet par satellite** (ex. Starlink en Ukraine).  
- **Réseaux mesh** (maillage local via Wi-Fi/Bluetooth).  
- **Radio amateur et SMS-gateways** pour transmettre de petits volumes d’informations.  

---

## Les limites de la censure technique
- Les contournements sont accessibles même à des utilisateurs non experts.  
- Plus un pays tente de bloquer, plus sa population apprend à contourner.  
- La censure a souvent des effets de bord : coupures de services tiers, ralentissements, mécontentement social.  

En pratique, **aucune barrière technique n’est durable** : tôt ou tard, un chemin de traverse apparaît.

---

## Les rares cas de contrôle quasi-total
Il existe toutefois quelques exceptions :  
- **Chine** : le « Grand Firewall » contrôle les backbones et surveille l’ensemble des flux.  
- **Corée du Nord** : Internet est inaccessible à la majorité de la population, remplacé par un intranet national.  
- **Iran** : des coupures massives sont régulièrement imposées lors de crises politiques.  

Ces cas restent rares, car ils nécessitent une **centralisation complète des infrastructures** nationales. La plupart des pays n’ont pas cette architecture.

---

## Conclusion
Peut-on censurer Internet ? Non.  
On peut limiter l’accès à certaines parties du réseau, parfois de manière sévère, mais **le réseau lui-même échappe à toute censure globale**.  

Les tentatives de blocage montrent toujours la même chose : dès qu’un utilisateur a le moindre accès, il a aussi les moyens de contourner.  
Internet, par sa conception, reste un espace résilient — et cela explique pourquoi la « censure » dont on parle souvent n’est, au fond, qu’un contrôle partiel et temporaire.

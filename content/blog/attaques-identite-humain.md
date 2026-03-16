---
title: "👨‍👨‍👧‍👦 Attaques sur l’identité et l’humain (Ingénierie sociale)"
date: 2025-08-28
lastmod: 2025-08-28
description: "Phishing, vishing, smishing, fraude au président, tailgating… Tour d’horizon des attaques qui exploitent les faiblesses humaines et sociales pour contourner la sécurité technique."
summary: "Les attaques d’ingénierie sociale visent l’humain plus que la machine. Découvrez les principales techniques (phishing, vishing, smishing, fraude au président, etc.) et les contre-mesures pour renforcer la vigilance et la culture sécurité."
categories: ["Cybersécurité"]
tags: ["ingénierie sociale", "identité", "phishing", "fraude", "cybersécurité"]
author: "Jean-Vivien Sicot"
draft: true
showToc: true
tocOpen: false
cover:
  image: "images/articles/chat-cyberhacker-social-engineering.png"
  alt: "Illustration abstraite représentant les attaques d’ingénierie sociale"
  caption: "L’humain reste le maillon le plus faible de la sécurité."
---

# Attaques sur l’identité et l’humain (Ingénierie sociale)

Les attaques sur l’identité et l’humain ne reposent pas sur une faille technique, mais sur 
les **faiblesses psychologiques et comportementales**.  
L’attaquant exploite la confiance, la curiosité, la peur, la politesse ou l’autorité pour 
obtenir des informations sensibles, pousser une action non voulue ou accéder à un système.  

Elles se déclinent sous de nombreuses formes : emails frauduleux (phishing, spear phishing), 
appels téléphoniques (vishing), SMS (smishing), faux supports techniques, ou encore intrusion 
physique (tailgating, dumpster diving, shoulder surfing).  
Leur efficacité repose sur un point central : **l’humain est souvent le maillon le plus faible 
de la sécurité**.

---

## 1. Phishing

### 1. Situation de départ
Un utilisateur reçoit un email semblant venir de sa banque :  
“Votre compte est bloqué, cliquez ici pour réactiver”.

### 2. Ce que fait l’attaquant
- Le mail contient un lien vers un faux site imitant le vrai.  
- L’utilisateur entre ses identifiants de connexion.  

### 3. Conséquence
- Vol des identifiants.  
- Accès illégitime au compte bancaire.  

### 4. Pourquoi c’est possible
- Les emails peuvent facilement usurper une identité visuelle.  
- Les utilisateurs font confiance à ce qu’ils reconnaissent (logo, style).  

### 5. Contre-mesures

#### ✅ Formation des utilisateurs
- Expliquer comment repérer les signaux (URL différente, fautes d’orthographe).  
- **Pourquoi ça protège** : réduit les chances que l’utilisateur tombe dans le piège.  

#### ✅ Authentification forte
- MFA (SMS, TOTP, clé physique).  
- **Pourquoi ça protège** : même si le mot de passe est volé, l’accès reste bloqué.  

#### ✅ Filtres anti-phishing
- Passerelles mail avec détection d’URL suspectes.  
- **Pourquoi ça protège** : bloque ou marque les mails avant qu’ils atteignent l’utilisateur.  

---

## 2. Spear Phishing

### 1. Situation de départ
Un employé reçoit un mail personnalisé :  
“Bonjour Jean, voici la facture pour le projet X dont vous avez parlé avec Paul”.

### 2. Ce que fait l’attaquant
- Utilise des informations personnelles récupérées sur LinkedIn ou réseaux sociaux.  
- Rend l’email crédible et ciblé.  

### 3. Conséquence
- L’utilisateur clique ou ouvre la pièce jointe.  
- Vol d’identifiants, installation d’un malware.  

### 4. Pourquoi c’est possible
- Les attaquants collectent facilement des infos publiques.  
- Les utilisateurs ne s’attendent pas à ce niveau de personnalisation.  

### 5. Contre-mesures

#### ✅ Sensibilisation renforcée
- Expliquer aux employés que même un mail crédible peut être piégé.  
- **Pourquoi ça protège** : augmente la vigilance face aux mails personnalisés.  

#### ✅ Vérification systématique
- Avant d’exécuter une demande sensible (paiement, virement), confirmer par téléphone ou canal différent.  
- **Pourquoi ça protège** : empêche qu’un simple mail trompe un employé.  

#### ✅ DLP et sandbox
- Scanner les pièces jointes et liens avant ouverture.  
- **Pourquoi ça protège** : limite l’exécution de malwares via pièces jointes piégées.  

---

## 3. Vishing (Voice Phishing)

### 1. Situation de départ
Un employé reçoit un appel téléphonique d’un “support technique Microsoft”.

### 2. Ce que fait l’attaquant
- Il explique que l’ordinateur est infecté.  
- Il demande à installer un logiciel de prise en main à distance.  

### 3. Conséquence
- L’attaquant prend le contrôle du poste.  
- Vol de données, installation de ransomware.  

### 4. Pourquoi c’est possible
- La voix donne une impression de légitimité et d’urgence.  
- Les utilisateurs veulent souvent “aider” ou résoudre vite un problème.  

### 5. Contre-mesures

#### ✅ Procédures internes
- Avoir un canal officiel pour le support technique.  
- **Pourquoi ça protège** : évite de faire confiance à un appel spontané.  

#### ✅ Formation à la reconnaissance
- Expliquer les signaux d’alerte (demande d’installer un logiciel, urgence).  
- **Pourquoi ça protège** : permet à l’utilisateur de raccrocher sans culpabilité.  

#### ✅ Caller ID et filtrage
- Outils pour identifier et bloquer les numéros frauduleux.  
- **Pourquoi ça protège** : réduit la probabilité d’exposition.  

---

## 4. Smishing (SMS Phishing)

### 1. Situation de départ
Un utilisateur reçoit un SMS :  
“Votre colis est en attente, cliquez ici pour payer 1€ de frais”.

### 2. Ce que fait l’attaquant
- Le lien mène à un faux site de livraison.  
- L’utilisateur entre ses infos bancaires.  

### 3. Conséquence
- Vol de carte bancaire.  
- Fraudes financières.  

### 4. Pourquoi c’est possible
- Les SMS paraissent venir d’un numéro connu (ex. La Poste).  
- Les utilisateurs font confiance aux messages courts et urgents.  

### 5. Contre-mesures

#### ✅ Vérification hors bande
- Contacter directement le service concerné via leur site officiel.  
- **Pourquoi ça protège** : on évite de cliquer sur le lien frauduleux.  

#### ✅ Sensibilisation
- Expliquer que les organismes ne demandent jamais d’infos sensibles par SMS.  
- **Pourquoi ça protège** : l’utilisateur identifie la fraude plus facilement.  

#### ✅ Filtrage opérateur
- Certains opérateurs bloquent déjà les SMS suspects.  
- **Pourquoi ça protège** : réduit l’exposition en amont.  

---

## 5. Pretexting (usurpation de rôle)

### 1. Situation de départ
Un attaquant appelle un employé en se faisant passer pour le service informatique.  

### 2. Ce que fait l’attaquant
- Il invente un scénario crédible : “nous faisons une mise à jour de sécurité, j’ai besoin de vos identifiants”.  
- L’utilisateur, rassuré, coopère.  

### 3. Conséquence
- Vol de mots de passe.  
- Accès direct aux systèmes internes.  

### 4. Pourquoi c’est possible
- Les humains ont tendance à faire confiance à une autorité perçue.  
- Pas de procédure formelle pour vérifier l’identité du demandeur.  

### 5. Contre-mesures

#### ✅ Procédures d’authentification interne
- Exiger un code interne ou une vérification par un autre canal.  
- **Pourquoi ça protège** : empêche qu’un simple appel suffise.  

#### ✅ Sensibilisation à l’autorité
- Former les employés à résister aux pressions d’autorité.  
- **Pourquoi ça protège** : réduit la manipulation psychologique.  

---

## 6. Quid pro quo

### 1. Situation de départ
Un employé reçoit un appel : “Nous offrons une carte cadeau Amazon si vous installez ce logiciel de test”.  

### 2. Ce que fait l’attaquant
- Il propose un “service” en échange d’une action.  
- L’utilisateur installe un logiciel malveillant.  

### 3. Conséquence
- Infection du poste.  
- Accès non autorisé aux systèmes internes.  

### 4. Pourquoi c’est possible
- Les humains aiment recevoir une récompense pour un petit effort.  
- L’offre semble anodine.  

### 5. Contre-mesures

#### ✅ Politique stricte d’installation logicielle
- Interdire toute installation non validée par l’IT.  
- **Pourquoi ça protège** : même si l’employé est tenté, l’installation échoue.  

#### ✅ Sensibilisation à la manipulation
- Expliquer que “cadeaux” et “bonus” peuvent cacher une attaque.  
- **Pourquoi ça protège** : l’utilisateur hésite avant d’accepter.  

---
## 7. Fraude au président (Business Email Compromise)

### 1. Situation de départ
Une assistante comptable reçoit un mail du “PDG” de son entreprise :  
“Je suis en déplacement à l’étranger, c’est urgent : fais un virement de 50 000 € à ce compte fournisseur”.

### 2. Ce que fait l’attaquant
- Le mail imite l’adresse du PDG (ex. `ceo@entreprlse.com` avec un “l” remplacé par un “i”).  
- Il joue sur l’urgence et l’autorité.  
- Il demande de contourner les procédures habituelles (“ne parle à personne, c’est confidentiel”).  

### 3. Conséquence
- L’employée effectue le virement.  
- L’argent est perdu et difficilement récupérable.  

### 4. Pourquoi c’est possible
- L’humain est sensible à l’autorité (surtout venant du PDG).  
- Pression du temps → absence de vérification.  
- Pas de procédure de double validation pour les virements.  

### 5. Contre-mesures

#### ✅ Procédure de validation des paiements
- Tout virement doit être validé par deux personnes.  
- **Pourquoi ça protège** : empêche qu’une seule personne, manipulée, exécute la fraude.  

#### ✅ Sensibilisation aux faux emails
- Montrer des exemples concrets de domaines usurpés.  
- **Pourquoi ça protège** : habitue l’employé à vérifier attentivement l’adresse.  

#### ✅ Simulation de phishing interne
- Organiser des tests contrôlés pour mesurer la réaction des employés.  
- **Pourquoi ça protège** : entraîne les réflexes en conditions réalistes.  

---

## 8. Faux support technique (tech support scam)

### 1. Situation de départ
Un employé reçoit un appel d’un “technicien Microsoft” :  
“Votre ordinateur envoie des erreurs, nous devons intervenir immédiatement”.

### 2. Ce que fait l’attaquant
- Il demande à installer un logiciel de prise de contrôle à distance (ex. TeamViewer).  
- Il affiche volontairement de faux messages d’erreur pour convaincre la victime.  

### 3. Conséquence
- L’attaquant prend le contrôle complet du poste.  
- Il peut voler des fichiers, installer un ransomware.  

### 4. Pourquoi c’est possible
- L’humain fait confiance à une personne qui paraît compétente et utilise du jargon technique.  
- Le sentiment d’urgence empêche de réfléchir.  

### 5. Contre-mesures

#### ✅ Procédures officielles de support
- Communiquer aux employés le seul canal légitime du support interne.  
- **Pourquoi ça protège** : ils savent immédiatement qu’un appel externe est suspect.  

#### ✅ Limiter les droits d’admin
- Les utilisateurs n’ont pas le droit d’installer des logiciels.  
- **Pourquoi ça protège** : même si manipulé, l’employé ne peut pas donner la main.  

#### ✅ Formation par jeux de rôle
- Simuler des appels de faux techniciens lors de formations.  
- **Pourquoi ça protège** : habitue les utilisateurs à dire “non” sans culpabiliser.  

---

## 9. Tailgating (intrusion physique par suivi)

### 1. Situation de départ
Une entreprise utilise un badge pour entrer dans les bureaux.  

### 2. Ce que fait l’attaquant
- Il attend qu’un employé ouvre la porte.  
- Il se glisse derrière en tenant un café ou en parlant au téléphone.  
- L’employé, par politesse, ne lui demande pas de badger.  

### 3. Conséquence
- L’attaquant accède physiquement aux bureaux.  
- Vol de matériel, branchement d’un keylogger, récupération de documents imprimés.  

### 4. Pourquoi c’est possible
- La politesse et la confiance sont des biais humains forts.  
- Les employés n’osent pas “jouer à la police”.  

### 5. Contre-mesures

#### ✅ Politique “no tailgating”
- Former les employés à fermer les portes derrière eux.  
- **Pourquoi ça protège** : réduit la possibilité de suivre quelqu’un sans badge.  

#### ✅ Vidéosurveillance et contrôles
- Caméras et personnel de sécurité.  
- **Pourquoi ça protège** : dissuade et permet d’identifier une intrusion.  

#### ✅ Sensibilisation à l’ingénierie sociale physique
- Expliquer que l’attaquant utilisera la politesse comme arme.  
- **Pourquoi ça protège** : déculpabilise l’employé qui ose demander un badge.  

---

## 10. Dumpster Diving (fouille de poubelles)

### 1. Situation de départ
Une entreprise jette ses brouillons, factures ou vieux disques durs sans précaution.  

### 2. Ce que fait l’attaquant
- Il fouille les poubelles ou récupère des disques jetés.  
- Il y trouve des informations sensibles (numéros clients, logins, données financières).  

### 3. Conséquence
- Vol d’informations confidentielles.  
- Préparation d’attaques ciblées (phishing crédible).  

### 4. Pourquoi c’est possible
- Les documents ou supports ne sont pas détruits correctement.  
- Les employés considèrent la poubelle comme “sécurisée”.  

### 5. Contre-mesures

#### ✅ Broyeurs de documents
- Détruire tous les papiers sensibles avant de les jeter.  
- **Pourquoi ça protège** : rend la reconstitution impossible.  

#### ✅ Effacement sécurisé des disques
- Utiliser des outils de wipe ou destruction physique.  
- **Pourquoi ça protège** : empêche la récupération de données effacées.  

#### ✅ Politique de gestion des déchets
- Définir clairement quoi jeter, où, et comment.  
- **Pourquoi ça protège** : réduit les fuites accidentelles.  

---

## 11. Shoulder Surfing (observation visuelle)

### 1. Situation de départ
Un employé travaille dans un café ou un open space.  

### 2. Ce que fait l’attaquant
- Il s’assoit derrière ou à côté.  
- Il observe les mots de passe tapés ou lit les infos affichées.  

### 3. Conséquence
- Vol d’identifiants.  
- Divulgation d’informations sensibles.  

### 4. Pourquoi c’est possible
- Les écrans sont visibles par des personnes non autorisées.  
- Aucun filtre visuel.  

### 5. Contre-mesures

#### ✅ Filtres de confidentialité sur écrans
- Limite l’angle de vision.  
- **Pourquoi ça protège** : seul l’utilisateur en face peut lire.  

#### ✅ Posture discrète
- Tourner l’écran vers un mur ou un angle discret.  
- **Pourquoi ça protège** : réduit les risques d’espionnage accidentel.  

#### ✅ Sensibilisation
- Expliquer que l’espionnage peut être aussi simple qu’un regard discret.  
- **Pourquoi ça protège** : incite à plus de vigilance en public.  

---

# Conclusion

Les attaques d’ingénierie sociale rappellent que la sécurité ne dépend pas uniquement des machines 
et des protocoles, mais aussi de la vigilance des personnes.  
En usurpant une identité, en jouant sur l’urgence ou en exploitant la politesse, un attaquant peut 
obtenir plus qu’avec une attaque technique complexe.  

Trois axes majeurs se dégagent :  

- **Sensibilisation et formation** → donner aux utilisateurs les bons réflexes.  
- **Procédures claires** → exiger des validations multiples, définir des canaux officiels.  
- **Culture de sécurité** → déculpabiliser les employés qui doutent ou refusent une demande suspecte.  

En résumé, la défense face à ces attaques repose moins sur la technologie que sur l’**hygiène 
comportementale** et la **maturité collective** face aux manipulations.
# AetherDesk — Roadmap

> Un environnement de travail complet sur Android, pour ceux qui n'ont pas d'ordinateur.

---

## Principe directeur

On ne change pas de version selon une date, mais selon un **déclencheur mesurable**.
Tant que le déclencheur n'est pas atteint, on ne passe pas à la version suivante.

**Règle absolue :** un module n'est ajouté que lorsque le précédent est réellement utilisable.
Pas d'interface vide, pas de données factices en production.

---

## Contraintes permanentes

| Contrainte | Conséquence |
|---|---|
| Machine 4 Go RAM | Aucun `flutter build` / `flutter run` en local. Uniquement `flutter analyze` et `dart format`. |
| Compilation | Exclusivement via GitHub Actions. |
| Carte bancaire non validée | Pas de Play Store, pas de Galaxy Store, pas de Firebase Blaze. |
| Distribution | APK direct via GitHub Releases + landing page GitHub Pages + lien TikTok. |
| Coût mensuel cible | **0 FCFA** jusqu'à validation de la carte. |

---

## V1 — « Coder sans PC »

Le cœur du produit. Tout le reste en découle.

### Périmètre

- [ ] Connexion GitHub via **OAuth device flow** (aucun client secret dans l'APK)
- [ ] Liste des repos de l'utilisateur
- [ ] Navigation dans l'arborescence d'un repo (API Contents — pas de `git clone`)
- [ ] Éditeur avec vraie coloration syntaxique (`re_editor` ou `flutter_code_editor`)
- [ ] Modification + commit + push via API GitHub
- [ ] Déclenchement d'un workflow GitHub Actions
- [ ] Suivi des logs de build
- [ ] Téléchargement de l'artifact APK produit
- [ ] **Vérification de mise à jour au lancement** (API GitHub Releases)

### Hors périmètre V1

Fenêtres flottantes · Vault · IA · Cyber · 2D · 3D · Firebase · tout backend

### Infrastructure

Aucun serveur. Aucun Firebase. 0 FCFA/mois.

### Déclencheur V1 → V2

**J'ai développé Caisse de Poche pendant une semaine complète depuis mon téléphone, sans toucher au PC.**

Si je n'y arrive pas moi-même, personne n'y arrivera. Ce test passe avant toute publication.

---

## V2 — Confort de travail + IA (clé utilisateur)

### Périmètre

- [ ] Onglets multi-fichiers
- [ ] Recherche dans le repo
- [ ] Cache hors-ligne (Hive)
- [ ] Explorateur de fichiers local
- [ ] Gestion projets / tâches / notes (100 % local)
- [ ] **Assistant IA avec clé API fournie par l'utilisateur**

### Note sur l'IA en V2

L'utilisateur colle **sa propre** clé (Gemini, Claude, OpenAI) dans les paramètres.
Stockage chiffré local (`flutter_secure_storage`). L'app appelle l'API directement.

→ Aucun serveur, aucun coût pour moi, aucune carte bancaire requise.
→ Pour un public de développeurs, c'est même un argument : ils gardent le contrôle de leur clé.

### Déclencheur V2 → V3

Téléchargements réguliers sur les GitHub Releases + retours utilisateurs (TikTok / WhatsApp) demandant explicitement un mode multi-fenêtres.

---

## V3 — Mode Workspace / Desktop

La vision d'origine. Maintenant les fenêtres ont quelque chose dedans.

### Périmètre

- [ ] `features/workspace/` : desktop_mode, window_manager, task_bar, workspace_home
- [ ] Fenêtres flottantes redimensionnables
- [ ] Plusieurs modules ouverts simultanément
- [ ] **Tablette d'abord.** Sur téléphone : dashboard classique.

### Déclencheur V3 → V4

V3 stable + carte bancaire validée.

---

## V4 — Monétisation et backend

Ne démarre **que** si la carte bancaire est validée.

- [ ] Publication Galaxy Store, puis Play Store
- [ ] Firebase Blaze
- [ ] Comptes utilisateurs + synchronisation
- [ ] Proxy IA côté serveur (clé cachée)
- [ ] Abonnement via facturation intégrée du store (évite Stripe / Paddle)

**Règle :** ne jamais héberger de clé API sans revenus en face. Un seul utilisateur abusif vide le compte.

---

## V5+ — Modules d'extension

Uniquement sur demande réelle des utilisateurs. Ces modules restent dans la **vision**, pas dans le **planning**.

- Vault sécurisé — *concurrence : Bitwarden, gratuit et audité. Justifier avant de construire.*
- Cyber Workspace — *Android non-rooté bloque ICMP et ARP. Périmètre réaliste : scan TCP connect, DNS, HTTP, OSINT.*
- Création 2D
- Création 3D — *bibliothèques Flutter immatures. Projet à part entière.*

---

## Distribution

### Canal actuel

1. Build via GitHub Actions
2. Publication en **GitHub Release** avec numéro de version
3. Landing page GitHub Pages
4. Lien en bio TikTok

### Mesure (sans store)

- Compteur de téléchargements des Releases (visible via l'API GitHub)
- Commentaires TikTok
- Retours WhatsApp directs

### Signature APK — à faire avant la première Release publique

- [ ] Générer la keystore
- [ ] La sauvegarder en lieu sûr (**perte = utilisateurs obligés de désinstaller pour mettre à jour**)
- [ ] La stocker dans les GitHub Secrets
- [ ] Configurer la signature dans le workflow

Même clé réutilisée plus tard pour les stores. **À faire pas à pas, sans improviser.**

---

## Fichiers de suivi

| Fichier | Rôle | Fréquence de mise à jour |
|---|---|---|
| `CLAUDE.md` | Règles permanentes (4 Go RAM, interdits) | Presque jamais |
| `PROJECT_STATUS.md` | État d'avancement, prochaine étape | Chaque session |
| `ROADMAP.md` | Ce fichier — vision et déclencheurs | À chaque changement de version |

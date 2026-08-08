# PROJECT_STATUS.md

État d'avancement réel du code AetherDesk. À mettre à jour à chaque session (voir `ROADMAP.md` pour la vision produit et les déclencheurs de version, `CLAUDE.md` pour les conventions techniques).

**Cette version a été entièrement réécrite après audit ligne par ligne du code réel (pas des suppositions) — la version précédente sous-estimait lourdement l'état du projet : elle décrivait encore 8 des 9 modules comme des `ModulePlaceholderPage` vides, alors que 8 sont en réalité fonctionnels avec de vraies fonctionnalités (le 9e, `code_editor`, l'était aussi mais avec une coloration syntaxique simplifiée depuis remplacée — voir plus bas).**

## Règles permanentes

- **NE JAMAIS exécuter ni proposer** : `flutter build`, `flutter run`, `flutter test`, `dart run`, génération d'APK locale.
- Seuls autorisés en local : `flutter pub get`, `flutter gen-l10n`, `flutter analyze`, `dart format .`.
- Toute compilation passe par GitHub Actions (`.github/workflows/build_apk.yml`).
- Ne pas ajouter la logique métier réelle d'un module sans qu'elle soit explicitement demandée pour ce module précis.

## État réel du code

Statut de compilation à la date de cette mise à jour : `flutter analyze` → **No issues found!** (aucune erreur, aucun warning) après chaque lot de changements de cette session.

### 1. `ai_assistant` — **Disponible**
Chat complet (historique, bulles utilisateur/IA, indicateur "réflexion", streaming token par token) branché sur `AiService`. `aiAssistantRepositoryProvider` choisit dynamiquement :
- un vrai fournisseur `OpenAiCompatibleAiService` (endpoint `/chat/completions`, streaming SSE réel, compatible Ollama/LM Studio/OpenRouter/tout serveur OpenAI-compatible) si l'utilisateur a renseigné une URL d'endpoint dans Réglages > IA ;
- sinon `SimulatedAiService` (réponses canned, clairement annoncées comme simulées dans le texte affiché).

Erreurs réseau réelles gérées proprement (`ChatMessage.isError`) : message localisé, pas de crash, pas de fausse réponse.

### 2. `code_editor` — **Disponible**
Édition de texte réelle (ouverture/enregistrement via `file_picker`, `RealFileIoService`), coloration syntaxique **réelle** via `flutter_highlighting`/`highlighting` (port Dart de highlight.js — `RealSyntaxHighlighter`, remplace l'ancien tokenizer mots-clés/regex `SimulatedSyntaxHighlighter`, supprimé). 7 langages (Dart, Python, C++, JavaScript, HTML, CSS, JSON), compteurs lignes/mots/caractères, "Copier" via le presse-papiers OS.

### 3. `project_management` — **Disponible**
Persistance locale réelle via `shared_preferences` (tâches, statuts, vue Kanban).

### 4. `secure_vault` — **Disponible**
Chiffrement AES-GCM réel (`cryptography`), verrou biométrique/PIN réel (`local_auth`), stockage sécurisé réel (`flutter_secure_storage`) pour la clé maître du coffre.

### 5. `cyber_workspace` — **Disponible**
- Outils réseau réels (`RealCyberToolsService`, `dart:io`) : résolution DNS réelle, scan de ports par vraies connexions TCP, analyse IP/URL. Terminal réel avec commandes `whoami`, `ping` (poignée de main TCP réelle, pas ICMP), `dns`, `portcheck`, `myip` (appel HTTP réel à un service public gratuit), `speedtest` (téléchargement réel chronométré), `ifconfig`.
- Onglet Appareil : capteurs réels (`sensors_plus`), lampe torche réelle (`torch_light`), scan/génération QR réels (`mobile_scanner`/`qr_flutter`), scanner BLE réel (`flutter_blue_plus`), GPS réel (`geolocator`), lecture UID NFC réelle en lecture seule (`nfc_manager`), console USB-série réelle pour Arduino/ESP32 (`usb_serial`) — sert aussi de panneau GPIO/dashboard capteurs génériques pour tout firmware qui parle en lignes de texte sur le port série.
- RFID externe (RC522) et GPIO dédié : couverts par le NFC téléphone et la console série ci-dessus plutôt que dupliqués — un téléphone n'a pas de port SPI/GPIO généraliste pour un vrai lecteur RC522.

### 6. `creation_2d` — **Disponible**
Canvas de dessin réel (traits, formes, texte), calques réels avec compositing par vrai `BlendMode` `dart:ui` (normal/multiply/screen/overlay/darken/lighten), duplication de calque, export PNG réel via `FileIoService`.

### 7. `creation_3d` — **Disponible**
Viewport 3D interactif réel, entièrement fait main en Dart pur (`Scene3dViewport`) : caméra orbitale, génération de maillages réels (cube/sphère/cylindre/cône/plan), vraies matrices modèle/vue/projection (`vector_math`), ombrage Lambertien réel par face, tri peintre pour la profondeur, sélection par tap. Graphe de scène réel (asset browser/outliner/inspecteur de transform), export JSON réel de la scène.
**Nouveau cette session** : mode paysage (`OrientationBuilder`) — rail vertical de la palette d'objets à gauche, viewport au centre, panneau de transform (le même qu'en portrait, pas dupliqué) à droite. Le layout portrait existant est inchangé.

### 8. `settings` — **Disponible**
Thème/langue/apparence réels (en mémoire). Sécurité : vérification biométrique réelle (PIN code encore "Bientôt disponible", affiché comme tel). Sauvegarde réelle : "Sauvegarder"/"Restaurer" lisent/écrivent le profil sur Firestore (`profiles/{uid}`), nécessite le compte cloud optionnel de `user_profile`. Notifications réelles : le bouton demande la vraie permission OS et s'abonne/désabonne d'un topic FCM. IA : endpoint/modèle/clé API configurables (voir `ai_assistant`). Stockage : usage disque réel calculé via `path_provider` (somme des répertoires documents/support/temporaire de l'app), "Vider le cache" supprime réellement le contenu du répertoire temporaire. Infos app : vérification de mise à jour réelle via l'API GitHub Releases (`core/services/updates/`), bannière d'annonce réelle si une valeur Remote Config `announcement_message` est publiée.

### 9. `user_profile` — **Disponible**
Profil local modifiable (nom, pseudo, bio, pays, avatar) — en mémoire par défaut, aucun compte requis. Avatar réel : icône+couleur, ou une vraie photo choisie sur l'appareil et copiée dans le stockage privé de l'app (`FileIoService.pickAndStoreImage`). Compte cloud optionnel réel (Firebase Auth email/mot de passe) permettant la sauvegarde/restauration Firestore décrite ci-dessus — l'app reste 100 % utilisable sans jamais se connecter.

## Firebase (Auth, Firestore, FCM, Remote Config)

Réellement connecté cette session — un vrai bug a été trouvé et corrigé au passage : le plugin Gradle Google Services n'était **jamais appliqué** (`android/app/build.gradle.kts`/`android/settings.gradle.kts`), donc `google-services.json` n'était jamais traité et `Firebase.initializeApp()` aurait échoué au runtime malgré tout le code déjà écrit. `main.dart` appelle maintenant réellement l'initialisation avant `runApp` (c'était documenté comme fait mais ne l'était pas). Cloud Storage reste volontairement exclu (plan payant Blaze).

## Dépendances notables (voir `pubspec.yaml` pour la liste complète et les commentaires par lot)

Firebase (`firebase_core`/`firebase_auth`/`cloud_firestore`/`firebase_messaging`/`firebase_remote_config`), réseau (`http`, `url_launcher`), matériel (`sensors_plus`, `torch_light`, `mobile_scanner`, `qr_flutter`, `flutter_blue_plus`, `geolocator`, `nfc_manager`, `usb_serial`), 3D (`vector_math`), fichiers/stockage (`file_picker`, `path_provider`, `flutter_secure_storage`, `shared_preferences`), sécurité (`local_auth`, `cryptography`), coloration syntaxique (`flutter_highlighting`, `highlighting`).

## CI

Fichier : `.github/workflows/build_apk.yml`.

- Déclencheurs : `push` sur `main`, et `workflow_dispatch` manuel.
- Étapes : checkout → Java 17 (Zulu) → Flutter 3.44.6 stable (`subosito/flutter-action`) → écriture de `android/app/google-services.json` depuis le secret de dépôt `GOOGLE_SERVICES_JSON` (ajouté cette session, requis depuis l'activation du plugin Google Services) → `flutter pub get` → `flutter analyze` → `flutter build apk --release` → upload de `app-release.apk` en artifact (rétention 30 jours).
- Signature : aucune configuration de signature release — `android/app/build.gradle.kts` signe le build `release` avec le keystore **debug**. Suffisant pour un APK de test interne, bloquant pour une distribution publique.
- **Dernier état connu** : secret `GOOGLE_SERVICES_JSON` configuré par l'utilisateur, build confirmé passant sur GitHub Actions.

## Ce qui reste explicitement non fait (choix assumés, pas des oublis)

- **IA locale sur l'appareil** (modèle embarqué type Gemma/Llama) : pas commencé — nécessite un choix de modèle/licence/taille avant d'être lancé (voir `CLAUDE.md`, gate explicite). L'alternative "endpoint distant configurable" ci-dessus est en place et fonctionne dès aujourd'hui avec un serveur local (Ollama/LM Studio) ou distant au choix de l'utilisateur.
- **PIN code** (`settings` > Sécurité) : affiché "Bientôt disponible", non implémenté.
- **Signature de release APK** : keystore debug uniquement.

## Historique : authentification GitHub (retirée)

Une connexion GitHub Device Flow avait été ajoutée puis **entièrement supprimée** car elle rendait GitHub obligatoire au démarrage. Elle pourrait revenir plus tard comme action optionnelle dans `code_editor`/`settings`, jamais comme porte d'entrée de l'app — sans lien avec le compte cloud Firebase de `user_profile` décrit plus haut, qui est une fonctionnalité distincte et déjà optionnelle par construction.

## Prochaine étape

<!-- à remplir -->

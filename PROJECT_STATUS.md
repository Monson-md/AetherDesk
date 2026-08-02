# PROJECT_STATUS.md

État d'avancement réel du code AetherDesk. À mettre à jour à chaque session (voir `ROADMAP.md` pour la vision produit et les déclencheurs de version, `CLAUDE.md` pour les conventions techniques).

## Règles permanentes

- **NE JAMAIS exécuter ni proposer** : `flutter build`, `flutter run`, génération d'APK locale. La machine a 4 Go de RAM.
- Seuls autorisés en local : `flutter analyze`, `dart format`.
- Toute compilation passe par GitHub Actions (`.github/workflows/build_apk.yml`).
- Une étape à la fois, test sur téléphone avant de continuer.

## État réel du code

Statut de compilation à la date de cette mise à jour : `flutter analyze` → **No issues found!** (aucune erreur, aucun warning).

### Authentification GitHub (ÉTAPE V1-1 — nouveau, hors des 9 modules)

Ce n'est pas un des 9 modules `features/` — c'est une porte transverse devant toute l'app, donc le code vit dans `core/auth/` et `core/services/github/` (même logique que `core/theme/`, `core/router/`).

- **Fichiers présents** :
  - `core/services/github/` : `github_device_code.dart` (modèle), `github_auth_service.dart` (interface `GithubAuthService` + implémentation réelle `GithubAuthServiceImpl` — device flow complet : `POST /login/device/code`, polling `POST /login/oauth/access_token` avec gestion de `authorization_pending`/`slow_down`/`expired_token`/`access_denied`), `github_auth_service_provider.dart`, `github_api_client.dart` (`GithubApiClient` — client authentifié `api.github.com`, gère 401 → déconnexion auto + 403 → message clair), `github_api_client_provider.dart`.
  - `core/services/storage/` : `secure_storage_service_impl.dart` — première implémentation réelle de l'interface `SecureStorageService` déjà existante, via `flutter_secure_storage` (jamais `SharedPreferences`, jamais loggé) — + `secure_storage_service_provider.dart`.
  - `core/auth/` : `auth_state.dart` (`AuthStatus` : disconnected/pending/connected), `auth_controller.dart` (`Notifier` Riverpod orchestrant le flow), `login_page.dart` (bouton connexion, affichage du user_code en gros + copie, bouton "Ouvrir GitHub" via `url_launcher`, indicateur d'attente, message d'erreur si expiration/refus).
  - Routing : `RoutePaths.login` ajouté, `route_guards.dart` redirige réellement vers `/login` si non connecté (et inversement), `app_router.dart` réagit immédiatement aux changements d'état via un `refreshListenable` branché sur `authControllerProvider`.
- **Catégorie** : **fonctionnalité réelle et connectée** — ceci parle vraiment à `github.com`/`api.github.com`, ce n'est plus simulé comme `ai_assistant`/`code_editor`.
- **Ce qui manque** : aucun bouton de test/QA automatisé du flow (à valider sur téléphone, comme l'exige la règle "une étape à la fois"). Pas de gestion d'un éventuel refus de permission navigateur. Le reste du périmètre V1 (liste des repos, navigation dans l'arborescence, commit/push, déclenchement de workflow, logs, téléchargement d'APK, vérification de mise à jour) n'est pas commencé.

### 1. `ai_assistant`
- **Fichiers présents** : couche complète — `domain/` (`chat_message.dart`, `ai_assistant_repository.dart`, `send_message_usecase.dart`), `data/repositories/ai_assistant_repository_impl.dart`, `presentation/` (page, 2 providers, 6 widgets). Support côté `core/services/ai/` : `ai_service.dart` (contrat), `simulated_ai_service.dart`, `ai_service_provider.dart`.
- **Catégorie** : **fonctionnalité réelle mais 100 % simulée** — historique de conversation, bulles utilisateur/IA, indicateur "réflexion", streaming de réponse token par token, tout fonctionne réellement via Riverpod, mais les réponses viennent de `SimulatedAiService` (mots-clés → texte fixe), aucun appel réseau.
- **Ce qui manque pour être utilisable en vrai** : brancher un vrai fournisseur (Gemini/Claude/OpenAI) derrière `AiService` — c'est le seul point de bascule prévu. Selon `ROADMAP.md` (V2) : l'utilisateur doit pouvoir coller sa propre clé API, stockée via `flutter_secure_storage` (déjà une dépendance du projet depuis l'étape V1-1, via `SecureStorageServiceImpl` — réutilisable telle quelle), et l'app appelle l'API directement (pas de serveur).

### 2. `code_editor`
- **Fichiers présents** : couche complète — `domain/` (`code_document.dart`, `code_editor_repository.dart`, `highlight_code_usecase.dart`), `data/repositories/code_editor_repository_impl.dart`, `presentation/` (page, 2 providers, 7 widgets). Support côté `core/services/code_editor/` : `code_language.dart`, `code_token.dart`, `syntax_highlighter.dart` (contrat), `simulated_syntax_highlighter.dart`, `syntax_highlighter_provider.dart`.
- **Catégorie** : **fonctionnalité réelle mais locale et déconnectée** — édition de texte en mémoire, numéros de ligne, coloration syntaxique simulée (tokenizer mots-clés/regex, pas un vrai parser) pour 7 langages, compteurs lignes/mots/caractères. Aucun fichier réel : "Ouvrir" et "Enregistrer" sont des placeholders (snackbar), "Copier" utilise le presse-papiers OS.
- **Ce qui manque pour être utilisable en vrai** (périmètre V1 de `ROADMAP.md`) : la connexion GitHub existe désormais (étape V1-1, `core/auth` + `core/services/github`) mais `code_editor` ne s'en sert pas encore — il reste à brancher : liste des repos, navigation dans l'arborescence via l'API Contents (pas de `git clone`), commit + push via l'API GitHub (`GithubApiClient` est réutilisable), déclenchement d'un workflow Actions, suivi des logs de build, téléchargement de l'APK produit, vérification de mise à jour au lancement.

### 3. `project_management`
- **Fichiers présents** : un seul fichier réel, `presentation/pages/project_management_home_page.dart` (rend `ModulePlaceholderPage`). Les dossiers `data/`, `domain/`, `presentation/providers`, `presentation/widgets` n'ont qu'un `.gitkeep`.
- **Catégorie** : **UI vide** (placeholder "Bientôt disponible").
- **Ce qui manque** : tout — c'est prévu en V2 (`ROADMAP.md`) sous la forme "gestion projets/tâches/notes, 100 % local".

### 4. `secure_vault`
- **Fichiers présents** : idem — un seul fichier, placeholder.
- **Catégorie** : **UI vide**.
- **Ce qui manque** : tout. `ROADMAP.md` (V5+) questionne même la pertinence de le construire ("concurrence Bitwarden, gratuit et audité — justifier avant de construire").

### 5. `cyber_workspace`
- **Fichiers présents** : un seul fichier, placeholder.
- **Catégorie** : **UI vide**.
- **Ce qui manque** : tout. `ROADMAP.md` (V5+) note qu'Android non-rooté bloque ICMP/ARP — périmètre réaliste limité à scan TCP connect, DNS, HTTP, OSINT.

### 6. `creation_2d`
- **Fichiers présents** : un seul fichier, placeholder.
- **Catégorie** : **UI vide**.
- **Ce qui manque** : tout. V5+, aucune priorité fixée.

### 7. `creation_3d`
- **Fichiers présents** : un seul fichier, placeholder.
- **Catégorie** : **UI vide**.
- **Ce qui manque** : tout. `ROADMAP.md` (V5+) signale que les bibliothèques Flutter 3D sont immatures — "projet à part entière".

### 8. `settings`
- **Fichiers présents** : un seul fichier, placeholder.
- **Catégorie** : **UI vide**.
- **Ce qui manque** : tout, y compris le futur écran de saisie de clé API (V2) et le choix de thème (actuellement en mémoire uniquement via `theme_mode_provider.dart`, pas exposé à l'utilisateur).

### 9. `user_profile`
- **Fichiers présents** : couche complète — `domain/` (`user_profile.dart`, `user_profile_repository.dart`, `get_current_user_profile_usecase.dart`), `data/repositories/user_profile_repository_impl.dart` (appelle `GithubApiClient.getJson('/user')`), `presentation/` (page réécrite, `user_profile_providers.dart`, `user_profile_controller.dart`).
- **Catégorie** : **fonctionnalité réelle et connectée** — avatar, login, nom, nombre de dépôts publics réels via `GET /user`, bouton de déconnexion qui efface le token et renvoie automatiquement vers `/login`.
- **Ce qui manque** : rien pour ce périmètre précis (affichage du profil + déconnexion). Le "compte utilisateur + synchronisation" complet reste en V4 (`ROADMAP.md`).

## Dépendances

D'après `pubspec.yaml` :

| Dépendance | Déclarée | Utilisée ? |
|---|---|---|
| `flutter` (sdk) | oui | Oui — base du projet. |
| `cupertino_icons` `^1.0.8` | oui | **Non.** Aucun import de `CupertinoIcons` trouvé dans `lib/`. Reste du template par défaut `flutter create`, jamais utilisé (l'app n'utilise que `Icons.*` Material). Candidat à suppression. |
| `flutter_riverpod` `^3.4.2` | oui | Oui — état/DI de toute l'app. |
| `go_router` `^17.3.0` | oui | Oui — `core/router/app_router.dart`. |
| `intl` `^0.20.2` | oui | Oui — `DateFormat` dans `chat_message_bubble.dart`, plus utilisé en interne par le code généré `flutter gen-l10n`. |
| `flutter_localizations` (sdk) | oui | Oui — délégués de localisation branchés dans `app.dart` via `AppLocalizations.localizationsDelegates`. |
| `http` `^1.6.0` | oui *(ajouté V1-1)* | Oui — `GithubAuthServiceImpl` (device flow) et `GithubApiClient` (`api.github.com`). |
| `flutter_secure_storage` `^10.3.1` | oui *(ajouté V1-1)* | Oui — seule et unique implémentation de `SecureStorageService`, stocke le token GitHub chiffré. |
| `url_launcher` `^6.3.2` | oui *(ajouté V1-1)* | Oui — `login_page.dart` ouvre `verification_uri` dans le navigateur externe. |
| `flutter_test` (sdk, dev) | oui | Présent, un seul test (`test/widget_test.dart`), mais **non exécuté** — ni en local (règle du projet : pas de `flutter test`), ni dans le workflow CI actuel (qui ne fait qu'`analyze` + `build apk`). |
| `flutter_lints` `^6.0.0` (dev) | oui | Oui — pilote `analysis_options.yaml`. |

Aucune dépendance manquante détectée pour le code existant. Dépendances **anticipées mais pas encore ajoutées**, nécessaires pour les prochaines étapes du `ROADMAP.md` : `hive` (cache hors-ligne, V2), un vrai moteur d'édition type `re_editor`/`flutter_code_editor` (V1, si la coloration simulée actuelle doit être remplacée), un client pour l'API Contents / commits GitHub (V1, suite logique de l'auth — probablement construit au-dessus de `GithubApiClient` existant plutôt qu'une nouvelle dépendance).

## CI

Fichier : `.github/workflows/build_apk.yml`.

- Déclencheurs : `push` sur `main`, et `workflow_dispatch` manuel.
- Étapes : checkout → Java 17 (Zulu) → Flutter 3.44.6 stable (`subosito/flutter-action`) → `flutter pub get` → `flutter analyze` → `flutter build apk --release` → upload de `app-release.apk` en artifact (rétention 30 jours).
- Signature : aucune configuration de signature release — `android/app/build.gradle.kts` signe le build `release` avec le keystore **debug**. Suffisant pour un APK de test interne, mais bloquant pour une distribution publique (`ROADMAP.md` liste explicitement "Signature APK — à faire avant la première Release publique" comme tâche non commencée).
- **Dernier état connu** : le workflow a été ajouté et poussé dans le commit `65efaa6` (HEAD actuel de `main`), ce qui a dû déclencher une exécution. **Impossible de vérifier le résultat de cette exécution depuis cet environnement** — pas de `gh` CLI installé, et le dépôt étant privé, l'API GitHub REST publique renvoie 404 sans authentification. À vérifier manuellement dans l'onglet **Actions** du dépôt.

## Prochaine étape

<!-- à remplir -->

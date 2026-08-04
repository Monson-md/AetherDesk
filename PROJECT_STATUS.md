# PROJECT_STATUS.md

État d'avancement réel du code AetherDesk. À mettre à jour à chaque session (voir `ROADMAP.md` pour la vision produit et les déclencheurs de version, `CLAUDE.md` pour les conventions techniques).

## Règles permanentes

- **NE JAMAIS exécuter ni proposer** : `flutter build`, `flutter run`, génération d'APK locale. La machine a 4 Go de RAM.
- Seuls autorisés en local : `flutter analyze`, `dart format`.
- Toute compilation passe par GitHub Actions (`.github/workflows/build_apk.yml`).
- Une étape à la fois, test sur téléphone avant de continuer.

## État réel du code

Statut de compilation à la date de cette mise à jour : `flutter analyze` → **No issues found!** (aucune erreur, aucun warning).

### Authentification GitHub (ÉTAPE V1-1 — retirée)

La connexion GitHub Device Flow ajoutée en V1-1 (`core/auth/`, `core/services/github/`, `SecureStorageServiceImpl`, redirection forcée vers `/login`) a été **entièrement supprimée** : elle rendait GitHub obligatoire au démarrage de l'app, ce qui n'est plus acceptable. `route_guards.dart` est revenu à son état d'origine (`authRedirectGuard` ne redirige jamais). `RoutePaths.login` et le module `user_profile` (qui affichait le profil GitHub réel) sont revenus à leur état pré-V1-1 — `user_profile` affiche à nouveau `ModulePlaceholderPage`.

La connexion GitHub reviendra plus tard, mais uniquement comme action optionnelle dans `code_editor` ou dans `settings` (« Comptes connectés »), jamais comme porte d'entrée de l'app.

### 1. `ai_assistant`
- **Fichiers présents** : couche complète — `domain/` (`chat_message.dart`, `ai_assistant_repository.dart`, `send_message_usecase.dart`), `data/repositories/ai_assistant_repository_impl.dart`, `presentation/` (page, 2 providers, 6 widgets). Support côté `core/services/ai/` : `ai_service.dart` (contrat), `simulated_ai_service.dart`, `ai_service_provider.dart`.
- **Catégorie** : **fonctionnalité réelle mais 100 % simulée** — historique de conversation, bulles utilisateur/IA, indicateur "réflexion", streaming de réponse token par token, tout fonctionne réellement via Riverpod, mais les réponses viennent de `SimulatedAiService` (mots-clés → texte fixe), aucun appel réseau.
- **Ce qui manque pour être utilisable en vrai** : brancher un vrai fournisseur (Gemini/Claude/OpenAI) derrière `AiService` — c'est le seul point de bascule prévu. Selon `ROADMAP.md` (V2) : l'utilisateur doit pouvoir coller sa propre clé API, stockée via `flutter_secure_storage` (à réintroduire comme dépendance et implémentation de `SecureStorageService` le jour venu — retirée avec l'étape V1-1), et l'app appelle l'API directement (pas de serveur).

### 2. `code_editor`
- **Fichiers présents** : couche complète — `domain/` (`code_document.dart`, `code_editor_repository.dart`, `highlight_code_usecase.dart`), `data/repositories/code_editor_repository_impl.dart`, `presentation/` (page, 2 providers, 7 widgets). Support côté `core/services/code_editor/` : `code_language.dart`, `code_token.dart`, `syntax_highlighter.dart` (contrat), `simulated_syntax_highlighter.dart`, `syntax_highlighter_provider.dart`.
- **Catégorie** : **fonctionnalité réelle mais locale et déconnectée** — édition de texte en mémoire, numéros de ligne, coloration syntaxique simulée (tokenizer mots-clés/regex, pas un vrai parser) pour 7 langages, compteurs lignes/mots/caractères. Aucun fichier réel : "Ouvrir" et "Enregistrer" sont des placeholders (snackbar), "Copier" utilise le presse-papiers OS.
- **Ce qui manque pour être utilisable en vrai** (périmètre V1 de `ROADMAP.md`) : la connexion GitHub (V1-1) a été retirée de l'app — `code_editor` reste 100 % local. Elle devra être réintroduite ici (ou dans `settings`) comme connexion optionnelle avant de brancher : liste des repos, navigation dans l'arborescence via l'API Contents (pas de `git clone`), commit + push via l'API GitHub, déclenchement d'un workflow Actions, suivi des logs de build, téléchargement de l'APK produit, vérification de mise à jour au lancement.

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
- **Fichiers présents** : un seul fichier réel, `presentation/pages/user_profile_home_page.dart` (rend `ModulePlaceholderPage`). Les dossiers `data/`, `domain/`, `presentation/providers`, `presentation/widgets` n'ont qu'un `.gitkeep`.
- **Catégorie** : **UI vide** (placeholder "Bientôt disponible"). Avait brièvement affiché le profil GitHub réel pendant l'étape V1-1 ; revenu au placeholder quand l'auth a été retirée.
- **Ce qui manque** : tout. Le "compte utilisateur + synchronisation" complet reste en V4 (`ROADMAP.md`).

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
| `flutter_test` (sdk, dev) | oui | Présent, un seul test (`test/widget_test.dart`), mais **non exécuté** — ni en local (règle du projet : pas de `flutter test`), ni dans le workflow CI actuel (qui ne fait qu'`analyze` + `build apk`). |
| `flutter_lints` `^6.0.0` (dev) | oui | Oui — pilote `analysis_options.yaml`. |

`http` `^1.6.0`, `flutter_secure_storage` `^10.3.1` et `url_launcher` `^6.3.2` avaient été ajoutés en V1-1 pour l'auth GitHub et ont été **retirés** avec elle. Aucune dépendance manquante détectée pour le code existant. Dépendances **anticipées mais pas encore ajoutées**, nécessaires pour les prochaines étapes du `ROADMAP.md` : `hive` (cache hors-ligne, V2), un vrai moteur d'édition type `re_editor`/`flutter_code_editor` (V1, si la coloration simulée actuelle doit être remplacée), `flutter_secure_storage`/`http`/`url_launcher` de nouveau le jour où la connexion GitHub optionnelle est reconstruite.

## CI

Fichier : `.github/workflows/build_apk.yml`.

- Déclencheurs : `push` sur `main`, et `workflow_dispatch` manuel.
- Étapes : checkout → Java 17 (Zulu) → Flutter 3.44.6 stable (`subosito/flutter-action`) → `flutter pub get` → `flutter analyze` → `flutter build apk --release` → upload de `app-release.apk` en artifact (rétention 30 jours).
- Signature : aucune configuration de signature release — `android/app/build.gradle.kts` signe le build `release` avec le keystore **debug**. Suffisant pour un APK de test interne, mais bloquant pour une distribution publique (`ROADMAP.md` liste explicitement "Signature APK — à faire avant la première Release publique" comme tâche non commencée).
- **Dernier état connu** : le workflow a été ajouté et poussé dans le commit `65efaa6` (HEAD actuel de `main`), ce qui a dû déclencher une exécution. **Impossible de vérifier le résultat de cette exécution depuis cet environnement** — pas de `gh` CLI installé, et le dépôt étant privé, l'API GitHub REST publique renvoie 404 sans authentification. À vérifier manuellement dans l'onglet **Actions** du dépôt.

## Prochaine étape

<!-- à remplir -->

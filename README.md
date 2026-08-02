# AetherDesk

Application mobile/desktop modulaire construite en Flutter. Ce document décrit
l'architecture du projet : elle est volontairement posée **avant** toute
fonctionnalité métier, pour pouvoir évoluer plusieurs années sans devenir
difficile à maintenir.

## Stack technique

| Domaine            | Choix              | Pourquoi |
|---------------------|--------------------|----------|
| State management    | `flutter_riverpod` | Testable, pas de `BuildContext` requis dans la logique, standard actuel des projets Flutter modulaires. Sert aussi de mécanisme d'injection de dépendances (pas de `get_it`). |
| Navigation          | `go_router`        | Package officiel de l'équipe Flutter, routes déclaratives, deep-linking natif. |
| Localisation        | `intl` + `flutter_localizations` + `flutter gen-l10n` | Génération de code officielle à partir de fichiers `.arb`. |
| Architecture        | Clean Architecture simplifiée, par module | Chaque module (`features/*`) est isolé en 3 couches : `data`, `domain`, `presentation`. |

Aucune dépendance métier (Firebase, IA, stockage chiffré...) n'a été ajoutée :
seules des **interfaces abstraites** existent dans `core/services/`, prêtes à
être implémentées quand ces fonctionnalités seront développées.

## Arborescence

```
lib/
├── main.dart                     # Point d'entrée : ProviderScope + AetherDeskApp
├── app.dart                      # Widget racine : MaterialApp.router, thème, localisation
├── core/                         # Tout ce qui est transverse aux modules
│   ├── config/                   # Métadonnées d'app + environnements (dev/staging/prod)
│   ├── constants/                # Couleurs, dimensions, durées, chemins d'assets, chaînes non traduisibles
│   ├── theme/                    # Thème clair/sombre + provider Riverpod de bascule
│   ├── router/                   # go_router : routes, shell de navigation, page tableau de bord
│   ├── error/                    # Result<T>, Failure, AppException, mapping centralisé
│   ├── localization/             # Sortie générée de flutter gen-l10n (AppLocalizations)
│   ├── services/                 # Interfaces abstraites uniquement (firebase, ai, storage, connectivity)
│   ├── utils/                    # Extensions, logger, validators
│   └── widgets/                  # Composants réutilisables (boutons, inputs, loaders, dialogs, layout)
├── features/                     # Un dossier par module métier
│   ├── ai_assistant/
│   ├── code_editor/
│   ├── project_management/
│   ├── secure_vault/
│   ├── cyber_workspace/
│   ├── creation_2d/
│   ├── creation_3d/
│   ├── settings/
│   └── user_profile/
└── l10n/                         # Fichiers sources .arb (fr = référence, en = traduction)
```

### Rôle de chaque dossier `core/`

- **`core/config`** — Constantes de build (nom, version) et l'énumération
  `Environment` (dev/staging/prod), pour préparer de futurs flavors sans les
  implémenter maintenant.
- **`core/constants`** — Valeurs brutes (couleurs, espacements, durées,
  chemins d'assets). Ne jamais utiliser ces couleurs directement dans l'UI :
  toujours passer par `Theme.of(context).colorScheme`.
- **`core/theme`** — `light_theme.dart` / `dark_theme.dart` définissent les
  `ThemeData` ; `theme_mode_provider.dart` est un `Notifier` Riverpod qui gère
  le choix clair/sombre/système (en mémoire pour l'instant — la persistance
  viendra avec `core/services/storage`).
- **`core/router`** — `app_router.dart` est la source unique des routes (une
  route par module). `app_shell.dart` est le cadre de navigation persistant
  (NavigationRail sur grand écran, Drawer sur mobile). `dashboard_overview_page.dart`
  est l'écran d'accueil qui liste les 9 modules — ce n'est pas un module
  métier, juste le point d'entrée de la navigation.
- **`core/error`** — `Result<T>` (Success/Error) est le type de retour des
  futurs usecases/repositories, pour éviter les exceptions non gérées.
  `AppException` reste interne à `data/` ; `error_handler.dart` la convertit
  en `Failure`, seul type que voit `presentation/`.
- **`core/localization`** — Ne contient que le code généré par
  `flutter gen-l10n` (voir `l10n.yaml` à la racine et `lib/l10n/*.arb`).
- **`core/services`** — Contrats (`abstract interface class`) pour les
  intégrations futures : `firebase/firebase_service.dart` (aucune dépendance
  Firebase ajoutée), `ai/ai_service.dart` (contrat pour un futur provider IA,
  utilisé par le module `ai_assistant`), `storage/` (stockage local et
  sécurisé), `connectivity/`. Implémenter un de ces contrats plus tard ne
  change aucun point d'appel existant.
- **`core/utils`** — Extensions (`context`, `String`, `DateTime`), un logger
  fin au-dessus de `dart:developer`, et des validateurs de formulaire partagés.
- **`core/widgets`** — Composants réutilisables par tous les modules
  (`PrimaryButton`, `AppTextField`, `AppLoadingIndicator`, `AppAlertDialog`,
  `EmptyStateWidget`, `ErrorView`, `ModulePlaceholderPage`,
  `ResponsiveContentWrapper`), exportés via le barrel `core_widgets.dart`.

### Structure d'un module (`features/<module>/`)

Chaque module suit la même Clean Architecture à 3 couches :

```
features/<module>/
├── data/
│   ├── datasources/     # Sources de données locales/distantes
│   ├── models/          # Modèles de données (sérialisation)
│   └── repositories/    # Implémentations concrètes des repositories
├── domain/
│   ├── entities/        # Objets métier purs, sans dépendance Flutter
│   ├── repositories/    # Interfaces abstraites (contrats)
│   └── usecases/        # Une action métier = une classe
└── presentation/
    ├── pages/            # Écrans (contient déjà une page d'accueil placeholder)
    ├── widgets/          # Widgets spécifiques au module
    └── providers/        # Providers Riverpod du module
```

Aujourd'hui, seule `presentation/pages/<module>_home_page.dart` contient du
code : un écran "Bientôt disponible" basé sur `ModulePlaceholderPage`,
suffisant pour que la navigation soit fonctionnelle. Les autres dossiers
existent (avec un `.gitkeep`) pour que la structure soit prête dès qu'une
fonctionnalité réelle sera développée, sans réorganisation à prévoir.

## Localisation

Le français (`lib/l10n/app_fr.arb`) est la langue de référence
(`template-arb-file` dans `l10n.yaml`), l'anglais (`app_en.arb`) est fourni en
parallèle. `flutter gen-l10n` génère `AppLocalizations` dans
`lib/core/localization/generated/`. Pour ajouter une langue : dupliquer un
fichier `.arb`, changer `@@locale`, traduire les valeurs.

## Ce qui n'est PAS fait (volontairement)

- Aucune fonctionnalité métier dans aucun module.
- Aucune dépendance Firebase, IA, ou de stockage chiffré n'est ajoutée —
  seules les interfaces existent.
- Aucun workflow CI/CD n'a été créé ou modifié.
- Le projet n'a pas été compilé (`flutter run`/`flutter build`) : les APK
  seront générés uniquement via GitHub Actions.

## Commandes autorisées en local

```
flutter pub get       # résolution des dépendances
flutter gen-l10n       # génération des classes de localisation
flutter analyze        # analyse statique
dart format .           # formatage
```

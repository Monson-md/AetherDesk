# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

AetherDesk is a modular Flutter app (mobile/desktop) built around 9 planned feature modules, each isolated behind a simplified Clean Architecture. The architecture was deliberately laid down **before** most business logic, so it needs to stay coherent across years of incremental feature work rather than be reworked.

## Commands

```
flutter pub get        # resolve dependencies
flutter gen-l10n        # regenerate AppLocalizations from lib/l10n/*.arb after editing an .arb file
flutter analyze         # static analysis — must report "No issues found" before considering work done
dart format .            # formatting — run after analyze is clean
```

There is a `test/widget_test.dart` smoke test, but running `flutter test` is not part of this project's normal workflow (see Constraints below).

No lockfile/package-manager commands beyond `flutter pub get` — this is a single Flutter app, not a monorepo.

## Hard constraints (do not violate)

- **Never run `flutter run` or `flutter build` locally.** The only permitted local commands are `flutter pub get`, `flutter gen-l10n`, `flutter analyze`, and `dart format .`. APKs are produced exclusively by the GitHub Actions workflow (`.github/workflows/build_apk.yml`), triggered by pushing to `main`.
- Every change must end with `flutter analyze` reporting **zero issues** and `dart format .` applied. Fix lints rather than suppressing them; `// ignore:` comments are a last resort and must explain why in a comment (see `highlighting_text_controller.dart` for the one existing precedent — a public API name intentionally differs from a private backing field).
- Don't add a module's real business logic unless explicitly asked for that specific module. Untouched modules must keep rendering their `ModulePlaceholderPage` "Bientôt disponible" placeholder.
- No backend, no Firebase, no real network/AI calls, no real disk I/O — until a task explicitly says otherwise. Feature work so far (`ai_assistant`, `code_editor`) is entirely local/simulated, wired through an abstract interface in `core/services/` so a real backend can be swapped in later without touching `domain/` or `presentation/`.
- Don't modify `core/router/` (routes, nav destinations, shell) unless a module genuinely needs a new route — most new modules reuse an already-registered `RoutePaths` entry and `nav_destinations.dart` entry from the initial scaffold.
- Work directly against the GitHub repo: at the end of a sprint, commit, push to `main`, and update the CI workflow if the build needs it. Never force-push; never skip `flutter analyze`/`dart format` before committing.
- PowerShell is the reliable shell for `flutter`/`dart` commands in this environment (Bash's PATH has been observed to lose Unix coreutils/`flutter` mid-session). PowerShell 5.1 sometimes reports a native command as failed (`NativeCommandError`, exit 1) purely because of stderr wrapping even when the printed output shows success (e.g. `No issues found!`) — trust the captured text over the exit status.

## Architecture

### Per-module Clean Architecture

Every module under `lib/features/<module>/` follows the same 3-layer shape:

```
features/<module>/
├── data/repositories/       # concrete repository implementations
├── domain/
│   ├── entities/             # plain Dart objects, no Flutter imports
│   ├── repositories/         # abstract interfaces (contracts)
│   └── usecases/             # one class per business action, calling a repository
└── presentation/
    ├── pages/                 # <module>_home_page.dart — the screen registered in the router
    ├── providers/             # Riverpod providers/Notifiers wiring the above layers together
    └── widgets/               # module-local widgets
```

A not-yet-built module only has `presentation/pages/<module>_home_page.dart`, rendering `ModulePlaceholderPage` via `destinationFor(l10n, RoutePaths.<module>)`. The other layer folders exist with `.gitkeep` placeholders so structure never needs to be reorganized when real work starts.

### The "swap point" pattern for future real integrations

`core/services/<capability>/` holds an `abstract interface class` contract plus a fully local/simulated implementation, wired through a single Riverpod `Provider`. This is the one seam meant to change when a real backend/engine arrives — nothing in a module's `domain/` or `presentation/` should need to change.

Existing examples:
- `core/services/ai/ai_service.dart` (`AiService`) → `simulated_ai_service.dart` → `ai_service_provider.dart`, consumed by `features/ai_assistant`.
- `core/services/code_editor/syntax_highlighter.dart` (`SyntaxHighlighter`) → `simulated_syntax_highlighter.dart` (keyword/regex tokenizer, not a real parser) → `syntax_highlighter_provider.dart`, consumed by `features/code_editor`.
- Not yet implemented but already contracted: `core/services/firebase/firebase_service.dart`, `core/services/storage/{local_storage_service,secure_storage_service}.dart`, `core/services/connectivity/connectivity_service.dart`.

When adding a new cross-cutting capability, follow this same three-file shape (`<x>_service.dart` interface, `simulated_<x>_service.dart` or similar, `<x>_service_provider.dart`) rather than baking a concrete implementation directly into a module.

### Navigation

`core/router/route_paths.dart` (`RoutePaths`) is the single source of truth for path strings. `core/router/nav_destinations.dart` (`buildNavDestinations`/`destinationFor`) is the single source of truth for each module's icon/label/accent color — the dashboard grid, the `AppShell` rail/drawer, and each module's own page all read from it instead of duplicating metadata. `core/router/app_router.dart` registers one `GoRoute` per module inside a single `ShellRoute` wrapping `AppShell`. Deeper in-module navigation (e.g. opening a specific project) should be nested under that module's own routes as it's built out, not by growing `app_router.dart` indefinitely.

To add a new module's route: add a `RoutePaths` constant, an entry in `buildNavDestinations`, an l10n key for its nav label, its `<module>_home_page.dart`, then one `GoRoute` — in that order.

### Error handling

`core/error/result.dart` defines a hand-rolled `Result<T>` (`Success<T>`/`Error<T>`, Dart 3 sealed classes + pattern matching) as the intended return type for repositories/usecases — no `dartz`/`fpdart` dependency. `AppException` (`core/error/app_exception.dart`) stays internal to `data/`; `error_handler.dart` converts it to a `Failure`, the only error type `presentation/` should see. (Note: the `ai_assistant` and `code_editor` usecases built so far are simple pass-throughs and don't yet use `Result` — follow the existing pattern in a module before introducing a new error-handling convention.)

### State management & DI

Riverpod is the only state management/DI mechanism (no `get_it`). Pattern used throughout: a `Provider` wires a repository from a service provider, a second `Provider` wires a usecase from the repository provider, and a `Notifier`/`NotifierProvider` holds screen state and calls the usecase. See `features/code_editor/presentation/providers/` for the clearest example of this chain.

### Localization

French (`lib/l10n/app_fr.arb`) is the reference/template locale (`template-arb-file` in `l10n.yaml`); English (`lib/l10n/app_en.arb`) is the translation. Generated code lives only in `lib/core/localization/generated/` (never hand-edit it) and is produced by `flutter gen-l10n`. Every user-facing string goes through `AppLocalizations.of(context)!` — proper nouns that shouldn't be translated (e.g. programming language names in `CodeLanguage.label`) are the only accepted exception. After adding/editing a key in one `.arb` file, mirror it in the other and re-run `flutter gen-l10n`.

### Theming

Material 3 (`useMaterial3: true`), `ColorScheme.fromSeed` in `core/theme/{light_theme,dark_theme}.dart`, toggled by a Riverpod `Notifier` in `theme_mode_provider.dart` (in-memory only — no persistence yet). Use `Theme.of(context).colorScheme` in widgets; never reference `core/constants/app_colors.dart` values directly in UI code. Per-module accent colors (used for icons, highlighting, badges) come from `nav_destinations.dart`, not new ad-hoc colors — see `features/code_editor/presentation/widgets/code_token_colors.dart` for an example of reusing the module accent palette for syntax-highlighting colors instead of inventing a separate scheme.

### Linting

`analysis_options.yaml` extends `package:flutter_lints/flutter.yaml` with stricter additions enabled project-wide: `directives_ordering`, `prefer_const_constructors`, `prefer_single_quotes`, `require_trailing_commas`, `avoid_redundant_argument_values`, `always_declare_return_types`, among others. Import order matters: `package:aetherdesk/...` sorts alphabetically among `package:` imports (i.e. before `package:flutter/...`).

## CI/CD

`.github/workflows/build_apk.yml` runs on every push to `main` (and manual `workflow_dispatch`): checkout → Java 17 (Zulu) → Flutter 3.44.6 stable via `subosito/flutter-action` → `flutter pub get` → `flutter analyze` → `flutter build apk --release` → uploads `app-release.apk` as a workflow artifact (30-day retention). This is the only place APKs get built — keep it in sync if the pinned Flutter/Java version drifts from what's used locally (check with `flutter --version`).

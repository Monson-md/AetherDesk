import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/localization/locale_provider.dart';
import 'package:aetherdesk/core/theme/text_scale_provider.dart';
import 'package:aetherdesk/core/theme/theme_mode_provider.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Three thin UI layers over cross-cutting providers already defined in
/// `core/` (`localeProvider`, `themeModeProvider`, `textScaleProvider`) —
/// `settings` is the only screen that exposes them to the user, but it
/// doesn't own their state, the same way it doesn't own the routing or the
/// nav destinations.
class LanguageSection extends ConsumerWidget {
  const LanguageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final notifier = ref.read(localeProvider.notifier);

    return SettingsSectionCard(
      title: l10n.settingsLanguageTitle,
      icon: Icons.language_outlined,
      child: SegmentedButton<Locale?>(
        segments: [
          ButtonSegment(value: null, label: Text(l10n.settingsLanguageSystem)),
          ButtonSegment(
            value: const Locale('fr'),
            label: Text(l10n.settingsLanguageFrench),
          ),
          ButtonSegment(
            value: const Locale('en'),
            label: Text(l10n.settingsLanguageEnglish),
          ),
        ],
        selected: {locale},
        onSelectionChanged: (selection) => notifier.setLocale(selection.first),
      ),
    );
  }
}

class ThemeSection extends ConsumerWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final notifier = ref.read(themeModeProvider.notifier);

    return SettingsSectionCard(
      title: l10n.settingsThemeTitle,
      icon: Icons.brightness_6_outlined,
      child: SegmentedButton<ThemeMode>(
        segments: [
          ButtonSegment(
            value: ThemeMode.system,
            label: Text(l10n.settingsThemeSystem),
          ),
          ButtonSegment(
            value: ThemeMode.light,
            label: Text(l10n.settingsThemeLight),
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            label: Text(l10n.settingsThemeDark),
          ),
        ],
        selected: {themeMode},
        onSelectionChanged: (selection) =>
            notifier.setThemeMode(selection.first),
      ),
    );
  }
}

extension _TextScaleOptionLabel on TextScaleOption {
  String label(AppLocalizations l10n) => switch (this) {
    TextScaleOption.small => l10n.settingsTextScaleSmall,
    TextScaleOption.medium => l10n.settingsTextScaleMedium,
    TextScaleOption.large => l10n.settingsTextScaleLarge,
  };
}

class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final textScale = ref.watch(textScaleProvider);
    final notifier = ref.read(textScaleProvider.notifier);

    return SettingsSectionCard(
      title: l10n.settingsAppearanceTitle,
      icon: Icons.format_size_outlined,
      child: SegmentedButton<TextScaleOption>(
        segments: TextScaleOption.values
            .map(
              (option) =>
                  ButtonSegment(value: option, label: Text(option.label(l10n))),
            )
            .toList(),
        selected: {textScale},
        onSelectionChanged: (selection) =>
            notifier.setTextScale(selection.first),
      ),
    );
  }
}

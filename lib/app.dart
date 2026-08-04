import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/localization/locale_provider.dart';
import 'package:aetherdesk/core/router/app_router.dart';
import 'package:aetherdesk/core/theme/app_theme.dart';
import 'package:aetherdesk/core/theme/text_scale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root widget: wires together routing, theming, and localization. Feature
/// modules never construct a `MaterialApp` themselves — this is the single
/// place that happens.
class AetherDeskApp extends ConsumerWidget {
  const AetherDeskApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final textScaleOption = ref.watch(textScaleProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: locale,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScaleOption.scaleFactor)),
        child: child!,
      ),
    );
  }
}

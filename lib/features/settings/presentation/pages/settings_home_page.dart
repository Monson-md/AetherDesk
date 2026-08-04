import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/nav_destinations.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/ai_section.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/app_info_section.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/appearance_section.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/backup_section.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/notifications_section.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/privacy_section.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/profile_section.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/security_section.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/storage_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen of the `settings` module: one scrolling list of section
/// cards. Theme/language/text-scale sections are thin UI over `core/`
/// providers; every other section owns its state locally through this
/// module's own `AppSettings`/`SettingsController`.
class SettingsHomePage extends ConsumerWidget {
  const SettingsHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final destination = destinationFor(l10n, RoutePaths.settings);

    return Scaffold(
      appBar: AppBar(title: Text(destination.label)),
      body: ResponsiveContentWrapper(
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          children: const [
            ProfileSection(),
            SizedBox(height: AppDimensions.spacingMd),
            LanguageSection(),
            SizedBox(height: AppDimensions.spacingMd),
            ThemeSection(),
            SizedBox(height: AppDimensions.spacingMd),
            AppearanceSection(),
            SizedBox(height: AppDimensions.spacingMd),
            NotificationsSection(),
            SizedBox(height: AppDimensions.spacingMd),
            BackupSection(),
            SizedBox(height: AppDimensions.spacingMd),
            SecuritySection(),
            SizedBox(height: AppDimensions.spacingMd),
            PrivacySection(),
            SizedBox(height: AppDimensions.spacingMd),
            StorageSection(),
            SizedBox(height: AppDimensions.spacingMd),
            AiSection(),
            SizedBox(height: AppDimensions.spacingMd),
            AppInfoSection(),
          ],
        ),
      ),
    );
  }
}

import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/nav_destinations.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen of the `user_profile` module. A [ConsumerWidget] so it is
/// ready to `ref.watch` real providers as soon as this module gets business
/// logic — for now it only renders the shared "coming soon" placeholder.
class UserProfileHomePage extends ConsumerWidget {
  const UserProfileHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final destination = destinationFor(l10n, RoutePaths.userProfile);
    return ModulePlaceholderPage(
      title: destination.label,
      icon: destination.icon,
      accentColor: destination.color,
      comingSoonTitle: l10n.comingSoonTitle,
      comingSoonMessage: l10n.comingSoonMessage,
    );
  }
}

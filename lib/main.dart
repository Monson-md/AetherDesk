import 'package:aetherdesk/app.dart';
import 'package:aetherdesk/core/services/firebase/real_firebase_service.dart';
import 'package:aetherdesk/features/project_management/data/repositories/project_management_local_store.dart';
import 'package:aetherdesk/features/project_management/presentation/providers/project_management_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Every other module works fully offline; a misconfigured/unreachable
  // Firebase project must not block app startup, only the cloud-optional
  // features (Compte cloud, push notifications) that depend on it.
  try {
    await const RealFirebaseService().initialize();
  } on Exception {
    // Cloud features degrade gracefully; nothing to do here.
  }
  final projectManagementSeed = await loadProjectManagementSeed();

  runApp(
    ProviderScope(
      overrides: [
        projectManagementSeedProvider.overrideWithValue(projectManagementSeed),
      ],
      child: const AetherDeskApp(),
    ),
  );
}

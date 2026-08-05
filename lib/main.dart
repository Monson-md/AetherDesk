import 'package:aetherdesk/app.dart';
import 'package:aetherdesk/features/project_management/data/repositories/project_management_local_store.dart';
import 'package:aetherdesk/features/project_management/presentation/providers/project_management_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

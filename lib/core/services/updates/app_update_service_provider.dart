import 'package:aetherdesk/core/services/updates/app_update_service.dart';
import 'package:aetherdesk/core/services/updates/github_app_update_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appUpdateServiceProvider = Provider<AppUpdateService>(
  (ref) => GithubAppUpdateService(),
);

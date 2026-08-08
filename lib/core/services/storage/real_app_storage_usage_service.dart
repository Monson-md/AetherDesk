import 'dart:io';

import 'package:aetherdesk/core/services/storage/app_storage_usage_service.dart';
import 'package:path_provider/path_provider.dart';

/// Real [AppStorageUsageService] backed by `path_provider` + `dart:io`:
/// walks the app's own documents/support/temporary directories and sums
/// real file sizes — no illustrative placeholder numbers.
class RealAppStorageUsageService implements AppStorageUsageService {
  const RealAppStorageUsageService();

  @override
  Future<int> calculateUsageBytes() async {
    final directories = await Future.wait([
      getApplicationDocumentsDirectory(),
      getApplicationSupportDirectory(),
      getTemporaryDirectory(),
    ]);
    final sizes = await Future.wait(directories.map(_directorySize));
    return sizes.fold<int>(0, (sum, size) => sum + size);
  }

  @override
  Future<void> clearCache() async {
    final tempDir = await getTemporaryDirectory();
    if (!tempDir.existsSync()) return;
    await for (final entity in tempDir.list()) {
      try {
        await entity.delete(recursive: true);
      } on Exception {
        // Best-effort: a file currently in use shouldn't block the rest.
      }
    }
  }

  Future<int> _directorySize(Directory directory) async {
    if (!directory.existsSync()) return 0;
    var total = 0;
    await for (final entity in directory.list(
      recursive: true,
      followLinks: false,
    )) {
      if (entity is! File) continue;
      try {
        total += await entity.length();
      } on Exception {
        // The file may have been deleted/moved mid-scan.
      }
    }
    return total;
  }
}

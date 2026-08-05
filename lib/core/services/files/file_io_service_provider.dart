import 'package:aetherdesk/core/services/files/file_io_service.dart';
import 'package:aetherdesk/core/services/files/real_file_io_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The single place to swap the file I/O implementation later (e.g. cloud
/// file support): change what this provider returns and every consumer —
/// currently `features/code_editor` — picks up the change.
final fileIoServiceProvider = Provider<FileIoService>(
  (ref) => const RealFileIoService(),
);

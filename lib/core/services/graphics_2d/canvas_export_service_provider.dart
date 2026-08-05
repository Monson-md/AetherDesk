import 'package:aetherdesk/core/services/graphics_2d/canvas_export_service.dart';
import 'package:aetherdesk/core/services/graphics_2d/simulated_canvas_export_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The single place to swap the simulated exporter for a real
/// rasterizer/file writer later: change what this provider returns (or
/// override it in a `ProviderScope`) and every consumer — currently
/// `features/creation_2d` — picks up the new implementation automatically.
final canvasExportServiceProvider = Provider<CanvasExportService>(
  (ref) => const SimulatedCanvasExportService(),
);

import 'package:aetherdesk/core/services/graphics_2d/canvas_export_service.dart';

/// Placeholder [CanvasExportService]: waits briefly to mimic real rendering
/// work, then returns a description of what *would* have been exported. This
/// is not real cryptography, rendering or disk I/O — just enough to let the
/// UI exercise a full export flow before a real rasterizer exists.
class SimulatedCanvasExportService implements CanvasExportService {
  const SimulatedCanvasExportService();

  static const _latency = Duration(milliseconds: 500);

  @override
  Future<String> exportProject({
    required String projectName,
    required int layerCount,
    required int elementCount,
  }) async {
    await Future<void>.delayed(_latency);
    return '$projectName.png ($layerCount calques, $elementCount éléments) — export simulé';
  }
}

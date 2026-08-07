import 'dart:math' as math;

import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/material_preset.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object_type.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

typedef _Face = List<vm.Vector3>;

/// A real, interactive 3D viewport: generates actual mesh geometry for each
/// primitive type, transforms it with real model/view/projection matrices
/// (`package:vector_math`), and rasterizes it with a painter's-algorithm
/// depth sort plus per-face Lambertian shading driven by the scene's own
/// [SceneObjectType.light] objects. Orbit with a drag, zoom with a pinch,
/// tap an object to select it — this replaces the old top-down schematic
/// icon layout with a genuine camera.
class Scene3dViewport extends StatefulWidget {
  const Scene3dViewport({
    required this.objects,
    required this.selectedObjectId,
    required this.onObjectSelected,
    required this.isExporting,
    required this.onExport,
    super.key,
  });

  final List<SceneObject3d> objects;
  final String? selectedObjectId;
  final ValueChanged<String?> onObjectSelected;
  final bool isExporting;
  final VoidCallback onExport;

  @override
  State<Scene3dViewport> createState() => _Scene3dViewportState();
}

class _Scene3dViewportState extends State<Scene3dViewport> {
  double _yaw = -0.6;
  double _pitch = 0.35;
  double _distance = 9;
  double _distanceAtGestureStart = 9;

  void _onScaleStart(ScaleStartDetails details) {
    _distanceAtGestureStart = _distance;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _yaw -= details.focalPointDelta.dx * 0.01;
      _pitch = (_pitch + details.focalPointDelta.dy * 0.01).clamp(-1.45, 1.45);
      _distance = (_distanceAtGestureStart / details.scale).clamp(2.0, 40.0);
    });
  }

  _Camera get _camera => _Camera(yaw: _yaw, pitch: _pitch, distance: _distance);

  void _onTapUp(TapUpDetails details, Size size) {
    final camera = _camera;
    final fovYRadians = _fovYRadiansFor(widget.objects);
    String? closestId;
    var closestScreenDistance = double.infinity;
    var closestDepth = double.infinity;
    for (final object in widget.objects.where((o) => o.isVisible)) {
      final screen = camera.project(
        vm.Vector3(object.position.x, object.position.y, object.position.z),
        size,
        fovYRadians,
      );
      if (screen == null) continue;
      final dist = (screen.offset - details.localPosition).distance;
      if (dist < 40 &&
          (dist < closestScreenDistance - 4 || screen.depth < closestDepth)) {
        closestScreenDistance = dist;
        closestDepth = screen.depth;
        closestId = object.id;
      }
    }
    widget.onObjectSelected(closestId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                return GestureDetector(
                  onScaleStart: _onScaleStart,
                  onScaleUpdate: _onScaleUpdate,
                  onTapUp: (details) => _onTapUp(details, size),
                  child: CustomPaint(
                    size: size,
                    painter: _ScenePainter(
                      objects: widget.objects,
                      selectedObjectId: widget.selectedObjectId,
                      camera: _camera,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: AppDimensions.spacingSm,
            top: AppDimensions.spacingSm,
            child: Text(
              l10n.creation3dViewportHintLabel,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: Colors.white70),
            ),
          ),
          Positioned(
            right: AppDimensions.spacingSm,
            bottom: AppDimensions.spacingSm,
            child: FilledButton.icon(
              icon: widget.isExporting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.ios_share_outlined),
              label: Text(l10n.creation3dExportScene),
              onPressed: widget.isExporting ? null : widget.onExport,
            ),
          ),
        ],
      ),
    );
  }
}

/// A real orbit camera: builds view/projection matrices and projects world
/// points to screen space, honoring perspective divide.
class _Camera {
  factory _Camera({
    required double yaw,
    required double pitch,
    required double distance,
  }) {
    final eye = vm.Vector3(
      distance * math.cos(pitch) * math.sin(yaw),
      distance * math.sin(pitch),
      distance * math.cos(pitch) * math.cos(yaw),
    );
    final view = vm.makeViewMatrix(eye, vm.Vector3.zero(), vm.Vector3(0, 1, 0));
    return _Camera._(eye: eye, view: view);
  }

  _Camera._({required this.eye, required this.view});

  final vm.Vector3 eye;
  final vm.Matrix4 view;

  vm.Matrix4 projectionFor(Size size, double fovYRadians) {
    final aspect = size.width / (size.height == 0 ? 1 : size.height);
    return vm.makePerspectiveMatrix(fovYRadians, aspect, 0.1, 100);
  }

  /// Projects a world-space point to screen space, or returns null if the
  /// point is behind the camera.
  _ScreenPoint? project(
    vm.Vector3 world,
    Size size, [
    double fovYRadians = _defaultFovYRadians,
  ]) {
    final viewPoint = view.transformed3(world.clone());
    if (viewPoint.z > -0.05) return null;
    final proj = projectionFor(size, fovYRadians);
    final clip = proj.transform(
      vm.Vector4(viewPoint.x, viewPoint.y, viewPoint.z, 1),
    );
    if (clip.w <= 0.0001) return null;
    final ndcX = clip.x / clip.w;
    final ndcY = clip.y / clip.w;
    return _ScreenPoint(
      offset: Offset(
        (ndcX * 0.5 + 0.5) * size.width,
        (1 - (ndcY * 0.5 + 0.5)) * size.height,
      ),
      depth: -viewPoint.z,
    );
  }
}

const _defaultFovYRadians = 50 * math.pi / 180;

class _ScreenPoint {
  const _ScreenPoint({required this.offset, required this.depth});

  final Offset offset;
  final double depth;
}

class _FaceDraw {
  const _FaceDraw({
    required this.points,
    required this.depth,
    required this.color,
    required this.isSelected,
    required this.wireframeOnly,
  });

  final List<Offset> points;
  final double depth;
  final Color color;
  final bool isSelected;
  final bool wireframeOnly;
}

class _ScenePainter extends CustomPainter {
  _ScenePainter({
    required this.objects,
    required this.selectedObjectId,
    required this.camera,
  });

  final List<SceneObject3d> objects;
  final String? selectedObjectId;
  final _Camera camera;

  @override
  void paint(Canvas canvas, Size size) {
    final fovYRadians = _fovYRadiansFor(objects);
    _ScreenPoint? project(vm.Vector3 world) =>
        camera.project(world, size, fovYRadians);

    // Ground grid, drawn first as the scene's backdrop.
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    const gridExtent = 6;
    for (var i = -gridExtent; i <= gridExtent; i++) {
      final a = project(vm.Vector3(i.toDouble(), 0, -gridExtent.toDouble()));
      final b = project(vm.Vector3(i.toDouble(), 0, gridExtent.toDouble()));
      if (a != null && b != null) {
        canvas.drawLine(a.offset, b.offset, gridPaint);
      }
      final c = project(vm.Vector3(-gridExtent.toDouble(), 0, i.toDouble()));
      final d = project(vm.Vector3(gridExtent.toDouble(), 0, i.toDouble()));
      if (c != null && d != null) {
        canvas.drawLine(c.offset, d.offset, gridPaint);
      }
    }

    final lightObjects = objects.where(
      (o) => o.isVisible && o.type == SceneObjectType.light,
    );

    vm.Vector3 lightDirFor(vm.Vector3 point) {
      for (final light in lightObjects) {
        final lightPos = vm.Vector3(
          light.position.x,
          light.position.y,
          light.position.z,
        );
        return (lightPos - point).normalized();
      }
      return vm.Vector3(0.4, 1, 0.3).normalized();
    }

    final drawables = <_FaceDraw>[];

    for (final object in objects.where((o) => o.isVisible)) {
      final isHelper =
          object.type == SceneObjectType.light ||
          object.type == SceneObjectType.camera;
      final model = vm.Matrix4.identity()
        ..translateByDouble(
          object.position.x,
          object.position.y,
          object.position.z,
          1,
        )
        ..rotateX(object.rotation.x * math.pi / 180)
        ..rotateY(object.rotation.y * math.pi / 180)
        ..rotateZ(object.rotation.z * math.pi / 180)
        ..scaleByDouble(
          isHelper ? 1.0 : object.scale.x,
          isHelper ? 1.0 : object.scale.y,
          isHelper ? 1.0 : object.scale.z,
          1,
        );
      final objectWorldPos = vm.Vector3(
        object.position.x,
        object.position.y,
        object.position.z,
      );
      final baseColor = Color(object.colorValue);
      final isSelected = object.id == selectedObjectId;

      for (final face in _meshForType(object.type)) {
        final worldVerts = face
            .map((v) => model.transformed3(v.clone()))
            .toList();
        var normal = _faceNormal(worldVerts);
        final centroid = _average(worldVerts);
        if (normal.dot(centroid - objectWorldPos) < 0) {
          normal = -normal;
        }

        final screenPoints = <Offset>[];
        var behindCamera = false;
        for (final v in worldVerts) {
          final p = project(v);
          if (p == null) {
            behindCamera = true;
            break;
          }
          screenPoints.add(p.offset);
        }
        if (behindCamera || screenPoints.length < 3) continue;

        final viewCentroid = camera.view.transformed3(centroid.clone());
        final depth = -viewCentroid.z;

        Color shadedColor;
        if (isHelper) {
          shadedColor = baseColor;
        } else if (object.material == MaterialPreset.emissive) {
          shadedColor = baseColor;
        } else {
          const ambient = 0.28;
          final ndotl = normal.dot(lightDirFor(centroid)).clamp(0.0, 1.0);
          var shade = ambient + ndotl * (1 - ambient);
          if (object.material == MaterialPreset.metallic) {
            shade = math.pow(shade.clamp(0.12, 1.0), 0.65).toDouble();
          }
          shadedColor = Color.lerp(Colors.black, baseColor, shade)!;
          if (object.material == MaterialPreset.glass) {
            shadedColor = shadedColor.withValues(alpha: 0.5);
          }
        }

        drawables.add(
          _FaceDraw(
            points: screenPoints,
            depth: depth,
            color: shadedColor,
            isSelected: isSelected,
            wireframeOnly: isHelper,
          ),
        );
      }
    }

    drawables.sort((a, b) => b.depth.compareTo(a.depth));

    for (final drawable in drawables) {
      final path = Path()..addPolygon(drawable.points, true);
      if (drawable.wireframeOnly) {
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4
            ..color = drawable.color,
        );
      } else {
        canvas.drawPath(path, Paint()..color = drawable.color);
        if (drawable.isSelected) {
          canvas.drawPath(
            path,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.4
              ..color = Colors.orange,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) => true;
}

double _fovYRadiansFor(List<SceneObject3d> objects) {
  for (final object in objects) {
    if (object.type == SceneObjectType.camera && object.cameraFov != null) {
      return object.cameraFov! * math.pi / 180;
    }
  }
  return _defaultFovYRadians;
}

vm.Vector3 _faceNormal(List<vm.Vector3> verts) {
  final edge1 = verts[1] - verts[0];
  final edge2 = verts[2] - verts[0];
  final normal = edge1.cross(edge2);
  if (normal.length2 == 0) return vm.Vector3(0, 1, 0);
  return normal.normalized();
}

vm.Vector3 _average(List<vm.Vector3> verts) {
  final sum = verts.fold(vm.Vector3.zero(), (acc, v) => acc + v);
  return sum / verts.length.toDouble();
}

List<_Face> _meshForType(SceneObjectType type) {
  switch (type) {
    case SceneObjectType.cube:
      return _cubeFaces();
    case SceneObjectType.sphere:
      return _sphereFaces();
    case SceneObjectType.cylinder:
      return _cylinderFaces();
    case SceneObjectType.cone:
      return _coneFaces();
    case SceneObjectType.plane:
      return _planeFaces();
    case SceneObjectType.light:
    case SceneObjectType.camera:
      return _gizmoFaces();
  }
}

List<_Face> _cubeFaces() {
  const h = 0.5;
  final p = [
    vm.Vector3(-h, -h, -h),
    vm.Vector3(h, -h, -h),
    vm.Vector3(h, h, -h),
    vm.Vector3(-h, h, -h),
    vm.Vector3(-h, -h, h),
    vm.Vector3(h, -h, h),
    vm.Vector3(h, h, h),
    vm.Vector3(-h, h, h),
  ];
  return [
    [p[0], p[1], p[2], p[3]],
    [p[5], p[4], p[7], p[6]],
    [p[4], p[0], p[3], p[7]],
    [p[1], p[5], p[6], p[2]],
    [p[3], p[2], p[6], p[7]],
    [p[4], p[5], p[1], p[0]],
  ];
}

List<_Face> _sphereFaces({int segments = 12, int rings = 8}) {
  const radius = 0.5;
  final ringPoints = List.generate(rings + 1, (r) {
    final theta = math.pi * r / rings;
    return List.generate(segments, (s) {
      final phi = 2 * math.pi * s / segments;
      final y = radius * math.cos(theta);
      final rr = radius * math.sin(theta);
      return vm.Vector3(rr * math.cos(phi), y, rr * math.sin(phi));
    });
  });
  final faces = <_Face>[];
  for (var r = 0; r < rings; r++) {
    for (var s = 0; s < segments; s++) {
      final s2 = (s + 1) % segments;
      faces.add([
        ringPoints[r][s],
        ringPoints[r][s2],
        ringPoints[r + 1][s2],
        ringPoints[r + 1][s],
      ]);
    }
  }
  return faces;
}

List<_Face> _cylinderFaces({int segments = 16}) {
  const radius = 0.5;
  const halfHeight = 0.5;
  final top = List.generate(segments, (s) {
    final phi = 2 * math.pi * s / segments;
    return vm.Vector3(
      radius * math.cos(phi),
      halfHeight,
      radius * math.sin(phi),
    );
  });
  final bottom = List.generate(segments, (s) {
    final phi = 2 * math.pi * s / segments;
    return vm.Vector3(
      radius * math.cos(phi),
      -halfHeight,
      radius * math.sin(phi),
    );
  });
  final faces = <_Face>[];
  for (var s = 0; s < segments; s++) {
    final s2 = (s + 1) % segments;
    faces.add([bottom[s], bottom[s2], top[s2], top[s]]);
  }
  faces.add(top);
  faces.add(bottom.reversed.toList());
  return faces;
}

List<_Face> _coneFaces({int segments = 16}) {
  const radius = 0.5;
  const halfHeight = 0.5;
  final apex = vm.Vector3(0, halfHeight, 0);
  final base = List.generate(segments, (s) {
    final phi = 2 * math.pi * s / segments;
    return vm.Vector3(
      radius * math.cos(phi),
      -halfHeight,
      radius * math.sin(phi),
    );
  });
  final faces = <_Face>[];
  for (var s = 0; s < segments; s++) {
    final s2 = (s + 1) % segments;
    faces.add([base[s], base[s2], apex]);
  }
  faces.add(base);
  return faces;
}

List<_Face> _planeFaces() {
  const h = 0.5;
  return [
    [
      vm.Vector3(-h, 0, -h),
      vm.Vector3(h, 0, -h),
      vm.Vector3(h, 0, h),
      vm.Vector3(-h, 0, h),
    ],
  ];
}

List<_Face> _gizmoFaces() {
  const s = 0.3;
  final top = vm.Vector3(0, s, 0);
  final bottom = vm.Vector3(0, -s, 0);
  final ring = [
    vm.Vector3(s, 0, 0),
    vm.Vector3(0, 0, s),
    vm.Vector3(-s, 0, 0),
    vm.Vector3(0, 0, -s),
  ];
  final faces = <_Face>[];
  for (var i = 0; i < 4; i++) {
    final j = (i + 1) % 4;
    faces.add([ring[i], ring[j], top]);
    faces.add([ring[j], ring[i], bottom]);
  }
  return faces;
}

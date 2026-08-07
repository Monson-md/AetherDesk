import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_element.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_layer.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_point.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_tool.dart';
import 'package:aetherdesk/features/creation_2d/presentation/widgets/canvas_tool_widgets.dart';
import 'package:flutter/material.dart';

/// Interactive drawing surface: renders every visible [Canvas2dLayer] and
/// turns pan/tap gestures into strokes, shapes or text elements, handed back
/// to the caller via the `on*` callbacks (the caller — `Creation2dController`
/// — owns the actual element list).
class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({
    required this.layers,
    required this.activeTool,
    required this.colorValue,
    required this.strokeWidth,
    required this.isActiveLayerLocked,
    required this.onStrokeComplete,
    required this.onShapeComplete,
    required this.onTextTap,
    super.key,
  });

  final List<Canvas2dLayer> layers;
  final Canvas2dTool activeTool;
  final int colorValue;
  final double strokeWidth;
  final bool isActiveLayerLocked;
  final void Function(List<CanvasPoint> points, {required bool isEraser})
  onStrokeComplete;
  final void Function(CanvasPoint start, CanvasPoint end) onShapeComplete;
  final ValueChanged<CanvasPoint> onTextTap;

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<CanvasPoint> _currentPoints = const [];
  CanvasPoint? _shapeStart;
  CanvasPoint? _shapeEnd;

  bool get _isDrawingTool =>
      widget.activeTool == Canvas2dTool.brush ||
      widget.activeTool == Canvas2dTool.eraser;

  bool get _isShapeTool =>
      widget.activeTool == Canvas2dTool.line ||
      widget.activeTool == Canvas2dTool.rectangle ||
      widget.activeTool == Canvas2dTool.ellipse;

  CanvasPoint _pointOf(Offset offset) => CanvasPoint(offset.dx, offset.dy);

  void _handlePanStart(DragStartDetails details) {
    if (widget.isActiveLayerLocked) return;
    final point = _pointOf(details.localPosition);
    if (_isDrawingTool) {
      setState(() => _currentPoints = [point]);
    } else if (_isShapeTool) {
      setState(() {
        _shapeStart = point;
        _shapeEnd = point;
      });
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (widget.isActiveLayerLocked) return;
    final point = _pointOf(details.localPosition);
    if (_isDrawingTool && _currentPoints.isNotEmpty) {
      setState(() => _currentPoints = [..._currentPoints, point]);
    } else if (_isShapeTool && _shapeStart != null) {
      setState(() => _shapeEnd = point);
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (widget.isActiveLayerLocked) return;
    if (_isDrawingTool && _currentPoints.isNotEmpty) {
      widget.onStrokeComplete(
        _currentPoints,
        isEraser: widget.activeTool == Canvas2dTool.eraser,
      );
      setState(() => _currentPoints = const []);
    } else if (_isShapeTool && _shapeStart != null && _shapeEnd != null) {
      widget.onShapeComplete(_shapeStart!, _shapeEnd!);
      setState(() {
        _shapeStart = null;
        _shapeEnd = null;
      });
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isActiveLayerLocked) return;
    if (widget.activeTool == Canvas2dTool.text) {
      widget.onTextTap(_pointOf(details.localPosition));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: GestureDetector(
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        onTapUp: _handleTapUp,
        child: CustomPaint(
          size: Size.infinite,
          painter: _Canvas2dPainter(
            layers: widget.layers,
            previewPoints: _currentPoints,
            previewColorValue: widget.colorValue,
            previewStrokeWidth: widget.strokeWidth,
            previewShapeType: widget.activeTool.asShapeType,
            previewShapeStart: _shapeStart,
            previewShapeEnd: _shapeEnd,
            previewIsEraser: widget.activeTool == Canvas2dTool.eraser,
          ),
        ),
      ),
    );
  }
}

class _Canvas2dPainter extends CustomPainter {
  _Canvas2dPainter({
    required this.layers,
    required this.previewPoints,
    required this.previewColorValue,
    required this.previewStrokeWidth,
    required this.previewShapeType,
    required this.previewShapeStart,
    required this.previewShapeEnd,
    required this.previewIsEraser,
  });

  final List<Canvas2dLayer> layers;
  final List<CanvasPoint> previewPoints;
  final int previewColorValue;
  final double previewStrokeWidth;
  final Canvas2dShapeType? previewShapeType;
  final CanvasPoint? previewShapeStart;
  final CanvasPoint? previewShapeEnd;
  final bool previewIsEraser;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);

    for (final layer in layers) {
      if (!layer.isVisible) continue;
      canvas.saveLayer(
        Offset.zero & size,
        Paint()
          ..color = Color.fromRGBO(0, 0, 0, layer.opacity)
          ..blendMode = layer.blendMode.blendMode,
      );
      for (final element in layer.elements) {
        _paintElement(canvas, element);
      }
      canvas.restore();
    }

    if (previewPoints.length > 1) {
      _paintStrokePath(
        canvas,
        previewPoints,
        previewColorValue,
        previewStrokeWidth,
        previewIsEraser,
      );
    }
    final shapeType = previewShapeType;
    final start = previewShapeStart;
    final end = previewShapeEnd;
    if (shapeType != null && start != null && end != null) {
      _paintShape(
        canvas,
        shapeType,
        start,
        end,
        previewColorValue,
        previewStrokeWidth,
        isFilled: false,
      );
    }
  }

  void _paintElement(Canvas canvas, Canvas2dElement element) {
    switch (element) {
      case final StrokeElement e:
        _paintStrokePath(
          canvas,
          e.points,
          e.colorValue,
          e.strokeWidth,
          e.isEraser,
        );
      case final ShapeElement e:
        _paintShape(
          canvas,
          e.shapeType,
          e.start,
          e.end,
          e.colorValue,
          e.strokeWidth,
          isFilled: e.isFilled,
        );
      case final TextElement2d e:
        final painter = TextPainter(
          text: TextSpan(
            text: e.text,
            style: TextStyle(color: Color(e.colorValue), fontSize: e.fontSize),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        painter.paint(canvas, Offset(e.position.dx, e.position.dy));
    }
  }

  void _paintStrokePath(
    Canvas canvas,
    List<CanvasPoint> points,
    int colorValue,
    double strokeWidth,
    bool isEraser,
  ) {
    if (points.isEmpty) return;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    final paint = Paint()
      ..color = isEraser ? Colors.white : Color(colorValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..blendMode = isEraser ? BlendMode.clear : BlendMode.srcOver;
    canvas.drawPath(path, paint);
  }

  void _paintShape(
    Canvas canvas,
    Canvas2dShapeType type,
    CanvasPoint start,
    CanvasPoint end,
    int colorValue,
    double strokeWidth, {
    required bool isFilled,
  }) {
    final paint = Paint()
      ..color = Color(colorValue)
      ..strokeWidth = strokeWidth
      ..style = isFilled ? PaintingStyle.fill : PaintingStyle.stroke;
    final rect = Rect.fromPoints(
      Offset(start.dx, start.dy),
      Offset(end.dx, end.dy),
    );
    switch (type) {
      case Canvas2dShapeType.line:
        canvas.drawLine(
          Offset(start.dx, start.dy),
          Offset(end.dx, end.dy),
          paint,
        );
      case Canvas2dShapeType.rectangle:
        canvas.drawRect(rect, paint);
      case Canvas2dShapeType.ellipse:
        canvas.drawOval(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _Canvas2dPainter oldDelegate) => true;
}

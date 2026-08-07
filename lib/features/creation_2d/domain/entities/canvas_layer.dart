import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_blend_mode.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_element.dart';

/// One layer of a [Canvas2dProject]: an ordered stack of drawn elements plus
/// visibility/lock/opacity/blend-mode state, matching how layers behave in
/// real drawing tools.
class Canvas2dLayer {
  const Canvas2dLayer({
    required this.id,
    required this.name,
    this.elements = const [],
    this.isVisible = true,
    this.isLocked = false,
    this.opacity = 1.0,
    this.blendMode = Canvas2dBlendMode.normal,
  });

  final String id;
  final String name;
  final List<Canvas2dElement> elements;
  final bool isVisible;
  final bool isLocked;
  final double opacity;
  final Canvas2dBlendMode blendMode;

  Canvas2dLayer copyWith({
    String? name,
    List<Canvas2dElement>? elements,
    bool? isVisible,
    bool? isLocked,
    double? opacity,
    Canvas2dBlendMode? blendMode,
  }) {
    return Canvas2dLayer(
      id: id,
      name: name ?? this.name,
      elements: elements ?? this.elements,
      isVisible: isVisible ?? this.isVisible,
      isLocked: isLocked ?? this.isLocked,
      opacity: opacity ?? this.opacity,
      blendMode: blendMode ?? this.blendMode,
    );
  }

  Canvas2dLayer addElement(Canvas2dElement element) =>
      copyWith(elements: [...elements, element]);

  Canvas2dLayer removeLastElement() {
    if (elements.isEmpty) return this;
    return copyWith(elements: elements.sublist(0, elements.length - 1));
  }

  Canvas2dLayer clearElements() => copyWith(elements: const []);
}

/// A real layer-compositing blend mode, applied via `dart:ui`'s `BlendMode`
/// when a [Canvas2dLayer] is composited onto the canvas (see
/// `DrawingCanvas`'s `_Canvas2dPainter`) — genuine pixel compositing, not a
/// cosmetic label.
enum Canvas2dBlendMode { normal, multiply, screen, overlay, darken, lighten }

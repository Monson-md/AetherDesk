import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The user's chosen text size, applied app-wide as a [TextScaler] in
/// `app.dart`. Presentation layers map each value to a localized label.
enum TextScaleOption { small, medium, large }

extension TextScaleOptionFactor on TextScaleOption {
  double get scaleFactor => switch (this) {
    TextScaleOption.small => 0.9,
    TextScaleOption.medium => 1.0,
    TextScaleOption.large => 1.15,
  };
}

/// Holds the user's chosen [TextScaleOption]. In-memory only for now —
/// mirrors `core/theme/theme_mode_provider.dart`.
class TextScaleNotifier extends Notifier<TextScaleOption> {
  @override
  TextScaleOption build() => TextScaleOption.medium;

  void setTextScale(TextScaleOption option) => state = option;
}

final textScaleProvider = NotifierProvider<TextScaleNotifier, TextScaleOption>(
  TextScaleNotifier.new,
);

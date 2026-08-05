import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

const List<int> kCanvas2dPalette = [
  0xFF1A1A1A,
  0xFFFFFFFF,
  0xFFEF4444,
  0xFFF59E0B,
  0xFFFACC15,
  0xFF22C55E,
  0xFF06B6D4,
  0xFF3B82F6,
  0xFF8B5CF6,
  0xFFEC4899,
];

/// Row of preset color swatches driving the active drawing color.
class ColorSwatchPicker extends StatelessWidget {
  const ColorSwatchPicker({
    required this.colorValue,
    required this.onColorChanged,
    super.key,
  });

  final int colorValue;
  final ValueChanged<int> onColorChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: kCanvas2dPalette.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppDimensions.spacingXs),
        itemBuilder: (context, index) {
          final swatch = kCanvas2dPalette[index];
          final isActive = swatch == colorValue;
          return GestureDetector(
            onTap: () => onColorChanged(swatch),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(swatch),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                  width: isActive ? 3 : 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

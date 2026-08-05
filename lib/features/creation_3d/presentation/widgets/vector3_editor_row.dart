import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/vector3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A labeled row of three compact numeric fields editing a [Vector3]'s
/// x/y/z components, used for position/rotation/scale in the inspector.
class Vector3EditorRow extends StatelessWidget {
  const Vector3EditorRow({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final Vector3 value;
  final ValueChanged<Vector3> onChanged;

  Widget _axisField(
    BuildContext context,
    String axisLabel,
    double axisValue,
    ValueChanged<double> onAxisChanged,
  ) {
    return Expanded(
      child: TextFormField(
        key: ValueKey('$label-$axisLabel-${axisValue.toStringAsFixed(2)}'),
        initialValue: axisValue.toStringAsFixed(1),
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
        ],
        decoration: InputDecoration(
          isDense: true,
          prefixText: '$axisLabel ',
          border: const OutlineInputBorder(),
        ),
        onFieldSubmitted: (text) {
          final parsed = double.tryParse(text);
          if (parsed != null) onAxisChanged(parsed);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: AppDimensions.spacingXs),
        Row(
          children: [
            _axisField(
              context,
              'X',
              value.x,
              (x) => onChanged(value.copyWith(x: x)),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            _axisField(
              context,
              'Y',
              value.y,
              (y) => onChanged(value.copyWith(y: y)),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            _axisField(
              context,
              'Z',
              value.z,
              (z) => onChanged(value.copyWith(z: z)),
            ),
          ],
        ),
      ],
    );
  }
}

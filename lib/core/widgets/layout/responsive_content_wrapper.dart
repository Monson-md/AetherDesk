import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

/// Constrains page content to a comfortable reading/working width on large
/// desktop windows, while filling the screen on narrow ones. AetherDesk is a
/// workspace-style app expected to run on tablets and desktop, so this
/// avoids content stretching edge-to-edge on wide monitors.
class ResponsiveContentWrapper extends StatelessWidget {
  const ResponsiveContentWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppDimensions.maxContentWidth,
        ),
        child: child,
      ),
    );
  }
}

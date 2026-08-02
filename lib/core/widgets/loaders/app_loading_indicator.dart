import 'package:flutter/material.dart';

/// Full-size centered spinner used as the standard "loading" state across
/// every module's `presentation/pages`.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

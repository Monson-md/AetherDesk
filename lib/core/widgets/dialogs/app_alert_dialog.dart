import 'package:flutter/material.dart';

/// Standard alert/confirmation dialog. Centralizing this means every
/// "Are you sure?" prompt across the 9 modules looks and behaves the same.
class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    required this.title,
    required this.message,
    this.confirmLabel = 'OK',
    this.cancelLabel,
    super.key,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String? cancelLabel;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'OK',
    String? cancelLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AppAlertDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (cancelLabel != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel!),
          ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}

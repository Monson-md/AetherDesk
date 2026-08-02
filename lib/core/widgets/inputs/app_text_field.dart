import 'package:flutter/material.dart';

/// Standard text input, wired to the app's `InputDecorationTheme` from
/// `core/theme`. Wrapping `TextFormField` here means adding a shared
/// behavior later (e.g. a clear button, consistent error styling) only
/// requires touching this one file.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
    );
  }
}

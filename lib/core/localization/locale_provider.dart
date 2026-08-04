import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the user's chosen app language, or `null` to follow the device's
/// system locale (`MaterialApp.locale` treats `null` this way already).
///
/// In-memory only for now — mirrors `core/theme/theme_mode_provider.dart`;
/// once `core/services/storage` gets a concrete implementation, [setLocale]
/// should persist the choice so it survives app restarts.
class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  void setLocale(Locale? locale) => state = locale;
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);

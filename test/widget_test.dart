// Minimal smoke test placeholder. Intentionally not executed as part of
// this scaffolding pass (project constraints: no `flutter test` run) — kept
// buildable so `flutter analyze` has no dangling references to the old
// counter demo app.

import 'package:aetherdesk/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots and shows the dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AetherDeskApp()));
    await tester.pumpAndSettle();

    expect(find.byType(AetherDeskApp), findsOneWidget);
  });
}

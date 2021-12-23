import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:test_hacker_news/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'end-to-end test',
    () {
      testWidgets(
        'HN Integration test',
        (WidgetTester tester) async {
          app.main();
          await tester.pumpAndSettle();
          // Verify that our counter starts at 0.
          final textField = find.byType(TextField);
          expect(textField, findsOneWidget);

          await tester.enterText(textField, 'fligh');

          await tester.pump();

          expect(find.text('flight'), findsOneWidget);
        },
      );
    },
  );
}

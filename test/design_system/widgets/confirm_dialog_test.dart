import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group('showConfirmDialog', () {
    late Future<bool> result;

    Future<void> open(
      WidgetTester tester, {
      Brightness brightness = Brightness.light,
    }) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => result = showConfirmDialog(
              context,
              title: 'Delete Eggs?',
              message: "It won't be suggested here again.",
              cancelLabel: 'Cancel',
              confirmLabel: 'Delete',
            ),
            child: const Text('Open'),
          ),
        ),
        brightness: brightness,
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    }

    testWidgets('asks the question and says what happens', (tester) async {
      await open(tester);

      expect(find.byType(ConfirmDialog), findsOneWidget);
      expect(find.text('Delete Eggs?'), findsOneWidget);
      expect(find.text("It won't be suggested here again."), findsOneWidget);
    });

    testWidgets('returns true when confirmed', (tester) async {
      await open(tester);

      await tester.tap(find.text('Delete'));

      expect(await result, isTrue);
    });

    testWidgets('returns false when cancelled', (tester) async {
      await open(tester);

      await tester.tap(find.text('Cancel'));

      expect(await result, isFalse);
    });

    testWidgets('returns false when dismissed', (tester) async {
      await open(tester);

      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();

      expect(await result, isFalse);
    });

    testWidgets('shows the action in the error colour', (tester) async {
      await open(tester);

      final delete = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Delete'),
      );
      expect(
        delete.style?.foregroundColor?.resolve({}),
        AppColors.legalPad.error,
      );
    });

    for (final MapEntry(key: theme, value: brightness)
        in brightnessesUnderTest.entries) {
      testWidgets('meets accessibility guidelines on the $theme', (
        tester,
      ) async {
        await open(tester, brightness: brightness);

        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}

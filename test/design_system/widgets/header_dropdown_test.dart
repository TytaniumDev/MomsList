import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group('showHeaderDropdown', () {
    Future<void> open(WidgetTester tester, {Brightness? brightness}) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showHeaderDropdown<void>(
                context,
                top: 100,
                builder: (menuContext) => TextButton(
                  onPressed: () => Navigator.of(menuContext).pop(),
                  child: const Text('Close'),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
        brightness: brightness ?? Brightness.light,
      );
      await tester.tap(find.text('Open'));
      await tester.pump();
    }

    testWidgets('shows the content full width at top', (tester) async {
      await open(tester);

      final panel = find.ancestor(
        of: find.text('Close'),
        matching: find.byType(SingleChildScrollView),
      );
      expect(tester.getTopLeft(panel), const Offset(0, 100));
      expect(tester.getSize(panel).width, iPhoneProSize.width);
    });

    testWidgets('closes from its content', (tester) async {
      await open(tester);

      await tester.tap(find.text('Close'));
      await tester.pump();

      expect(find.text('Close'), findsNothing);
    });

    testWidgets('closes when the page behind is tapped', (tester) async {
      await open(tester);

      await tester.tapAt(const Offset(200, 800));
      await tester.pump();

      expect(find.text('Close'), findsNothing);
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

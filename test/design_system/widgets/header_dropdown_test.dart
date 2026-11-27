import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group('showHeaderDropdown', () {
    /// Taps Open, then lets [elapsed] of the opening run, or all of it.
    Future<void> open(
      WidgetTester tester, {
      Brightness? brightness,
      bool disableAnimations = false,
      Duration? elapsed,
    }) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(disableAnimations: disableAnimations),
            child: Builder(
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
          ),
        ),
        brightness: brightness ?? Brightness.light,
      );
      await tester.tap(find.text('Open'));
      if (elapsed == null) {
        await tester.pumpAndSettle();
      } else {
        // Pushes the dropdown, then starts its opening.
        await tester.pump();
        await tester.pump();
        await tester.pump(elapsed);
      }
    }

    Finder panel() => find.ancestor(
      of: find.text('Close'),
      matching: find.byType(SingleChildScrollView),
    );

    double panelOpacity(WidgetTester tester) => tester
        .widget<FadeTransition>(
          find
              .ancestor(of: panel(), matching: find.byType(FadeTransition))
              .first,
        )
        .opacity
        .value;

    testWidgets('shows the content full width at top', (tester) async {
      await open(tester);

      expect(tester.getTopLeft(panel()), const Offset(0, 100));
      expect(tester.getSize(panel()).width, iPhoneProSize.width);
      expect(panelOpacity(tester), 1);
    });

    testWidgets('slides down from under the header as it fades in', (
      tester,
    ) async {
      await open(tester, elapsed: AppMotion.standard ~/ 2);

      expect(tester.getTopLeft(panel()).dy, lessThan(100));
      expect(panelOpacity(tester), inExclusiveRange(0, 1));
      // Clipped at the header's edge, so it never covers the header.
      expect(
        find.ancestor(of: panel(), matching: find.byType(ClipRect)),
        findsWidgets,
      );
    });

    testWidgets('only fades in with Reduce Motion on', (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(reduceMotion: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );

      await open(tester, elapsed: AppMotion.standard ~/ 2);

      expect(tester.getTopLeft(panel()).dy, 100);
      expect(panelOpacity(tester), inExclusiveRange(0, 1));
    });

    testWidgets('opens at once when animations are off', (tester) async {
      await open(tester, disableAnimations: true, elapsed: Duration.zero);

      expect(tester.getTopLeft(panel()).dy, 100);
      expect(panelOpacity(tester), 1);
    });

    testWidgets('closes from its content', (tester) async {
      await open(tester);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Close'), findsNothing);
    });

    testWidgets('closes when the page behind is tapped', (tester) async {
      await open(tester);

      await tester.tapAt(const Offset(200, 800));
      await tester.pumpAndSettle();

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

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(AppMotion, () {
    Future<BuildContext> contextWith(
      WidgetTester tester, {
      bool disableAnimations = false,
    }) async {
      late BuildContext captured;
      await tester.pumpApp(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(disableAnimations: disableAnimations),
            child: Builder(
              builder: (context) {
                captured = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      return captured;
    }

    test('keeps changes brief', () {
      expect(AppMotion.quick, lessThan(AppMotion.standard));
      expect(AppMotion.standard, lessThanOrEqualTo(Durations.medium1));
    });

    testWidgets('animates and moves by default', (tester) async {
      final context = await contextWith(tester);

      expect(
        AppMotion.durationOf(context, AppMotion.standard),
        AppMotion.standard,
      );
      expect(AppMotion.allowsMovementOf(context), isTrue);
    });

    testWidgets('only fades with Reduce Motion on', (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(reduceMotion: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      final context = await contextWith(tester);

      expect(AppMotion.durationOf(context, AppMotion.quick), AppMotion.quick);
      expect(AppMotion.allowsMovementOf(context), isFalse);
    });

    testWidgets('does not animate when animations are off', (tester) async {
      final context = await contextWith(tester, disableAnimations: true);

      expect(AppMotion.durationOf(context, AppMotion.standard), Duration.zero);
      expect(AppMotion.allowsMovementOf(context), isFalse);
    });
  });
}

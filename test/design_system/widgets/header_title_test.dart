import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/widgets/header_title.dart';

import '../../helpers/helpers.dart';

void main() {
  group(HeaderTitle, () {
    const longName = 'Albertsons on Main Street by the old post office';

    Future<double> heightFor(
      WidgetTester tester,
      String text, {
      double textScale = 1,
      int actionCount = 0,
      bool hasTrailingIcon = false,
    }) async {
      late double height;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            height = HeaderTitle.toolbarHeight(
              context,
              text,
              actionCount: actionCount,
              hasTrailingIcon: hasTrailingIcon,
            );
            return const SizedBox();
          },
        ),
        textScale: textScale,
      );
      return height;
    }

    testWidgets('shows the title at the full text size', (tester) async {
      await tester.pumpApp(
        Scaffold(
          appBar: AppBar(title: HeaderTitle('Costco', onTap: () {})),
        ),
        textScale: 3.12,
      );

      final title = tester.element(find.text('Costco'));
      expect(MediaQuery.textScalerOf(title).scale(10), closeTo(31.2, 0.01));
      expect(
        tester.getSize(find.byIcon(Icons.arrow_drop_down)).width,
        24 * 3.12,
      );
    });

    testWidgets('is a plain title without onTap', (tester) async {
      await tester.pumpApp(
        Scaffold(appBar: AppBar(title: const HeaderTitle('Stores'))),
      );

      expect(find.text('Stores'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('cross-fades to a new title', (tester) async {
      Widget header(String title) =>
          Scaffold(appBar: AppBar(title: HeaderTitle(title)));
      await tester.pumpApp(header('Costco'));

      await tester.pumpApp(header('Target'), settle: false);
      await tester.pump();
      expect(find.text('Costco'), findsOneWidget);
      expect(find.text('Target'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Costco'), findsNothing);
      expect(find.text('Target'), findsOneWidget);
    });

    testWidgets('is a button with a hint when it has onTap', (tester) async {
      var taps = 0;
      await tester.pumpApp(
        Scaffold(
          appBar: AppBar(
            title: HeaderTitle(
              'Costco',
              onTap: () => taps++,
              tapHint: 'Switch store',
            ),
          ),
        ),
      );

      await tester.tap(find.text('Costco'));
      expect(taps, 1);
      expect(
        tester.getSemantics(find.byType(InkWell)),
        isSemantics(isButton: true, hint: 'Switch store'),
      );
    });

    testWidgets('keeps the standard app bar height for short titles', (
      tester,
    ) async {
      expect(await heightFor(tester, 'Costco'), kToolbarHeight);
    });

    testWidgets('grows the app bar so long titles wrap', (tester) async {
      final oneLine = await heightFor(tester, 'Costco', textScale: 3.12);
      final wrapped = await heightFor(
        tester,
        longName,
        textScale: 3.12,
        hasTrailingIcon: true,
      );

      expect(oneLine, greaterThan(kToolbarHeight));
      expect(wrapped, greaterThan(oneLine * 2));
    });

    testWidgets('leaves room for the actions', (tester) async {
      final noActions = await heightFor(tester, longName, textScale: 2);
      final twoActions = await heightFor(
        tester,
        longName,
        textScale: 2,
        actionCount: 2,
      );

      expect(twoActions, greaterThan(noActions));
    });
  });
}

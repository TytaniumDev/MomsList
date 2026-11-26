import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/view/full_size_app_bar_title.dart';

import '../../helpers/helpers.dart';

void main() {
  group(FullSizeAppBarTitle, () {
    const longName = 'Albertsons on Main Street by the old post office';

    Future<double> heightFor(
      WidgetTester tester,
      String text, {
      double textScale = 1,
      bool hasTrailingIcon = false,
    }) async {
      late double height;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            height = FullSizeAppBarTitle.toolbarHeight(
              context,
              text,
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
          appBar: AppBar(
            title: const FullSizeAppBarTitle(
              'Costco',
              trailingIcon: Icons.arrow_drop_down,
            ),
          ),
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
  });
}

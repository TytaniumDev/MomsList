import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/grocery/grocery.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(StoreSwitcherButton, () {
    final costco = Store(
      id: 'costco',
      name: 'Costco',
      createdAt: DateTime(2026),
    );
    final longName = Store(
      id: 'long',
      name: 'Albertsons on Main Street by the old post office',
      createdAt: DateTime(2026),
    );

    testWidgets('opens the store picker when tapped', (tester) async {
      await tester.pumpApp(
        Scaffold(
          appBar: AppBar(title: StoreSwitcherButton(store: costco)),
        ),
        overrides: groceryOverrides(await seededGroceries()),
      );

      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      await tester.tap(find.text('Costco'));
      await tester.pumpAndSettle();

      expect(find.byType(StorePickerPage), findsOneWidget);
    });

    testWidgets('sizes the app bar for the name', (tester) async {
      late double height;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            height = StoreSwitcherButton.toolbarHeight(context, longName);
            return const SizedBox();
          },
        ),
        textScale: 3.12,
      );

      expect(height, greaterThan(kToolbarHeight * 2));
    });
  });
}

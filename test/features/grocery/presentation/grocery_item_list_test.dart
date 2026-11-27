import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';
import 'package:moms_list/features/grocery/data/in_memory_grocery_repository.dart';
import 'package:moms_list/features/grocery/grocery.dart';
import 'package:moms_list/features/grocery/presentation/grocery_item_list.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(GroceryItemList, () {
    Future<void> pumpList(
      WidgetTester tester,
      InMemoryGroceryRepository repository, {
      String storeId = 'costco',
    }) => tester.pumpApp(
      Scaffold(body: GroceryItemList(storeId: storeId)),
      overrides: groceryOverrides(repository),
    );

    testWidgets('lists items to get above the checked ones', (tester) async {
      await pumpList(tester, await seededGroceries());

      final eggs = tester.getTopLeft(find.text('Eggs')).dy;
      final heading = tester.getTopLeft(find.text('Got it (1)')).dy;
      final coffee = tester.getTopLeft(find.text('Coffee beans')).dy;
      expect(eggs, lessThan(heading));
      expect(heading, lessThan(coffee));
      expect(find.text('Milk'), findsNothing);
    });

    testWidgets('glides a checked item down to Got it and back', (
      tester,
    ) async {
      final repository = await seededGroceries();
      await pumpList(tester, repository);
      final eggsId = GroceryItem.idFor(storeId: 'costco', name: 'Eggs');
      final from = tester.getTopLeft(find.text('Eggs')).dy;

      await repository.setChecked(eggsId, checked: true);
      await tester.pump();
      await tester.pump();
      await tester.pump(AppMotion.standard ~/ 2);
      final midway = tester.getTopLeft(find.text('Eggs')).dy;
      await tester.pumpAndSettle();
      final to = tester.getTopLeft(find.text('Eggs')).dy;

      expect(to, greaterThan(tester.getTopLeft(find.text('Got it (2)')).dy));
      expect(midway, inExclusiveRange(from, to));

      await repository.setChecked(eggsId, checked: false);
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.text('Eggs')).dy, from);
    });

    testWidgets('says when there is nothing to get', (tester) async {
      final repository = await seededGroceries();
      await repository.setChecked(
        GroceryItem.idFor(storeId: 'albertsons', name: 'Milk'),
        checked: true,
      );
      await pumpList(tester, repository, storeId: 'albertsons');

      expect(find.text('Nothing to get. Type an item above.'), findsOneWidget);
      expect(find.text('Got it (1)'), findsOneWidget);
    });

    testWidgets('has no heading before anything is checked', (tester) async {
      await pumpList(tester, await seededGroceries(), storeId: 'albertsons');

      expect(find.textContaining('Got it'), findsNothing);
    });

    testWidgets('is empty while loading', (tester) async {
      await tester.pumpApp(
        const Scaffold(body: GroceryItemList(storeId: 'costco')),
        settle: false,
      );

      expect(find.text('Eggs'), findsNothing);
    });
  });
}

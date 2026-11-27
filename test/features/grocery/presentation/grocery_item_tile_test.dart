import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/grocery/data/in_memory_grocery_repository.dart';
import 'package:moms_list/features/grocery/grocery.dart';
import 'package:moms_list/features/grocery/presentation/grocery_item_tile.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(GroceryItemTile, () {
    late InMemoryGroceryRepository repository;
    final eggsId = GroceryItem.idFor(storeId: 'costco', name: 'Eggs');
    final coffeeId = GroceryItem.idFor(storeId: 'costco', name: 'Coffee beans');

    setUp(() async => repository = await seededGroceries());

    Future<GroceryItem?> itemWithId(String id) async => [
      for (final item in await repository.watchItems().first)
        if (item.id == id) item,
    ].firstOrNull;

    Future<void> pumpTile(WidgetTester tester, String id) async {
      final item = (await itemWithId(id))!;
      await tester.pumpApp(
        Scaffold(body: GroceryItemTile(item: item)),
        overrides: groceryOverrides(repository),
      );
    }

    testWidgets('checks off an item when tapped', (tester) async {
      await pumpTile(tester, eggsId);

      await tester.tap(find.text('Eggs'));
      await tester.pump();

      expect((await itemWithId(eggsId))!.checked, isTrue);
    });

    testWidgets('puts a checked item back when tapped', (tester) async {
      await pumpTile(tester, coffeeId);

      await tester.tap(find.text('Coffee beans'));
      await tester.pump();

      expect((await itemWithId(coffeeId))!.checked, isFalse);
    });

    testWidgets('crosses out checked items', (tester) async {
      await pumpTile(tester, coffeeId);

      final text = tester.widget<Text>(find.text('Coffee beans'));
      expect(text.style?.decoration, TextDecoration.lineThrough);
      expect(
        tester.getSemantics(find.byType(GroceryItemTile)),
        isSemantics(hasCheckedState: true, isChecked: true),
      );
    });

    testWidgets('deletes an item after holding it down', (tester) async {
      await pumpTile(tester, eggsId);

      await tester.longPress(find.text('Eggs'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(await itemWithId(eggsId), isNull);
    });

    testWidgets('keeps the item when delete is cancelled', (tester) async {
      await pumpTile(tester, eggsId);

      await tester.longPress(find.text('Eggs'));
      await tester.pumpAndSettle();
      expect(find.text('Delete Eggs?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(await itemWithId(eggsId), isNotNull);
    });

    testWidgets('keeps the item when the dialog is dismissed', (tester) async {
      await pumpTile(tester, eggsId);

      await tester.longPress(find.text('Eggs'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      expect(await itemWithId(eggsId), isNotNull);
    });
  });
}

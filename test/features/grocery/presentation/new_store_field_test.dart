import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/grocery/data/in_memory_grocery_repository.dart';
import 'package:moms_list/features/grocery/grocery.dart';
import 'package:moms_list/features/grocery/presentation/new_store_field.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(NewStoreField, () {
    late InMemoryGroceryRepository repository;

    setUp(() => repository = InMemoryGroceryRepository());

    Future<List<String>> storeNames() async => [
      for (final store in await repository.watchStores().first) store.name,
    ];

    Future<void> pumpField(WidgetTester tester, {VoidCallback? onAdded}) =>
        tester.pumpApp(
          Scaffold(body: NewStoreField(onAdded: onAdded)),
          overrides: groceryOverrides(repository),
        );

    testWidgets('adds and opens a store with the Add button', (tester) async {
      var added = false;
      await pumpField(tester, onAdded: () => added = true);

      await tester.enterText(find.byType(TextField), ' Costco ');
      await tester.tap(find.text('Add'));
      await tester.pump();

      expect(await storeNames(), ['Costco']);
      expect(added, isTrue);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(NewStoreField)),
      );
      final stores = await repository.watchStores().first;
      expect(container.read(selectedStoreIdProvider), stores.single.id);
      expect(find.text('Costco'), findsNothing);
    });

    testWidgets('adds a store on return', (tester) async {
      await pumpField(tester);

      await tester.enterText(find.byType(TextField), 'Target');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(await storeNames(), ['Target']);
    });

    testWidgets('ignores a blank name', (tester) async {
      await pumpField(tester);

      await tester.enterText(find.byType(TextField), '   ');
      await tester.tap(find.text('Add'));
      await tester.pump();

      expect(await storeNames(), isEmpty);
    });
  });
}

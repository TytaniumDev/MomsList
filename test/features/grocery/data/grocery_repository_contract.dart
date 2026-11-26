import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/features/grocery/domain/grocery_item.dart';
import 'package:moms_list/features/grocery/domain/grocery_repository.dart';
import 'package:moms_list/features/grocery/domain/store.dart';

/// Behaviour every [GroceryRepository] must have. Each implementation's test
/// runs it.
void groceryRepositoryContract(GroceryRepository Function() create) {
  // Local time, like clock.now() and Timestamp.toDate().
  final t0 = DateTime(2026, 11, 26, 9);
  final t1 = t0.add(const Duration(minutes: 1));
  final t2 = t0.add(const Duration(minutes: 2));

  late GroceryRepository repository;

  setUp(() => repository = create());

  Future<List<Store>> stores() => repository.watchStores().first;
  Future<List<GroceryItem>> items() => repository.watchItems().first;

  group('stores', () {
    test('are listed in the order they were added', () async {
      await withClock(Clock.fixed(t1), () async {
        await repository.addStore(id: 'b', name: 'Costco');
      });
      await withClock(Clock.fixed(t0), () async {
        await repository.addStore(id: 'a', name: ' Albertsons ');
      });

      expect(await stores(), [
        Store(id: 'a', name: 'Albertsons', createdAt: t0),
        Store(id: 'b', name: 'Costco', createdAt: t1),
      ]);
    });

    test('can be renamed', () async {
      await withClock(Clock.fixed(t0), () async {
        await repository.addStore(id: 'a', name: 'Albertsons');
      });

      await repository.renameStore(id: 'a', name: 'Safeway');

      expect(await stores(), [Store(id: 'a', name: 'Safeway', createdAt: t0)]);
    });

    test('take their items with them when deleted', () async {
      await repository.addStore(id: 'a', name: 'Albertsons');
      await repository.addStore(id: 'b', name: 'Costco');
      await repository.addItem(storeId: 'a', name: 'Milk');
      await repository.addItem(storeId: 'b', name: 'Eggs');

      await repository.deleteStore('a');

      expect((await stores()).map((store) => store.id), ['b']);
      expect((await items()).map((item) => item.name), ['Eggs']);
    });
  });

  group('items', () {
    test('are added unchecked', () async {
      await withClock(Clock.fixed(t0), () async {
        await repository.addItem(storeId: 'a', name: ' Milk ');
      });

      expect(await items(), [
        GroceryItem(
          id: GroceryItem.idFor(storeId: 'a', name: 'milk'),
          storeId: 'a',
          name: 'Milk',
          checked: false,
          addedAt: t0,
        ),
      ]);
    });

    test('are checked and un-checked', () async {
      await withClock(Clock.fixed(t0), () async {
        await repository.addItem(storeId: 'a', name: 'Milk');
      });
      final id = (await items()).single.id;

      await withClock(Clock.fixed(t1), () async {
        await repository.setChecked(id, checked: true);
      });
      expect((await items()).single.checked, isTrue);
      expect((await items()).single.checkedAt, t1);

      await repository.setChecked(id, checked: false);
      expect((await items()).single.checked, isFalse);
      expect((await items()).single.checkedAt, isNull);
    });

    test('added again are un-checked instead of duplicated', () async {
      await withClock(Clock.fixed(t0), () async {
        await repository.addItem(storeId: 'a', name: 'milk');
      });
      await repository.setChecked((await items()).single.id, checked: true);

      await withClock(Clock.fixed(t2), () async {
        await repository.addItem(storeId: 'a', name: 'MILK ');
      });

      final item = (await items()).single;
      expect(item.name, 'MILK', reason: 'keeps the latest spelling');
      expect(item.checked, isFalse);
      expect(item.addedAt, t2);
      expect(item.checkedAt, isNull);
    });

    test('with the same name at two stores stay separate', () async {
      await repository.addItem(storeId: 'a', name: 'Milk');
      await repository.addItem(storeId: 'b', name: 'Milk');

      expect(await items(), hasLength(2));
    });

    test('can be deleted', () async {
      await repository.addItem(storeId: 'a', name: 'Milk');

      await repository.deleteItem((await items()).single.id);

      expect(await items(), isEmpty);
    });

    test('stream every change', () async {
      final seen = repository.watchItems().map(
        (items) => items.map((item) => item.name).toList(),
      );

      final expectation = expectLater(seen, emitsThrough(['Milk']));
      await repository.addItem(storeId: 'a', name: 'Milk');
      await expectation;
    });
  });
}

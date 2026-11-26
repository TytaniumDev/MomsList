import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/features/grocery/data/in_memory_grocery_repository.dart';
import 'package:moms_list/features/grocery/domain/grocery_repository.dart';
import 'package:moms_list/features/grocery/grocery.dart';

class _MockGroceryRepository extends Mock implements GroceryRepository;

void main() {
  group(GroceryController, () {
    late InMemoryGroceryRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = InMemoryGroceryRepository();
      container = ProviderContainer.test(
        overrides: [groceryRepositoryProvider.overrideWithValue(repository)],
      )..listen(groceryControllerProvider, (_, _) {});
    });

    GroceryController controller() =>
        container.read(groceryControllerProvider.notifier);

    Future<List<String>> storeNames() async => [
      for (final store in await repository.watchStores().first) store.name,
    ];

    Future<List<GroceryItem>> items() => repository.watchItems().first;

    test('adds, renames and deletes stores', () async {
      final id = controller().addStore('Costco');
      expect(await storeNames(), ['Costco']);

      controller().renameStore(id, 'Albertsons');
      expect(await storeNames(), ['Albertsons']);

      controller().deleteStore(id);
      expect(await storeNames(), isEmpty);
    });

    test('adds, checks and deletes items', () async {
      controller().addItem(storeId: 's', name: 'Milk');
      final id = (await items()).single.id;

      controller().setChecked(id, checked: true);
      expect((await items()).single.checked, isTrue);

      controller().deleteItem(id);
      expect(await items(), isEmpty);
    });

    test('ignores blank items', () async {
      controller().addItem(storeId: 's', name: '   ');

      expect(await items(), isEmpty);
    });

    test('keeps going when a save fails', () async {
      final failing = _MockGroceryRepository();
      when(() => failing.deleteItem(any()))
          .thenAnswer((_) => Future.error(Exception('offline')));
      final container = ProviderContainer.test(
        overrides: [groceryRepositoryProvider.overrideWithValue(failing)],
      )..listen(groceryControllerProvider, (_, _) {});

      container.read(groceryControllerProvider.notifier).deleteItem('x');
      await pumpEventQueue();

      verify(() => failing.deleteItem('x')).called(1);
    });
  });
}

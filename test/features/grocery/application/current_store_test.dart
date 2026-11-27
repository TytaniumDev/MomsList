import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/features/grocery/data/in_memory_grocery_repository.dart';
import 'package:moms_list/features/grocery/data/last_store_storage.dart';
import 'package:moms_list/features/grocery/grocery.dart';

import '../../../helpers/helpers.dart';

class _MockLastStoreStorage extends Mock implements LastStoreStorage;

void main() {
  group('currentStoreProvider', () {
    Future<ProviderContainer> containerWith(
      InMemoryGroceryRepository repository, {
      LastStoreStorage? storage,
    }) async {
      final container = ProviderContainer.test(
        overrides: [
          ...groceryOverrides(repository),
          if (storage != null)
            lastStoreStorageProvider.overrideWithValue(storage),
        ],
      )..listen(currentStoreProvider, (_, _) {});
      await container.read(storesProvider.future);
      await container.read(lastStoreIdProvider.future);
      return container;
    }

    test('is null before there are any stores', () async {
      final container = await containerWith(InMemoryGroceryRepository());

      expect(container.read(currentStoreProvider).value, isNull);
    });

    test('is the first store until Mom picks one', () async {
      final container = await containerWith(await seededGroceries());

      expect(container.read(currentStoreProvider).value?.id, 'costco');
    });

    test('is the store Mom picked', () async {
      final container = await containerWith(await seededGroceries());

      container.read(selectedStoreIdProvider.notifier).select('albertsons');

      expect(container.read(currentStoreProvider).value?.id, 'albertsons');
    });

    test('is the store Mom had open last time', () async {
      await LastStoreStorage().write('albertsons');

      final container = await containerWith(await seededGroceries());

      expect(container.read(currentStoreProvider).value?.id, 'albertsons');
    });

    test('saves the store Mom picks for next time', () async {
      final container = await containerWith(await seededGroceries());

      container.read(selectedStoreIdProvider.notifier).select('albertsons');
      await pumpEventQueue();

      expect(await LastStoreStorage().read(), 'albertsons');
    });

    test('waits for the saved store before showing a list', () {
      final container = ProviderContainer.test(
        overrides: groceryOverrides(InMemoryGroceryRepository()),
      );

      expect(container.read(currentStoreProvider), isA<AsyncLoading<Store?>>());
    });

    test('opens on the first store if the saved one cannot be read', () async {
      final storage = _MockLastStoreStorage();
      when(storage.read).thenThrow(Exception('storage unavailable'));

      final container = await containerWith(
        await seededGroceries(),
        storage: storage,
      );

      expect(container.read(currentStoreProvider).value?.id, 'costco');
    });

    test('falls back to the first store if the picked one is gone', () async {
      final container = await containerWith(await seededGroceries());

      container.read(selectedStoreIdProvider.notifier).select('deleted');

      expect(container.read(currentStoreProvider).value?.id, 'costco');
    });
  });
}

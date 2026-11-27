import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/features/grocery/data/in_memory_grocery_repository.dart';
import 'package:moms_list/features/grocery/grocery.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('currentStoreProvider', () {
    Future<ProviderContainer> containerWith(
      InMemoryGroceryRepository repository,
    ) async {
      final container = ProviderContainer.test(
        overrides: groceryOverrides(repository),
      )..listen(currentStoreProvider, (_, _) {});
      await container.read(storesProvider.future);
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

    test('falls back to the first store if the picked one is gone', () async {
      final container = await containerWith(await seededGroceries());

      container.read(selectedStoreIdProvider.notifier).select('deleted');

      expect(container.read(currentStoreProvider).value?.id, 'costco');
    });
  });
}

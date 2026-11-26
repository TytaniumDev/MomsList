import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/app/services/auth_service.dart';
import 'package:moms_list/app/services/firebase.dart';
import 'package:moms_list/features/account/account.dart';
import 'package:moms_list/features/grocery/data/firestore_grocery_repository.dart';
import 'package:moms_list/features/grocery/data/in_memory_grocery_repository.dart';
import 'package:moms_list/features/grocery/grocery.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('groceryRepositoryProvider', () {
    test('keeps the list in memory without Firebase', () {
      final container = ProviderContainer.test();

      expect(
        container.read(groceryRepositoryProvider),
        isA<InMemoryGroceryRepository>(),
      );
    });

    test('uses Firestore once signed in', () async {
      final auth = MockAuthService();
      when(auth.watchUser).thenAnswer((_) => Stream.value(testUser));
      final container = ProviderContainer.test(
        overrides: [
          firestoreProvider.overrideWithValue(FakeFirebaseFirestore()),
          authServiceProvider.overrideWithValue(auth),
        ],
      );
      final repository = container.listen(groceryRepositoryProvider, (_, _) {});

      expect(repository.read(), isA<InMemoryGroceryRepository>());
      await container.read(authUserProvider.future);
      expect(repository.read(), isA<FirestoreGroceryRepository>());
    });
  });

  group('with a list', () {
    late InMemoryGroceryRepository repository;
    late ProviderContainer container;

    setUp(() async {
      repository = InMemoryGroceryRepository();
      container = ProviderContainer.test(
        overrides: [groceryRepositoryProvider.overrideWithValue(repository)],
      );
      await repository.addStore(id: 'costco', name: 'Costco');
      await repository.addStore(id: 'albertsons', name: 'Albertsons');
      await repository.addItem(storeId: 'costco', name: 'Eggs');
      await repository.addItem(storeId: 'albertsons', name: 'Milk');
    });

    test('storesProvider lists the stores', () async {
      container.listen(storesProvider, (_, _) {});

      final stores = await container.read(storesProvider.future);

      expect(stores.map((store) => store.name), ['Costco', 'Albertsons']);
    });

    test("storeItemsProvider lists one store's items", () async {
      final items = container.listen(storeItemsProvider('costco'), (_, _) {});
      await container.read(groceryItemsProvider.future);

      expect(items.read().value?.map((item) => item.name), ['Eggs']);
    });

    test('itemSuggestionsForProvider suggests from every store', () async {
      container
        ..listen(storesProvider, (_, _) {})
        ..listen(groceryItemsProvider, (_, _) {});
      await container.read(storesProvider.future);
      await container.read(groceryItemsProvider.future);

      final suggestions = container.read(
        itemSuggestionsForProvider(storeId: 'costco', query: 'mi'),
      );

      expect(suggestions, const [
        ItemSuggestion(
          name: 'Milk',
          source: SuggestionSource.otherStore,
          storeName: 'Albertsons',
        ),
      ]);
    });

    test('itemSuggestionsForProvider is empty while loading', () {
      expect(
        container.read(
          itemSuggestionsForProvider(storeId: 'costco', query: 'mi'),
        ),
        isEmpty,
      );
    });
  });
}

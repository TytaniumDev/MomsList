import 'package:flutter_riverpod/misc.dart';
import 'package:moms_list/features/grocery/data/in_memory_grocery_repository.dart';
import 'package:moms_list/features/grocery/grocery.dart';

/// Mom's stores for widget tests: Costco with two items to get and one
/// already checked off, and Albertsons with milk to get.
Future<InMemoryGroceryRepository> seededGroceries() async {
  final repository = InMemoryGroceryRepository();
  await repository.addStore(id: 'costco', name: 'Costco');
  await repository.addStore(id: 'albertsons', name: 'Albertsons');
  await repository.addItem(storeId: 'costco', name: 'Eggs');
  await repository.addItem(storeId: 'costco', name: 'Paper towels');
  await repository.addItem(storeId: 'costco', name: 'Coffee beans');
  await repository.setChecked(
    GroceryItem.idFor(storeId: 'costco', name: 'Coffee beans'),
    checked: true,
  );
  await repository.addItem(storeId: 'albertsons', name: 'Milk');
  return repository;
}

/// Overrides that make widgets read and write [repository].
List<Override> groceryOverrides(InMemoryGroceryRepository repository) => [
  groceryRepositoryProvider.overrideWithValue(repository),
];

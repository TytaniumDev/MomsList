import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/features/grocery/data/in_memory_grocery_repository.dart';

import 'grocery_repository_contract.dart';

void main() {
  group(InMemoryGroceryRepository, () {
    groceryRepositoryContract(InMemoryGroceryRepository.new);

    test('ignores changes to missing stores and items', () async {
      final repository = InMemoryGroceryRepository();

      await repository.renameStore(id: 'nope', name: 'Costco');
      await repository.setChecked('nope', checked: true);

      expect(await repository.watchStores().first, isEmpty);
      expect(await repository.watchItems().first, isEmpty);
    });
  });
}

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/features/grocery/data/firestore_grocery_repository.dart';

import 'grocery_repository_contract.dart';

void main() {
  group(FirestoreGroceryRepository, () {
    late FakeFirebaseFirestore firestore;

    FirestoreGroceryRepository create() {
      firestore = FakeFirebaseFirestore();
      return FirestoreGroceryRepository(firestore: firestore, userId: 'mom');
    }

    groceryRepositoryContract(create);

    test("keeps everything under the user's document", () async {
      final repository = create();

      await repository.addStore(id: 'costco', name: 'Costco');
      await repository.addItem(storeId: 'costco', name: 'Eggs');

      final user = firestore.collection('users').doc('mom');
      expect(
        (await user.collection('stores').doc('costco').get()).data(),
        containsPair('name', 'Costco'),
      );
      expect(
        (await user.collection('items').get()).docs.single.data(),
        allOf(
          containsPair('storeId', 'costco'),
          containsPair('name', 'Eggs'),
          containsPair('checked', false),
        ),
      );
    });
  });
}

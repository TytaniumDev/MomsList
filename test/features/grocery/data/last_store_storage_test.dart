import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/features/grocery/data/last_store_storage.dart';

void main() {
  group(LastStoreStorage, () {
    test('is empty until a store is saved', () async {
      expect(await LastStoreStorage().read(), isNull);
    });

    test('reads back the saved store', () async {
      await LastStoreStorage().write('costco');

      expect(await LastStoreStorage().read(), 'costco');
    });
  });
}

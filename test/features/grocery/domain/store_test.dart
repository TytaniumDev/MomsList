import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/features/grocery/domain/store.dart';

void main() {
  group(Store, () {
    test('compares by value', () {
      final t0 = DateTime(2026, 11, 26);
      final costco = Store(id: '1', name: 'Costco', createdAt: t0);

      expect(costco, Store(id: '1', name: 'Costco', createdAt: t0));
      expect(
        costco.hashCode,
        Store(id: '1', name: 'Costco', createdAt: t0).hashCode,
      );
      expect(costco, isNot(Store(id: '1', name: 'Safeway', createdAt: t0)));
    });
  });
}

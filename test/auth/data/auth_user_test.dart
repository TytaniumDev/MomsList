import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/auth/auth.dart';

void main() {
  group(AuthUser, () {
    test('compares by value', () {
      const a = AuthUser(id: '1', displayName: 'Mom', method: .apple);
      const same = AuthUser(id: '1', displayName: 'Mom', method: .apple);
      const other = AuthUser(id: '1', displayName: 'Mom', method: .google);

      expect(a, same);
      expect(a.hashCode, same.hashCode);
      expect(a, isNot(other));
    });
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/app/services/auth_service.dart';
import 'package:moms_list/features/account/account.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('authUserProvider', () {
    test("emits the auth service's user", () async {
      final auth = MockAuthService();
      when(auth.watchUser).thenAnswer((_) => Stream.value(testUser));
      final container = ProviderContainer.test(
        overrides: [authServiceProvider.overrideWithValue(auth)],
      );

      final user = container.listen(authUserProvider.future, (_, _) {});

      expect(await user.read(), testUser);
    });
  });
}

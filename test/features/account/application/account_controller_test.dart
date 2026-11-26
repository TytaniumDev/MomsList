import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/app/services/auth_service.dart';
import 'package:moms_list/features/account/application/account_controller.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(AccountController, () {
    late MockAuthService auth;
    late ProviderContainer container;

    setUp(() {
      auth = MockAuthService();
      container =
          ProviderContainer.test(
              overrides: [authServiceProvider.overrideWithValue(auth)],
            )
            // Keep the auto-disposed controller alive for the whole test.
            ..listen(accountControllerProvider, (_, _) {});
    });

    AccountController controller() =>
        container.read(accountControllerProvider.notifier);

    test('starts with nothing to report', () {
      expect(container.read(accountControllerProvider).value, isNull);
    });

    test('signs in with Google', () async {
      when(auth.signInWithGoogle)
          .thenAnswer((_) async => AuthOutcome.completed);

      expect(await controller().signInWithGoogle(), AuthOutcome.completed);
      expect(
        container.read(accountControllerProvider).value,
        AuthOutcome.completed,
      );
    });

    test('holds the error when signing in fails', () async {
      when(auth.signInWithGoogle)
          .thenAnswer((_) => Future.error(const AuthFailure('offline')));

      expect(await controller().signInWithGoogle(), isNull);
      expect(container.read(accountControllerProvider).hasError, isTrue);
    });

    test('signs out', () async {
      when(auth.signOut).thenAnswer((_) async {});

      expect(await controller().signOut(), AuthOutcome.completed);
      verify(auth.signOut).called(1);
    });
  });
}

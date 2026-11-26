import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/auth/auth.dart';

void main() {
  group(SignedOutAuthRepository, () {
    const repository = SignedOutAuthRepository();

    test('is always signed out', () async {
      expect(await repository.watchUser().first, isNull);
    });

    test('reports that sign-in is not available', () async {
      await expectLater(
        repository.signInWithApple(),
        throwsA(isA<AuthFailure>()),
      );
      await expectLater(
        repository.signInWithGoogle(),
        throwsA(isA<AuthFailure>()),
      );
    });

    test('signing out does nothing', () async {
      await expectLater(repository.signOut(), completes);
    });
  });

  group(AuthFailure, () {
    test('describes its cause', () {
      expect(const AuthFailure('offline').toString(), 'AuthFailure: offline');
    });
  });
}

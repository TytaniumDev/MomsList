import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/app/services/auth_service.dart';
import 'package:moms_list/app/services/firebase.dart';
import 'package:moms_list/app/services/firebase_auth_service.dart';

class _MockFirebaseApp extends Mock implements FirebaseApp;

void main() {
  group(AuthUser, () {
    test('compares by value', () {
      const a = AuthUser(id: '1', displayName: 'Mom');
      const same = AuthUser(id: '1', displayName: 'Mom');
      const other = AuthUser(id: '2', displayName: 'Mom');

      expect(a, same);
      expect(a.hashCode, same.hashCode);
      expect(a, isNot(other));
    });
  });

  group(AuthFailure, () {
    test('describes its cause', () {
      expect(const AuthFailure('offline').toString(), 'AuthFailure: offline');
    });
  });

  group(SignedOutAuthService, () {
    const service = SignedOutAuthService();

    test('is always signed out and cannot sign in', () async {
      expect(await service.watchUser().first, isNull);
      await expectLater(
        service.signInWithGoogle(),
        throwsA(isA<AuthFailure>()),
      );
      await expectLater(service.signOut(), completes);
    });
  });

  group('providers', () {
    test('without Firebase, sign-in is off and the app is signed out', () {
      final container = ProviderContainer.test();

      expect(container.read(signInAvailableProvider), isFalse);
      expect(container.read(authServiceProvider), isA<SignedOutAuthService>());
    });

    test('with Firebase, sign-in uses Firebase Auth', () {
      final app = _MockFirebaseApp();
      when(() => app.name).thenReturn('[DEFAULT]');
      when(() => app.options).thenReturn(
        const FirebaseOptions(
          apiKey: 'key',
          appId: 'app',
          messagingSenderId: 'sender',
          projectId: 'project',
          iosClientId: 'ios-client',
        ),
      );
      final container = ProviderContainer.test(
        overrides: [firebaseAppProvider.overrideWithValue(app)],
      );

      expect(container.read(signInAvailableProvider), isTrue);
      expect(container.read(authServiceProvider), isA<FirebaseAuthService>());
    });
  });
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/auth/auth.dart';

import '../../helpers/helpers.dart';

class _MockFirebaseApp extends Mock implements FirebaseApp;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('without Firebase config', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    test('sign-in is not available', () {
      expect(container.read(signInAvailableProvider), isFalse);
    });

    test('uses the signed-out repository', () {
      expect(
        container.read(authRepositoryProvider),
        isA<SignedOutAuthRepository>(),
      );
    });
  });

  group('with Firebase config', () {
    late ProviderContainer container;

    setUp(() {
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
      container = ProviderContainer(
        overrides: [firebaseAppProvider.overrideWithValue(app)],
      );
      addTearDown(container.dispose);
    });

    test('sign-in is available', () {
      expect(container.read(signInAvailableProvider), isTrue);
    });

    test('uses Firebase Auth', () {
      expect(
        container.read(authRepositoryProvider),
        isA<FirebaseAuthRepository>(),
      );
    });
  });

  group('authUserProvider', () {
    test("emits the repository's user", () async {
      final repository = MockAuthRepository();
      when(repository.watchUser).thenAnswer((_) => Stream.value(testUser));
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final user = container.listen(authUserProvider.future, (_, _) {});

      expect(await user.read(), testUser);
    });
  });
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/app/services/firebase.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('firebase', () {
    test('without config, Firebase stays off', () async {
      expect(await initFirebase(null), isNull);

      final container = ProviderContainer.test();
      expect(container.read(firebaseAppProvider), isNull);
      expect(container.read(firestoreProvider), isNull);
    });

    test('with config, Firebase starts', () async {
      setupFirebaseCoreMocks();
      // The mock's default app has these options.
      const options = FirebaseOptions(
        apiKey: '123',
        appId: '123',
        messagingSenderId: '123',
        projectId: '123',
      );

      final app = await initFirebase(options);

      expect(app?.options, options);

      final container = ProviderContainer.test(
        overrides: [firebaseAppProvider.overrideWithValue(app)],
      );
      final firestore = container.read(firestoreProvider);
      expect(firestore?.settings.persistenceEnabled, isTrue);
    });
  });
}

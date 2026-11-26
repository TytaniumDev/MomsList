import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/firebase_options.dart';

void main() {
  group(DefaultFirebaseOptions, () {
    test('has no config until the Firebase project exists', () {
      expect(DefaultFirebaseOptions.currentPlatform, isNull);
      expect(DefaultFirebaseOptions.googleServerClientId, isNull);
    });
  });
}

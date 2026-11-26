import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/firebase_options.dart';

void main() {
  group(DefaultFirebaseOptions, () {
    FirebaseOptions? on(TargetPlatform platform, {bool isWeb = false}) =>
        DefaultFirebaseOptions.forPlatform(isWeb: isWeb, platform: platform);

    test('picks the registered app for each platform', () {
      expect(on(.iOS), DefaultFirebaseOptions.ios);
      expect(on(.iOS, isWeb: true), DefaultFirebaseOptions.web);
      // Tests run as Android, which has no registered app.
      expect(DefaultFirebaseOptions.currentPlatform, isNull);
    });

    test('has no config elsewhere, which runs signed out', () {
      for (final platform in [
        TargetPlatform.android,
        TargetPlatform.fuchsia,
        TargetPlatform.linux,
        TargetPlatform.macOS,
        TargetPlatform.windows,
      ]) {
        expect(on(platform), isNull, reason: '$platform');
      }
    });
  });
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase config for each platform, for the `moms-list-app` project.
///
/// The same values `flutterfire configure --project=moms-list-app` writes,
/// read from the project's registered apps. None of them are secrets: the
/// security rules protect the backend.
abstract final class DefaultFirebaseOptions {
  /// The options for the platform the app runs on, or null on a platform
  /// with no registered app, which then runs signed out.
  static FirebaseOptions? get currentPlatform =>
      forPlatform(isWeb: kIsWeb, platform: defaultTargetPlatform);

  /// The options for [platform], or for web when [isWeb].
  @visibleForTesting
  static FirebaseOptions? forPlatform({
    required bool isWeb,
    required TargetPlatform platform,
  }) {
    if (isWeb) return web;
    return switch (platform) {
      .iOS => ios,
      .android || .fuchsia || .linux || .macOS || .windows => null,
    };
  }

  /// The web app.
  static const web = FirebaseOptions(
    apiKey: 'AIzaSyAUyvPfl27w17vsv_q4sterq650K8nFwX0',
    appId: '1:703730322104:web:b6d60f8aad04dfd8d8024d',
    messagingSenderId: _senderId,
    projectId: _projectId,
    authDomain: 'moms-list-app.firebaseapp.com',
    storageBucket: _storageBucket,
  );

  /// The iOS app. Its reversed client id is also a URL scheme in
  /// `ios/Runner/Info.plist`, which the Google sign-in sheet returns to.
  static const ios = FirebaseOptions(
    apiKey: 'AIzaSyAei7vQZaKG9otOn9087B9bm9oVh8NAbss',
    appId: '1:703730322104:ios:ea09613dad23121cd8024d',
    messagingSenderId: _senderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
    iosClientId:
        '703730322104-lpnbshq13mp40v7m3h3ooj6vp07umlvj'
        '.apps.googleusercontent.com',
    iosBundleId: 'com.tytaniumdev.momsList',
  );

  static const _projectId = 'moms-list-app';
  static const _senderId = '703730322104';
  static const _storageBucket = 'moms-list-app.firebasestorage.app';
}

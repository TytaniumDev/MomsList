import 'package:firebase_core/firebase_core.dart';

/// Firebase config for the app's Firebase project.
///
/// Empty until the project is created and its iOS and web apps are
/// registered. Until then the app starts without Firebase and skips
/// sign-in, so builds keep working exactly as before.
abstract final class DefaultFirebaseOptions {
  /// The options for the platform the app runs on, or null when this build
  /// has no Firebase config.
  static FirebaseOptions? get currentPlatform => null;

  /// The project's web OAuth client. Native Google sign-in asks for an ID
  /// token for this client, which is the audience Firebase Auth accepts.
  static const String? googleServerClientId = null;
}

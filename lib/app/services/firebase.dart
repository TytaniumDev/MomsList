import 'package:firebase_core/firebase_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase.g.dart';

/// The started Firebase app, or null when this build has no Firebase
/// config, as in tests. `bootstrap` overrides it with the app [initFirebase]
/// started.
@Riverpod(keepAlive: true)
FirebaseApp? firebaseApp(Ref ref) => null;

/// Starts Firebase with [options], or returns null without them, so a build
/// without Firebase config still runs, signed out.
Future<FirebaseApp?> initFirebase(FirebaseOptions? options) async =>
    options == null ? null : await Firebase.initializeApp(options: options);

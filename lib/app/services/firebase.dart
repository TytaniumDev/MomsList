import 'package:cloud_firestore/cloud_firestore.dart';
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

/// Cloud Firestore for [firebaseAppProvider], or null without Firebase.
///
/// Turns on the local cache everywhere (it is off by default on web), so
/// Mom's list opens and changes offline and syncs when she is back online.
/// Settings can only be set once, so this is kept alive.
@Riverpod(keepAlive: true)
FirebaseFirestore? firestore(Ref ref) {
  final app = ref.watch(firebaseAppProvider);
  if (app == null) return null;
  return FirebaseFirestore.instanceFor(app: app)
    ..settings = const Settings(persistenceEnabled: true);
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moms_list/auth/data/auth_repository.dart';
import 'package:moms_list/auth/data/auth_user.dart';
import 'package:moms_list/auth/data/firebase_auth_repository.dart';
import 'package:moms_list/firebase_options.dart';

/// The started Firebase app, or null when this build has no Firebase
/// config, as in tests. `bootstrap` overrides it with the app it started.
final firebaseAppProvider = Provider<FirebaseApp?>((ref) => null);

/// Whether this build can sign in. Without Firebase config the app skips
/// sign-in and works on this device only.
final signInAvailableProvider = Provider<bool>(
  (ref) => ref.watch(firebaseAppProvider) != null,
);

/// Apple and Google sign-in through Firebase, or [SignedOutAuthRepository]
/// when this build has no Firebase config.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final app = ref.watch(firebaseAppProvider);
  if (app == null) return const SignedOutAuthRepository();
  return FirebaseAuthRepository(
    auth: FirebaseAuth.instanceFor(app: app),
    google: GoogleSignIn.instance,
    googleClientId: app.options.iosClientId,
    googleServerClientId: DefaultFirebaseOptions.googleServerClientId,
    isWeb: kIsWeb,
  );
});

/// The signed-in user, or null when signed out.
final authUserProvider = StreamProvider<AuthUser?>(
  (ref) => ref.watch(authRepositoryProvider).watchUser(),
);

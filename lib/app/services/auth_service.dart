import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moms_list/app/services/firebase.dart';
import 'package:moms_list/app/services/firebase_auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

/// The signed-in user.
@immutable
class const AuthUser({
  required final String id,
  final String? displayName,
  final String? email,
}) {
  @override
  bool operator ==(Object other) =>
      other is AuthUser &&
      other.id == id &&
      other.displayName == displayName &&
      other.email == email;

  @override
  int get hashCode => Object.hash(id, displayName, email);
}

/// How a sign-in the user can back out of ended.
enum AuthOutcome() {
  completed,

  /// The user closed the Google sheet or popup.
  canceled,
}

/// A sign-in that failed for a reason other than the user canceling, such
/// as no connection.
class const AuthFailure(
  /// What went wrong underneath, for error reports.
  final Object cause,
) implements Exception {
  @override
  String toString() => 'AuthFailure: $cause';
}

/// Google sign-in and sign-out.
///
/// [FirebaseAuthService] when the build has Firebase config, otherwise
/// [SignedOutAuthService].
abstract interface class AuthService {
  /// The current user, or null when signed out.
  Stream<AuthUser?> watchUser();

  /// Throws [AuthFailure] when sign-in fails.
  Future<AuthOutcome> signInWithGoogle();

  /// Signs out on this device.
  Future<void> signOut();
}

/// Always signed out, for builds without Firebase config. Sign-in reports
/// that it is not available.
class const SignedOutAuthService() implements AuthService {
  @override
  Stream<AuthUser?> watchUser() => Stream.value(null);

  @override
  Future<AuthOutcome> signInWithGoogle() =>
      Future.error(AuthFailure(UnsupportedError('Firebase is not set up.')));

  @override
  Future<void> signOut() async {}
}

/// Whether this build can sign in. Without Firebase config the app skips
/// sign-in and works on this device only.
@Riverpod(keepAlive: true)
bool signInAvailable(Ref ref) => ref.watch(firebaseAppProvider) != null;

@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  final app = ref.watch(firebaseAppProvider);
  if (app == null) return const SignedOutAuthService();
  return FirebaseAuthService(
    auth: FirebaseAuth.instanceFor(app: app),
    google: GoogleSignIn.instance,
    googleClientId: app.options.iosClientId,
    isWeb: kIsWeb,
  );
}

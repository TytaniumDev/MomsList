import 'package:moms_list/auth/data/auth_user.dart';

/// How a sign-in the user can back out of ended.
enum AuthOutcome() {
  completed,

  /// The user closed the Apple or Google sheet.
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

/// Apple and Google sign-in and sign-out.
abstract interface class AuthRepository {
  /// The current user, or null when signed out.
  Stream<AuthUser?> watchUser();

  /// Throws [AuthFailure] when sign-in fails.
  Future<AuthOutcome> signInWithApple();

  /// Throws [AuthFailure] when sign-in fails.
  Future<AuthOutcome> signInWithGoogle();

  /// Signs out on this device.
  Future<void> signOut();
}

/// Always signed out, for builds without Firebase config.
class const SignedOutAuthRepository() implements AuthRepository {
  @override
  Stream<AuthUser?> watchUser() => Stream.value(null);

  @override
  Future<AuthOutcome> signInWithApple() => _unavailable();

  @override
  Future<AuthOutcome> signInWithGoogle() => _unavailable();

  @override
  Future<void> signOut() async {}

  Future<AuthOutcome> _unavailable() =>
      Future.error(AuthFailure(UnsupportedError('Firebase is not set up.')));
}

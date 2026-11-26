import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moms_list/auth/data/auth_repository.dart';
import 'package:moms_list/auth/data/auth_user.dart';

/// Firebase Auth error codes that mean the user closed the sign-in sheet or
/// popup rather than something failing.
const _canceledCodes = {
  'canceled',
  'cancelled-popup-request',
  'popup-closed-by-user',
  'user-cancelled',
  'web-context-canceled',
  'web-context-cancelled',
};

/// [AuthRepository] through Firebase Auth, mirrored from Sousvite.
///
/// Apple uses Firebase's provider flow, which is native on iOS, and a popup
/// on web. Google uses the native Google sheet on phones and a popup on web.
class FirebaseAuthRepository({
  required final FirebaseAuth _auth,
  required final GoogleSignIn _google,

  /// The OAuth client for the native Google sheet on iOS.
  required final String? _googleClientId,

  /// The web OAuth client that the native Google sheet asks for an ID token
  /// for, so Firebase Auth accepts the token.
  required final String? _googleServerClientId,

  /// Web signs in with popups instead of native sheets.
  required final bool _isWeb,
}) implements AuthRepository {
  // Google sign-in must be initialized exactly once before use.
  late final Future<void> _googleReady = _google.initialize(
    clientId: _googleClientId,
    serverClientId: _googleServerClientId,
  );

  @override
  Stream<AuthUser?> watchUser() => _auth.authStateChanges().map(_toAuthUser);

  @override
  Future<AuthOutcome> signInWithApple() => _guard(() async {
    final provider = AppleAuthProvider()
      ..addScope('email')
      ..addScope('name');
    await (_isWeb
        ? _auth.signInWithPopup(provider)
        : _auth.signInWithProvider(provider));
  });

  @override
  Future<AuthOutcome> signInWithGoogle() => _guard(() async {
    if (_isWeb) {
      await _auth.signInWithPopup(GoogleAuthProvider());
      return;
    }
    await _googleReady;
    final account = await _google.authenticate();
    await _auth.signInWithCredential(
      GoogleAuthProvider.credential(idToken: account.authentication.idToken),
    );
  });

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    if (!_isWeb) {
      await _googleReady;
      await _google.signOut();
    }
  }

  /// Runs [action], turning a closed sign-in sheet into
  /// [AuthOutcome.canceled] and any other failure into [AuthFailure].
  Future<AuthOutcome> _guard(Future<void> Function() action) async {
    try {
      await action();
      return .completed;
    } on GoogleSignInException catch (error) {
      if (error.code == .canceled) return .canceled;
      throw AuthFailure(error);
    } on FirebaseAuthException catch (error) {
      if (_canceledCodes.contains(error.code)) return .canceled;
      throw AuthFailure(error);
    }
  }
}

AuthUser? _toAuthUser(User? user) => user == null
    ? null
    : AuthUser(
        id: user.uid,
        displayName: user.displayName,
        email: user.email,
        method: _methodOf(user),
      );

SignInMethod? _methodOf(User user) {
  for (final info in user.providerData) {
    switch (info.providerId) {
      case 'apple.com':
        return .apple;
      case 'google.com':
        return .google;
    }
  }
  return null;
}

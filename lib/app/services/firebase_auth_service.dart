import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moms_list/app/services/auth_service.dart';

/// Firebase Auth error codes that mean the user closed the sign-in popup
/// rather than something failing.
const _canceledCodes = {
  'cancelled-popup-request',
  'popup-closed-by-user',
  'user-cancelled',
};

/// [AuthService] through Firebase Auth, mirrored from Sousvite.
///
/// Google uses the native Google sheet on phones and a popup on web.
class FirebaseAuthService({
  required final FirebaseAuth _auth,
  required final GoogleSignIn _google,

  /// The OAuth client for the native Google sheet on iOS. Web doesn't use
  /// it.
  required final String? _googleClientId,

  /// Web signs in with a popup instead of the native sheet.
  required final bool _isWeb,
}) implements AuthService {
  // Google sign-in must be initialized exactly once before use.
  late final Future<void> _googleReady = _google.initialize(
    clientId: _googleClientId,
  );

  @override
  Stream<AuthUser?> watchUser() => _auth.authStateChanges().map(_toAuthUser);

  @override
  Future<AuthOutcome> signInWithGoogle() async {
    try {
      if (_isWeb) {
        await _auth.signInWithPopup(GoogleAuthProvider());
      } else {
        await _googleReady;
        final account = await _google.authenticate();
        await _auth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: account.authentication.idToken,
          ),
        );
      }
      return .completed;
    } on GoogleSignInException catch (error) {
      if (error.code == .canceled) return .canceled;
      throw AuthFailure(error);
    } on FirebaseAuthException catch (error) {
      if (_canceledCodes.contains(error.code)) return .canceled;
      throw AuthFailure(error);
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    if (!_isWeb) {
      await _googleReady;
      await _google.signOut();
    }
  }
}

AuthUser? _toAuthUser(User? user) => user == null
    ? null
    : AuthUser(id: user.uid, displayName: user.displayName, email: user.email);

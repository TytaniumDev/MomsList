import 'package:flutter/foundation.dart';

/// How a user signed in.
enum SignInMethod() {
  apple,
  google,
}

/// The signed-in user.
@immutable
class const AuthUser({
  required final String id,
  final String? displayName,
  final String? email,

  /// Null for an account that uses neither Apple nor Google, which the app
  /// never creates.
  final SignInMethod? method,
}) {
  @override
  bool operator ==(Object other) =>
      other is AuthUser &&
      other.id == id &&
      other.displayName == displayName &&
      other.email == email &&
      other.method == method;

  @override
  int get hashCode => Object.hash(id, displayName, email, method);
}

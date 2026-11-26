// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in user, or null when signed out. App-wide, so kept alive.

@ProviderFor(authUser)
final authUserProvider = AuthUserProvider._();

/// The signed-in user, or null when signed out. App-wide, so kept alive.

final class AuthUserProvider
    extends
        $FunctionalProvider<AsyncValue<AuthUser?>, AuthUser?, Stream<AuthUser?>>
    with $FutureModifier<AuthUser?>, $StreamProvider<AuthUser?> {
  /// The signed-in user, or null when signed out. App-wide, so kept alive.
  AuthUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authUserHash();

  @$internal
  @override
  $StreamProviderElement<AuthUser?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AuthUser?> create(Ref ref) {
    return authUser(ref);
  }
}

String _$authUserHash() => r'3a960ffcb76c2185c84fc6c12909dd8b26f699f3';

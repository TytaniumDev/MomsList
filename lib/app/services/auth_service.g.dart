// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether this build can sign in. Without Firebase config the app skips
/// sign-in and works on this device only.

@ProviderFor(signInAvailable)
final signInAvailableProvider = SignInAvailableProvider._();

/// Whether this build can sign in. Without Firebase config the app skips
/// sign-in and works on this device only.

final class SignInAvailableProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether this build can sign in. Without Firebase config the app skips
  /// sign-in and works on this device only.
  SignInAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInAvailableProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInAvailableHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return signInAvailable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$signInAvailableHash() => r'a1941ef1342aa0480a2381f073035c7f81239f4c';

@ProviderFor(authService)
final authServiceProvider = AuthServiceProvider._();

final class AuthServiceProvider
    extends $FunctionalProvider<AuthService, AuthService, AuthService>
    with $Provider<AuthService> {
  AuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authServiceHash();

  @$internal
  @override
  $ProviderElement<AuthService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthService create(Ref ref) {
    return authService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthService>(value),
    );
  }
}

String _$authServiceHash() => r'5ff2521a541ada91ac2a7ddec109b4408768c2c5';

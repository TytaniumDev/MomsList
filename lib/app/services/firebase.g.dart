// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The started Firebase app, or null when this build has no Firebase
/// config, as in tests. `bootstrap` overrides it with the app [initFirebase]
/// started.

@ProviderFor(firebaseApp)
final firebaseAppProvider = FirebaseAppProvider._();

/// The started Firebase app, or null when this build has no Firebase
/// config, as in tests. `bootstrap` overrides it with the app [initFirebase]
/// started.

final class FirebaseAppProvider
    extends $FunctionalProvider<FirebaseApp?, FirebaseApp?, FirebaseApp?>
    with $Provider<FirebaseApp?> {
  /// The started Firebase app, or null when this build has no Firebase
  /// config, as in tests. `bootstrap` overrides it with the app [initFirebase]
  /// started.
  FirebaseAppProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAppProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAppHash();

  @$internal
  @override
  $ProviderElement<FirebaseApp?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseApp? create(Ref ref) {
    return firebaseApp(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseApp? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseApp?>(value),
    );
  }
}

String _$firebaseAppHash() => r'222f6f54d2be01bff3d3f18c15d0d222c788ff33';

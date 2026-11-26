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

/// Cloud Firestore for [firebaseAppProvider], or null without Firebase.
///
/// Turns on the local cache everywhere (it is off by default on web), so
/// Mom's list opens and changes offline and syncs when she is back online.
/// Settings can only be set once, so this is kept alive.

@ProviderFor(firestore)
final firestoreProvider = FirestoreProvider._();

/// Cloud Firestore for [firebaseAppProvider], or null without Firebase.
///
/// Turns on the local cache everywhere (it is off by default on web), so
/// Mom's list opens and changes offline and syncs when she is back online.
/// Settings can only be set once, so this is kept alive.

final class FirestoreProvider
    extends
        $FunctionalProvider<
          FirebaseFirestore?,
          FirebaseFirestore?,
          FirebaseFirestore?
        >
    with $Provider<FirebaseFirestore?> {
  /// Cloud Firestore for [firebaseAppProvider], or null without Firebase.
  ///
  /// Turns on the local cache everywhere (it is off by default on web), so
  /// Mom's list opens and changes offline and syncs when she is back online.
  /// Settings can only be set once, so this is kept alive.
  FirestoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firestoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firestoreHash();

  @$internal
  @override
  $ProviderElement<FirebaseFirestore?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseFirestore? create(Ref ref) {
    return firestore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseFirestore? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseFirestore?>(value),
    );
  }
}

String _$firestoreHash() => r'4db8f877d45f3d5de528182976075ddccd7c782f';

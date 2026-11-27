// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Where the last opened store is saved on this phone.

@ProviderFor(lastStoreStorage)
final lastStoreStorageProvider = LastStoreStorageProvider._();

/// Where the last opened store is saved on this phone.

final class LastStoreStorageProvider
    extends
        $FunctionalProvider<
          LastStoreStorage,
          LastStoreStorage,
          LastStoreStorage
        >
    with $Provider<LastStoreStorage> {
  /// Where the last opened store is saved on this phone.
  LastStoreStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastStoreStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastStoreStorageHash();

  @$internal
  @override
  $ProviderElement<LastStoreStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LastStoreStorage create(Ref ref) {
    return lastStoreStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LastStoreStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LastStoreStorage>(value),
    );
  }
}

String _$lastStoreStorageHash() => r'4f5636ab89c6f757c2a5693fe64a8d987865f8a3';

/// The id of the store Mom had open when she last used the app, read once
/// at launch. Null if none was saved or it couldn't be read.

@ProviderFor(lastStoreId)
final lastStoreIdProvider = LastStoreIdProvider._();

/// The id of the store Mom had open when she last used the app, read once
/// at launch. Null if none was saved or it couldn't be read.

final class LastStoreIdProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// The id of the store Mom had open when she last used the app, read once
  /// at launch. Null if none was saved or it couldn't be read.
  LastStoreIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastStoreIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastStoreIdHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return lastStoreId(ref);
  }
}

String _$lastStoreIdHash() => r'32b261909db78d932d22a0094c44d0e7fdc9e520';

/// The id of the store Mom picked since the app opened, or null before she
/// picks one. App-wide, so the list stays on that store while the app is
/// open. Each pick is also saved for next launch.

@ProviderFor(SelectedStoreId)
final selectedStoreIdProvider = SelectedStoreIdProvider._();

/// The id of the store Mom picked since the app opened, or null before she
/// picks one. App-wide, so the list stays on that store while the app is
/// open. Each pick is also saved for next launch.
final class SelectedStoreIdProvider
    extends $NotifierProvider<SelectedStoreId, String?> {
  /// The id of the store Mom picked since the app opened, or null before she
  /// picks one. App-wide, so the list stays on that store while the app is
  /// open. Each pick is also saved for next launch.
  SelectedStoreIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedStoreIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedStoreIdHash();

  @$internal
  @override
  SelectedStoreId create() => SelectedStoreId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedStoreIdHash() => r'30c966479a085b2181e7bc6faaaf1381dfff81c1';

/// The id of the store Mom picked since the app opened, or null before she
/// picks one. App-wide, so the list stays on that store while the app is
/// open. Each pick is also saved for next launch.

abstract class _$SelectedStoreId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The store whose list is showing: the one Mom picked, else the one she had
/// open last time, else the first store, or null when there are no stores.

@ProviderFor(currentStore)
final currentStoreProvider = CurrentStoreProvider._();

/// The store whose list is showing: the one Mom picked, else the one she had
/// open last time, else the first store, or null when there are no stores.

final class CurrentStoreProvider
    extends
        $FunctionalProvider<
          AsyncValue<Store?>,
          AsyncValue<Store?>,
          AsyncValue<Store?>
        >
    with $Provider<AsyncValue<Store?>> {
  /// The store whose list is showing: the one Mom picked, else the one she had
  /// open last time, else the first store, or null when there are no stores.
  CurrentStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentStoreHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<Store?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<Store?> create(Ref ref) {
    return currentStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Store?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Store?>>(value),
    );
  }
}

String _$currentStoreHash() => r'1045f797ec80a28da92812497dc81c138ce2659a';

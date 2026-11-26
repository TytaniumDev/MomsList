// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The id of the store Mom last picked, or null before she picks one.
/// App-wide, so the list stays on that store while the app is open.

@ProviderFor(SelectedStoreId)
final selectedStoreIdProvider = SelectedStoreIdProvider._();

/// The id of the store Mom last picked, or null before she picks one.
/// App-wide, so the list stays on that store while the app is open.
final class SelectedStoreIdProvider
    extends $NotifierProvider<SelectedStoreId, String?> {
  /// The id of the store Mom last picked, or null before she picks one.
  /// App-wide, so the list stays on that store while the app is open.
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

String _$selectedStoreIdHash() => r'6361a183d0d87b81ff2a4ce2a89c73a33225e24d';

/// The id of the store Mom last picked, or null before she picks one.
/// App-wide, so the list stays on that store while the app is open.

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

/// The store whose list is showing: the one Mom picked, else the first
/// store, or null when there are no stores yet.

@ProviderFor(currentStore)
final currentStoreProvider = CurrentStoreProvider._();

/// The store whose list is showing: the one Mom picked, else the first
/// store, or null when there are no stores yet.

final class CurrentStoreProvider
    extends
        $FunctionalProvider<
          AsyncValue<Store?>,
          AsyncValue<Store?>,
          AsyncValue<Store?>
        >
    with $Provider<AsyncValue<Store?>> {
  /// The store whose list is showing: the one Mom picked, else the first
  /// store, or null when there are no stores yet.
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

String _$currentStoreHash() => r'09d86a6cd9efd966b0242f1186f294429819055e';

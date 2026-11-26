// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in user's stores and items in Firestore, or an in-memory list
/// while signed out or without Firebase config. App-wide, so kept alive.

@ProviderFor(groceryRepository)
final groceryRepositoryProvider = GroceryRepositoryProvider._();

/// The signed-in user's stores and items in Firestore, or an in-memory list
/// while signed out or without Firebase config. App-wide, so kept alive.

final class GroceryRepositoryProvider
    extends
        $FunctionalProvider<
          GroceryRepository,
          GroceryRepository,
          GroceryRepository
        >
    with $Provider<GroceryRepository> {
  /// The signed-in user's stores and items in Firestore, or an in-memory list
  /// while signed out or without Firebase config. App-wide, so kept alive.
  GroceryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groceryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groceryRepositoryHash();

  @$internal
  @override
  $ProviderElement<GroceryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GroceryRepository create(Ref ref) {
    return groceryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroceryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroceryRepository>(value),
    );
  }
}

String _$groceryRepositoryHash() => r'014f24a38b7b83d4979d6ed877adf4b2a7d41757';

/// Every store, in the order they were added.

@ProviderFor(stores)
final storesProvider = StoresProvider._();

/// Every store, in the order they were added.

final class StoresProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Store>>,
          List<Store>,
          Stream<List<Store>>
        >
    with $FutureModifier<List<Store>>, $StreamProvider<List<Store>> {
  /// Every store, in the order they were added.
  StoresProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storesHash();

  @$internal
  @override
  $StreamProviderElement<List<Store>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Store>> create(Ref ref) {
    return stores(ref);
  }
}

String _$storesHash() => r'96910b6d171effcaca7e57e8eb58a5736d469204';

/// Every item at every store.

@ProviderFor(groceryItems)
final groceryItemsProvider = GroceryItemsProvider._();

/// Every item at every store.

final class GroceryItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GroceryItem>>,
          List<GroceryItem>,
          Stream<List<GroceryItem>>
        >
    with
        $FutureModifier<List<GroceryItem>>,
        $StreamProvider<List<GroceryItem>> {
  /// Every item at every store.
  GroceryItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groceryItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groceryItemsHash();

  @$internal
  @override
  $StreamProviderElement<List<GroceryItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<GroceryItem>> create(Ref ref) {
    return groceryItems(ref);
  }
}

String _$groceryItemsHash() => r'14e69ba22cde50548361650b98b6f03f5720361b';

/// The items at [storeId], in [shoppingOrder].

@ProviderFor(storeItems)
final storeItemsProvider = StoreItemsFamily._();

/// The items at [storeId], in [shoppingOrder].

final class StoreItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GroceryItem>>,
          AsyncValue<List<GroceryItem>>,
          AsyncValue<List<GroceryItem>>
        >
    with $Provider<AsyncValue<List<GroceryItem>>> {
  /// The items at [storeId], in [shoppingOrder].
  StoreItemsProvider._({
    required StoreItemsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'storeItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$storeItemsHash();

  @override
  String toString() {
    return r'storeItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<List<GroceryItem>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<GroceryItem>> create(Ref ref) {
    final argument = this.argument as String;
    return storeItems(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<GroceryItem>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<GroceryItem>>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StoreItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$storeItemsHash() => r'0180ab2dd2db978558b33b241611920fec7a74cf';

/// The items at [storeId], in [shoppingOrder].

final class StoreItemsFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<List<GroceryItem>>, String> {
  StoreItemsFamily._()
    : super(
        retry: null,
        name: r'storeItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The items at [storeId], in [shoppingOrder].

  StoreItemsProvider call(String storeId) =>
      StoreItemsProvider._(argument: storeId, from: this);

  @override
  String toString() => r'storeItemsProvider';
}

/// Up to [limit] previously entered names matching [query] at [storeId].
/// See [itemSuggestions].

@ProviderFor(itemSuggestionsFor)
final itemSuggestionsForProvider = ItemSuggestionsForFamily._();

/// Up to [limit] previously entered names matching [query] at [storeId].
/// See [itemSuggestions].

final class ItemSuggestionsForProvider
    extends
        $FunctionalProvider<
          List<ItemSuggestion>,
          List<ItemSuggestion>,
          List<ItemSuggestion>
        >
    with $Provider<List<ItemSuggestion>> {
  /// Up to [limit] previously entered names matching [query] at [storeId].
  /// See [itemSuggestions].
  ItemSuggestionsForProvider._({
    required ItemSuggestionsForFamily super.from,
    required ({String storeId, String query, int limit}) super.argument,
  }) : super(
         retry: null,
         name: r'itemSuggestionsForProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$itemSuggestionsForHash();

  @override
  String toString() {
    return r'itemSuggestionsForProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<List<ItemSuggestion>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<ItemSuggestion> create(Ref ref) {
    final argument =
        this.argument as ({String storeId, String query, int limit});
    return itemSuggestionsFor(
      ref,
      storeId: argument.storeId,
      query: argument.query,
      limit: argument.limit,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ItemSuggestion> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ItemSuggestion>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ItemSuggestionsForProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$itemSuggestionsForHash() =>
    r'9079b0f582ac0d3d7b10a216ab2c4e5ce48cfc7e';

/// Up to [limit] previously entered names matching [query] at [storeId].
/// See [itemSuggestions].

final class ItemSuggestionsForFamily extends $Family
    with
        $FunctionalFamilyOverride<
          List<ItemSuggestion>,
          ({String storeId, String query, int limit})
        > {
  ItemSuggestionsForFamily._()
    : super(
        retry: null,
        name: r'itemSuggestionsForProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Up to [limit] previously entered names matching [query] at [storeId].
  /// See [itemSuggestions].

  ItemSuggestionsForProvider call({
    required String storeId,
    required String query,
    int limit = 3,
  }) => ItemSuggestionsForProvider._(
    argument: (storeId: storeId, query: query, limit: limit),
    from: this,
  );

  @override
  String toString() => r'itemSuggestionsForProvider';
}

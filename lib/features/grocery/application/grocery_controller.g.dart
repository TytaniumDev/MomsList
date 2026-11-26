// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Changes Mom's stores and items.
///
/// Each change shows on screen at once, through the providers' streams.
/// Saving to the server happens in the background, even offline, so callers
/// don't wait; a save that fails is sent to Sentry.

@ProviderFor(GroceryController)
final groceryControllerProvider = GroceryControllerProvider._();

/// Changes Mom's stores and items.
///
/// Each change shows on screen at once, through the providers' streams.
/// Saving to the server happens in the background, even offline, so callers
/// don't wait; a save that fails is sent to Sentry.
final class GroceryControllerProvider
    extends $NotifierProvider<GroceryController, void> {
  /// Changes Mom's stores and items.
  ///
  /// Each change shows on screen at once, through the providers' streams.
  /// Saving to the server happens in the background, even offline, so callers
  /// don't wait; a save that fails is sent to Sentry.
  GroceryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groceryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groceryControllerHash();

  @$internal
  @override
  GroceryController create() => GroceryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$groceryControllerHash() => r'064867e98ea99fe52a6167de6a367fa6015773e2';

/// Changes Mom's stores and items.
///
/// Each change shows on screen at once, through the providers' streams.
/// Saving to the server happens in the background, even offline, so callers
/// don't wait; a save that fails is sent to Sentry.

abstract class _$GroceryController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runs one account action at a time. The state is loading while an action
/// runs, then the outcome of the last one, or its error, which is also
/// sent to Sentry.

@ProviderFor(AccountController)
final accountControllerProvider = AccountControllerProvider._();

/// Runs one account action at a time. The state is loading while an action
/// runs, then the outcome of the last one, or its error, which is also
/// sent to Sentry.
final class AccountControllerProvider
    extends $AsyncNotifierProvider<AccountController, AuthOutcome?> {
  /// Runs one account action at a time. The state is loading while an action
  /// runs, then the outcome of the last one, or its error, which is also
  /// sent to Sentry.
  AccountControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountControllerHash();

  @$internal
  @override
  AccountController create() => AccountController();
}

String _$accountControllerHash() => r'24b6943dff46ff1b58329cd79cc8667db5aeed91';

/// Runs one account action at a time. The state is loading while an action
/// runs, then the outcome of the last one, or its error, which is also
/// sent to Sentry.

abstract class _$AccountController extends $AsyncNotifier<AuthOutcome?> {
  FutureOr<AuthOutcome?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthOutcome?>, AuthOutcome?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthOutcome?>, AuthOutcome?>,
              AsyncValue<AuthOutcome?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

import 'dart:async';

import 'package:moms_list/app/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'account_controller.g.dart';

/// Runs one account action at a time. The state is loading while an action
/// runs, then the outcome of the last one, or its error, which is also
/// sent to Sentry.
@riverpod
class AccountController extends _$AccountController {
  @override
  FutureOr<AuthOutcome?> build() => null;

  Future<AuthOutcome?> signInWithGoogle() =>
      _run((auth) => auth.signInWithGoogle());

  Future<AuthOutcome?> signOut() => _run((auth) async {
    await auth.signOut();
    return .completed;
  });

  Future<AuthOutcome?> _run(
    Future<AuthOutcome> Function(AuthService auth) action,
  ) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => action(ref.read(authServiceProvider)),
    );
    if (result case AsyncError(:final error, :final stackTrace)) {
      unawaited(Sentry.captureException(error, stackTrace: stackTrace));
    }
    if (ref.mounted) state = result;
    return result.value;
  }
}

import 'package:moms_list/app/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_user.g.dart';

/// The signed-in user, or null when signed out. App-wide, so kept alive.
@Riverpod(keepAlive: true)
Stream<AuthUser?> authUser(Ref ref) =>
    ref.watch(authServiceProvider).watchUser();

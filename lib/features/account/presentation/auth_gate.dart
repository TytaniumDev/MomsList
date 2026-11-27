import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/services/auth_service.dart';
import 'package:moms_list/design_system/design_system.dart';
import 'package:moms_list/features/account/application/auth_user.dart';
import 'package:moms_list/features/account/presentation/sign_in_page.dart';
import 'package:moms_list/features/feedback/feedback.dart';
import 'package:moms_list/features/home/home.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Shows [SignInPage] until Mom signs in, then fades to [HomePage].
///
/// Builds without Firebase config go straight to [HomePage].
class AuthGate extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(signInAvailableProvider)) return const HomePage();

    return FadeSwitcher(
      child: switch (ref.watch(authUserProvider)) {
        AsyncData(value: null) || AsyncError() => const SignInPage(),
        AsyncData() => const HomePage(),
        AsyncLoading() => const _LoadingPage(),
      },
    );
  }
}

/// Shown for the moment it takes to read whether Mom is signed in.
class _LoadingPage extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [FeedbackButton()],
      ),
      body: Center(
        child: CircularProgressIndicator(semanticsLabel: l10n.loadingLabel),
      ),
    );
  }
}

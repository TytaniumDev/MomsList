import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/auth/state/auth_providers.dart';
import 'package:moms_list/auth/view/sign_in_page.dart';
import 'package:moms_list/feedback/feedback.dart';
import 'package:moms_list/home/home.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Shows [SignInPage] until Mom signs in, then [HomePage].
///
/// Builds without Firebase config go straight to [HomePage].
class AuthGate extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(signInAvailableProvider)) return const HomePage();

    return switch (ref.watch(authUserProvider)) {
      AsyncData(value: null) || AsyncError() => const SignInPage(),
      AsyncData() => const HomePage(),
      AsyncLoading() => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.appTitle),
          actions: const [FeedbackButton()],
        ),
        body: Center(
          child: CircularProgressIndicator(
            semanticsLabel: context.l10n.loadingLabel,
          ),
        ),
      ),
    };
  }
}

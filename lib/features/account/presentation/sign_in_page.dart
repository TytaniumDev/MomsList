import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/account/application/account_controller.dart';
import 'package:moms_list/features/feedback/feedback.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Asks Mom to sign in with Google, so her list is the same on every
/// device.
class SignInPage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [FeedbackButton()],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(l10n.signInTitle, style: textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text(l10n.signInMessage, style: textTheme.bodyLarge),
            const SizedBox(height: 32),
            const _GoogleSignInButton(),
            const _SignInError(),
          ],
        ),
      ),
    );
  }
}

/// Full width, with a label that wraps instead of truncating at large text
/// sizes. Shows a spinner while signing in.
class _GoogleSignInButton extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(
      accountControllerProvider.select((state) => state.isLoading),
    );
    final controller = ref.read(accountControllerProvider.notifier);

    return FilledButton.icon(
      onPressed: busy ? null : controller.signInWithGoogle,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: Theme.of(context).textTheme.titleMedium,
      ),
      icon: busy
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.login),
      label: Text(
        context.l10n.signInWithGoogleButton,
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Says that signing in failed, until the next try.
class _SignInError extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final failed = ref.watch(
      accountControllerProvider.select((state) => state.hasError),
    );
    if (!failed) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Semantics(
        liveRegion: true,
        child: Text(
          context.l10n.signInErrorMessage,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      ),
    );
  }
}

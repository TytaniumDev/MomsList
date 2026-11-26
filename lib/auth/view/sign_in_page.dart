import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/auth/data/auth_repository.dart';
import 'package:moms_list/auth/data/auth_user.dart';
import 'package:moms_list/auth/state/auth_providers.dart';
import 'package:moms_list/auth/view/sign_in_button.dart';
import 'package:moms_list/feedback/feedback.dart';
import 'package:moms_list/l10n/l10n.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Asks Mom to sign in with Apple or Google, so her list is the same on
/// every device.
class SignInPage extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  /// The sign-in that is running, if any.
  SignInMethod? _pending;
  bool _failed = false;

  Future<void> _signIn(SignInMethod method) async {
    setState(() {
      _pending = method;
      _failed = false;
    });
    final repository = ref.read(authRepositoryProvider);
    try {
      await switch (method) {
        .apple => repository.signInWithApple(),
        .google => repository.signInWithGoogle(),
      };
    } on AuthFailure catch (failure) {
      await Sentry.captureException(failure.cause);
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _pending = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final busy = _pending != null;
    // Apple asks for a black button on light backgrounds and a white one on
    // dark backgrounds.
    final isDark = theme.brightness == Brightness.dark;

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
            SignInButton(
              icon: const Icon(Icons.apple),
              label: l10n.signInWithAppleButton,
              backgroundColor: isDark ? Colors.white : Colors.black,
              foregroundColor: isDark ? Colors.black : Colors.white,
              busy: _pending == .apple,
              onPressed: busy ? null : () => _signIn(.apple),
            ),
            const SizedBox(height: 16),
            SignInButton(
              icon: const Icon(Icons.account_circle_outlined),
              label: l10n.signInWithGoogleButton,
              backgroundColor: colors.surfaceContainerHighest,
              foregroundColor: colors.onSurface,
              busy: _pending == .google,
              onPressed: busy ? null : () => _signIn(.google),
            ),
            const SizedBox(height: 24),
            Text(l10n.signInSameAccountHint, style: textTheme.bodyLarge),
            if (_failed) ...[
              const SizedBox(height: 24),
              Semantics(
                liveRegion: true,
                child: Text(
                  l10n.signInErrorMessage,
                  style: textTheme.bodyLarge?.copyWith(color: colors.error),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

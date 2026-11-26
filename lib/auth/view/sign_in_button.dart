import 'package:material_ui/material_ui.dart';

/// A full-width sign-in button whose label wraps instead of truncating at
/// large text sizes.
///
/// While [busy] it shows a spinner in place of [icon]. It is disabled when
/// [onPressed] is null.
class SignInButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.busy = false,
    super.key,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: Theme.of(context).textTheme.titleMedium,
      ),
      icon: busy
          ? SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foregroundColor,
              ),
            )
          : icon,
      label: Text(label, textAlign: TextAlign.center),
    );
  }
}

import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/tokens/app_spacing.dart';

/// The page title in the navy header, in the `store-title` style, at the
/// full system text size. Part of `PageScaffold`.
///
/// [AppBar] caps its title's text size at about 1.3x, so at large Dynamic
/// Type sizes a normal title is smaller than the rest of the page. This
/// title uses the system text size again and wraps instead of being cut
/// off. Give the [AppBar] a matching [toolbarHeight] so it fits.
///
/// With [onTap], it shows a ▼ and is a button, such as the store name that
/// opens the store menu.
class HeaderTitle extends StatelessWidget {
  const new(this.text, {this.onTap, this.tapHint, super.key});

  final String text;

  /// Called when the title is tapped. Adds a ▼ after the text.
  final VoidCallback? onTap;

  /// What tapping does, for VoiceOver, such as "Switch store".
  final String? tapHint;

  static const double _iconSize = 24;

  /// Side spacing [AppBar] keeps around its title.
  static const double _sideSpacing = 16;

  /// The text size Mom picked in her phone's settings, which [AppBar]
  /// overrides inside its title.
  static TextScaler _systemTextScaler(BuildContext context) =>
      MediaQueryData.fromView(View.of(context)).textScaler;

  static TextStyle? _style(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.titleLarge?.copyWith(
      color: theme.appBarTheme.foregroundColor,
    );
  }

  /// An app bar height that fits [text] at the system text size, beside
  /// [actionCount] action buttons, with a ▼ if [hasTrailingIcon].
  static double toolbarHeight(
    BuildContext context,
    String text, {
    int actionCount = 0,
    bool hasTrailingIcon = false,
  }) {
    final textScaler = _systemTextScaler(context);
    final iconWidth = hasTrailingIcon ? textScaler.scale(_iconSize) : 0;
    final reservedWidth =
        _sideSpacing * 2 + AppSpacing.tapTarget * actionCount + iconWidth;
    final painter =
        TextPainter(
          text: TextSpan(text: text, style: _style(context)),
          textScaler: textScaler,
          textDirection: Directionality.of(context),
        )..layout(
          maxWidth: (MediaQuery.sizeOf(context).width - reservedWidth).clamp(
            1,
            double.infinity,
          ),
        );
    final height = painter.height + AppSpacing.md;
    painter.dispose();
    return height < kToolbarHeight ? kToolbarHeight : height;
  }

  @override
  Widget build(BuildContext context) {
    final textScaler = _systemTextScaler(context);
    final title = MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(text, style: _style(context))),
          if (onTap != null)
            Icon(Icons.arrow_drop_down, size: textScaler.scale(_iconSize)),
        ],
      ),
    );
    if (onTap == null) return title;

    return Semantics(
      button: true,
      hint: tapHint,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSpacing.tapTarget),
          child: title,
        ),
      ),
    );
  }
}

import 'package:material_ui/material_ui.dart';

/// An app bar title shown at Mom's full text size.
///
/// [AppBar] caps its title's text size at about 1.3x, but Mom reads at
/// about 3x, so a normal title is far smaller than the rest of the page.
/// This title uses the system text size again, in the `store-title` style,
/// and wraps instead of being cut off. Give the [AppBar] a matching
/// [toolbarHeight] so it fits.
class FullSizeAppBarTitle extends StatelessWidget {
  const new(this.text, {this.trailingIcon, super.key});

  final String text;

  /// An icon after the text, such as ▼ for a menu. Scales with the text.
  final IconData? trailingIcon;

  static const double _iconSize = 24;

  /// Width the app bar needs besides the title: its side spacing and two
  /// action buttons.
  static const double _reservedWidth = 16.0 * 2 + 48 * 2;

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

  /// An app bar height that fits [text] (and a trailing icon, if
  /// [hasTrailingIcon]) at the system text size.
  static double toolbarHeight(
    BuildContext context,
    String text, {
    bool hasTrailingIcon = false,
  }) {
    final textScaler = _systemTextScaler(context);
    final iconWidth = hasTrailingIcon ? textScaler.scale(_iconSize) : 0;
    final maxWidth =
        MediaQuery.sizeOf(context).width - _reservedWidth - iconWidth;
    final painter = TextPainter(
      text: TextSpan(text: text, style: _style(context)),
      textScaler: textScaler,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: maxWidth.clamp(1, double.infinity));
    final height = painter.height + 8;
    painter.dispose();
    return height < kToolbarHeight ? kToolbarHeight : height;
  }

  @override
  Widget build(BuildContext context) {
    final textScaler = _systemTextScaler(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(text, style: _style(context))),
          if (trailingIcon != null)
            Icon(trailingIcon, size: textScaler.scale(_iconSize)),
        ],
      ),
    );
  }
}

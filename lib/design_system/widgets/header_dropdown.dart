import 'package:material_ui/material_ui.dart';

/// Drops [builder]'s content down from the navy header, full width and
/// [top] points from the top of the screen (the header's bottom edge).
///
/// The page behind is dimmed. Tapping it, or going back, closes the
/// dropdown; content closes it with `Navigator.pop`. It appears at once,
/// with no animation, and scrolls when it's taller than the screen.
Future<T?> showHeaderDropdown<T>(
  BuildContext context, {
  required double top,
  required WidgetBuilder builder,
}) => Navigator.of(context).push(
  HeaderDropdownRoute<T>(
    top: top,
    builder: builder,
    barrierColor: Theme.of(context).colorScheme.scrim
        .withValues(alpha: _barrierOpacity),
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  ),
);

const double _barrierOpacity = 0.5;

/// The route behind [showHeaderDropdown].
class HeaderDropdownRoute<T> extends PopupRoute<T> {
  new({
    required this.top,
    required this.builder,
    required this.barrierColor,
    required this.barrierLabel,
  });

  /// Where the dropdown starts, from the top of the screen.
  final double top;
  final WidgetBuilder builder;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        // Stay above the keyboard while typing in the dropdown.
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              child: SingleChildScrollView(child: Builder(builder: builder)),
            ),
          ),
        ],
      ),
    );
  }
}

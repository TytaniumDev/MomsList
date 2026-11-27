import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/tokens/app_motion.dart';

/// Drops [builder]'s content down from the navy header, full width and
/// [top] points from the top of the screen (the header's bottom edge).
///
/// The page behind is dimmed. Tapping it, or going back, closes the
/// dropdown; content closes it with `Navigator.pop`. It slides down from
/// under the header as it fades in, and back up as it closes (it only
/// fades with Reduce Motion on). It scrolls when it's taller than the
/// screen.
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
    slides: AppMotion.allowsMovementOf(context),
    transitionDuration: AppMotion.durationOf(context, AppMotion.standard),
    reverseTransitionDuration: AppMotion.durationOf(context, AppMotion.quick),
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
    this.slides = true,
    this.transitionDuration = AppMotion.standard,
    this.reverseTransitionDuration = AppMotion.quick,
  });

  /// Where the dropdown starts, from the top of the screen.
  final double top;
  final WidgetBuilder builder;

  /// Whether the dropdown slides down as it opens, or only fades in.
  final bool slides;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Curve get barrierCurve => AppMotion.enter;

  CurvedAnimation? _curved;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final curved = _curved ??= CurvedAnimation(
      parent: animation,
      curve: AppMotion.enter,
      reverseCurve: AppMotion.exit,
    );
    Widget panel = FadeTransition(
      opacity: curved,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        child: SingleChildScrollView(child: Builder(builder: builder)),
      ),
    );
    if (slides) {
      // Out from under the header: clipped at its edge, so it never
      // covers it.
      panel = ClipRect(
        child: SlideTransition(
          position: curved.drive(_fromAbove),
          child: panel,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        top: top,
        // Stay above the keyboard while typing in the dropdown.
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Flexible(child: panel)],
      ),
    );
  }

  static final _fromAbove = Tween<Offset>(
    begin: const Offset(0, -1),
    end: Offset.zero,
  );

  @override
  void dispose() {
    _curved?.dispose();
    super.dispose();
  }
}

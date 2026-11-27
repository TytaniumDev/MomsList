import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/tokens/app_motion.dart';

/// Cross-fades to a new [child] instead of jumping, such as a page's body
/// going from loading to its list, or one store's list replacing another.
///
/// A change counts when [child]'s type or key changes, so give each state
/// its own key (for example `ValueKey(store.id)`). Updates to the same
/// child just rebuild it. Children are laid out top first, with the
/// constraints the switcher gets, exactly as they would be without it.
///
/// Fading is gentle enough for iOS's Reduce Motion, so it always runs,
/// unless the phone asks for no animations at all.
class FadeSwitcher extends StatelessWidget {
  const new({
    required this.child,
    this.duration = AppMotion.standard,
    super.key,
  });

  final Widget child;

  /// How long the fade takes. One of the [AppMotion] durations.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppMotion.durationOf(context, duration),
      switchInCurve: AppMotion.enter,
      switchOutCurve: AppMotion.exit,
      layoutBuilder: _layout,
      child: child,
    );
  }

  static Widget _layout(Widget? currentChild, List<Widget> previousChildren) {
    // Top first (Stack's default), unlike AnimatedSwitcher's centering.
    return Stack(
      fit: StackFit.passthrough,
      children: [
        for (final previous in previousChildren) _wrap(previous, leaving: true),
        if (currentChild != null) _wrap(currentChild),
      ],
    );
  }

  /// A child that's fading out is only something to see: it can't be
  /// tapped or read by VoiceOver. Every child gets the same wrapper, keyed
  /// like the child, so it keeps its state (such as its scroll position)
  /// as it starts leaving.
  static Widget _wrap(Widget child, {bool leaving = false}) => IgnorePointer(
    key: child.key,
    ignoring: leaving,
    child: ExcludeSemantics(excluding: leaving, child: child),
  );
}

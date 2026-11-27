import 'package:material_ui/material_ui.dart';

/// Motion from Mom's List design system: every big change on screen, such
/// as a dropdown opening or one list replacing another, eases in briefly
/// instead of jumping. Only opacity, transforms and clips are animated, so
/// nothing is laid out again on each frame.
///
/// Read durations through [durationOf] and ask [allowsMovementOf] before
/// sliding anything, so Mom's motion settings are always respected.
abstract final class AppMotion {
  /// Small swaps inside a page, such as the header's store name or the list
  /// turning into suggestions while typing.
  static const Duration quick = Duration(milliseconds: 150);

  /// Something arriving, such as a dropdown opening or a new store's list.
  static const Duration standard = Duration(milliseconds: 250);

  /// Curve for something arriving: fast, then settling gently.
  static const Curve enter = Curves.easeOutCubic;

  /// Curve for something leaving: gentle, then out of the way.
  static const Curve exit = Curves.easeInCubic;

  /// [duration], or no time at all when the phone asks for no animations
  /// (Android's "Remove animations").
  static Duration durationOf(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;

  /// Whether things may slide or grow. False when the phone asks for less
  /// motion (iOS's "Reduce Motion") or none: changes then only fade.
  ///
  /// Flutter 3.47's [MediaQuery] doesn't carry Reduce Motion yet, so it's
  /// read from the platform each time this is called. Call it as something
  /// starts moving, such as when a dropdown opens.
  static bool allowsMovementOf(BuildContext context) =>
      !MediaQuery.disableAnimationsOf(context) &&
      !View.of(context).platformDispatcher.accessibilityFeatures.reduceMotion;
}

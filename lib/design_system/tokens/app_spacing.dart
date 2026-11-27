/// Spacing from Mom's List design system. Dense on purpose: useful text
/// over whitespace.
abstract final class AppSpacing {
  /// Header bar padding, gap between a label and its icon.
  static const double xs = 4;

  /// Padding and gap in the entry row.
  static const double sm = 6;

  /// Vertical padding of the Got it band.
  static const double md = 8;

  /// Vertical padding of a list row (24px line + 24px = 48px), and the
  /// margin line's distance from the edge.
  static const double row = 12;

  /// Where list text starts: past the margin line (12 + 2 + 12).
  static const double textInset = 26;

  /// Minimum height and width of anything tappable.
  static const double tapTarget = 48;
}

/// Corner radii. Paper is square; only controls get a small rounding.
abstract final class AppRadii {
  /// Text fields, buttons and dialogs.
  static const double sm = 4;
}

/// Line widths.
abstract final class AppStrokes {
  /// The blue rule under each row, the red margin line and the
  /// strike-through on checked items.
  static const double rule = 2;

  /// Text field border.
  static const double field = 2;

  /// The ink rule under the entry row and above the Got it band.
  static const double heavy = 3;
}

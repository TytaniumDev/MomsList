import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/theme/app_colors.dart';

/// Lato, the font Mom read every day in her old list app. Bundled in
/// `assets/fonts/lato/`, so it works offline.
const appFontFamily = 'Lato';

/// The design system's type styles, mapped onto Material's [TextTheme].
///
/// Sizes are at iOS's default text size (scale 1.0) and grow with Dynamic
/// Type. Weights: 400 for anything read in a list, 700 for buttons, 900 for
/// headings.
TextTheme appTextTheme() => const TextTheme(
  // store-title: the store name in the header, and page titles.
  titleLarge: _LatoStyle(size: 20, lineHeight: 24, weight: FontWeight.w900),
  // dialog-title.
  headlineSmall: _LatoStyle(size: 20, lineHeight: 26, weight: FontWeight.w700),
  // item and field: every list line and typed text. Never bold.
  bodyLarge: _LatoStyle(size: 18, lineHeight: 24),
  // button.
  labelLarge: _LatoStyle(size: 18, lineHeight: 24, weight: FontWeight.w700),
  // section-label: the Got it heading.
  titleSmall: _LatoStyle(size: 17, lineHeight: 22, weight: FontWeight.w900),
  // caption: a second line in ink-muted, such as "3 to get".
  bodyMedium: _LatoStyle(size: 15, lineHeight: 20),
);

class _LatoStyle extends TextStyle {
  const new({
    required double size,
    required double lineHeight,
    FontWeight weight = FontWeight.w400,
  }) : super(
         fontFamily: appFontFamily,
         fontSize: size,
         height: lineHeight / size,
         fontWeight: weight,
         color: AppColors.ink,
         leadingDistribution: TextLeadingDistribution.even,
       );
}

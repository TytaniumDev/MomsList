import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/app.dart';
import 'package:moms_list/design_system/design_system.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Logical screen size of an iPhone Pro (iPhone 17 Pro / 18 Pro class).
const Size iPhoneProSize = Size(402, 874);

extension PumpApp on WidgetTester {
  /// Pumps [widget] inside a [MaterialApp] with the app's themes and
  /// localizations, on an iPhone Pro sized screen at [textScale]. Pass
  /// `brightness: Brightness.dark` to see the dark theme.
  ///
  /// [overrides] replace providers, for example with a fake
  /// `authServiceProvider`. Pass `settle: false` for a page that never
  /// settles, such as one with a spinner.
  Future<void> pumpApp(
    Widget widget, {
    double textScale = 1,
    Brightness brightness = Brightness.light,
    List<Override> overrides = const [],
    bool settle = true,
  }) async {
    platformDispatcher.platformBrightnessTestValue = brightness;
    addTearDown(platformDispatcher.clearPlatformBrightnessTestValue);
    await _pumpOnIPhonePro(
      MaterialApp(
        theme: AppTheme.legalPad(),
        darkTheme: AppTheme.blackPad(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
      textScale: textScale,
      overrides: overrides,
      settle: settle,
    );
  }

  /// Pumps a widget that builds its own [MaterialApp], such as [App], on an
  /// iPhone Pro sized screen at [textScale].
  Future<void> pumpRootApp(
    Widget app, {
    double textScale = 1,
    List<Override> overrides = const [],
  }) => _pumpOnIPhonePro(app, textScale: textScale, overrides: overrides);

  Future<void> _pumpOnIPhonePro(
    Widget app, {
    required double textScale,
    required List<Override> overrides,
    bool settle = true,
  }) async {
    view
      ..physicalSize = iPhoneProSize * 3
      ..devicePixelRatio = 3;
    platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(view.reset);
    addTearDown(platformDispatcher.clearTextScaleFactorTestValue);

    await pumpWidget(ProviderScope(overrides: overrides, child: app));
    if (settle) await pumpAndSettle();
  }
}

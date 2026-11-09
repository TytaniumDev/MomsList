import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/app.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Logical screen size of an iPhone Pro (iPhone 17 Pro / 18 Pro class).
const Size iPhoneProSize = Size(402, 874);

extension PumpApp on WidgetTester {
  /// Pumps [widget] inside a [MaterialApp] with the app's theme and
  /// localizations, on an iPhone Pro sized screen at [textScale].
  Future<void> pumpApp(Widget widget, {double textScale = 1}) async {
    await _pumpOnIPhonePro(
      MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
      textScale: textScale,
    );
  }

  /// Pumps a widget that builds its own [MaterialApp], such as [App], on an
  /// iPhone Pro sized screen at [textScale].
  Future<void> pumpRootApp(Widget app, {double textScale = 1}) =>
      _pumpOnIPhonePro(app, textScale: textScale);

  Future<void> _pumpOnIPhonePro(Widget app, {required double textScale}) async {
    view
      ..physicalSize = iPhoneProSize * 3
      ..devicePixelRatio = 3;
    platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(view.reset);
    addTearDown(platformDispatcher.clearTextScaleFactorTestValue);

    await pumpWidget(app);
    await pumpAndSettle();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Logical screen size of an iPhone Pro (iPhone 17 Pro / 18 Pro class).
const Size iPhoneProSize = Size(402, 874);

extension PumpApp on WidgetTester {
  /// Pumps [widget] on an iPhone Pro sized screen at the given [textScale].
  ///
  /// [widget] should build its own `MaterialApp` (for example `MomsListApp`)
  /// so the real theme is under test.
  Future<void> pumpAtTextScale(Widget widget, {double textScale = 1}) async {
    view
      ..physicalSize = iPhoneProSize * 3
      ..devicePixelRatio = 3;
    platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(view.reset);
    addTearDown(platformDispatcher.clearTextScaleFactorTestValue);

    await pumpWidget(widget);
    await pumpAndSettle();
  }

  /// Asserts the Flutter accessibility guidelines that matter most for
  /// Mom's List: tap target size, labelled targets and text contrast.
  Future<void> expectAccessibilityGuidelines() async {
    final handle = ensureSemantics();
    await expectLater(this, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(this, meetsGuideline(androidTapTargetGuideline));
    await expectLater(this, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(this, meetsGuideline(textContrastGuideline));
    handle.dispose();
  }
}

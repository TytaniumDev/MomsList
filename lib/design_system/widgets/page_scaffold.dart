import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/widgets/header_dropdown.dart';
import 'package:moms_list/design_system/widgets/header_title.dart';

/// A page with the navy header bar (the design system's StoreHeader) on
/// top of [body].
///
/// The header shows [title] at the full text size and grows to fit it when
/// it wraps. With [titleDropdown] the title gets a ▼ and becomes a button
/// that drops that content down from the header, like the store name that
/// opens the store menu. End [actions] with the app's Send feedback button.
class PageScaffold extends StatelessWidget {
  const new({
    required this.title,
    required this.body,
    this.actions = const [],
    this.titleDropdown,
    this.titleTapHint,
    super.key,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;

  /// What drops down from the header when the title is tapped. Close it
  /// with `Navigator.pop` on the context it's built with.
  final WidgetBuilder? titleDropdown;

  /// What tapping the title does, for VoiceOver.
  final String? titleTapHint;

  @override
  Widget build(BuildContext context) {
    final dropdown = titleDropdown;
    final toolbarHeight = HeaderTitle.toolbarHeight(
      context,
      title,
      actionCount: actions.length,
      hasTrailingIcon: dropdown != null,
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbarHeight,
        title: HeaderTitle(
          title,
          onTap: dropdown == null
              ? null
              : () => unawaited(
                  showHeaderDropdown<void>(
                    context,
                    top: MediaQuery.paddingOf(context).top + toolbarHeight,
                    builder: dropdown,
                  ),
                ),
          tapHint: titleTapHint,
        ),
        actions: actions,
      ),
      body: SafeArea(child: body),
    );
  }
}

import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/widgets/header_title.dart';

/// A page with the navy header bar (the design system's StoreHeader) on
/// top of [body].
///
/// The header shows [title] at the full text size and grows to fit it when
/// it wraps. With [onTitleTap] the title gets a ▼ and becomes a button, like
/// the store name that opens the store picker. End [actions] with the app's
/// Send feedback button.
class PageScaffold extends StatelessWidget {
  const new({
    required this.title,
    required this.body,
    this.actions = const [],
    this.onTitleTap,
    this.titleTapHint,
    super.key,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;

  /// Called when the title is tapped.
  final VoidCallback? onTitleTap;

  /// What tapping the title does, for VoiceOver.
  final String? titleTapHint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: HeaderTitle.toolbarHeight(
          context,
          title,
          actionCount: actions.length,
          hasTrailingIcon: onTitleTap != null,
        ),
        title: HeaderTitle(title, onTap: onTitleTap, tapHint: titleTapHint),
        actions: actions,
      ),
      body: SafeArea(child: body),
    );
  }
}

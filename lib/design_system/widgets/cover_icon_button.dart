import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/theme/notepad_colors.dart';
import 'package:moms_list/design_system/tokens/app_spacing.dart';

/// A square navy icon button, like the add button beside the entry row.
/// Its icon grows with the text size.
///
/// It's filled with the notepad's navy cover in both themes, rather than
/// the accent blue used for marks on the paper.
class CoverIconButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final IconData icon;

  /// What the button does, shown on a long press and read by VoiceOver.
  final String tooltip;
  final VoidCallback onPressed;

  static const double _iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final notepad = NotepadColors.of(context);
    return IconButton.filled(
      onPressed: onPressed,
      tooltip: tooltip,
      iconSize: MediaQuery.textScalerOf(context).scale(_iconSize),
      style: IconButton.styleFrom(
        backgroundColor: notepad.cover,
        foregroundColor: notepad.onCover,
        minimumSize: const Size.square(AppSpacing.tapTarget),
      ),
      icon: Icon(icon),
    );
  }
}

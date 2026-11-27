import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/widgets/ruled_row.dart';

/// One plain sentence where a list would be, when it's empty or couldn't
/// load. It says what to do next. With [isError] it's in the error colour.
///
/// It doesn't scroll on its own, so put it in a list.
class EmptyState extends StatelessWidget {
  const new({required this.message, this.isError = false, super.key});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: RuledRow.padding,
      child: Text(
        message,
        style: isError
            ? theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              )
            : theme.textTheme.bodyLarge,
      ),
    );
  }
}

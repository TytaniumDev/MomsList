import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';
import 'package:moms_list/features/account/application/account_controller.dart';
import 'package:moms_list/features/account/application/auth_user.dart';
import 'package:moms_list/l10n/l10n.dart';

/// App bar action that signs out after Mom confirms. Shows nothing while
/// signed out.
class SignOutButton extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedIn = ref.watch(
      authUserProvider.select((user) => user.value != null),
    );
    if (!signedIn) return const SizedBox.shrink();

    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: context.l10n.signOutButtonTooltip,
      onPressed: () => _confirmSignOut(context, ref),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.signOutDialogTitle,
      message: l10n.signOutDialogMessage,
      cancelLabel: l10n.signOutDialogCancelButton,
      confirmLabel: l10n.signOutDialogConfirmButton,
    );
    if (confirmed) {
      await ref.read(accountControllerProvider.notifier).signOut();
    }
  }
}

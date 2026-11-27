/// Mom's List design system: tokens, themes and shared widgets.
///
/// The source of truth for the look is the Claude design system
/// (https://claude.ai/artifact/LAZBw61TibWwNXD6CKWv1G). Each widget here is
/// one of its components. Widgets take plain values (never entities or
/// providers) and every label is a parameter, so features pass
/// `context.l10n` strings. Features import only this file.
library;

export 'theme/app_theme.dart';
export 'theme/notepad_colors.dart';
export 'tokens/app_colors.dart';
export 'tokens/app_spacing.dart';
export 'tokens/app_text_theme.dart';
export 'widgets/confirm_dialog.dart';
export 'widgets/cover_icon_button.dart';
export 'widgets/empty_state.dart';
export 'widgets/entry_row.dart';
export 'widgets/got_it_band.dart';
export 'widgets/item_row.dart';
export 'widgets/margin_line.dart';
export 'widgets/page_scaffold.dart';
export 'widgets/ruled_row.dart';
export 'widgets/store_row.dart';
export 'widgets/suggestion_row.dart';

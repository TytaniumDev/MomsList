import 'dart:async';

import 'package:moms_list/features/grocery/application/grocery_providers.dart';
import 'package:moms_list/features/grocery/domain/grocery_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uuid/uuid.dart';

part 'grocery_controller.g.dart';

/// Changes Mom's stores and items.
///
/// Each change shows on screen at once, through the providers' streams.
/// Saving to the server happens in the background, even offline, so callers
/// don't wait; a save that fails is sent to Sentry.
@riverpod
class GroceryController extends _$GroceryController {
  static const _uuid = Uuid();

  @override
  void build() {}

  /// Adds a store called [name] and returns its id, so the UI can open it.
  String addStore(String name) {
    final id = _uuid.v4();
    _save((repository) => repository.addStore(id: id, name: name));
    return id;
  }

  void renameStore(String id, String name) =>
      _save((repository) => repository.renameStore(id: id, name: name));

  void deleteStore(String id) =>
      _save((repository) => repository.deleteStore(id));

  /// Adds [name] to the store's list, or un-checks it if it was added
  /// before.
  void addItem({required String storeId, required String name}) {
    if (name.trim().isEmpty) return;
    _save((repository) => repository.addItem(storeId: storeId, name: name));
  }

  void setChecked(String itemId, {required bool checked}) =>
      _save((repository) => repository.setChecked(itemId, checked: checked));

  void deleteItem(String itemId) =>
      _save((repository) => repository.deleteItem(itemId));

  void _save(Future<void> Function(GroceryRepository repository) change) {
    final repository = ref.read(groceryRepositoryProvider);
    unawaited(
      change(repository).catchError(
        (Object error, StackTrace stackTrace) =>
            Sentry.captureException(error, stackTrace: stackTrace),
      ),
    );
  }
}

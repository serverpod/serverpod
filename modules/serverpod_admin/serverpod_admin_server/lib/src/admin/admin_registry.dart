import 'package:serverpod/serverpod.dart';
import 'package:serverpod_admin_server/src/admin/admin_entry.dart';
import 'package:serverpod_admin_server/src/admin/admin_entry_base.dart';

import '../../serverpod_admin_server.dart' show AdminResource;

typedef JsonMap = Map<String, dynamic>;

/// Concrete CRUD entry bound to a specific Serverpod table row type.

class AdminRegistry {
  AdminRegistry._();

  static final AdminRegistry _instance = AdminRegistry._();

  factory AdminRegistry() => _instance;

  final Map<Type, AdminEntryBase> _entries = {};
  final Map<String, AdminEntryBase> _entriesByKey = {};

  /// Registers a new table row type. Table metadata and JSON serialization can
  /// be provided explicitly, but if omitted, they will be resolved from the
  /// host server's [SerializationManager]. This lets host projects register
  /// resources with a simple [register]<T>() call.
  void register<T extends TableRow>({
    Table? table,
    T Function(JsonMap json)? fromJson,
    Future<List<T>> Function(Session session)? listRows,
    Future<T?> Function(Session session, Object id)? findRowById,
    Future<T> Function(Session session, T row)? createRow,
    Future<T> Function(Session session, T row)? updateRow,
    Future<void> Function(Session session, Object id)? deleteById,
    String? resourceKey,
  }) {
    final type = T;
    if (_entries.containsKey(type)) return;

    final entry = AdminEntry<T>(
      table: table,
      fromJson: fromJson,
      listRows: listRows ?? (session) => session.db.find<T>(),
      findRowById: findRowById ?? (session, id) => session.db.findById<T>(id),
      createRow: createRow ?? (session, row) => session.db.insertRow<T>(row),
      updateRow: updateRow ?? (session, row) => session.db.updateRow<T>(row),
      deleteById: deleteById ??
          (session, id) async {
            final row = await session.db.findById<T>(id);
            if (row != null) {
              await session.db.deleteRow<T>(row);
            }
          },
      resourceKey: resourceKey,
    );
    _entries[type] = entry;
    _entriesByKey[entry.resourceKey] = entry;
  }

  /// Returns the registered CRUD resources.
  List<AdminEntryBase> get registeredEntries =>
      List.unmodifiable(_entries.values);

  /// Lookup helper to retrieve a registered entry by type.
  AdminEntryBase? operator [](Type type) => _entries[type];

  /// Lookup helper by resource key.
  AdminEntryBase? entryByKey(String key) => _entriesByKey[key];

  /// Returns registered resource keys.
  List<String> get registeredResourceKeys =>
      List.unmodifiable(_entriesByKey.keys);

  /// Returns metadata for all registered entries.
  List<AdminResource> get registeredResourceMetadata =>
      registeredEntries.map((entry) => entry.metadata).toList(growable: false);

  /// Removes all registered entries. Primarily useful during hot-reload or when
  /// reconfiguring the module at runtime.
  void reset() {
    _entries.clear();
    _entriesByKey.clear();
  }
}

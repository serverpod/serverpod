import 'package:serverpod/serverpod.dart';

import '../../serverpod_admin_server.dart' show AdminColumn, AdminResource;

typedef JsonMap = Map<String, dynamic>;

/// Base contract describing a resource that exposes generic CRUD helpers
/// for a Serverpod `TableRow`.
abstract class AdminCrudEntryBase {
  Type get type;
  String get resourceKey;
  String get tableName;
  Table get table;

  /// Column metadata for dynamic UIs.
  List<Column> get columns => table.columns;

  /// Rich metadata describing this resource.
  AdminResource get metadata;

  /// Creates a strongly typed row from a JSON payload.
  TableRow fromJson(JsonMap json);

  /// Serializes a strongly typed row into JSON.
  JsonMap toJson(TableRow row);

  /// Returns all rows for this resource.
  Future<List<TableRow>> listRows(Session session);

  /// Returns a single row by its primary key, if present.
  Future<TableRow?> findRowById(Session session, Object id);

  /// Persists a new row in the database.
  Future<TableRow> createRow(Session session, TableRow row);

  /// Persists updates to an existing row.
  Future<TableRow> updateRow(Session session, TableRow row);

  /// Deletes a single row identified by its primary key.
  Future<void> deleteById(Session session, Object id);

  /// Convenience helper returning JSON encoded rows.
  Future<List<JsonMap>> list(Session session) async =>
      (await listRows(session)).map(toJson).toList();

  /// Convenience helper returning a single JSON encoded row.
  Future<JsonMap?> find(Session session, Object id) async {
    final row = await findRowById(session, id);
    if (row == null) return null;
    return toJson(row);
  }

  /// Convenience helper that performs a create from JSON.
  Future<JsonMap> create(Session session, JsonMap json) async {
    final row = fromJson(json);
    final created = await createRow(session, row);
    return toJson(created);
  }

  /// Convenience helper that performs an update from JSON.
  Future<JsonMap> update(Session session, JsonMap json) async {
    final row = fromJson(json);
    final updated = await updateRow(session, row);
    return toJson(updated);
  }

  /// Deletes a single row identified by its primary key.
  Future<void> delete(Session session, Object id) => deleteById(session, id);
}

/// Concrete CRUD entry bound to a specific Serverpod table row type.
class AdminCrudEntry<T extends TableRow> extends AdminCrudEntryBase {
  AdminCrudEntry({
    Table? table,
    T Function(JsonMap json)? fromJson,
    required Future<List<T>> Function(Session session) listRows,
    required Future<T?> Function(Session session, Object id) findRowById,
    required Future<T> Function(Session session, T row) createRow,
    required Future<T> Function(Session session, T row) updateRow,
    required Future<void> Function(Session session, Object id) deleteById,
    String? resourceKey,
  })  : _table = table,
        _fromJson = fromJson,
        _listRows = listRows,
        _findRowById = findRowById,
        _createRow = createRow,
        _updateRow = updateRow,
        _deleteById = deleteById,
        _resourceKeyOverride = resourceKey;

  Table? _table;
  T Function(JsonMap json)? _fromJson;
  final Future<List<T>> Function(Session session) _listRows;
  final Future<T?> Function(Session session, Object id) _findRowById;
  final Future<T> Function(Session session, T row) _createRow;
  final Future<T> Function(Session session, T row) _updateRow;
  final Future<void> Function(Session session, Object id) _deleteById;
  final String? _resourceKeyOverride;
  List<AdminColumn>? _adminColumns;
  AdminResource? _metadataCache;

  @override
  Type get type => T;

  @override
  String get resourceKey => _resourceKeyOverride ?? _resolvedTable.tableName;

  @override
  String get tableName => _resolvedTable.tableName;

  @override
  Table get table => _resolvedTable;

  @override
  List<Column> get columns => _resolvedTable.columns;

  @override
  AdminResource get metadata => _metadataCache ??= AdminResource(
        key: resourceKey,
        tableName: tableName,
        columns: _resolvedAdminColumns,
      );

  @override
  TableRow fromJson(JsonMap json) => _resolvedFromJson(json);

  @override
  JsonMap toJson(TableRow row) => (row as T).toJson();

  @override
  Future<List<TableRow>> listRows(Session session) async {
    final rows = await _listRows(session);
    return rows.cast<TableRow>();
  }

  @override
  Future<TableRow?> findRowById(Session session, Object id) async {
    final row = await _findRowById(session, id);
    return row;
  }

  @override
  Future<TableRow> createRow(Session session, TableRow row) async {
    final created = await _createRow(session, row as T);
    return created;
  }

  @override
  Future<TableRow> updateRow(Session session, TableRow row) async {
    final updated = await _updateRow(session, row as T);
    return updated;
  }

  @override
  Future<void> deleteById(Session session, Object id) async {
    await _deleteById(session, id);
  }

  Table get _resolvedTable {
    return _table ??= _inferTableForType<T>();
  }

  T Function(JsonMap json) get _resolvedFromJson {
    return _fromJson ??= _inferFromJsonForType<T>();
  }

  List<AdminColumn> get _resolvedAdminColumns =>
      _adminColumns ??= _resolvedTable.columns
          .map(
            (column) => AdminColumn(
              name: column.columnName,
              dataType: column.type.toString(),
              hasDefault: column.hasDefault,
              isPrimary: identical(column, _resolvedTable.id),
            ),
          )
          .toList(growable: false);
}

class AdminRegistry {
  AdminRegistry._();

  static final AdminRegistry _instance = AdminRegistry._();

  factory AdminRegistry() => _instance;

  final Map<Type, AdminCrudEntryBase> _entries = {};
  final Map<String, AdminCrudEntryBase> _entriesByKey = {};

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

    final entry = AdminCrudEntry<T>(
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
  List<AdminCrudEntryBase> get registeredEntries =>
      List.unmodifiable(_entries.values);

  /// Lookup helper to retrieve a registered entry by type.
  AdminCrudEntryBase? operator [](Type type) => _entries[type];

  /// Lookup helper by resource key.
  AdminCrudEntryBase? entryByKey(String key) => _entriesByKey[key];

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

Table _inferTableForType<T extends TableRow>() {
  final pod = Serverpod.instance;
  final table = pod.serializationManager.getTableForType(T);
  if (table == null) {
    throw StateError(
      'serverpod_admin: Unable to resolve table metadata for $T. '
      'Pass the table parameter to registry.register to configure this type.',
    );
  }
  return table;
}

T Function(JsonMap json) _inferFromJsonForType<T extends TableRow>() {
  final pod = Serverpod.instance;
  return (json) => pod.serializationManager.deserialize<T>(json);
}

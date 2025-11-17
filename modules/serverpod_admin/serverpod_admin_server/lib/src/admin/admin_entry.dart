import 'package:serverpod/serverpod.dart';
import 'package:serverpod_admin_server/serverpod_admin_server.dart';
import 'package:serverpod_admin_server/src/admin/admin_entry_base.dart';

class AdminEntry<T extends TableRow> extends AdminEntryBase {
  AdminEntry({
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

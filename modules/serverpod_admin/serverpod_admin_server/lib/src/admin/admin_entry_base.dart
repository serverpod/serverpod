import 'package:serverpod/serverpod.dart';
import 'package:serverpod_admin_server/serverpod_admin_server.dart';

/// Base contract describing a resource that exposes generic CRUD helpers
/// for a Serverpod `TableRow`.
abstract class AdminEntryBase {
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

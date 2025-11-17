import 'package:serverpod/serverpod.dart';
import 'package:serverpod_admin_server/src/admin/admin_entry_base.dart';

import '../../admin/admin.dart';
import '../admin_registry.dart';
import '../../../serverpod_admin_server.dart' show AdminResource;

class AdminEndpoint extends Endpoint {
  final AdminRegistry _registry = AdminRegistry();

  AdminEntryBase _resolve(String resourceKey) {
    adminRegister();
    final entry = _registry.entryByKey(resourceKey);
    if (entry == null) {
      throw ArgumentError('Unknown admin resource "$resourceKey".');
    }
    return entry;
  }

  Future<List<AdminResource>> resources(Session session) async {
    adminRegister();
    return _registry.registeredResourceMetadata;
  }

  Future<List<Map<String, String>>> list(
    Session session,
    String resourceKey,
  ) async {
    final entry = _resolve(resourceKey);

    final result = await entry.list(session);
    final serialized = _stringifyRecords(result);

    session.log(
      'Session load $serialized',
    );

    return serialized;
  }

  Future<List<Map<String, String>>> listPage(
    Session session,
    String resourceKey,
    int offset,
    int limit,
  ) async {
    if (offset < 0 || limit <= 0) {
      throw ArgumentError(
        'Invalid pagination arguments. Offset must be >= 0 and limit > 0.',
      );
    }

    final entry = _resolve(resourceKey);
    final all = await entry.list(session);
    final window = all.skip(offset).take(limit).toList(growable: false);

    session.log(
      'AdminEndpoint.listPage resource=$resourceKey offset=$offset '
      'limit=$limit returned=${window.length}',
    );

    return _stringifyRecords(window);
  }

  Future<Map<String, dynamic>?> find(
    Session session,
    String resourceKey,
    Object id,
  ) async {
    final entry = _resolve(resourceKey);
    return entry.find(session, id);
  }

  Future<Map<String, String>> create(
    Session session,
    String resourceKey,
    Map<String, String> data,
  ) async {
    session.log(
      'AdminEndpoint.create resource=$resourceKey payload=$data',
    );
    final entry = _resolve(resourceKey);
    final normalized = _normalizePayload(entry, data);
    session.log(
      'AdminEndpoint.create normalized payload=$normalized',
    );
    final created = await entry.create(session, normalized);
    return _stringifyRecord(created);
  }

  Future<Map<String, String>> update(
    Session session,
    String resourceKey,
    Map<String, String> data,
  ) async {
    session.log(
      'AdminEndpoint.update resource=$resourceKey payload=$data',
    );
    final entry = _resolve(resourceKey);
    final normalized = _normalizePayload(entry, data);
    session.log(
      'AdminEndpoint.update normalized payload=$normalized',
    );
    final updated = await entry.update(session, normalized);
    return _stringifyRecord(updated);
  }

  Future<bool> delete(
    Session session,
    String resourceKey,
    String id,
  ) async {
    final entry = _resolve(resourceKey);
    final primaryColumnMetadata = entry.metadata.columns.firstWhere(
      (column) => column.isPrimary,
      orElse: () => entry.metadata.columns.first,
    );
    final tableColumn = entry.columns.firstWhere(
      (column) => column.columnName == primaryColumnMetadata.name,
      orElse: () => entry.columns.first,
    );
    final normalizedId = _parseColumnValue(tableColumn, id) ?? id;
    await entry.delete(session, normalizedId);
    return true;
  }

  Map<String, dynamic> _normalizePayload(
    AdminEntryBase entry,
    Map<String, String> data,
  ) {
    final normalized = <String, dynamic>{};
    for (final column in entry.columns) {
      final name = column.columnName;
      if (!data.containsKey(name)) continue;
      final value = data[name];
      normalized[name] = _parseColumnValue(column, value);
    }
    return normalized;
  }

  dynamic _parseColumnValue(Column column, String? raw) {
    if (raw == null) return null;
    final value = raw.trim();
    if (value.isEmpty) return null;

    if (column is ColumnInt || column is ColumnBigInt) {
      return int.tryParse(value);
    }
    if (column is ColumnDouble) {
      return double.tryParse(value);
    }
    if (column is ColumnBool) {
      final lowered = value.toLowerCase();
      if (lowered == 'true' || lowered == '1' || lowered == 'yes') return true;
      if (lowered == 'false' || lowered == '0' || lowered == 'no') {
        return false;
      }
      return null;
    }
    if (column is ColumnDateTime) {
      return DateTime.tryParse(value)?.toUtc().toIso8601String();
    }
    return value;
  }

  List<Map<String, String>> _stringifyRecords(
    List<Map<String, dynamic>> rows,
  ) =>
      rows.map(_stringifyRecord).toList();

  Map<String, String> _stringifyRecord(Map<String, dynamic> row) => row.map(
        (key, value) => MapEntry(
          key,
          _stringifyValue(value),
        ),
      );

  String _stringifyValue(dynamic value) {
    if (value == null) return '';
    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    }
    return value.toString();
  }
}

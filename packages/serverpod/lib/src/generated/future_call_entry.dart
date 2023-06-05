/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef FutureCallEntryExpressionBuilder = _i1.Expression Function(
    FutureCallEntryTable);

/// A serialized future call with bindings to the database.
abstract class FutureCallEntry extends _i1.TableRow {
  const FutureCallEntry._();

  const factory FutureCallEntry({
    int? id,
    required String name,
    required DateTime time,
    String? serializedObject,
    required String serverId,
    String? identifier,
  }) = _FutureCallEntry;

  factory FutureCallEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return FutureCallEntry(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      time:
          serializationManager.deserialize<DateTime>(jsonSerialization['time']),
      serializedObject: serializationManager
          .deserialize<String?>(jsonSerialization['serializedObject']),
      serverId: serializationManager
          .deserialize<String>(jsonSerialization['serverId']),
      identifier: serializationManager
          .deserialize<String?>(jsonSerialization['identifier']),
    );
  }

  static const t = FutureCallEntryTable();

  FutureCallEntry copyWith({
    int? id,
    String? name,
    DateTime? time,
    String? serializedObject,
    String? serverId,
    String? identifier,
  });
  @override
  String get tableName => 'serverpod_future_call';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'serializedObject': serializedObject,
      'serverId': serverId,
      'identifier': identifier,
    };
  }

  static Future<List<FutureCallEntry>> find(
    _i1.Session session, {
    FutureCallEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<FutureCallEntry>(
      where: where != null ? where(FutureCallEntry.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<FutureCallEntry?> findSingleRow(
    _i1.Session session, {
    FutureCallEntryExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<FutureCallEntry>(
      where: where != null ? where(FutureCallEntry.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<FutureCallEntry?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<FutureCallEntry>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required FutureCallEntryExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FutureCallEntry>(
      where: where(FutureCallEntry.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    FutureCallEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    FutureCallEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  /// Inserts a row into the database.
  /// Returns updated row with the id set.
  static Future<FutureCallEntry> insert(
    _i1.Session session,
    FutureCallEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    FutureCallEntryExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FutureCallEntry>(
      where: where != null ? where(FutureCallEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  /// Name of the future call. Used to find the correct method to call.
  String get name;

  /// Time to execute the call.
  DateTime get time;

  /// The serialized object, used as a parameter to the call.
  String? get serializedObject;

  /// The id of the server where the call was created.
  String get serverId;

  /// An optional identifier which can be used to cancel the call.
  String? get identifier;
}

class _Undefined {}

/// A serialized future call with bindings to the database.
class _FutureCallEntry extends FutureCallEntry {
  const _FutureCallEntry({
    int? id,
    required this.name,
    required this.time,
    this.serializedObject,
    required this.serverId,
    this.identifier,
  }) : super._();

  /// Name of the future call. Used to find the correct method to call.
  @override
  final String name;

  /// Time to execute the call.
  @override
  final DateTime time;

  /// The serialized object, used as a parameter to the call.
  @override
  final String? serializedObject;

  /// The id of the server where the call was created.
  @override
  final String serverId;

  /// An optional identifier which can be used to cancel the call.
  @override
  final String? identifier;

  @override
  String get tableName => 'serverpod_future_call';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'serializedObject': serializedObject,
      'serverId': serverId,
      'identifier': identifier,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is FutureCallEntry &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.name,
                  name,
                ) ||
                other.name == name) &&
            (identical(
                  other.time,
                  time,
                ) ||
                other.time == time) &&
            (identical(
                  other.serializedObject,
                  serializedObject,
                ) ||
                other.serializedObject == serializedObject) &&
            (identical(
                  other.serverId,
                  serverId,
                ) ||
                other.serverId == serverId) &&
            (identical(
                  other.identifier,
                  identifier,
                ) ||
                other.identifier == identifier));
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        time,
        serializedObject,
        serverId,
        identifier,
      );

  @override
  FutureCallEntry copyWith({
    Object? id = _Undefined,
    String? name,
    DateTime? time,
    Object? serializedObject = _Undefined,
    String? serverId,
    Object? identifier = _Undefined,
  }) {
    return FutureCallEntry(
      id: id == _Undefined ? this.id : (id as int?),
      name: name ?? this.name,
      time: time ?? this.time,
      serializedObject: serializedObject == _Undefined
          ? this.serializedObject
          : (serializedObject as String?),
      serverId: serverId ?? this.serverId,
      identifier:
          identifier == _Undefined ? this.identifier : (identifier as String?),
    );
  }
}

class FutureCallEntryTable extends _i1.Table {
  const FutureCallEntryTable() : super(tableName: 'serverpod_future_call');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// Name of the future call. Used to find the correct method to call.
  final name = const _i1.ColumnString('name');

  /// Time to execute the call.
  final time = const _i1.ColumnDateTime('time');

  /// The serialized object, used as a parameter to the call.
  final serializedObject = const _i1.ColumnString('serializedObject');

  /// The id of the server where the call was created.
  final serverId = const _i1.ColumnString('serverId');

  /// An optional identifier which can be used to cancel the call.
  final identifier = const _i1.ColumnString('identifier');

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        time,
        serializedObject,
        serverId,
        identifier,
      ];
}

@Deprecated('Use FutureCallEntryTable.t instead.')
FutureCallEntryTable tFutureCallEntry = const FutureCallEntryTable();

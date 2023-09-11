/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// A serialized future call with bindings to the database.
abstract class FutureCallEntry extends _i1.TableRow {
  FutureCallEntry._({
    int? id,
    required this.name,
    required this.time,
    this.serializedObject,
    required this.serverId,
    this.identifier,
  }) : super(id);

  factory FutureCallEntry({
    int? id,
    required String name,
    required DateTime time,
    String? serializedObject,
    required String serverId,
    String? identifier,
  }) = _FutureCallEntryImpl;

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

  static final t = FutureCallEntryTable();

  /// Name of the future call. Used to find the correct method to call.
  String name;

  /// Time to execute the call.
  DateTime time;

  /// The serialized object, used as a parameter to the call.
  String? serializedObject;

  /// The id of the server where the call was created.
  String serverId;

  /// An optional identifier which can be used to cancel the call.
  String? identifier;

  @override
  String get tableName => 'serverpod_future_call';
  FutureCallEntry copyWith({
    int? id,
    String? name,
    DateTime? time,
    String? serializedObject,
    String? serverId,
    String? identifier,
  });
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

  @override
  Map<String, dynamic> allToJson() {
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
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'name':
        name = value;
        return;
      case 'time':
        time = value;
        return;
      case 'serializedObject':
        serializedObject = value;
        return;
      case 'serverId':
        serverId = value;
        return;
      case 'identifier':
        identifier = value;
        return;
      default:
        throw UnimplementedError();
    }
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

  static Future<void> insert(
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

  static FutureCallEntryInclude include() {
    return FutureCallEntryInclude._();
  }
}

class _Undefined {}

class _FutureCallEntryImpl extends FutureCallEntry {
  _FutureCallEntryImpl({
    int? id,
    required String name,
    required DateTime time,
    String? serializedObject,
    required String serverId,
    String? identifier,
  }) : super._(
          id: id,
          name: name,
          time: time,
          serializedObject: serializedObject,
          serverId: serverId,
          identifier: identifier,
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
      id: id is! int? ? this.id : id,
      name: name ?? this.name,
      time: time ?? this.time,
      serializedObject: serializedObject is! String?
          ? this.serializedObject
          : serializedObject,
      serverId: serverId ?? this.serverId,
      identifier: identifier is! String? ? this.identifier : identifier,
    );
  }
}

typedef FutureCallEntryExpressionBuilder = _i1.Expression Function(
    FutureCallEntryTable);

class FutureCallEntryTable extends _i1.Table {
  FutureCallEntryTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_future_call') {
    name = _i1.ColumnString(
      'name',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    time = _i1.ColumnDateTime(
      'time',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    serializedObject = _i1.ColumnString(
      'serializedObject',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    serverId = _i1.ColumnString(
      'serverId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    identifier = _i1.ColumnString(
      'identifier',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// Name of the future call. Used to find the correct method to call.
  late final _i1.ColumnString name;

  /// Time to execute the call.
  late final _i1.ColumnDateTime time;

  /// The serialized object, used as a parameter to the call.
  late final _i1.ColumnString serializedObject;

  /// The id of the server where the call was created.
  late final _i1.ColumnString serverId;

  /// An optional identifier which can be used to cancel the call.
  late final _i1.ColumnString identifier;

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
FutureCallEntryTable tFutureCallEntry = FutureCallEntryTable();

class FutureCallEntryInclude extends _i1.Include {
  FutureCallEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => FutureCallEntry.t;
}

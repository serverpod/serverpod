/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart';

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

  static const db = FutureCallEntryRepository._();

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
  _i1.Table get table => t;

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
      if (id != null) 'id': id,
      'name': name,
      'time': time.toJson(),
      if (serializedObject != null) 'serializedObject': serializedObject,
      'serverId': serverId,
      if (identifier != null) 'identifier': identifier,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'time': time.toJson(),
      if (serializedObject != null) 'serializedObject': serializedObject,
      'serverId': serverId,
      if (identifier != null) 'identifier': identifier,
    };
  }

  static FutureCallEntryInclude include() {
    return FutureCallEntryInclude._();
  }

  static FutureCallEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<FutureCallEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FutureCallEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FutureCallEntryTable>? orderByList,
    FutureCallEntryInclude? include,
  }) {
    return FutureCallEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FutureCallEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FutureCallEntry.t),
      include: include,
    );
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
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      serializedObject: serializedObject is String?
          ? serializedObject
          : this.serializedObject,
      serverId: serverId ?? this.serverId,
      identifier: identifier is String? ? identifier : this.identifier,
    );
  }
}

class FutureCallEntryTable extends _i1.Table {
  FutureCallEntryTable({super.tableRelation})
      : super(tableName: 'serverpod_future_call') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    time = _i1.ColumnDateTime(
      'time',
      this,
    );
    serializedObject = _i1.ColumnString(
      'serializedObject',
      this,
    );
    serverId = _i1.ColumnString(
      'serverId',
      this,
    );
    identifier = _i1.ColumnString(
      'identifier',
      this,
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

class FutureCallEntryInclude extends _i1.IncludeObject {
  FutureCallEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => FutureCallEntry.t;
}

class FutureCallEntryIncludeList extends _i1.IncludeList {
  FutureCallEntryIncludeList._({
    _i1.WhereExpressionBuilder<FutureCallEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FutureCallEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => FutureCallEntry.t;
}

class FutureCallEntryRepository {
  const FutureCallEntryRepository._();

  Future<List<FutureCallEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FutureCallEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FutureCallEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FutureCallEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<FutureCallEntry>(
      where: where?.call(FutureCallEntry.t),
      orderBy: orderBy?.call(FutureCallEntry.t),
      orderByList: orderByList?.call(FutureCallEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<FutureCallEntry?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FutureCallEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<FutureCallEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FutureCallEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<FutureCallEntry>(
      where: where?.call(FutureCallEntry.t),
      orderBy: orderBy?.call(FutureCallEntry.t),
      orderByList: orderByList?.call(FutureCallEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<FutureCallEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<FutureCallEntry>(
      id,
      transaction: transaction,
    );
  }

  Future<List<FutureCallEntry>> insert(
    _i1.Session session,
    List<FutureCallEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<FutureCallEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<FutureCallEntry> insertRow(
    _i1.Session session,
    FutureCallEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FutureCallEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<FutureCallEntry>> update(
    _i1.Session session,
    List<FutureCallEntry> rows, {
    _i1.ColumnSelections<FutureCallEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FutureCallEntry>(
      rows,
      columns: columns?.call(FutureCallEntry.t),
      transaction: transaction,
    );
  }

  Future<FutureCallEntry> updateRow(
    _i1.Session session,
    FutureCallEntry row, {
    _i1.ColumnSelections<FutureCallEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FutureCallEntry>(
      row,
      columns: columns?.call(FutureCallEntry.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<FutureCallEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FutureCallEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    FutureCallEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FutureCallEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FutureCallEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FutureCallEntry>(
      where: where(FutureCallEntry.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FutureCallEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FutureCallEntry>(
      where: where?.call(FutureCallEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

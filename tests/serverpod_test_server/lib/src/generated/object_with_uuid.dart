/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ObjectWithUuid extends _i1.TableRow {
  ObjectWithUuid._({
    int? id,
    required this.uuid,
    this.uuidNullable,
  }) : super(id);

  factory ObjectWithUuid({
    int? id,
    required _i1.UuidValue uuid,
    _i1.UuidValue? uuidNullable,
  }) = _ObjectWithUuidImpl;

  factory ObjectWithUuid.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithUuid(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      uuid: serializationManager
          .deserialize<_i1.UuidValue>(jsonSerialization['uuid']),
      uuidNullable: serializationManager
          .deserialize<_i1.UuidValue?>(jsonSerialization['uuidNullable']),
    );
  }

  static final t = ObjectWithUuidTable();

  static const db = ObjectWithUuidRepository._();

  _i1.UuidValue uuid;

  _i1.UuidValue? uuidNullable;

  @override
  _i1.Table get table => t;

  ObjectWithUuid copyWith({
    int? id,
    _i1.UuidValue? uuid,
    _i1.UuidValue? uuidNullable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'uuidNullable': uuidNullable,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'uuid': uuid,
      'uuidNullable': uuidNullable,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'uuid': uuid,
      'uuidNullable': uuidNullable,
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
      case 'uuid':
        uuid = value;
        return;
      case 'uuidNullable':
        uuidNullable = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<ObjectWithUuid>> find(
    _i1.Session session, {
    ObjectWithUuidExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithUuid>(
      where: where != null ? where(ObjectWithUuid.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<ObjectWithUuid?> findSingleRow(
    _i1.Session session, {
    ObjectWithUuidExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectWithUuid>(
      where: where != null ? where(ObjectWithUuid.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<ObjectWithUuid?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithUuid>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required ObjectWithUuidExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithUuid>(
      where: where(ObjectWithUuid.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    ObjectWithUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
  static Future<bool> update(
    _i1.Session session,
    ObjectWithUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
  static Future<void> insert(
    _i1.Session session,
    ObjectWithUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    ObjectWithUuidExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithUuid>(
      where: where != null ? where(ObjectWithUuid.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static ObjectWithUuidInclude include() {
    return ObjectWithUuidInclude._();
  }
}

class _Undefined {}

class _ObjectWithUuidImpl extends ObjectWithUuid {
  _ObjectWithUuidImpl({
    int? id,
    required _i1.UuidValue uuid,
    _i1.UuidValue? uuidNullable,
  }) : super._(
          id: id,
          uuid: uuid,
          uuidNullable: uuidNullable,
        );

  @override
  ObjectWithUuid copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuid,
    Object? uuidNullable = _Undefined,
  }) {
    return ObjectWithUuid(
      id: id is int? ? id : this.id,
      uuid: uuid ?? this.uuid,
      uuidNullable:
          uuidNullable is _i1.UuidValue? ? uuidNullable : this.uuidNullable,
    );
  }
}

typedef ObjectWithUuidExpressionBuilder = _i1.Expression Function(
    ObjectWithUuidTable);

class ObjectWithUuidTable extends _i1.Table {
  ObjectWithUuidTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'object_with_uuid') {
    uuid = _i1.ColumnUuid(
      'uuid',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    uuidNullable = _i1.ColumnUuid(
      'uuidNullable',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  late final _i1.ColumnUuid uuid;

  late final _i1.ColumnUuid uuidNullable;

  @override
  List<_i1.Column> get columns => [
        id,
        uuid,
        uuidNullable,
      ];
}

@Deprecated('Use ObjectWithUuidTable.t instead.')
ObjectWithUuidTable tObjectWithUuid = ObjectWithUuidTable();

class ObjectWithUuidInclude extends _i1.Include {
  ObjectWithUuidInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectWithUuid.t;
}

class ObjectWithUuidRepository {
  const ObjectWithUuidRepository._();

  Future<List<ObjectWithUuid>> find(
    _i1.Session session, {
    ObjectWithUuidExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<ObjectWithUuid>(
      where: where?.call(ObjectWithUuid.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  Future<ObjectWithUuid?> findRow(
    _i1.Session session, {
    ObjectWithUuidExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findRow<ObjectWithUuid>(
      where: where?.call(ObjectWithUuid.t),
      transaction: transaction,
    );
  }

  Future<ObjectWithUuid?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<ObjectWithUuid>(
      id,
      transaction: transaction,
    );
  }

  Future<ObjectWithUuid> insertRow(
    _i1.Session session,
    ObjectWithUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<ObjectWithUuid>(
      row,
      transaction: transaction,
    );
  }

  Future<ObjectWithUuid> updateRow(
    _i1.Session session,
    ObjectWithUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<ObjectWithUuid>(
      row,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ObjectWithUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<ObjectWithUuid>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required ObjectWithUuidExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<ObjectWithUuid>(
      where: where(ObjectWithUuid.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    ObjectWithUuidExpressionBuilder? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<ObjectWithUuid>(
      where: where?.call(ObjectWithUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

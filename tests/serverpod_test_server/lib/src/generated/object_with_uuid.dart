/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef ObjectWithUuidExpressionBuilder = _i1.Expression Function(
    ObjectWithUuidTable);

abstract class ObjectWithUuid extends _i1.TableRow {
  const ObjectWithUuid._();

  const factory ObjectWithUuid({
    int? id,
    required _i1.UuidValue uuid,
    _i1.UuidValue? uuidNullable,
  }) = _ObjectWithUuid;

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

  static const t = ObjectWithUuidTable();

  ObjectWithUuid copyWith({
    int? id,
    _i1.UuidValue? uuid,
    _i1.UuidValue? uuidNullable,
  });
  @override
  String get tableName => 'object_with_uuid';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'uuid': uuid,
      'uuidNullable': uuidNullable,
    };
  }

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

  static Future<ObjectWithUuid?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithUuid>(id);
  }

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

  /// Inserts a row into the database.
  /// Returns updated row with the id set.
  static Future<ObjectWithUuid> insert(
    _i1.Session session,
    ObjectWithUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

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

  _i1.UuidValue get uuid;
  _i1.UuidValue? get uuidNullable;
}

class _Undefined {}

class _ObjectWithUuid extends ObjectWithUuid {
  const _ObjectWithUuid({
    int? id,
    required this.uuid,
    this.uuidNullable,
  }) : super._();

  @override
  final _i1.UuidValue uuid;

  @override
  final _i1.UuidValue? uuidNullable;

  @override
  String get tableName => 'object_with_uuid';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'uuidNullable': uuidNullable,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ObjectWithUuid &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.uuid,
                  uuid,
                ) ||
                other.uuid == uuid) &&
            (identical(
                  other.uuidNullable,
                  uuidNullable,
                ) ||
                other.uuidNullable == uuidNullable));
  }

  @override
  int get hashCode => Object.hash(
        id,
        uuid,
        uuidNullable,
      );

  @override
  ObjectWithUuid copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuid,
    Object? uuidNullable = _Undefined,
  }) {
    return ObjectWithUuid(
      id: id == _Undefined ? this.id : (id as int?),
      uuid: uuid ?? this.uuid,
      uuidNullable: uuidNullable == _Undefined
          ? this.uuidNullable
          : (uuidNullable as _i1.UuidValue?),
    );
  }
}

class ObjectWithUuidTable extends _i1.Table {
  const ObjectWithUuidTable() : super(tableName: 'object_with_uuid');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  final uuid = const _i1.ColumnUuid('uuid');

  final uuidNullable = const _i1.ColumnUuid('uuidNullable');

  @override
  List<_i1.Column> get columns => [
        id,
        uuid,
        uuidNullable,
      ];
}

@Deprecated('Use ObjectWithUuidTable.t instead.')
ObjectWithUuidTable tObjectWithUuid = const ObjectWithUuidTable();

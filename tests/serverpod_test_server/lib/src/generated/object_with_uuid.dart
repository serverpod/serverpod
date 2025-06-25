/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ObjectWithUuid
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithUuid._({
    this.id,
    required this.uuid,
    this.uuidNullable,
  });

  factory ObjectWithUuid({
    int? id,
    required _i1.UuidValue uuid,
    _i1.UuidValue? uuidNullable,
  }) = _ObjectWithUuidImpl;

  factory ObjectWithUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithUuid(
      id: jsonSerialization['id'] as int?,
      uuid: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['uuid']),
      uuidNullable: jsonSerialization['uuidNullable'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidNullable']),
    );
  }

  static final t = ObjectWithUuidTable();

  static const db = ObjectWithUuidRepository._();

  @override
  int? id;

  _i1.UuidValue uuid;

  _i1.UuidValue? uuidNullable;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithUuid copyWith({
    int? id,
    _i1.UuidValue? uuid,
    _i1.UuidValue? uuidNullable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uuid': uuid.toJson(),
      if (uuidNullable != null) 'uuidNullable': uuidNullable?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'uuid': uuid.toJson(),
      if (uuidNullable != null) 'uuidNullable': uuidNullable?.toJson(),
    };
  }

  static ObjectWithUuidInclude include() {
    return ObjectWithUuidInclude._();
  }

  static ObjectWithUuidIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithUuidTable>? orderByList,
    ObjectWithUuidInclude? include,
  }) {
    return ObjectWithUuidIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithUuid.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithUuid.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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

  /// Returns a shallow copy of this [ObjectWithUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

class ObjectWithUuidTable extends _i1.Table<int?> {
  ObjectWithUuidTable({super.tableRelation})
      : super(tableName: 'object_with_uuid') {
    uuid = _i1.ColumnUuid(
      'uuid',
      this,
    );
    uuidNullable = _i1.ColumnUuid(
      'uuidNullable',
      this,
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

class ObjectWithUuidInclude extends _i1.IncludeObject {
  ObjectWithUuidInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithUuid.t;
}

class ObjectWithUuidIncludeList extends _i1.IncludeList {
  ObjectWithUuidIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithUuidTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithUuid.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithUuid.t;
}

class ObjectWithUuidRepository {
  const ObjectWithUuidRepository._();

  /// Returns a list of [ObjectWithUuid]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ObjectWithUuid>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithUuidTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithUuid>(
      where: where?.call(ObjectWithUuid.t),
      orderBy: orderBy?.call(ObjectWithUuid.t),
      orderByList: orderByList?.call(ObjectWithUuid.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ObjectWithUuid] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ObjectWithUuid?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithUuidTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithUuidTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithUuid>(
      where: where?.call(ObjectWithUuid.t),
      orderBy: orderBy?.call(ObjectWithUuid.t),
      orderByList: orderByList?.call(ObjectWithUuid.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectWithUuid] by its [id] or null if no such row exists.
  Future<ObjectWithUuid?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithUuid>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectWithUuid]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithUuid]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectWithUuid>> insert(
    _i1.Session session,
    List<ObjectWithUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithUuid>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectWithUuid] and returns the inserted row.
  ///
  /// The returned [ObjectWithUuid] will have its `id` field set.
  Future<ObjectWithUuid> insertRow(
    _i1.Session session,
    ObjectWithUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithUuid]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithUuid>> update(
    _i1.Session session,
    List<ObjectWithUuid> rows, {
    _i1.ColumnSelections<ObjectWithUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithUuid>(
      rows,
      columns: columns?.call(ObjectWithUuid.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithUuid]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithUuid> updateRow(
    _i1.Session session,
    ObjectWithUuid row, {
    _i1.ColumnSelections<ObjectWithUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithUuid>(
      row,
      columns: columns?.call(ObjectWithUuid.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithUuid]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithUuid>> delete(
    _i1.Session session,
    List<ObjectWithUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithUuid>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithUuid].
  Future<ObjectWithUuid> deleteRow(
    _i1.Session session,
    ObjectWithUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithUuid>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithUuidTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithUuid>(
      where: where(ObjectWithUuid.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithUuidTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithUuid>(
      where: where?.call(ObjectWithUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

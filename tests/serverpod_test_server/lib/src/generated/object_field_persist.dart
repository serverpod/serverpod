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
import 'simple_data.dart' as _i2;

abstract class ObjectFieldPersist
    implements _i1.TableRow, _i1.ProtocolSerialization {
  ObjectFieldPersist._({
    this.id,
    required this.normal,
    this.api,
    this.data,
  });

  factory ObjectFieldPersist({
    int? id,
    required String normal,
    String? api,
    _i2.SimpleData? data,
  }) = _ObjectFieldPersistImpl;

  factory ObjectFieldPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectFieldPersist(
      id: jsonSerialization['id'] as int?,
      normal: jsonSerialization['normal'] as String,
      api: jsonSerialization['api'] as String?,
      data: jsonSerialization['data'] == null
          ? null
          : _i2.SimpleData.fromJson(
              (jsonSerialization['data'] as Map<String, dynamic>)),
    );
  }

  static final t = ObjectFieldPersistTable();

  static const db = ObjectFieldPersistRepository._();

  @override
  int? id;

  String normal;

  String? api;

  _i2.SimpleData? data;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [ObjectFieldPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectFieldPersist copyWith({
    int? id,
    String? normal,
    String? api,
    _i2.SimpleData? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'normal': normal,
      if (api != null) 'api': api,
      if (data != null) 'data': data?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'normal': normal,
      if (api != null) 'api': api,
      if (data != null) 'data': data?.toJsonForProtocol(),
    };
  }

  static ObjectFieldPersistInclude include() {
    return ObjectFieldPersistInclude._();
  }

  static ObjectFieldPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectFieldPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectFieldPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectFieldPersistTable>? orderByList,
    ObjectFieldPersistInclude? include,
  }) {
    return ObjectFieldPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectFieldPersist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectFieldPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectFieldPersistImpl extends ObjectFieldPersist {
  _ObjectFieldPersistImpl({
    int? id,
    required String normal,
    String? api,
    _i2.SimpleData? data,
  }) : super._(
          id: id,
          normal: normal,
          api: api,
          data: data,
        );

  /// Returns a shallow copy of this [ObjectFieldPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectFieldPersist copyWith({
    Object? id = _Undefined,
    String? normal,
    Object? api = _Undefined,
    Object? data = _Undefined,
  }) {
    return ObjectFieldPersist(
      id: id is int? ? id : this.id,
      normal: normal ?? this.normal,
      api: api is String? ? api : this.api,
      data: data is _i2.SimpleData? ? data : this.data?.copyWith(),
    );
  }
}

class ObjectFieldPersistTable extends _i1.Table {
  ObjectFieldPersistTable({super.tableRelation})
      : super(tableName: 'object_field_persist') {
    normal = _i1.ColumnString(
      'normal',
      this,
    );
  }

  late final _i1.ColumnString normal;

  @override
  List<_i1.Column> get columns => [
        id,
        normal,
      ];
}

class ObjectFieldPersistInclude extends _i1.IncludeObject {
  ObjectFieldPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectFieldPersist.t;
}

class ObjectFieldPersistIncludeList extends _i1.IncludeList {
  ObjectFieldPersistIncludeList._({
    _i1.WhereExpressionBuilder<ObjectFieldPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectFieldPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectFieldPersist.t;
}

class ObjectFieldPersistRepository {
  const ObjectFieldPersistRepository._();

  /// Returns a list of [ObjectFieldPersist]s matching the given query parameters.
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
  Future<List<ObjectFieldPersist>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectFieldPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectFieldPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectFieldPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectFieldPersist>(
      where: where?.call(ObjectFieldPersist.t),
      orderBy: orderBy?.call(ObjectFieldPersist.t),
      orderByList: orderByList?.call(ObjectFieldPersist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ObjectFieldPersist] matching the given query parameters.
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
  Future<ObjectFieldPersist?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectFieldPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectFieldPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectFieldPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectFieldPersist>(
      where: where?.call(ObjectFieldPersist.t),
      orderBy: orderBy?.call(ObjectFieldPersist.t),
      orderByList: orderByList?.call(ObjectFieldPersist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectFieldPersist] by its [id] or null if no such row exists.
  Future<ObjectFieldPersist?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectFieldPersist>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectFieldPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectFieldPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectFieldPersist>> insert(
    _i1.Session session,
    List<ObjectFieldPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectFieldPersist>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectFieldPersist] and returns the inserted row.
  ///
  /// The returned [ObjectFieldPersist] will have its `id` field set.
  Future<ObjectFieldPersist> insertRow(
    _i1.Session session,
    ObjectFieldPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectFieldPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectFieldPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectFieldPersist>> update(
    _i1.Session session,
    List<ObjectFieldPersist> rows, {
    _i1.ColumnSelections<ObjectFieldPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectFieldPersist>(
      rows,
      columns: columns?.call(ObjectFieldPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectFieldPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectFieldPersist> updateRow(
    _i1.Session session,
    ObjectFieldPersist row, {
    _i1.ColumnSelections<ObjectFieldPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectFieldPersist>(
      row,
      columns: columns?.call(ObjectFieldPersist.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectFieldPersist]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectFieldPersist>> delete(
    _i1.Session session,
    List<ObjectFieldPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectFieldPersist>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectFieldPersist].
  Future<ObjectFieldPersist> deleteRow(
    _i1.Session session,
    ObjectFieldPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectFieldPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectFieldPersist>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectFieldPersistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectFieldPersist>(
      where: where(ObjectFieldPersist.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectFieldPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectFieldPersist>(
      where: where?.call(ObjectFieldPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

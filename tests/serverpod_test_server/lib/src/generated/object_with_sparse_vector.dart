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

abstract class ObjectWithSparseVector
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithSparseVector._({
    this.id,
    required this.sparseVector,
    this.sparseVectorNullable,
    required this.sparseVectorIndexedHnsw,
    required this.sparseVectorIndexedHnswWithParams,
  });

  factory ObjectWithSparseVector({
    int? id,
    required _i1.SparseVector sparseVector,
    _i1.SparseVector? sparseVectorNullable,
    required _i1.SparseVector sparseVectorIndexedHnsw,
    required _i1.SparseVector sparseVectorIndexedHnswWithParams,
  }) = _ObjectWithSparseVectorImpl;

  factory ObjectWithSparseVector.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ObjectWithSparseVector(
      id: jsonSerialization['id'] as int?,
      sparseVector: _i1.SparseVectorJsonExtension.fromJson(
          jsonSerialization['sparseVector']),
      sparseVectorNullable: jsonSerialization['sparseVectorNullable'] == null
          ? null
          : _i1.SparseVectorJsonExtension.fromJson(
              jsonSerialization['sparseVectorNullable']),
      sparseVectorIndexedHnsw: _i1.SparseVectorJsonExtension.fromJson(
          jsonSerialization['sparseVectorIndexedHnsw']),
      sparseVectorIndexedHnswWithParams: _i1.SparseVectorJsonExtension.fromJson(
          jsonSerialization['sparseVectorIndexedHnswWithParams']),
    );
  }

  static final t = ObjectWithSparseVectorTable();

  static const db = ObjectWithSparseVectorRepository._();

  @override
  int? id;

  _i1.SparseVector sparseVector;

  _i1.SparseVector? sparseVectorNullable;

  _i1.SparseVector sparseVectorIndexedHnsw;

  _i1.SparseVector sparseVectorIndexedHnswWithParams;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithSparseVector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithSparseVector copyWith({
    int? id,
    _i1.SparseVector? sparseVector,
    _i1.SparseVector? sparseVectorNullable,
    _i1.SparseVector? sparseVectorIndexedHnsw,
    _i1.SparseVector? sparseVectorIndexedHnswWithParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sparseVector': sparseVector.toJson(),
      if (sparseVectorNullable != null)
        'sparseVectorNullable': sparseVectorNullable?.toJson(),
      'sparseVectorIndexedHnsw': sparseVectorIndexedHnsw.toJson(),
      'sparseVectorIndexedHnswWithParams':
          sparseVectorIndexedHnswWithParams.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'sparseVector': sparseVector.toJson(),
      if (sparseVectorNullable != null)
        'sparseVectorNullable': sparseVectorNullable?.toJson(),
      'sparseVectorIndexedHnsw': sparseVectorIndexedHnsw.toJson(),
      'sparseVectorIndexedHnswWithParams':
          sparseVectorIndexedHnswWithParams.toJson(),
    };
  }

  static ObjectWithSparseVectorInclude include() {
    return ObjectWithSparseVectorInclude._();
  }

  static ObjectWithSparseVectorIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithSparseVectorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithSparseVectorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithSparseVectorTable>? orderByList,
    ObjectWithSparseVectorInclude? include,
  }) {
    return ObjectWithSparseVectorIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithSparseVector.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithSparseVector.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithSparseVectorImpl extends ObjectWithSparseVector {
  _ObjectWithSparseVectorImpl({
    int? id,
    required _i1.SparseVector sparseVector,
    _i1.SparseVector? sparseVectorNullable,
    required _i1.SparseVector sparseVectorIndexedHnsw,
    required _i1.SparseVector sparseVectorIndexedHnswWithParams,
  }) : super._(
          id: id,
          sparseVector: sparseVector,
          sparseVectorNullable: sparseVectorNullable,
          sparseVectorIndexedHnsw: sparseVectorIndexedHnsw,
          sparseVectorIndexedHnswWithParams: sparseVectorIndexedHnswWithParams,
        );

  /// Returns a shallow copy of this [ObjectWithSparseVector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithSparseVector copyWith({
    Object? id = _Undefined,
    _i1.SparseVector? sparseVector,
    Object? sparseVectorNullable = _Undefined,
    _i1.SparseVector? sparseVectorIndexedHnsw,
    _i1.SparseVector? sparseVectorIndexedHnswWithParams,
  }) {
    return ObjectWithSparseVector(
      id: id is int? ? id : this.id,
      sparseVector: sparseVector ?? this.sparseVector.clone(),
      sparseVectorNullable: sparseVectorNullable is _i1.SparseVector?
          ? sparseVectorNullable
          : this.sparseVectorNullable?.clone(),
      sparseVectorIndexedHnsw:
          sparseVectorIndexedHnsw ?? this.sparseVectorIndexedHnsw.clone(),
      sparseVectorIndexedHnswWithParams: sparseVectorIndexedHnswWithParams ??
          this.sparseVectorIndexedHnswWithParams.clone(),
    );
  }
}

class ObjectWithSparseVectorTable extends _i1.Table<int?> {
  ObjectWithSparseVectorTable({super.tableRelation})
      : super(tableName: 'object_with_sparse_vector') {
    sparseVector = _i1.ColumnSparseVector(
      'sparseVector',
      this,
      dimension: 512,
    );
    sparseVectorNullable = _i1.ColumnSparseVector(
      'sparseVectorNullable',
      this,
      dimension: 512,
    );
    sparseVectorIndexedHnsw = _i1.ColumnSparseVector(
      'sparseVectorIndexedHnsw',
      this,
      dimension: 512,
    );
    sparseVectorIndexedHnswWithParams = _i1.ColumnSparseVector(
      'sparseVectorIndexedHnswWithParams',
      this,
      dimension: 512,
    );
  }

  late final _i1.ColumnSparseVector sparseVector;

  late final _i1.ColumnSparseVector sparseVectorNullable;

  late final _i1.ColumnSparseVector sparseVectorIndexedHnsw;

  late final _i1.ColumnSparseVector sparseVectorIndexedHnswWithParams;

  @override
  List<_i1.Column> get columns => [
        id,
        sparseVector,
        sparseVectorNullable,
        sparseVectorIndexedHnsw,
        sparseVectorIndexedHnswWithParams,
      ];
}

class ObjectWithSparseVectorInclude extends _i1.IncludeObject {
  ObjectWithSparseVectorInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithSparseVector.t;
}

class ObjectWithSparseVectorIncludeList extends _i1.IncludeList {
  ObjectWithSparseVectorIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithSparseVectorTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithSparseVector.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithSparseVector.t;
}

class ObjectWithSparseVectorRepository {
  const ObjectWithSparseVectorRepository._();

  /// Returns a list of [ObjectWithSparseVector]s matching the given query parameters.
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
  Future<List<ObjectWithSparseVector>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithSparseVectorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithSparseVectorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithSparseVectorTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithSparseVector>(
      where: where?.call(ObjectWithSparseVector.t),
      orderBy: orderBy?.call(ObjectWithSparseVector.t),
      orderByList: orderByList?.call(ObjectWithSparseVector.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ObjectWithSparseVector] matching the given query parameters.
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
  Future<ObjectWithSparseVector?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithSparseVectorTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithSparseVectorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithSparseVectorTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithSparseVector>(
      where: where?.call(ObjectWithSparseVector.t),
      orderBy: orderBy?.call(ObjectWithSparseVector.t),
      orderByList: orderByList?.call(ObjectWithSparseVector.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectWithSparseVector] by its [id] or null if no such row exists.
  Future<ObjectWithSparseVector?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithSparseVector>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectWithSparseVector]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithSparseVector]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectWithSparseVector>> insert(
    _i1.Session session,
    List<ObjectWithSparseVector> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithSparseVector>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectWithSparseVector] and returns the inserted row.
  ///
  /// The returned [ObjectWithSparseVector] will have its `id` field set.
  Future<ObjectWithSparseVector> insertRow(
    _i1.Session session,
    ObjectWithSparseVector row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithSparseVector>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithSparseVector]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithSparseVector>> update(
    _i1.Session session,
    List<ObjectWithSparseVector> rows, {
    _i1.ColumnSelections<ObjectWithSparseVectorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithSparseVector>(
      rows,
      columns: columns?.call(ObjectWithSparseVector.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithSparseVector]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithSparseVector> updateRow(
    _i1.Session session,
    ObjectWithSparseVector row, {
    _i1.ColumnSelections<ObjectWithSparseVectorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithSparseVector>(
      row,
      columns: columns?.call(ObjectWithSparseVector.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithSparseVector]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithSparseVector>> delete(
    _i1.Session session,
    List<ObjectWithSparseVector> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithSparseVector>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithSparseVector].
  Future<ObjectWithSparseVector> deleteRow(
    _i1.Session session,
    ObjectWithSparseVector row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithSparseVector>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithSparseVector>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithSparseVectorTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithSparseVector>(
      where: where(ObjectWithSparseVector.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithSparseVectorTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithSparseVector>(
      where: where?.call(ObjectWithSparseVector.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

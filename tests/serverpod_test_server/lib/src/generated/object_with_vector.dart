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

abstract class ObjectWithVector
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithVector._({
    this.id,
    required this.vector,
    this.vectorNullable,
    required this.vectorIndexedHnsw,
    required this.vectorIndexedHnswWithParams,
    required this.vectorIndexedIvfflat,
    required this.vectorIndexedIvfflatWithParams,
  });

  factory ObjectWithVector({
    int? id,
    required _i1.Vector vector,
    _i1.Vector? vectorNullable,
    required _i1.Vector vectorIndexedHnsw,
    required _i1.Vector vectorIndexedHnswWithParams,
    required _i1.Vector vectorIndexedIvfflat,
    required _i1.Vector vectorIndexedIvfflatWithParams,
  }) = _ObjectWithVectorImpl;

  factory ObjectWithVector.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithVector(
      id: jsonSerialization['id'] as int?,
      vector: _i1.VectorJsonExtension.fromJson(jsonSerialization['vector']),
      vectorNullable: jsonSerialization['vectorNullable'] == null
          ? null
          : _i1.VectorJsonExtension.fromJson(
              jsonSerialization['vectorNullable']),
      vectorIndexedHnsw: _i1.VectorJsonExtension.fromJson(
          jsonSerialization['vectorIndexedHnsw']),
      vectorIndexedHnswWithParams: _i1.VectorJsonExtension.fromJson(
          jsonSerialization['vectorIndexedHnswWithParams']),
      vectorIndexedIvfflat: _i1.VectorJsonExtension.fromJson(
          jsonSerialization['vectorIndexedIvfflat']),
      vectorIndexedIvfflatWithParams: _i1.VectorJsonExtension.fromJson(
          jsonSerialization['vectorIndexedIvfflatWithParams']),
    );
  }

  static final t = ObjectWithVectorTable();

  static const db = ObjectWithVectorRepository._();

  @override
  int? id;

  _i1.Vector vector;

  _i1.Vector? vectorNullable;

  _i1.Vector vectorIndexedHnsw;

  _i1.Vector vectorIndexedHnswWithParams;

  _i1.Vector vectorIndexedIvfflat;

  _i1.Vector vectorIndexedIvfflatWithParams;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithVector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithVector copyWith({
    int? id,
    _i1.Vector? vector,
    _i1.Vector? vectorNullable,
    _i1.Vector? vectorIndexedHnsw,
    _i1.Vector? vectorIndexedHnswWithParams,
    _i1.Vector? vectorIndexedIvfflat,
    _i1.Vector? vectorIndexedIvfflatWithParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'vector': vector.toJson(),
      if (vectorNullable != null) 'vectorNullable': vectorNullable?.toJson(),
      'vectorIndexedHnsw': vectorIndexedHnsw.toJson(),
      'vectorIndexedHnswWithParams': vectorIndexedHnswWithParams.toJson(),
      'vectorIndexedIvfflat': vectorIndexedIvfflat.toJson(),
      'vectorIndexedIvfflatWithParams': vectorIndexedIvfflatWithParams.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'vector': vector.toJson(),
      if (vectorNullable != null) 'vectorNullable': vectorNullable?.toJson(),
      'vectorIndexedHnsw': vectorIndexedHnsw.toJson(),
      'vectorIndexedHnswWithParams': vectorIndexedHnswWithParams.toJson(),
      'vectorIndexedIvfflat': vectorIndexedIvfflat.toJson(),
      'vectorIndexedIvfflatWithParams': vectorIndexedIvfflatWithParams.toJson(),
    };
  }

  static ObjectWithVectorInclude include() {
    return ObjectWithVectorInclude._();
  }

  static ObjectWithVectorIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithVectorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithVectorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithVectorTable>? orderByList,
    ObjectWithVectorInclude? include,
  }) {
    return ObjectWithVectorIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithVector.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithVector.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithVectorImpl extends ObjectWithVector {
  _ObjectWithVectorImpl({
    int? id,
    required _i1.Vector vector,
    _i1.Vector? vectorNullable,
    required _i1.Vector vectorIndexedHnsw,
    required _i1.Vector vectorIndexedHnswWithParams,
    required _i1.Vector vectorIndexedIvfflat,
    required _i1.Vector vectorIndexedIvfflatWithParams,
  }) : super._(
          id: id,
          vector: vector,
          vectorNullable: vectorNullable,
          vectorIndexedHnsw: vectorIndexedHnsw,
          vectorIndexedHnswWithParams: vectorIndexedHnswWithParams,
          vectorIndexedIvfflat: vectorIndexedIvfflat,
          vectorIndexedIvfflatWithParams: vectorIndexedIvfflatWithParams,
        );

  /// Returns a shallow copy of this [ObjectWithVector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithVector copyWith({
    Object? id = _Undefined,
    _i1.Vector? vector,
    Object? vectorNullable = _Undefined,
    _i1.Vector? vectorIndexedHnsw,
    _i1.Vector? vectorIndexedHnswWithParams,
    _i1.Vector? vectorIndexedIvfflat,
    _i1.Vector? vectorIndexedIvfflatWithParams,
  }) {
    return ObjectWithVector(
      id: id is int? ? id : this.id,
      vector: vector ?? this.vector.clone(),
      vectorNullable: vectorNullable is _i1.Vector?
          ? vectorNullable
          : this.vectorNullable?.clone(),
      vectorIndexedHnsw: vectorIndexedHnsw ?? this.vectorIndexedHnsw.clone(),
      vectorIndexedHnswWithParams: vectorIndexedHnswWithParams ??
          this.vectorIndexedHnswWithParams.clone(),
      vectorIndexedIvfflat:
          vectorIndexedIvfflat ?? this.vectorIndexedIvfflat.clone(),
      vectorIndexedIvfflatWithParams: vectorIndexedIvfflatWithParams ??
          this.vectorIndexedIvfflatWithParams.clone(),
    );
  }
}

class ObjectWithVectorTable extends _i1.Table<int?> {
  ObjectWithVectorTable({super.tableRelation})
      : super(tableName: 'object_with_vector') {
    vector = _i1.ColumnVector(
      'vector',
      this,
      dimension: 512,
    );
    vectorNullable = _i1.ColumnVector(
      'vectorNullable',
      this,
      dimension: 512,
    );
    vectorIndexedHnsw = _i1.ColumnVector(
      'vectorIndexedHnsw',
      this,
      dimension: 512,
    );
    vectorIndexedHnswWithParams = _i1.ColumnVector(
      'vectorIndexedHnswWithParams',
      this,
      dimension: 512,
    );
    vectorIndexedIvfflat = _i1.ColumnVector(
      'vectorIndexedIvfflat',
      this,
      dimension: 512,
    );
    vectorIndexedIvfflatWithParams = _i1.ColumnVector(
      'vectorIndexedIvfflatWithParams',
      this,
      dimension: 512,
    );
  }

  late final _i1.ColumnVector vector;

  late final _i1.ColumnVector vectorNullable;

  late final _i1.ColumnVector vectorIndexedHnsw;

  late final _i1.ColumnVector vectorIndexedHnswWithParams;

  late final _i1.ColumnVector vectorIndexedIvfflat;

  late final _i1.ColumnVector vectorIndexedIvfflatWithParams;

  @override
  List<_i1.Column> get columns => [
        id,
        vector,
        vectorNullable,
        vectorIndexedHnsw,
        vectorIndexedHnswWithParams,
        vectorIndexedIvfflat,
        vectorIndexedIvfflatWithParams,
      ];
}

class ObjectWithVectorInclude extends _i1.IncludeObject {
  ObjectWithVectorInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithVector.t;
}

class ObjectWithVectorIncludeList extends _i1.IncludeList {
  ObjectWithVectorIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithVectorTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithVector.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithVector.t;
}

class ObjectWithVectorRepository {
  const ObjectWithVectorRepository._();

  /// Returns a list of [ObjectWithVector]s matching the given query parameters.
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
  Future<List<ObjectWithVector>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithVectorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithVectorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithVectorTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithVector>(
      where: where?.call(ObjectWithVector.t),
      orderBy: orderBy?.call(ObjectWithVector.t),
      orderByList: orderByList?.call(ObjectWithVector.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ObjectWithVector] matching the given query parameters.
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
  Future<ObjectWithVector?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithVectorTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithVectorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithVectorTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithVector>(
      where: where?.call(ObjectWithVector.t),
      orderBy: orderBy?.call(ObjectWithVector.t),
      orderByList: orderByList?.call(ObjectWithVector.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectWithVector] by its [id] or null if no such row exists.
  Future<ObjectWithVector?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithVector>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectWithVector]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithVector]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectWithVector>> insert(
    _i1.Session session,
    List<ObjectWithVector> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithVector>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectWithVector] and returns the inserted row.
  ///
  /// The returned [ObjectWithVector] will have its `id` field set.
  Future<ObjectWithVector> insertRow(
    _i1.Session session,
    ObjectWithVector row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithVector>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithVector]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithVector>> update(
    _i1.Session session,
    List<ObjectWithVector> rows, {
    _i1.ColumnSelections<ObjectWithVectorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithVector>(
      rows,
      columns: columns?.call(ObjectWithVector.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithVector]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithVector> updateRow(
    _i1.Session session,
    ObjectWithVector row, {
    _i1.ColumnSelections<ObjectWithVectorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithVector>(
      row,
      columns: columns?.call(ObjectWithVector.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithVector]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithVector>> delete(
    _i1.Session session,
    List<ObjectWithVector> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithVector>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithVector].
  Future<ObjectWithVector> deleteRow(
    _i1.Session session,
    ObjectWithVector row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithVector>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithVector>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithVectorTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithVector>(
      where: where(ObjectWithVector.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithVectorTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithVector>(
      where: where?.call(ObjectWithVector.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

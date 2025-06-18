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

abstract class ObjectWithHalfVector
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithHalfVector._({
    this.id,
    required this.halfVector,
    this.halfVectorNullable,
    required this.halfVectorIndexedHnsw,
    required this.halfVectorIndexedHnswWithParams,
    required this.halfVectorIndexedIvfflat,
    required this.halfVectorIndexedIvfflatWithParams,
  });

  factory ObjectWithHalfVector({
    int? id,
    required _i1.HalfVector halfVector,
    _i1.HalfVector? halfVectorNullable,
    required _i1.HalfVector halfVectorIndexedHnsw,
    required _i1.HalfVector halfVectorIndexedHnswWithParams,
    required _i1.HalfVector halfVectorIndexedIvfflat,
    required _i1.HalfVector halfVectorIndexedIvfflatWithParams,
  }) = _ObjectWithHalfVectorImpl;

  factory ObjectWithHalfVector.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ObjectWithHalfVector(
      id: jsonSerialization['id'] as int?,
      halfVector:
          _i1.HalfVectorJsonExtension.fromJson(jsonSerialization['halfVector']),
      halfVectorNullable: jsonSerialization['halfVectorNullable'] == null
          ? null
          : _i1.HalfVectorJsonExtension.fromJson(
              jsonSerialization['halfVectorNullable']),
      halfVectorIndexedHnsw: _i1.HalfVectorJsonExtension.fromJson(
          jsonSerialization['halfVectorIndexedHnsw']),
      halfVectorIndexedHnswWithParams: _i1.HalfVectorJsonExtension.fromJson(
          jsonSerialization['halfVectorIndexedHnswWithParams']),
      halfVectorIndexedIvfflat: _i1.HalfVectorJsonExtension.fromJson(
          jsonSerialization['halfVectorIndexedIvfflat']),
      halfVectorIndexedIvfflatWithParams: _i1.HalfVectorJsonExtension.fromJson(
          jsonSerialization['halfVectorIndexedIvfflatWithParams']),
    );
  }

  static final t = ObjectWithHalfVectorTable();

  static const db = ObjectWithHalfVectorRepository._();

  @override
  int? id;

  _i1.HalfVector halfVector;

  _i1.HalfVector? halfVectorNullable;

  _i1.HalfVector halfVectorIndexedHnsw;

  _i1.HalfVector halfVectorIndexedHnswWithParams;

  _i1.HalfVector halfVectorIndexedIvfflat;

  _i1.HalfVector halfVectorIndexedIvfflatWithParams;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithHalfVector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithHalfVector copyWith({
    int? id,
    _i1.HalfVector? halfVector,
    _i1.HalfVector? halfVectorNullable,
    _i1.HalfVector? halfVectorIndexedHnsw,
    _i1.HalfVector? halfVectorIndexedHnswWithParams,
    _i1.HalfVector? halfVectorIndexedIvfflat,
    _i1.HalfVector? halfVectorIndexedIvfflatWithParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'halfVector': halfVector.toJson(),
      if (halfVectorNullable != null)
        'halfVectorNullable': halfVectorNullable?.toJson(),
      'halfVectorIndexedHnsw': halfVectorIndexedHnsw.toJson(),
      'halfVectorIndexedHnswWithParams':
          halfVectorIndexedHnswWithParams.toJson(),
      'halfVectorIndexedIvfflat': halfVectorIndexedIvfflat.toJson(),
      'halfVectorIndexedIvfflatWithParams':
          halfVectorIndexedIvfflatWithParams.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'halfVector': halfVector.toJson(),
      if (halfVectorNullable != null)
        'halfVectorNullable': halfVectorNullable?.toJson(),
      'halfVectorIndexedHnsw': halfVectorIndexedHnsw.toJson(),
      'halfVectorIndexedHnswWithParams':
          halfVectorIndexedHnswWithParams.toJson(),
      'halfVectorIndexedIvfflat': halfVectorIndexedIvfflat.toJson(),
      'halfVectorIndexedIvfflatWithParams':
          halfVectorIndexedIvfflatWithParams.toJson(),
    };
  }

  static ObjectWithHalfVectorInclude include() {
    return ObjectWithHalfVectorInclude._();
  }

  static ObjectWithHalfVectorIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithHalfVectorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithHalfVectorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithHalfVectorTable>? orderByList,
    ObjectWithHalfVectorInclude? include,
  }) {
    return ObjectWithHalfVectorIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithHalfVector.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithHalfVector.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithHalfVectorImpl extends ObjectWithHalfVector {
  _ObjectWithHalfVectorImpl({
    int? id,
    required _i1.HalfVector halfVector,
    _i1.HalfVector? halfVectorNullable,
    required _i1.HalfVector halfVectorIndexedHnsw,
    required _i1.HalfVector halfVectorIndexedHnswWithParams,
    required _i1.HalfVector halfVectorIndexedIvfflat,
    required _i1.HalfVector halfVectorIndexedIvfflatWithParams,
  }) : super._(
          id: id,
          halfVector: halfVector,
          halfVectorNullable: halfVectorNullable,
          halfVectorIndexedHnsw: halfVectorIndexedHnsw,
          halfVectorIndexedHnswWithParams: halfVectorIndexedHnswWithParams,
          halfVectorIndexedIvfflat: halfVectorIndexedIvfflat,
          halfVectorIndexedIvfflatWithParams:
              halfVectorIndexedIvfflatWithParams,
        );

  /// Returns a shallow copy of this [ObjectWithHalfVector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithHalfVector copyWith({
    Object? id = _Undefined,
    _i1.HalfVector? halfVector,
    Object? halfVectorNullable = _Undefined,
    _i1.HalfVector? halfVectorIndexedHnsw,
    _i1.HalfVector? halfVectorIndexedHnswWithParams,
    _i1.HalfVector? halfVectorIndexedIvfflat,
    _i1.HalfVector? halfVectorIndexedIvfflatWithParams,
  }) {
    return ObjectWithHalfVector(
      id: id is int? ? id : this.id,
      halfVector: halfVector ?? this.halfVector.clone(),
      halfVectorNullable: halfVectorNullable is _i1.HalfVector?
          ? halfVectorNullable
          : this.halfVectorNullable?.clone(),
      halfVectorIndexedHnsw:
          halfVectorIndexedHnsw ?? this.halfVectorIndexedHnsw.clone(),
      halfVectorIndexedHnswWithParams: halfVectorIndexedHnswWithParams ??
          this.halfVectorIndexedHnswWithParams.clone(),
      halfVectorIndexedIvfflat:
          halfVectorIndexedIvfflat ?? this.halfVectorIndexedIvfflat.clone(),
      halfVectorIndexedIvfflatWithParams: halfVectorIndexedIvfflatWithParams ??
          this.halfVectorIndexedIvfflatWithParams.clone(),
    );
  }
}

class ObjectWithHalfVectorTable extends _i1.Table<int?> {
  ObjectWithHalfVectorTable({super.tableRelation})
      : super(tableName: 'object_with_half_vector') {
    halfVector = _i1.ColumnHalfVector(
      'halfVector',
      this,
      dimension: 512,
    );
    halfVectorNullable = _i1.ColumnHalfVector(
      'halfVectorNullable',
      this,
      dimension: 512,
    );
    halfVectorIndexedHnsw = _i1.ColumnHalfVector(
      'halfVectorIndexedHnsw',
      this,
      dimension: 512,
    );
    halfVectorIndexedHnswWithParams = _i1.ColumnHalfVector(
      'halfVectorIndexedHnswWithParams',
      this,
      dimension: 512,
    );
    halfVectorIndexedIvfflat = _i1.ColumnHalfVector(
      'halfVectorIndexedIvfflat',
      this,
      dimension: 512,
    );
    halfVectorIndexedIvfflatWithParams = _i1.ColumnHalfVector(
      'halfVectorIndexedIvfflatWithParams',
      this,
      dimension: 512,
    );
  }

  late final _i1.ColumnHalfVector halfVector;

  late final _i1.ColumnHalfVector halfVectorNullable;

  late final _i1.ColumnHalfVector halfVectorIndexedHnsw;

  late final _i1.ColumnHalfVector halfVectorIndexedHnswWithParams;

  late final _i1.ColumnHalfVector halfVectorIndexedIvfflat;

  late final _i1.ColumnHalfVector halfVectorIndexedIvfflatWithParams;

  @override
  List<_i1.Column> get columns => [
        id,
        halfVector,
        halfVectorNullable,
        halfVectorIndexedHnsw,
        halfVectorIndexedHnswWithParams,
        halfVectorIndexedIvfflat,
        halfVectorIndexedIvfflatWithParams,
      ];
}

class ObjectWithHalfVectorInclude extends _i1.IncludeObject {
  ObjectWithHalfVectorInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithHalfVector.t;
}

class ObjectWithHalfVectorIncludeList extends _i1.IncludeList {
  ObjectWithHalfVectorIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithHalfVectorTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithHalfVector.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithHalfVector.t;
}

class ObjectWithHalfVectorRepository {
  const ObjectWithHalfVectorRepository._();

  /// Returns a list of [ObjectWithHalfVector]s matching the given query parameters.
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
  Future<List<ObjectWithHalfVector>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithHalfVectorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithHalfVectorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithHalfVectorTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithHalfVector>(
      where: where?.call(ObjectWithHalfVector.t),
      orderBy: orderBy?.call(ObjectWithHalfVector.t),
      orderByList: orderByList?.call(ObjectWithHalfVector.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ObjectWithHalfVector] matching the given query parameters.
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
  Future<ObjectWithHalfVector?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithHalfVectorTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithHalfVectorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithHalfVectorTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithHalfVector>(
      where: where?.call(ObjectWithHalfVector.t),
      orderBy: orderBy?.call(ObjectWithHalfVector.t),
      orderByList: orderByList?.call(ObjectWithHalfVector.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectWithHalfVector] by its [id] or null if no such row exists.
  Future<ObjectWithHalfVector?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithHalfVector>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectWithHalfVector]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithHalfVector]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectWithHalfVector>> insert(
    _i1.Session session,
    List<ObjectWithHalfVector> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithHalfVector>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectWithHalfVector] and returns the inserted row.
  ///
  /// The returned [ObjectWithHalfVector] will have its `id` field set.
  Future<ObjectWithHalfVector> insertRow(
    _i1.Session session,
    ObjectWithHalfVector row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithHalfVector>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithHalfVector]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithHalfVector>> update(
    _i1.Session session,
    List<ObjectWithHalfVector> rows, {
    _i1.ColumnSelections<ObjectWithHalfVectorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithHalfVector>(
      rows,
      columns: columns?.call(ObjectWithHalfVector.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithHalfVector]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithHalfVector> updateRow(
    _i1.Session session,
    ObjectWithHalfVector row, {
    _i1.ColumnSelections<ObjectWithHalfVectorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithHalfVector>(
      row,
      columns: columns?.call(ObjectWithHalfVector.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithHalfVector]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithHalfVector>> delete(
    _i1.Session session,
    List<ObjectWithHalfVector> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithHalfVector>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithHalfVector].
  Future<ObjectWithHalfVector> deleteRow(
    _i1.Session session,
    ObjectWithHalfVector row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithHalfVector>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithHalfVector>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithHalfVectorTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithHalfVector>(
      where: where(ObjectWithHalfVector.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithHalfVectorTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithHalfVector>(
      where: where?.call(ObjectWithHalfVector.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

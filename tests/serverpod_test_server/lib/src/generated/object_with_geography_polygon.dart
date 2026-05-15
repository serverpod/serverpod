/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ObjectWithGeographyPolygon
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithGeographyPolygon._({
    this.id,
    required this.polygon,
    this.polygonNullable,
  });

  factory ObjectWithGeographyPolygon({
    int? id,
    required _i1.GeographyPolygon polygon,
    _i1.GeographyPolygon? polygonNullable,
  }) = _ObjectWithGeographyPolygonImpl;

  factory ObjectWithGeographyPolygon.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyPolygon(
      id: jsonSerialization['id'] as int?,
      polygon: _i1.GeographyPolygonJsonExtension.fromJson(
        jsonSerialization['polygon'],
      ),
      polygonNullable: jsonSerialization['polygonNullable'] == null
          ? null
          : _i1.GeographyPolygonJsonExtension.fromJson(
              jsonSerialization['polygonNullable'],
            ),
    );
  }

  static final t = ObjectWithGeographyPolygonTable();

  static const db = ObjectWithGeographyPolygonRepository._();

  @override
  int? id;

  _i1.GeographyPolygon polygon;

  _i1.GeographyPolygon? polygonNullable;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithGeographyPolygon]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithGeographyPolygon copyWith({
    int? id,
    _i1.GeographyPolygon? polygon,
    _i1.GeographyPolygon? polygonNullable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithGeographyPolygon',
      if (id != null) 'id': id,
      'polygon': polygon.toJson(),
      if (polygonNullable != null) 'polygonNullable': polygonNullable?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithGeographyPolygon',
      if (id != null) 'id': id,
      'polygon': polygon.toJson(),
      if (polygonNullable != null) 'polygonNullable': polygonNullable?.toJson(),
    };
  }

  static ObjectWithGeographyPolygonInclude include() {
    return ObjectWithGeographyPolygonInclude._();
  }

  static ObjectWithGeographyPolygonIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithGeographyPolygonTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyPolygonTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyPolygonTable>? orderByList,
    ObjectWithGeographyPolygonInclude? include,
  }) {
    return ObjectWithGeographyPolygonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyPolygon.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(ObjectWithGeographyPolygon.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyPolygonImpl extends ObjectWithGeographyPolygon {
  _ObjectWithGeographyPolygonImpl({
    int? id,
    required _i1.GeographyPolygon polygon,
    _i1.GeographyPolygon? polygonNullable,
  }) : super._(
         id: id,
         polygon: polygon,
         polygonNullable: polygonNullable,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyPolygon]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithGeographyPolygon copyWith({
    Object? id = _Undefined,
    _i1.GeographyPolygon? polygon,
    Object? polygonNullable = _Undefined,
  }) {
    return ObjectWithGeographyPolygon(
      id: id is int? ? id : this.id,
      polygon: polygon ?? this.polygon,
      polygonNullable: polygonNullable is _i1.GeographyPolygon?
          ? polygonNullable
          : this.polygonNullable,
    );
  }
}

class ObjectWithGeographyPolygonUpdateTable
    extends _i1.UpdateTable<ObjectWithGeographyPolygonTable> {
  ObjectWithGeographyPolygonUpdateTable(super.table);

  _i1.ColumnValue<_i1.GeographyPolygon, _i1.GeographyPolygon> polygon(
    _i1.GeographyPolygon value,
  ) => _i1.ColumnValue(
    table.polygon,
    value,
  );

  _i1.ColumnValue<_i1.GeographyPolygon, _i1.GeographyPolygon> polygonNullable(
    _i1.GeographyPolygon? value,
  ) => _i1.ColumnValue(
    table.polygonNullable,
    value,
  );
}

class ObjectWithGeographyPolygonTable extends _i1.Table<int?> {
  ObjectWithGeographyPolygonTable({super.tableRelation})
    : super(tableName: 'object_with_geography_polygon') {
    updateTable = ObjectWithGeographyPolygonUpdateTable(this);
    polygon = _i1.ColumnGeographyPolygon(
      'polygon',
      this,
    );
    polygonNullable = _i1.ColumnGeographyPolygon(
      'polygonNullable',
      this,
    );
  }

  late final ObjectWithGeographyPolygonUpdateTable updateTable;

  late final _i1.ColumnGeographyPolygon polygon;

  late final _i1.ColumnGeographyPolygon polygonNullable;

  @override
  List<_i1.Column> get columns => [
    id,
    polygon,
    polygonNullable,
  ];
}

class ObjectWithGeographyPolygonInclude extends _i1.IncludeObject {
  ObjectWithGeographyPolygonInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithGeographyPolygon.t;
}

class ObjectWithGeographyPolygonIncludeList extends _i1.IncludeList {
  ObjectWithGeographyPolygonIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithGeographyPolygonTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithGeographyPolygon.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithGeographyPolygon.t;
}

class ObjectWithGeographyPolygonRepository {
  const ObjectWithGeographyPolygonRepository._();

  /// Returns a list of [ObjectWithGeographyPolygon]s matching the given query parameters.
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
  Future<List<ObjectWithGeographyPolygon>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithGeographyPolygonTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyPolygonTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyPolygonTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithGeographyPolygon>(
      where: where?.call(ObjectWithGeographyPolygon.t),
      orderBy: orderBy?.call(ObjectWithGeographyPolygon.t),
      orderByList: orderByList?.call(ObjectWithGeographyPolygon.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithGeographyPolygon] matching the given query parameters.
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
  Future<ObjectWithGeographyPolygon?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithGeographyPolygonTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyPolygonTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyPolygonTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithGeographyPolygon>(
      where: where?.call(ObjectWithGeographyPolygon.t),
      orderBy: orderBy?.call(ObjectWithGeographyPolygon.t),
      orderByList: orderByList?.call(ObjectWithGeographyPolygon.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithGeographyPolygon] by its [id] or null if no such row exists.
  Future<ObjectWithGeographyPolygon?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithGeographyPolygon>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithGeographyPolygon]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithGeographyPolygon]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ObjectWithGeographyPolygon>> insert(
    _i1.DatabaseSession session,
    List<ObjectWithGeographyPolygon> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ObjectWithGeographyPolygon>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ObjectWithGeographyPolygon] and returns the inserted row.
  ///
  /// The returned [ObjectWithGeographyPolygon] will have its `id` field set.
  Future<ObjectWithGeographyPolygon> insertRow(
    _i1.DatabaseSession session,
    ObjectWithGeographyPolygon row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithGeographyPolygon>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithGeographyPolygon]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithGeographyPolygon>> update(
    _i1.DatabaseSession session,
    List<ObjectWithGeographyPolygon> rows, {
    _i1.ColumnSelections<ObjectWithGeographyPolygonTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithGeographyPolygon>(
      rows,
      columns: columns?.call(ObjectWithGeographyPolygon.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithGeographyPolygon]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithGeographyPolygon> updateRow(
    _i1.DatabaseSession session,
    ObjectWithGeographyPolygon row, {
    _i1.ColumnSelections<ObjectWithGeographyPolygonTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithGeographyPolygon>(
      row,
      columns: columns?.call(ObjectWithGeographyPolygon.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithGeographyPolygon] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithGeographyPolygon?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ObjectWithGeographyPolygonUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithGeographyPolygon>(
      id,
      columnValues: columnValues(ObjectWithGeographyPolygon.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithGeographyPolygon]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ObjectWithGeographyPolygon>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ObjectWithGeographyPolygonUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ObjectWithGeographyPolygonTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyPolygonTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithGeographyPolygonTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ObjectWithGeographyPolygon>(
      columnValues: columnValues(ObjectWithGeographyPolygon.t.updateTable),
      where: where(ObjectWithGeographyPolygon.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyPolygon.t),
      orderByList: orderByList?.call(ObjectWithGeographyPolygon.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithGeographyPolygon]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithGeographyPolygon>> delete(
    _i1.DatabaseSession session,
    List<ObjectWithGeographyPolygon> rows, {
    _i1.OrderByBuilder<ObjectWithGeographyPolygonTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyPolygonTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithGeographyPolygon>(
      rows,
      orderBy: orderBy?.call(ObjectWithGeographyPolygon.t),
      orderByList: orderByList?.call(ObjectWithGeographyPolygon.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithGeographyPolygon].
  Future<ObjectWithGeographyPolygon> deleteRow(
    _i1.DatabaseSession session,
    ObjectWithGeographyPolygon row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithGeographyPolygon>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<ObjectWithGeographyPolygon>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithGeographyPolygonTable> where,
    _i1.OrderByBuilder<ObjectWithGeographyPolygonTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyPolygonTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithGeographyPolygon>(
      where: where(ObjectWithGeographyPolygon.t),
      orderBy: orderBy?.call(ObjectWithGeographyPolygon.t),
      orderByList: orderByList?.call(ObjectWithGeographyPolygon.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithGeographyPolygonTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithGeographyPolygon>(
      where: where?.call(ObjectWithGeographyPolygon.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithGeographyPolygon] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithGeographyPolygonTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithGeographyPolygon>(
      where: where(ObjectWithGeographyPolygon.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

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

abstract class ObjectWithGeographyPoint
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithGeographyPoint._({
    this.id,
    required this.location,
    this.locationNullable,
  });

  factory ObjectWithGeographyPoint({
    int? id,
    required _i1.GeographyPoint location,
    _i1.GeographyPoint? locationNullable,
  }) = _ObjectWithGeographyPointImpl;

  factory ObjectWithGeographyPoint.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyPoint(
      id: jsonSerialization['id'] as int?,
      location: _i1.GeographyPointJsonExtension.fromJson(
        jsonSerialization['location'],
      ),
      locationNullable: jsonSerialization['locationNullable'] == null
          ? null
          : _i1.GeographyPointJsonExtension.fromJson(
              jsonSerialization['locationNullable'],
            ),
    );
  }

  static final t = ObjectWithGeographyPointTable();

  static const db = ObjectWithGeographyPointRepository._();

  @override
  int? id;

  _i1.GeographyPoint location;

  _i1.GeographyPoint? locationNullable;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithGeographyPoint]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithGeographyPoint copyWith({
    int? id,
    _i1.GeographyPoint? location,
    _i1.GeographyPoint? locationNullable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithGeographyPoint',
      if (id != null) 'id': id,
      'location': location.toJson(),
      if (locationNullable != null)
        'locationNullable': locationNullable?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithGeographyPoint',
      if (id != null) 'id': id,
      'location': location.toJson(),
      if (locationNullable != null)
        'locationNullable': locationNullable?.toJson(),
    };
  }

  static ObjectWithGeographyPointInclude include() {
    return ObjectWithGeographyPointInclude._();
  }

  static ObjectWithGeographyPointIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithGeographyPointTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyPointTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyPointTable>? orderByList,
    ObjectWithGeographyPointInclude? include,
  }) {
    return ObjectWithGeographyPointIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyPoint.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(ObjectWithGeographyPoint.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyPointImpl extends ObjectWithGeographyPoint {
  _ObjectWithGeographyPointImpl({
    int? id,
    required _i1.GeographyPoint location,
    _i1.GeographyPoint? locationNullable,
  }) : super._(
         id: id,
         location: location,
         locationNullable: locationNullable,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyPoint]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithGeographyPoint copyWith({
    Object? id = _Undefined,
    _i1.GeographyPoint? location,
    Object? locationNullable = _Undefined,
  }) {
    return ObjectWithGeographyPoint(
      id: id is int? ? id : this.id,
      location: location ?? this.location,
      locationNullable: locationNullable is _i1.GeographyPoint?
          ? locationNullable
          : this.locationNullable,
    );
  }
}

class ObjectWithGeographyPointUpdateTable
    extends _i1.UpdateTable<ObjectWithGeographyPointTable> {
  ObjectWithGeographyPointUpdateTable(super.table);

  _i1.ColumnValue<_i1.GeographyPoint, _i1.GeographyPoint> location(
    _i1.GeographyPoint value,
  ) => _i1.ColumnValue(
    table.location,
    value,
  );

  _i1.ColumnValue<_i1.GeographyPoint, _i1.GeographyPoint> locationNullable(
    _i1.GeographyPoint? value,
  ) => _i1.ColumnValue(
    table.locationNullable,
    value,
  );
}

class ObjectWithGeographyPointTable extends _i1.Table<int?> {
  ObjectWithGeographyPointTable({super.tableRelation})
    : super(tableName: 'object_with_geography_point') {
    updateTable = ObjectWithGeographyPointUpdateTable(this);
    location = _i1.ColumnGeographyPoint(
      'location',
      this,
    );
    locationNullable = _i1.ColumnGeographyPoint(
      'locationNullable',
      this,
    );
  }

  late final ObjectWithGeographyPointUpdateTable updateTable;

  late final _i1.ColumnGeographyPoint location;

  late final _i1.ColumnGeographyPoint locationNullable;

  @override
  List<_i1.Column> get columns => [
    id,
    location,
    locationNullable,
  ];
}

class ObjectWithGeographyPointInclude extends _i1.IncludeObject {
  ObjectWithGeographyPointInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithGeographyPoint.t;
}

class ObjectWithGeographyPointIncludeList extends _i1.IncludeList {
  ObjectWithGeographyPointIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithGeographyPointTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithGeographyPoint.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithGeographyPoint.t;
}

class ObjectWithGeographyPointRepository {
  const ObjectWithGeographyPointRepository._();

  /// Returns a list of [ObjectWithGeographyPoint]s matching the given query parameters.
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
  Future<List<ObjectWithGeographyPoint>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithGeographyPointTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyPointTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyPointTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithGeographyPoint>(
      where: where?.call(ObjectWithGeographyPoint.t),
      orderBy: orderBy?.call(ObjectWithGeographyPoint.t),
      orderByList: orderByList?.call(ObjectWithGeographyPoint.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithGeographyPoint] matching the given query parameters.
  Future<ObjectWithGeographyPoint?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithGeographyPointTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyPointTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyPointTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithGeographyPoint>(
      where: where?.call(ObjectWithGeographyPoint.t),
      orderBy: orderBy?.call(ObjectWithGeographyPoint.t),
      orderByList: orderByList?.call(ObjectWithGeographyPoint.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithGeographyPoint] by its [id] or null if no such row exists.
  Future<ObjectWithGeographyPoint?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithGeographyPoint>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithGeographyPoint]s in the list and returns the inserted rows.
  Future<List<ObjectWithGeographyPoint>> insert(
    _i1.DatabaseSession session,
    List<ObjectWithGeographyPoint> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ObjectWithGeographyPoint>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ObjectWithGeographyPoint] and returns the inserted row.
  Future<ObjectWithGeographyPoint> insertRow(
    _i1.DatabaseSession session,
    ObjectWithGeographyPoint row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithGeographyPoint>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithGeographyPoint]s in the list and returns the updated rows.
  Future<List<ObjectWithGeographyPoint>> update(
    _i1.DatabaseSession session,
    List<ObjectWithGeographyPoint> rows, {
    _i1.ColumnSelections<ObjectWithGeographyPointTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithGeographyPoint>(
      rows,
      columns: columns?.call(ObjectWithGeographyPoint.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithGeographyPoint].
  Future<ObjectWithGeographyPoint> updateRow(
    _i1.DatabaseSession session,
    ObjectWithGeographyPoint row, {
    _i1.ColumnSelections<ObjectWithGeographyPointTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithGeographyPoint>(
      row,
      columns: columns?.call(ObjectWithGeographyPoint.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithGeographyPoint] by its [id] with the specified [columnValues].
  Future<ObjectWithGeographyPoint?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ObjectWithGeographyPointUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithGeographyPoint>(
      id,
      columnValues: columnValues(ObjectWithGeographyPoint.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithGeographyPoint]s matching the [where] expression.
  Future<List<ObjectWithGeographyPoint>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ObjectWithGeographyPointUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ObjectWithGeographyPointTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyPointTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithGeographyPointTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ObjectWithGeographyPoint>(
      columnValues: columnValues(ObjectWithGeographyPoint.t.updateTable),
      where: where(ObjectWithGeographyPoint.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyPoint.t),
      orderByList: orderByList?.call(ObjectWithGeographyPoint.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithGeographyPoint]s in the list and returns the deleted rows.
  Future<List<ObjectWithGeographyPoint>> delete(
    _i1.DatabaseSession session,
    List<ObjectWithGeographyPoint> rows, {
    _i1.OrderByBuilder<ObjectWithGeographyPointTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyPointTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithGeographyPoint>(
      rows,
      orderBy: orderBy?.call(ObjectWithGeographyPoint.t),
      orderByList: orderByList?.call(ObjectWithGeographyPoint.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithGeographyPoint].
  Future<ObjectWithGeographyPoint> deleteRow(
    _i1.DatabaseSession session,
    ObjectWithGeographyPoint row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithGeographyPoint>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithGeographyPoint>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithGeographyPointTable> where,
    _i1.OrderByBuilder<ObjectWithGeographyPointTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyPointTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithGeographyPoint>(
      where: where(ObjectWithGeographyPoint.t),
      orderBy: orderBy?.call(ObjectWithGeographyPoint.t),
      orderByList: orderByList?.call(ObjectWithGeographyPoint.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithGeographyPointTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithGeographyPoint>(
      where: where?.call(ObjectWithGeographyPoint.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithGeographyPoint] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithGeographyPointTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithGeographyPoint>(
      where: where(ObjectWithGeographyPoint.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

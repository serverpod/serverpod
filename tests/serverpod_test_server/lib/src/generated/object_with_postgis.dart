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

abstract class ObjectWithPostgis
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithPostgis._({
    this.id,
    required this.point,
    this.pointNullable,
    required this.lineString,
    this.lineStringNullable,
    required this.polygon,
    this.polygonNullable,
    required this.multiPolygon,
    this.multiPolygonNullable,
  });

  factory ObjectWithPostgis({
    int? id,
    required _i1.GeographyPoint point,
    _i1.GeographyPoint? pointNullable,
    required _i1.GeographyLineString lineString,
    _i1.GeographyLineString? lineStringNullable,
    required _i1.GeographyPolygon polygon,
    _i1.GeographyPolygon? polygonNullable,
    required _i1.GeographyMultiPolygon multiPolygon,
    _i1.GeographyMultiPolygon? multiPolygonNullable,
  }) = _ObjectWithPostgisImpl;

  factory ObjectWithPostgis.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithPostgis(
      id: jsonSerialization['id'] as int?,
      point: _i1.GeographyPointJsonExtension.fromJson(
        jsonSerialization['point'],
      ),
      pointNullable: jsonSerialization['pointNullable'] == null
          ? null
          : _i1.GeographyPointJsonExtension.fromJson(
              jsonSerialization['pointNullable'],
            ),
      lineString: _i1.GeographyLineStringJsonExtension.fromJson(
        jsonSerialization['lineString'],
      ),
      lineStringNullable: jsonSerialization['lineStringNullable'] == null
          ? null
          : _i1.GeographyLineStringJsonExtension.fromJson(
              jsonSerialization['lineStringNullable'],
            ),
      polygon: _i1.GeographyPolygonJsonExtension.fromJson(
        jsonSerialization['polygon'],
      ),
      polygonNullable: jsonSerialization['polygonNullable'] == null
          ? null
          : _i1.GeographyPolygonJsonExtension.fromJson(
              jsonSerialization['polygonNullable'],
            ),
      multiPolygon: _i1.GeographyMultiPolygonJsonExtension.fromJson(
        jsonSerialization['multiPolygon'],
      ),
      multiPolygonNullable: jsonSerialization['multiPolygonNullable'] == null
          ? null
          : _i1.GeographyMultiPolygonJsonExtension.fromJson(
              jsonSerialization['multiPolygonNullable'],
            ),
    );
  }

  static final t = ObjectWithPostgisTable();

  static const db = ObjectWithPostgisRepository._();

  @override
  int? id;

  _i1.GeographyPoint point;

  _i1.GeographyPoint? pointNullable;

  _i1.GeographyLineString lineString;

  _i1.GeographyLineString? lineStringNullable;

  _i1.GeographyPolygon polygon;

  _i1.GeographyPolygon? polygonNullable;

  _i1.GeographyMultiPolygon multiPolygon;

  _i1.GeographyMultiPolygon? multiPolygonNullable;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithPostgis]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithPostgis copyWith({
    int? id,
    _i1.GeographyPoint? point,
    _i1.GeographyPoint? pointNullable,
    _i1.GeographyLineString? lineString,
    _i1.GeographyLineString? lineStringNullable,
    _i1.GeographyPolygon? polygon,
    _i1.GeographyPolygon? polygonNullable,
    _i1.GeographyMultiPolygon? multiPolygon,
    _i1.GeographyMultiPolygon? multiPolygonNullable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithPostgis',
      if (id != null) 'id': id,
      'point': point.toJson(),
      if (pointNullable != null) 'pointNullable': pointNullable?.toJson(),
      'lineString': lineString.toJson(),
      if (lineStringNullable != null)
        'lineStringNullable': lineStringNullable?.toJson(),
      'polygon': polygon.toJson(),
      if (polygonNullable != null) 'polygonNullable': polygonNullable?.toJson(),
      'multiPolygon': multiPolygon.toJson(),
      if (multiPolygonNullable != null)
        'multiPolygonNullable': multiPolygonNullable?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithPostgis',
      if (id != null) 'id': id,
      'point': point.toJson(),
      if (pointNullable != null) 'pointNullable': pointNullable?.toJson(),
      'lineString': lineString.toJson(),
      if (lineStringNullable != null)
        'lineStringNullable': lineStringNullable?.toJson(),
      'polygon': polygon.toJson(),
      if (polygonNullable != null) 'polygonNullable': polygonNullable?.toJson(),
      'multiPolygon': multiPolygon.toJson(),
      if (multiPolygonNullable != null)
        'multiPolygonNullable': multiPolygonNullable?.toJson(),
    };
  }

  static ObjectWithPostgisInclude include() {
    return ObjectWithPostgisInclude._();
  }

  static ObjectWithPostgisIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithPostgisTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithPostgisTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithPostgisTable>? orderByList,
    ObjectWithPostgisInclude? include,
  }) {
    return ObjectWithPostgisIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithPostgis.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithPostgis.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithPostgisImpl extends ObjectWithPostgis {
  _ObjectWithPostgisImpl({
    int? id,
    required _i1.GeographyPoint point,
    _i1.GeographyPoint? pointNullable,
    required _i1.GeographyLineString lineString,
    _i1.GeographyLineString? lineStringNullable,
    required _i1.GeographyPolygon polygon,
    _i1.GeographyPolygon? polygonNullable,
    required _i1.GeographyMultiPolygon multiPolygon,
    _i1.GeographyMultiPolygon? multiPolygonNullable,
  }) : super._(
         id: id,
         point: point,
         pointNullable: pointNullable,
         lineString: lineString,
         lineStringNullable: lineStringNullable,
         polygon: polygon,
         polygonNullable: polygonNullable,
         multiPolygon: multiPolygon,
         multiPolygonNullable: multiPolygonNullable,
       );

  /// Returns a shallow copy of this [ObjectWithPostgis]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithPostgis copyWith({
    Object? id = _Undefined,
    _i1.GeographyPoint? point,
    Object? pointNullable = _Undefined,
    _i1.GeographyLineString? lineString,
    Object? lineStringNullable = _Undefined,
    _i1.GeographyPolygon? polygon,
    Object? polygonNullable = _Undefined,
    _i1.GeographyMultiPolygon? multiPolygon,
    Object? multiPolygonNullable = _Undefined,
  }) {
    return ObjectWithPostgis(
      id: id is int? ? id : this.id,
      point: point ?? this.point.copyWith(),
      pointNullable: pointNullable is _i1.GeographyPoint?
          ? pointNullable
          : this.pointNullable?.copyWith(),
      lineString: lineString ?? this.lineString.copyWith(),
      lineStringNullable: lineStringNullable is _i1.GeographyLineString?
          ? lineStringNullable
          : this.lineStringNullable?.copyWith(),
      polygon: polygon ?? this.polygon.copyWith(),
      polygonNullable: polygonNullable is _i1.GeographyPolygon?
          ? polygonNullable
          : this.polygonNullable?.copyWith(),
      multiPolygon: multiPolygon ?? this.multiPolygon.copyWith(),
      multiPolygonNullable: multiPolygonNullable is _i1.GeographyMultiPolygon?
          ? multiPolygonNullable
          : this.multiPolygonNullable?.copyWith(),
    );
  }
}

class ObjectWithPostgisUpdateTable
    extends _i1.UpdateTable<ObjectWithPostgisTable> {
  ObjectWithPostgisUpdateTable(super.table);

  _i1.ColumnValue<_i1.GeographyPoint, _i1.GeographyPoint> point(
    _i1.GeographyPoint value,
  ) => _i1.ColumnValue(
    table.point,
    value,
  );

  _i1.ColumnValue<_i1.GeographyPoint, _i1.GeographyPoint> pointNullable(
    _i1.GeographyPoint? value,
  ) => _i1.ColumnValue(
    table.pointNullable,
    value,
  );

  _i1.ColumnValue<_i1.GeographyLineString, _i1.GeographyLineString> lineString(
    _i1.GeographyLineString value,
  ) => _i1.ColumnValue(
    table.lineString,
    value,
  );

  _i1.ColumnValue<_i1.GeographyLineString, _i1.GeographyLineString>
  lineStringNullable(_i1.GeographyLineString? value) => _i1.ColumnValue(
    table.lineStringNullable,
    value,
  );

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

  _i1.ColumnValue<_i1.GeographyMultiPolygon, _i1.GeographyMultiPolygon>
  multiPolygon(_i1.GeographyMultiPolygon value) => _i1.ColumnValue(
    table.multiPolygon,
    value,
  );

  _i1.ColumnValue<_i1.GeographyMultiPolygon, _i1.GeographyMultiPolygon>
  multiPolygonNullable(_i1.GeographyMultiPolygon? value) => _i1.ColumnValue(
    table.multiPolygonNullable,
    value,
  );
}

class ObjectWithPostgisTable extends _i1.Table<int?> {
  ObjectWithPostgisTable({super.tableRelation})
    : super(tableName: 'object_with_postgis') {
    updateTable = ObjectWithPostgisUpdateTable(this);
    point = _i1.ColumnGeographyPoint(
      'point',
      this,
    );
    pointNullable = _i1.ColumnGeographyPoint(
      'pointNullable',
      this,
    );
    lineString = _i1.ColumnGeographyLineString(
      'lineString',
      this,
    );
    lineStringNullable = _i1.ColumnGeographyLineString(
      'lineStringNullable',
      this,
    );
    polygon = _i1.ColumnGeographyPolygon(
      'polygon',
      this,
    );
    polygonNullable = _i1.ColumnGeographyPolygon(
      'polygonNullable',
      this,
    );
    multiPolygon = _i1.ColumnGeographyMultiPolygon(
      'multiPolygon',
      this,
    );
    multiPolygonNullable = _i1.ColumnGeographyMultiPolygon(
      'multiPolygonNullable',
      this,
    );
  }

  late final ObjectWithPostgisUpdateTable updateTable;

  late final _i1.ColumnGeographyPoint point;

  late final _i1.ColumnGeographyPoint pointNullable;

  late final _i1.ColumnGeographyLineString lineString;

  late final _i1.ColumnGeographyLineString lineStringNullable;

  late final _i1.ColumnGeographyPolygon polygon;

  late final _i1.ColumnGeographyPolygon polygonNullable;

  late final _i1.ColumnGeographyMultiPolygon multiPolygon;

  late final _i1.ColumnGeographyMultiPolygon multiPolygonNullable;

  @override
  List<_i1.Column> get columns => [
    id,
    point,
    pointNullable,
    lineString,
    lineStringNullable,
    polygon,
    polygonNullable,
    multiPolygon,
    multiPolygonNullable,
  ];
}

class ObjectWithPostgisInclude extends _i1.IncludeObject {
  ObjectWithPostgisInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithPostgis.t;
}

class ObjectWithPostgisIncludeList extends _i1.IncludeList {
  ObjectWithPostgisIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithPostgisTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithPostgis.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithPostgis.t;
}

class ObjectWithPostgisRepository {
  const ObjectWithPostgisRepository._();

  /// Returns a list of [ObjectWithPostgis]s matching the given query parameters.
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
  Future<List<ObjectWithPostgis>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithPostgisTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithPostgisTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithPostgisTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithPostgis>(
      where: where?.call(ObjectWithPostgis.t),
      orderBy: orderBy?.call(ObjectWithPostgis.t),
      orderByList: orderByList?.call(ObjectWithPostgis.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ObjectWithPostgis] matching the given query parameters.
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
  Future<ObjectWithPostgis?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithPostgisTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithPostgisTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithPostgisTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithPostgis>(
      where: where?.call(ObjectWithPostgis.t),
      orderBy: orderBy?.call(ObjectWithPostgis.t),
      orderByList: orderByList?.call(ObjectWithPostgis.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectWithPostgis] by its [id] or null if no such row exists.
  Future<ObjectWithPostgis?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithPostgis>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectWithPostgis]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithPostgis]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectWithPostgis>> insert(
    _i1.Session session,
    List<ObjectWithPostgis> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithPostgis>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectWithPostgis] and returns the inserted row.
  ///
  /// The returned [ObjectWithPostgis] will have its `id` field set.
  Future<ObjectWithPostgis> insertRow(
    _i1.Session session,
    ObjectWithPostgis row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithPostgis>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithPostgis]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithPostgis>> update(
    _i1.Session session,
    List<ObjectWithPostgis> rows, {
    _i1.ColumnSelections<ObjectWithPostgisTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithPostgis>(
      rows,
      columns: columns?.call(ObjectWithPostgis.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithPostgis]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithPostgis> updateRow(
    _i1.Session session,
    ObjectWithPostgis row, {
    _i1.ColumnSelections<ObjectWithPostgisTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithPostgis>(
      row,
      columns: columns?.call(ObjectWithPostgis.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithPostgis] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithPostgis?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ObjectWithPostgisUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithPostgis>(
      id,
      columnValues: columnValues(ObjectWithPostgis.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithPostgis]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ObjectWithPostgis>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ObjectWithPostgisUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ObjectWithPostgisTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithPostgisTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithPostgisTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ObjectWithPostgis>(
      columnValues: columnValues(ObjectWithPostgis.t.updateTable),
      where: where(ObjectWithPostgis.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithPostgis.t),
      orderByList: orderByList?.call(ObjectWithPostgis.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithPostgis]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithPostgis>> delete(
    _i1.Session session,
    List<ObjectWithPostgis> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithPostgis>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithPostgis].
  Future<ObjectWithPostgis> deleteRow(
    _i1.Session session,
    ObjectWithPostgis row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithPostgis>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithPostgis>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithPostgisTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithPostgis>(
      where: where(ObjectWithPostgis.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithPostgisTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithPostgis>(
      where: where?.call(ObjectWithPostgis.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

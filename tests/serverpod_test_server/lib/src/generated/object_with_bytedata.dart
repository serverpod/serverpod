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
import 'dart:typed_data' as _i2;

abstract class ObjectWithByteData
    implements _i1.TableRow, _i1.ProtocolSerialization {
  ObjectWithByteData._({
    this.id,
    required this.byteData,
  });

  factory ObjectWithByteData({
    int? id,
    required _i2.ByteData byteData,
  }) = _ObjectWithByteDataImpl;

  factory ObjectWithByteData.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithByteData(
      id: jsonSerialization['id'] as int?,
      byteData:
          _i1.ByteDataJsonExtension.fromJson(jsonSerialization['byteData']),
    );
  }

  static final t = ObjectWithByteDataTable();

  static const db = ObjectWithByteDataRepository._();

  @override
  int? id;

  _i2.ByteData byteData;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [ObjectWithByteData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithByteData copyWith({
    int? id,
    _i2.ByteData? byteData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'byteData': byteData.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'byteData': byteData.toJson(),
    };
  }

  static ObjectWithByteDataInclude include() {
    return ObjectWithByteDataInclude._();
  }

  static ObjectWithByteDataIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    ObjectWithByteDataInclude? include,
  }) {
    return ObjectWithByteDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithByteData.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithByteDataImpl extends ObjectWithByteData {
  _ObjectWithByteDataImpl({
    int? id,
    required _i2.ByteData byteData,
  }) : super._(
          id: id,
          byteData: byteData,
        );

  /// Returns a shallow copy of this [ObjectWithByteData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithByteData copyWith({
    Object? id = _Undefined,
    _i2.ByteData? byteData,
  }) {
    return ObjectWithByteData(
      id: id is int? ? id : this.id,
      byteData: byteData ?? this.byteData.clone(),
    );
  }
}

class ObjectWithByteDataTable extends _i1.Table {
  ObjectWithByteDataTable({super.tableRelation})
      : super(tableName: 'object_with_bytedata') {
    byteData = _i1.ColumnByteData(
      'byteData',
      this,
    );
  }

  late final _i1.ColumnByteData byteData;

  @override
  List<_i1.Column> get columns => [
        id,
        byteData,
      ];
}

class ObjectWithByteDataInclude extends _i1.IncludeObject {
  ObjectWithByteDataInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectWithByteData.t;
}

class ObjectWithByteDataIncludeList extends _i1.IncludeList {
  ObjectWithByteDataIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithByteData.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectWithByteData.t;
}

class ObjectWithByteDataRepository {
  const ObjectWithByteDataRepository._();

  /// Returns a list of [ObjectWithByteData]s matching the given query parameters.
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
  Future<List<ObjectWithByteData>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithByteData>(
      where: where?.call(ObjectWithByteData.t),
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderByList: orderByList?.call(ObjectWithByteData.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ObjectWithByteData] matching the given query parameters.
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
  Future<ObjectWithByteData?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithByteData>(
      where: where?.call(ObjectWithByteData.t),
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderByList: orderByList?.call(ObjectWithByteData.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectWithByteData] by its [id] or null if no such row exists.
  Future<ObjectWithByteData?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithByteData>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectWithByteData]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithByteData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectWithByteData>> insert(
    _i1.Session session,
    List<ObjectWithByteData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithByteData>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectWithByteData] and returns the inserted row.
  ///
  /// The returned [ObjectWithByteData] will have its `id` field set.
  Future<ObjectWithByteData> insertRow(
    _i1.Session session,
    ObjectWithByteData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithByteData>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithByteData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithByteData>> update(
    _i1.Session session,
    List<ObjectWithByteData> rows, {
    _i1.ColumnSelections<ObjectWithByteDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithByteData>(
      rows,
      columns: columns?.call(ObjectWithByteData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithByteData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithByteData> updateRow(
    _i1.Session session,
    ObjectWithByteData row, {
    _i1.ColumnSelections<ObjectWithByteDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithByteData>(
      row,
      columns: columns?.call(ObjectWithByteData.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithByteData]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithByteData>> delete(
    _i1.Session session,
    List<ObjectWithByteData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithByteData>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithByteData].
  Future<ObjectWithByteData> deleteRow(
    _i1.Session session,
    ObjectWithByteData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithByteData>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithByteData>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithByteDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithByteData>(
      where: where(ObjectWithByteData.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithByteData>(
      where: where?.call(ObjectWithByteData.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

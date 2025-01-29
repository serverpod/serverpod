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

/// Information about a server method.
abstract class MethodInfo implements _i1.TableRow, _i1.ProtocolSerialization {
  MethodInfo._({
    this.id,
    required this.endpoint,
    required this.method,
  });

  factory MethodInfo({
    int? id,
    required String endpoint,
    required String method,
  }) = _MethodInfoImpl;

  factory MethodInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return MethodInfo(
      id: jsonSerialization['id'] as int?,
      endpoint: jsonSerialization['endpoint'] as String,
      method: jsonSerialization['method'] as String,
    );
  }

  static final t = MethodInfoTable();

  static const db = MethodInfoRepository._();

  @override
  int? id;

  /// The endpoint of this method.
  String endpoint;

  /// The name of this method.
  String method;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [MethodInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MethodInfo copyWith({
    int? id,
    String? endpoint,
    String? method,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'endpoint': endpoint,
      'method': method,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'endpoint': endpoint,
      'method': method,
    };
  }

  static MethodInfoInclude include() {
    return MethodInfoInclude._();
  }

  static MethodInfoIncludeList includeList({
    _i1.WhereExpressionBuilder<MethodInfoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MethodInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MethodInfoTable>? orderByList,
    MethodInfoInclude? include,
  }) {
    return MethodInfoIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MethodInfo.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MethodInfo.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MethodInfoImpl extends MethodInfo {
  _MethodInfoImpl({
    int? id,
    required String endpoint,
    required String method,
  }) : super._(
          id: id,
          endpoint: endpoint,
          method: method,
        );

  /// Returns a shallow copy of this [MethodInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MethodInfo copyWith({
    Object? id = _Undefined,
    String? endpoint,
    String? method,
  }) {
    return MethodInfo(
      id: id is int? ? id : this.id,
      endpoint: endpoint ?? this.endpoint,
      method: method ?? this.method,
    );
  }
}

class MethodInfoTable extends _i1.Table {
  MethodInfoTable({super.tableRelation})
      : super(tableName: 'serverpod_method') {
    endpoint = _i1.ColumnString(
      'endpoint',
      this,
    );
    method = _i1.ColumnString(
      'method',
      this,
    );
  }

  /// The endpoint of this method.
  late final _i1.ColumnString endpoint;

  /// The name of this method.
  late final _i1.ColumnString method;

  @override
  List<_i1.Column> get columns => [
        id,
        endpoint,
        method,
      ];
}

class MethodInfoInclude extends _i1.IncludeObject {
  MethodInfoInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => MethodInfo.t;
}

class MethodInfoIncludeList extends _i1.IncludeList {
  MethodInfoIncludeList._({
    _i1.WhereExpressionBuilder<MethodInfoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MethodInfo.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => MethodInfo.t;
}

class MethodInfoRepository {
  const MethodInfoRepository._();

  /// Returns a list of [MethodInfo]s matching the given query parameters.
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
  Future<List<MethodInfo>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MethodInfoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MethodInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MethodInfoTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MethodInfo>(
      where: where?.call(MethodInfo.t),
      orderBy: orderBy?.call(MethodInfo.t),
      orderByList: orderByList?.call(MethodInfo.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [MethodInfo] matching the given query parameters.
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
  Future<MethodInfo?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MethodInfoTable>? where,
    int? offset,
    _i1.OrderByBuilder<MethodInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MethodInfoTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MethodInfo>(
      where: where?.call(MethodInfo.t),
      orderBy: orderBy?.call(MethodInfo.t),
      orderByList: orderByList?.call(MethodInfo.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MethodInfo] by its [id] or null if no such row exists.
  Future<MethodInfo?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MethodInfo>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [MethodInfo]s in the list and returns the inserted rows.
  ///
  /// The returned [MethodInfo]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MethodInfo>> insert(
    _i1.Session session,
    List<MethodInfo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MethodInfo>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MethodInfo] and returns the inserted row.
  ///
  /// The returned [MethodInfo] will have its `id` field set.
  Future<MethodInfo> insertRow(
    _i1.Session session,
    MethodInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MethodInfo>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MethodInfo]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MethodInfo>> update(
    _i1.Session session,
    List<MethodInfo> rows, {
    _i1.ColumnSelections<MethodInfoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MethodInfo>(
      rows,
      columns: columns?.call(MethodInfo.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MethodInfo]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MethodInfo> updateRow(
    _i1.Session session,
    MethodInfo row, {
    _i1.ColumnSelections<MethodInfoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MethodInfo>(
      row,
      columns: columns?.call(MethodInfo.t),
      transaction: transaction,
    );
  }

  /// Deletes all [MethodInfo]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MethodInfo>> delete(
    _i1.Session session,
    List<MethodInfo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MethodInfo>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MethodInfo].
  Future<MethodInfo> deleteRow(
    _i1.Session session,
    MethodInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MethodInfo>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MethodInfo>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MethodInfoTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MethodInfo>(
      where: where(MethodInfo.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MethodInfoTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MethodInfo>(
      where: where?.call(MethodInfo.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

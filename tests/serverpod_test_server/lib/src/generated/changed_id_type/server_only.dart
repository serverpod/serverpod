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

abstract class ServerOnlyChangedIdFieldClass
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ServerOnlyChangedIdFieldClass._({this.id});

  factory ServerOnlyChangedIdFieldClass({_i1.UuidValue? id}) =
      _ServerOnlyChangedIdFieldClassImpl;

  factory ServerOnlyChangedIdFieldClass.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ServerOnlyChangedIdFieldClass(
        id: jsonSerialization['id'] == null
            ? null
            : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']));
  }

  static final t = ServerOnlyChangedIdFieldClassTable();

  static const db = ServerOnlyChangedIdFieldClassRepository._();

  @override
  _i1.UuidValue? id;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ServerOnlyChangedIdFieldClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ServerOnlyChangedIdFieldClass copyWith({_i1.UuidValue? id});
  @override
  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id?.toJson()};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ServerOnlyChangedIdFieldClassInclude include() {
    return ServerOnlyChangedIdFieldClassInclude._();
  }

  static ServerOnlyChangedIdFieldClassIncludeList includeList({
    _i1.WhereExpressionBuilder<ServerOnlyChangedIdFieldClassTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServerOnlyChangedIdFieldClassTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServerOnlyChangedIdFieldClassTable>? orderByList,
    ServerOnlyChangedIdFieldClassInclude? include,
  }) {
    return ServerOnlyChangedIdFieldClassIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ServerOnlyChangedIdFieldClass.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ServerOnlyChangedIdFieldClass.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServerOnlyChangedIdFieldClassImpl extends ServerOnlyChangedIdFieldClass {
  _ServerOnlyChangedIdFieldClassImpl({_i1.UuidValue? id}) : super._(id: id);

  /// Returns a shallow copy of this [ServerOnlyChangedIdFieldClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ServerOnlyChangedIdFieldClass copyWith({Object? id = _Undefined}) {
    return ServerOnlyChangedIdFieldClass(
        id: id is _i1.UuidValue? ? id : this.id);
  }
}

class ServerOnlyChangedIdFieldClassUpdateTable
    extends _i1.UpdateTable<ServerOnlyChangedIdFieldClassTable> {
  ServerOnlyChangedIdFieldClassUpdateTable(super.table);
}

class ServerOnlyChangedIdFieldClassTable extends _i1.Table<_i1.UuidValue?> {
  ServerOnlyChangedIdFieldClassTable({super.tableRelation})
      : super(tableName: 'server_only_changed_id_field_class') {
    updateTable = ServerOnlyChangedIdFieldClassUpdateTable(this);
  }

  late final ServerOnlyChangedIdFieldClassUpdateTable updateTable;

  @override
  List<_i1.Column> get columns => [id];
}

class ServerOnlyChangedIdFieldClassInclude extends _i1.IncludeObject {
  ServerOnlyChangedIdFieldClassInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ServerOnlyChangedIdFieldClass.t;
}

class ServerOnlyChangedIdFieldClassIncludeList extends _i1.IncludeList {
  ServerOnlyChangedIdFieldClassIncludeList._({
    _i1.WhereExpressionBuilder<ServerOnlyChangedIdFieldClassTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ServerOnlyChangedIdFieldClass.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ServerOnlyChangedIdFieldClass.t;
}

class ServerOnlyChangedIdFieldClassRepository {
  const ServerOnlyChangedIdFieldClassRepository._();

  /// Returns a list of [ServerOnlyChangedIdFieldClass]s matching the given query parameters.
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
  Future<List<ServerOnlyChangedIdFieldClass>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerOnlyChangedIdFieldClassTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServerOnlyChangedIdFieldClassTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServerOnlyChangedIdFieldClassTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ServerOnlyChangedIdFieldClass>(
      where: where?.call(ServerOnlyChangedIdFieldClass.t),
      orderBy: orderBy?.call(ServerOnlyChangedIdFieldClass.t),
      orderByList: orderByList?.call(ServerOnlyChangedIdFieldClass.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ServerOnlyChangedIdFieldClass] matching the given query parameters.
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
  Future<ServerOnlyChangedIdFieldClass?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerOnlyChangedIdFieldClassTable>? where,
    int? offset,
    _i1.OrderByBuilder<ServerOnlyChangedIdFieldClassTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServerOnlyChangedIdFieldClassTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ServerOnlyChangedIdFieldClass>(
      where: where?.call(ServerOnlyChangedIdFieldClass.t),
      orderBy: orderBy?.call(ServerOnlyChangedIdFieldClass.t),
      orderByList: orderByList?.call(ServerOnlyChangedIdFieldClass.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ServerOnlyChangedIdFieldClass] by its [id] or null if no such row exists.
  Future<ServerOnlyChangedIdFieldClass?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ServerOnlyChangedIdFieldClass>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ServerOnlyChangedIdFieldClass]s in the list and returns the inserted rows.
  ///
  /// The returned [ServerOnlyChangedIdFieldClass]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ServerOnlyChangedIdFieldClass>> insert(
    _i1.Session session,
    List<ServerOnlyChangedIdFieldClass> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ServerOnlyChangedIdFieldClass>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ServerOnlyChangedIdFieldClass] and returns the inserted row.
  ///
  /// The returned [ServerOnlyChangedIdFieldClass] will have its `id` field set.
  Future<ServerOnlyChangedIdFieldClass> insertRow(
    _i1.Session session,
    ServerOnlyChangedIdFieldClass row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ServerOnlyChangedIdFieldClass>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ServerOnlyChangedIdFieldClass]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ServerOnlyChangedIdFieldClass>> update(
    _i1.Session session,
    List<ServerOnlyChangedIdFieldClass> rows, {
    _i1.ColumnSelections<ServerOnlyChangedIdFieldClassTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ServerOnlyChangedIdFieldClass>(
      rows,
      columns: columns?.call(ServerOnlyChangedIdFieldClass.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ServerOnlyChangedIdFieldClass]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ServerOnlyChangedIdFieldClass> updateRow(
    _i1.Session session,
    ServerOnlyChangedIdFieldClass row, {
    _i1.ColumnSelections<ServerOnlyChangedIdFieldClassTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ServerOnlyChangedIdFieldClass>(
      row,
      columns: columns?.call(ServerOnlyChangedIdFieldClass.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ServerOnlyChangedIdFieldClass] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ServerOnlyChangedIdFieldClass?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1
        .ColumnValueListBuilder<ServerOnlyChangedIdFieldClassUpdateTable>
        columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ServerOnlyChangedIdFieldClass>(
      id,
      columnValues: columnValues(ServerOnlyChangedIdFieldClass.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ServerOnlyChangedIdFieldClass]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ServerOnlyChangedIdFieldClass>> updateWhere(
    _i1.Session session, {
    required _i1
        .ColumnValueListBuilder<ServerOnlyChangedIdFieldClassUpdateTable>
        columnValues,
    required _i1.WhereExpressionBuilder<ServerOnlyChangedIdFieldClassTable>
        where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServerOnlyChangedIdFieldClassTable>? orderBy,
    _i1.OrderByListBuilder<ServerOnlyChangedIdFieldClassTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ServerOnlyChangedIdFieldClass>(
      columnValues: columnValues(ServerOnlyChangedIdFieldClass.t.updateTable),
      where: where(ServerOnlyChangedIdFieldClass.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ServerOnlyChangedIdFieldClass.t),
      orderByList: orderByList?.call(ServerOnlyChangedIdFieldClass.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ServerOnlyChangedIdFieldClass]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ServerOnlyChangedIdFieldClass>> delete(
    _i1.Session session,
    List<ServerOnlyChangedIdFieldClass> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ServerOnlyChangedIdFieldClass>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ServerOnlyChangedIdFieldClass].
  Future<ServerOnlyChangedIdFieldClass> deleteRow(
    _i1.Session session,
    ServerOnlyChangedIdFieldClass row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ServerOnlyChangedIdFieldClass>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ServerOnlyChangedIdFieldClass>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ServerOnlyChangedIdFieldClassTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ServerOnlyChangedIdFieldClass>(
      where: where(ServerOnlyChangedIdFieldClass.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerOnlyChangedIdFieldClassTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ServerOnlyChangedIdFieldClass>(
      where: where?.call(ServerOnlyChangedIdFieldClass.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

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

abstract class UriDefault
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UriDefault._({
    this.id,
    Uri? uriDefault,
    Uri? uriDefaultNull,
  }) : uriDefault = uriDefault ?? Uri.parse('https://serverpod.dev/default'),
       uriDefaultNull =
           uriDefaultNull ?? Uri.parse('https://serverpod.dev/default');

  factory UriDefault({
    int? id,
    Uri? uriDefault,
    Uri? uriDefaultNull,
  }) = _UriDefaultImpl;

  factory UriDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return UriDefault(
      id: jsonSerialization['id'] as int?,
      uriDefault: _i1.UriJsonExtension.fromJson(
        jsonSerialization['uriDefault'],
      ),
      uriDefaultNull: jsonSerialization['uriDefaultNull'] == null
          ? null
          : _i1.UriJsonExtension.fromJson(jsonSerialization['uriDefaultNull']),
    );
  }

  static final t = UriDefaultTable();

  static const db = UriDefaultRepository._();

  @override
  int? id;

  Uri uriDefault;

  Uri? uriDefaultNull;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UriDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UriDefault copyWith({
    int? id,
    Uri? uriDefault,
    Uri? uriDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uriDefault': uriDefault.toJson(),
      if (uriDefaultNull != null) 'uriDefaultNull': uriDefaultNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'uriDefault': uriDefault.toJson(),
      if (uriDefaultNull != null) 'uriDefaultNull': uriDefaultNull?.toJson(),
    };
  }

  static UriDefaultInclude include() {
    return UriDefaultInclude._();
  }

  static UriDefaultIncludeList includeList({
    _i1.WhereExpressionBuilder<UriDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UriDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UriDefaultTable>? orderByList,
    UriDefaultInclude? include,
  }) {
    return UriDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UriDefault.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UriDefault.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UriDefaultImpl extends UriDefault {
  _UriDefaultImpl({
    int? id,
    Uri? uriDefault,
    Uri? uriDefaultNull,
  }) : super._(
         id: id,
         uriDefault: uriDefault,
         uriDefaultNull: uriDefaultNull,
       );

  /// Returns a shallow copy of this [UriDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UriDefault copyWith({
    Object? id = _Undefined,
    Uri? uriDefault,
    Object? uriDefaultNull = _Undefined,
  }) {
    return UriDefault(
      id: id is int? ? id : this.id,
      uriDefault: uriDefault ?? this.uriDefault,
      uriDefaultNull: uriDefaultNull is Uri?
          ? uriDefaultNull
          : this.uriDefaultNull,
    );
  }
}

class UriDefaultUpdateTable extends _i1.UpdateTable<UriDefaultTable> {
  UriDefaultUpdateTable(super.table);

  _i1.ColumnValue<Uri, Uri> uriDefault(Uri value) => _i1.ColumnValue(
    table.uriDefault,
    value,
  );

  _i1.ColumnValue<Uri, Uri> uriDefaultNull(Uri? value) => _i1.ColumnValue(
    table.uriDefaultNull,
    value,
  );
}

class UriDefaultTable extends _i1.Table<int?> {
  UriDefaultTable({super.tableRelation}) : super(tableName: 'uri_default') {
    updateTable = UriDefaultUpdateTable(this);
    uriDefault = _i1.ColumnUri(
      'uriDefault',
      this,
      hasDefault: true,
    );
    uriDefaultNull = _i1.ColumnUri(
      'uriDefaultNull',
      this,
      hasDefault: true,
    );
  }

  late final UriDefaultUpdateTable updateTable;

  late final _i1.ColumnUri uriDefault;

  late final _i1.ColumnUri uriDefaultNull;

  @override
  List<_i1.Column> get columns => [
    id,
    uriDefault,
    uriDefaultNull,
  ];
}

class UriDefaultInclude extends _i1.IncludeObject {
  UriDefaultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UriDefault.t;
}

class UriDefaultIncludeList extends _i1.IncludeList {
  UriDefaultIncludeList._({
    _i1.WhereExpressionBuilder<UriDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UriDefault.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UriDefault.t;
}

class UriDefaultRepository {
  const UriDefaultRepository._();

  /// Returns a list of [UriDefault]s matching the given query parameters.
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
  Future<List<UriDefault>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UriDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UriDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UriDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UriDefault>(
      where: where?.call(UriDefault.t),
      orderBy: orderBy?.call(UriDefault.t),
      orderByList: orderByList?.call(UriDefault.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UriDefault] matching the given query parameters.
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
  Future<UriDefault?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UriDefaultTable>? where,
    int? offset,
    _i1.OrderByBuilder<UriDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UriDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UriDefault>(
      where: where?.call(UriDefault.t),
      orderBy: orderBy?.call(UriDefault.t),
      orderByList: orderByList?.call(UriDefault.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UriDefault] by its [id] or null if no such row exists.
  Future<UriDefault?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UriDefault>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UriDefault]s in the list and returns the inserted rows.
  ///
  /// The returned [UriDefault]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UriDefault>> insert(
    _i1.Session session,
    List<UriDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UriDefault>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UriDefault] and returns the inserted row.
  ///
  /// The returned [UriDefault] will have its `id` field set.
  Future<UriDefault> insertRow(
    _i1.Session session,
    UriDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UriDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UriDefault]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UriDefault>> update(
    _i1.Session session,
    List<UriDefault> rows, {
    _i1.ColumnSelections<UriDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UriDefault>(
      rows,
      columns: columns?.call(UriDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UriDefault]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UriDefault> updateRow(
    _i1.Session session,
    UriDefault row, {
    _i1.ColumnSelections<UriDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UriDefault>(
      row,
      columns: columns?.call(UriDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UriDefault] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UriDefault?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UriDefaultUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UriDefault>(
      id,
      columnValues: columnValues(UriDefault.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UriDefault]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UriDefault>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UriDefaultUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UriDefaultTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UriDefaultTable>? orderBy,
    _i1.OrderByListBuilder<UriDefaultTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UriDefault>(
      columnValues: columnValues(UriDefault.t.updateTable),
      where: where(UriDefault.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UriDefault.t),
      orderByList: orderByList?.call(UriDefault.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UriDefault]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UriDefault>> delete(
    _i1.Session session,
    List<UriDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UriDefault>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UriDefault].
  Future<UriDefault> deleteRow(
    _i1.Session session,
    UriDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UriDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UriDefault>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UriDefaultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UriDefault>(
      where: where(UriDefault.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UriDefaultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UriDefault>(
      where: where?.call(UriDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

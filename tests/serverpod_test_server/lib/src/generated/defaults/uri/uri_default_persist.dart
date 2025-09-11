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

abstract class UriDefaultPersist
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UriDefaultPersist._({
    this.id,
    this.uriDefaultPersist,
  });

  factory UriDefaultPersist({
    int? id,
    Uri? uriDefaultPersist,
  }) = _UriDefaultPersistImpl;

  factory UriDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return UriDefaultPersist(
      id: jsonSerialization['id'] as int?,
      uriDefaultPersist: jsonSerialization['uriDefaultPersist'] == null
          ? null
          : _i1.UriJsonExtension.fromJson(
              jsonSerialization['uriDefaultPersist']),
    );
  }

  static final t = UriDefaultPersistTable();

  static const db = UriDefaultPersistRepository._();

  @override
  int? id;

  Uri? uriDefaultPersist;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UriDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UriDefaultPersist copyWith({
    int? id,
    Uri? uriDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (uriDefaultPersist != null)
        'uriDefaultPersist': uriDefaultPersist?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (uriDefaultPersist != null)
        'uriDefaultPersist': uriDefaultPersist?.toJson(),
    };
  }

  static UriDefaultPersistInclude include() {
    return UriDefaultPersistInclude._();
  }

  static UriDefaultPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<UriDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UriDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UriDefaultPersistTable>? orderByList,
    UriDefaultPersistInclude? include,
  }) {
    return UriDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UriDefaultPersist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UriDefaultPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UriDefaultPersistImpl extends UriDefaultPersist {
  _UriDefaultPersistImpl({
    int? id,
    Uri? uriDefaultPersist,
  }) : super._(
          id: id,
          uriDefaultPersist: uriDefaultPersist,
        );

  /// Returns a shallow copy of this [UriDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UriDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? uriDefaultPersist = _Undefined,
  }) {
    return UriDefaultPersist(
      id: id is int? ? id : this.id,
      uriDefaultPersist: uriDefaultPersist is Uri?
          ? uriDefaultPersist
          : this.uriDefaultPersist,
    );
  }
}

class UriDefaultPersistUpdateTable
    extends _i1.UpdateTable<UriDefaultPersistTable> {
  UriDefaultPersistUpdateTable(super.table);

  _i1.ColumnValue<Uri, Uri> uriDefaultPersist(Uri? value) => _i1.ColumnValue(
        table.uriDefaultPersist,
        value,
      );
}

class UriDefaultPersistTable extends _i1.Table<int?> {
  UriDefaultPersistTable({super.tableRelation})
      : super(tableName: 'uri_default_persist') {
    updateTable = UriDefaultPersistUpdateTable(this);
    uriDefaultPersist = _i1.ColumnUri(
      'uriDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final UriDefaultPersistUpdateTable updateTable;

  late final _i1.ColumnUri uriDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        uriDefaultPersist,
      ];
}

class UriDefaultPersistInclude extends _i1.IncludeObject {
  UriDefaultPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UriDefaultPersist.t;
}

class UriDefaultPersistIncludeList extends _i1.IncludeList {
  UriDefaultPersistIncludeList._({
    _i1.WhereExpressionBuilder<UriDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UriDefaultPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UriDefaultPersist.t;
}

class UriDefaultPersistRepository {
  const UriDefaultPersistRepository._();

  /// Returns a list of [UriDefaultPersist]s matching the given query parameters.
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
  Future<List<UriDefaultPersist>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UriDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UriDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UriDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UriDefaultPersist>(
      where: where?.call(UriDefaultPersist.t),
      orderBy: orderBy?.call(UriDefaultPersist.t),
      orderByList: orderByList?.call(UriDefaultPersist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UriDefaultPersist] matching the given query parameters.
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
  Future<UriDefaultPersist?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UriDefaultPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<UriDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UriDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UriDefaultPersist>(
      where: where?.call(UriDefaultPersist.t),
      orderBy: orderBy?.call(UriDefaultPersist.t),
      orderByList: orderByList?.call(UriDefaultPersist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UriDefaultPersist] by its [id] or null if no such row exists.
  Future<UriDefaultPersist?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UriDefaultPersist>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UriDefaultPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [UriDefaultPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UriDefaultPersist>> insert(
    _i1.Session session,
    List<UriDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UriDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UriDefaultPersist] and returns the inserted row.
  ///
  /// The returned [UriDefaultPersist] will have its `id` field set.
  Future<UriDefaultPersist> insertRow(
    _i1.Session session,
    UriDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UriDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UriDefaultPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UriDefaultPersist>> update(
    _i1.Session session,
    List<UriDefaultPersist> rows, {
    _i1.ColumnSelections<UriDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UriDefaultPersist>(
      rows,
      columns: columns?.call(UriDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UriDefaultPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UriDefaultPersist> updateRow(
    _i1.Session session,
    UriDefaultPersist row, {
    _i1.ColumnSelections<UriDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UriDefaultPersist>(
      row,
      columns: columns?.call(UriDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UriDefaultPersist] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UriDefaultPersist?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UriDefaultPersistUpdateTable>
        columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UriDefaultPersist>(
      id,
      columnValues: columnValues(UriDefaultPersist.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UriDefaultPersist]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UriDefaultPersist>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UriDefaultPersistUpdateTable>
        columnValues,
    required _i1.WhereExpressionBuilder<UriDefaultPersistTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UriDefaultPersistTable>? orderBy,
    _i1.OrderByListBuilder<UriDefaultPersistTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UriDefaultPersist>(
      columnValues: columnValues(UriDefaultPersist.t.updateTable),
      where: where(UriDefaultPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UriDefaultPersist.t),
      orderByList: orderByList?.call(UriDefaultPersist.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UriDefaultPersist]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UriDefaultPersist>> delete(
    _i1.Session session,
    List<UriDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UriDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UriDefaultPersist].
  Future<UriDefaultPersist> deleteRow(
    _i1.Session session,
    UriDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UriDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UriDefaultPersist>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UriDefaultPersistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UriDefaultPersist>(
      where: where(UriDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UriDefaultPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UriDefaultPersist>(
      where: where?.call(UriDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

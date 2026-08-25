/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import '../../models_with_relations/one_to_one/town.dart' as _i59ly1gg;

abstract class Company
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Company._({
    this.id,
    required this.name,
    required this.townId,
    this.town,
  });

  factory Company({
    int? id,
    required String name,
    required int townId,
    _i59ly1gg.Town? town,
  }) = _CompanyImpl;

  factory Company.fromJson(Map<String, dynamic> jsonSerialization) {
    return Company(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      townId: jsonSerialization['townId'] as int,
      town: jsonSerialization['town'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_i59ly1gg.Town>(
              jsonSerialization['town'],
            ),
    );
  }

  static final t = CompanyTable();

  static const db = CompanyRepository._();

  @override
  int? id;

  String name;

  int townId;

  _i59ly1gg.Town? town;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Company]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Company copyWith({
    int? id,
    String? name,
    int? townId,
    _i59ly1gg.Town? town,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Company',
      if (id != null) 'id': id,
      'name': name,
      'townId': townId,
      if (town != null) 'town': town?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Company',
      if (id != null) 'id': id,
      'name': name,
      'townId': townId,
      if (town != null) 'town': town?.toJsonForProtocol(),
    };
  }

  static CompanyInclude include({
    _i59ly1gg.TownInclude? town,
    _is.SelectColumnsBuilder<CompanyTable>? select,
  }) {
    return CompanyInclude._(
      town: town,
      selectedColumns: select?.call(Company.t),
    );
  }

  static CompanyIncludeList includeList({
    _is.WhereExpressionBuilder<CompanyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CompanyTable>? orderBy,
    _is.OrderByListBuilder<CompanyTable>? orderByList,
    CompanyInclude? include,
    _is.SelectColumnsBuilder<CompanyTable>? select,
  }) {
    return CompanyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Company.t),
      orderByList: orderByList?.call(Company.t),
      include: include,
      selectedColumns: select?.call(Company.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CompanyImpl extends Company {
  _CompanyImpl({
    int? id,
    required String name,
    required int townId,
    _i59ly1gg.Town? town,
  }) : super._(
         id: id,
         name: name,
         townId: townId,
         town: town,
       );

  /// Returns a shallow copy of this [Company]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Company copyWith({
    Object? id = _Undefined,
    String? name,
    int? townId,
    Object? town = _Undefined,
  }) {
    return Company(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      townId: townId ?? this.townId,
      town: town is _i59ly1gg.Town? ? town : this.town?.copyWith(),
    );
  }
}

class CompanyUpdateTable extends _is.UpdateTable<CompanyTable> {
  CompanyUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> townId(int value) => _is.ColumnValue(
    table.townId,
    value,
  );
}

class CompanyTable extends _is.Table<int?> {
  CompanyTable({super.tableRelation}) : super(tableName: 'company') {
    updateTable = CompanyUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    townId = _is.ColumnInt(
      'townId',
      this,
    );
  }

  late final CompanyUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnInt townId;

  _i59ly1gg.TownTable? _town;

  _i59ly1gg.TownTable get town {
    if (_town != null) return _town!;
    _town = _is.createRelationTable(
      relationFieldName: 'town',
      field: Company.t.townId,
      foreignField: _i59ly1gg.Town.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i59ly1gg.TownTable(tableRelation: foreignTableRelation),
    );
    return _town!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    townId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'town') {
      return town;
    }
    return null;
  }
}

class CompanyInclude extends _is.IncludeObject {
  CompanyInclude._({
    _i59ly1gg.TownInclude? town,
    this.selectedColumns,
  }) {
    _town = town;
  }

  _i59ly1gg.TownInclude? _town;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'town': _town};

  @override
  _is.Table<int?> get table => Company.t;
}

class CompanyIncludeList extends _is.IncludeList {
  CompanyIncludeList._({
    _is.WhereExpressionBuilder<CompanyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Company.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Company.t;
}

class CompanyRepository {
  const CompanyRepository._();

  final attachRow = const CompanyAttachRowRepository._();

  /// Returns a list of [Company]s matching the given query parameters.
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
  Future<List<Company>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CompanyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CompanyTable>? orderBy,
    _is.OrderByListBuilder<CompanyTable>? orderByList,
    _is.Transaction? transaction,
    CompanyInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Company>(
      where: where?.call(Company.t),
      orderBy: orderBy?.call(Company.t),
      orderByList: orderByList?.call(Company.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Company] matching the given query parameters.
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
  Future<Company?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CompanyTable>? where,
    int? offset,
    _is.OrderByBuilder<CompanyTable>? orderBy,
    _is.OrderByListBuilder<CompanyTable>? orderByList,
    _is.Transaction? transaction,
    CompanyInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Company>(
      where: where?.call(Company.t),
      orderBy: orderBy?.call(Company.t),
      orderByList: orderByList?.call(Company.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Company] by its [id] or null if no such row exists.
  Future<Company?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    CompanyInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Company>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CompanyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CompanyTable>? orderBy,
    _is.OrderByListBuilder<CompanyTable>? orderByList,
    _is.Transaction? transaction,
    CompanyInclude? include,
    _is.SelectColumnsBuilder<CompanyTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Company>(
      where: where?.call(Company.t),
      orderBy: orderBy?.call(Company.t),
      orderByList: orderByList?.call(Company.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Company.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CompanyTable>? where,
    int? offset,
    _is.OrderByBuilder<CompanyTable>? orderBy,
    _is.OrderByListBuilder<CompanyTable>? orderByList,
    _is.Transaction? transaction,
    CompanyInclude? include,
    _is.SelectColumnsBuilder<CompanyTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Company>(
      where: where?.call(Company.t),
      orderBy: orderBy?.call(Company.t),
      orderByList: orderByList?.call(Company.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Company.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    CompanyInclude? include,
    _is.SelectColumnsBuilder<CompanyTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Company>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Company.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Company]s in the list and returns the inserted rows.
  ///
  /// The returned [Company]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Company>> insert(
    _is.DatabaseSession session,
    List<Company> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Company>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Company] and returns the inserted row.
  ///
  /// The returned [Company] will have its `id` field set.
  Future<Company> insertRow(
    _is.DatabaseSession session,
    Company row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Company>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Company]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Company]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Company>> upsert(
    _is.DatabaseSession session,
    List<Company> rows, {
    required _is.ColumnSelections<CompanyTable> conflictColumns,
    _is.ColumnSelections<CompanyTable>? updateColumns,
    _is.WhereExpressionBuilder<CompanyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Company>(
      rows,
      conflictColumns: conflictColumns(Company.t),
      updateColumns: updateColumns?.call(Company.t),
      updateWhere: updateWhere?.call(Company.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Company] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Company] will have its `id` field set.
  Future<Company?> upsertRow(
    _is.DatabaseSession session,
    Company row, {
    required _is.ColumnSelections<CompanyTable> conflictColumns,
    _is.ColumnSelections<CompanyTable>? updateColumns,
    _is.WhereExpressionBuilder<CompanyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Company>(
      row,
      conflictColumns: conflictColumns(Company.t),
      updateColumns: updateColumns?.call(Company.t),
      updateWhere: updateWhere?.call(Company.t),
      transaction: transaction,
    );
  }

  /// Updates all [Company]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Company>> update(
    _is.DatabaseSession session,
    List<Company> rows, {
    _is.ColumnSelections<CompanyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Company>(
      rows,
      columns: columns?.call(Company.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Company]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Company> updateRow(
    _is.DatabaseSession session,
    Company row, {
    _is.ColumnSelections<CompanyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Company>(
      row,
      columns: columns?.call(Company.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Company] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Company?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CompanyUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Company>(
      id,
      columnValues: columnValues(Company.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Company]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Company>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CompanyUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CompanyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CompanyTable>? orderBy,
    _is.OrderByListBuilder<CompanyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Company>(
      columnValues: columnValues(Company.t.updateTable),
      where: where(Company.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Company.t),
      orderByList: orderByList?.call(Company.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Company]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Company>> delete(
    _is.DatabaseSession session,
    List<Company> rows, {
    _is.OrderByBuilder<CompanyTable>? orderBy,
    _is.OrderByListBuilder<CompanyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Company>(
      rows,
      orderBy: orderBy?.call(Company.t),
      orderByList: orderByList?.call(Company.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Company].
  Future<Company> deleteRow(
    _is.DatabaseSession session,
    Company row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Company>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Company>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CompanyTable> where,
    _is.OrderByBuilder<CompanyTable>? orderBy,
    _is.OrderByListBuilder<CompanyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Company>(
      where: where(Company.t),
      orderBy: orderBy?.call(Company.t),
      orderByList: orderByList?.call(Company.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CompanyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Company>(
      where: where?.call(Company.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Company] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CompanyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Company>(
      where: where(Company.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CompanyAttachRowRepository {
  const CompanyAttachRowRepository._();

  /// Creates a relation between the given [Company] and [Town]
  /// by setting the [Company]'s foreign key `townId` to refer to the [Town].
  Future<void> town(
    _is.DatabaseSession session,
    Company company,
    _i59ly1gg.Town town, {
    _is.Transaction? transaction,
  }) async {
    if (company.id == null) {
      throw ArgumentError.notNull('company.id');
    }
    if (town.id == null) {
      throw ArgumentError.notNull('town.id');
    }

    var $company = company.copyWith(townId: town.id);
    await session.db.updateRow<Company>(
      $company,
      columns: [Company.t.townId],
      transaction: transaction,
    );
  }
}

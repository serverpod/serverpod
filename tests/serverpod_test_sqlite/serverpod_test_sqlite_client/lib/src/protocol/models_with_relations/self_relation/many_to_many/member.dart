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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import '../../../models_with_relations/self_relation/many_to_many/blocking.dart'
    as _iv5rlvod;

abstract class Member
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  Member._({
    this.id,
    required this.name,
    this.blocking,
    this.blockedBy,
  });

  factory Member({
    int? id,
    required String name,
    List<_iv5rlvod.Blocking>? blocking,
    List<_iv5rlvod.Blocking>? blockedBy,
  }) = _MemberImpl;

  factory Member.fromJson(Map<String, dynamic> jsonSerialization) {
    return Member(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      blocking: jsonSerialization['blocking'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<List<_iv5rlvod.Blocking>>(
              jsonSerialization['blocking'],
            ),
      blockedBy: jsonSerialization['blockedBy'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<List<_iv5rlvod.Blocking>>(
              jsonSerialization['blockedBy'],
            ),
    );
  }

  static final t = MemberTable();

  static const db = MemberRepository._();

  @override
  int? id;

  String name;

  List<_iv5rlvod.Blocking>? blocking;

  List<_iv5rlvod.Blocking>? blockedBy;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [Member]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Member copyWith({
    int? id,
    String? name,
    List<_iv5rlvod.Blocking>? blocking,
    List<_iv5rlvod.Blocking>? blockedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Member',
      if (id != null) 'id': id,
      'name': name,
      if (blocking != null)
        'blocking': blocking?.toJson(valueToJson: (v) => v.toJson()),
      if (blockedBy != null)
        'blockedBy': blockedBy?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Member',
      if (id != null) 'id': id,
      'name': name,
      if (blocking != null)
        'blocking': blocking?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (blockedBy != null)
        'blockedBy': blockedBy?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  /// Builds a complete [MemberInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static MemberInclude include({
    _iv5rlvod.BlockingIncludeList? blocking,
    _iv5rlvod.BlockingIncludeList? blockedBy,
  }) {
    return MemberInclude._(
      blocking: blocking,
      blockedBy: blockedBy,
    );
  }

  /// Builds a complete [MemberIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static MemberIncludeList includeList({
    _isd.WhereExpressionBuilder<MemberTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<MemberTable>? orderBy,
    _isd.OrderByListBuilder<MemberTable>? orderByList,
    MemberInclude? include,
  }) {
    return MemberIncludeList._(
      where: where?.call(Member.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Member.t),
      orderByList: orderByList?.call(Member.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [MemberJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static MemberJsonInclude includeJson({
    _iv5rlvod.BlockingJsonIncludeList? blocking,
    _iv5rlvod.BlockingJsonIncludeList? blockedBy,
    _isd.SelectColumnsBuilder<MemberTable>? select,
  }) {
    return _MemberJsonInclude._(
      blocking: blocking,
      blockedBy: blockedBy,
      selectedColumns: select?.call(Member.t),
    );
  }

  /// Builds a JSON-compatible [MemberJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static MemberJsonIncludeList includeJsonList({
    _isd.WhereExpressionBuilder<MemberTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<MemberTable>? orderBy,
    _isd.OrderByListBuilder<MemberTable>? orderByList,
    MemberJsonInclude? include,
    _isd.SelectColumnsBuilder<MemberTable>? select,
  }) {
    return _MemberJsonIncludeList._(
      where: where?.call(Member.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Member.t),
      orderByList: orderByList?.call(Member.t),
      include: include,
      selectedColumns: select?.call(Member.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MemberImpl extends Member {
  _MemberImpl({
    int? id,
    required String name,
    List<_iv5rlvod.Blocking>? blocking,
    List<_iv5rlvod.Blocking>? blockedBy,
  }) : super._(
         id: id,
         name: name,
         blocking: blocking,
         blockedBy: blockedBy,
       );

  /// Returns a shallow copy of this [Member]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Member copyWith({
    Object? id = _Undefined,
    String? name,
    Object? blocking = _Undefined,
    Object? blockedBy = _Undefined,
  }) {
    return Member(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      blocking: blocking is List<_iv5rlvod.Blocking>?
          ? blocking
          : this.blocking?.map((e0) => e0.copyWith()).toList(),
      blockedBy: blockedBy is List<_iv5rlvod.Blocking>?
          ? blockedBy
          : this.blockedBy?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class MemberUpdateTable extends _isd.UpdateTable<MemberTable> {
  MemberUpdateTable(super.table);

  _isd.ColumnValue<String, String> name(String value) => _isd.ColumnValue(
    table.name,
    value,
  );
}

class MemberTable extends _isd.Table<int?> {
  MemberTable({super.tableRelation}) : super(tableName: 'member') {
    updateTable = MemberUpdateTable(this);
    name = _isd.ColumnString(
      'name',
      this,
    );
  }

  late final MemberUpdateTable updateTable;

  late final _isd.ColumnString name;

  _iv5rlvod.BlockingTable? ___blocking;

  _isd.ManyRelation<_iv5rlvod.BlockingTable>? _blocking;

  _iv5rlvod.BlockingTable? ___blockedBy;

  _isd.ManyRelation<_iv5rlvod.BlockingTable>? _blockedBy;

  _iv5rlvod.BlockingTable get __blocking {
    if (___blocking != null) return ___blocking!;
    ___blocking = _isd.createRelationTable(
      relationFieldName: '__blocking',
      field: Member.t.id,
      foreignField: _iv5rlvod.Blocking.t.blockedById,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iv5rlvod.BlockingTable(tableRelation: foreignTableRelation),
    );
    return ___blocking!;
  }

  _iv5rlvod.BlockingTable get __blockedBy {
    if (___blockedBy != null) return ___blockedBy!;
    ___blockedBy = _isd.createRelationTable(
      relationFieldName: '__blockedBy',
      field: Member.t.id,
      foreignField: _iv5rlvod.Blocking.t.blockedId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iv5rlvod.BlockingTable(tableRelation: foreignTableRelation),
    );
    return ___blockedBy!;
  }

  _isd.ManyRelation<_iv5rlvod.BlockingTable> get blocking {
    if (_blocking != null) return _blocking!;
    var relationTable = _isd.createRelationTable(
      relationFieldName: 'blocking',
      field: Member.t.id,
      foreignField: _iv5rlvod.Blocking.t.blockedById,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iv5rlvod.BlockingTable(tableRelation: foreignTableRelation),
    );
    _blocking = _isd.ManyRelation<_iv5rlvod.BlockingTable>(
      tableWithRelations: relationTable,
      table: _iv5rlvod.BlockingTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _blocking!;
  }

  _isd.ManyRelation<_iv5rlvod.BlockingTable> get blockedBy {
    if (_blockedBy != null) return _blockedBy!;
    var relationTable = _isd.createRelationTable(
      relationFieldName: 'blockedBy',
      field: Member.t.id,
      foreignField: _iv5rlvod.Blocking.t.blockedId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iv5rlvod.BlockingTable(tableRelation: foreignTableRelation),
    );
    _blockedBy = _isd.ManyRelation<_iv5rlvod.BlockingTable>(
      tableWithRelations: relationTable,
      table: _iv5rlvod.BlockingTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _blockedBy!;
  }

  @override
  List<_isd.Column> get columns => [
    id,
    name,
  ];

  @override
  _isd.Table? getRelationTable(String relationField) {
    if (relationField == 'blocking') {
      return __blocking;
    }
    if (relationField == 'blockedBy') {
      return __blockedBy;
    }
    return null;
  }
}

abstract interface class MemberJsonInclude
    implements _isd.JsonCompatibleInclude {}

abstract interface class MemberJsonIncludeList
    implements _isd.JsonCompatibleInclude {}

final class MemberInclude extends _isd.IncludeObject
    implements MemberJsonInclude, _isd.FullModelInclude {
  MemberInclude._({
    _iv5rlvod.BlockingIncludeList? blocking,
    _iv5rlvod.BlockingIncludeList? blockedBy,
  }) {
    _blocking = blocking;
    _blockedBy = blockedBy;
  }

  _iv5rlvod.BlockingIncludeList? _blocking;

  _iv5rlvod.BlockingIncludeList? _blockedBy;

  @override
  Map<String, _isd.Include?> get includes => {
    'blocking': _blocking,
    'blockedBy': _blockedBy,
  };

  @override
  _isd.Table<int?> get table => Member.t;
}

final class MemberIncludeList extends _isd.IncludeList
    implements MemberJsonIncludeList, _isd.FullModelInclude {
  MemberIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    MemberInclude? super.include,
  });

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Member.t;
}

final class _MemberJsonInclude extends _isd.IncludeObject
    implements MemberJsonInclude {
  _MemberJsonInclude._({
    _iv5rlvod.BlockingJsonIncludeList? blocking,
    _iv5rlvod.BlockingJsonIncludeList? blockedBy,
    this.selectedColumns,
  }) {
    _blocking = blocking;
    _blockedBy = blockedBy;
  }

  _iv5rlvod.BlockingJsonIncludeList? _blocking;

  _iv5rlvod.BlockingJsonIncludeList? _blockedBy;

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {
    'blocking': _blocking,
    'blockedBy': _blockedBy,
  };

  @override
  _isd.Table<int?> get table => Member.t;
}

final class _MemberJsonIncludeList extends _isd.IncludeList
    implements MemberJsonIncludeList {
  _MemberJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    MemberJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Member.t;
}

class MemberRepository {
  const MemberRepository._();

  final attach = const MemberAttachRepository._();

  final attachRow = const MemberAttachRowRepository._();

  /// Returns a list of [Member]s matching the given query parameters.
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
  Future<List<Member>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<MemberTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<MemberTable>? orderBy,
    _isd.OrderByListBuilder<MemberTable>? orderByList,
    _isd.Transaction? transaction,
    MemberInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Member>(
      where: where?.call(Member.t),
      orderBy: orderBy?.call(Member.t),
      orderByList: orderByList?.call(Member.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Member] matching the given query parameters.
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
  Future<Member?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<MemberTable>? where,
    int? offset,
    _isd.OrderByBuilder<MemberTable>? orderBy,
    _isd.OrderByListBuilder<MemberTable>? orderByList,
    _isd.Transaction? transaction,
    MemberInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Member>(
      where: where?.call(Member.t),
      orderBy: orderBy?.call(Member.t),
      orderByList: orderByList?.call(Member.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Member] by its [id] or null if no such row exists.
  Future<Member?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    MemberInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Member>(
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
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<MemberTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<MemberTable>? orderBy,
    _isd.OrderByListBuilder<MemberTable>? orderByList,
    _isd.Transaction? transaction,
    MemberJsonInclude? include,
    _isd.SelectColumnsBuilder<MemberTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Member>(
      where: where?.call(Member.t),
      orderBy: orderBy?.call(Member.t),
      orderByList: orderByList?.call(Member.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Member.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<MemberTable>? where,
    int? offset,
    _isd.OrderByBuilder<MemberTable>? orderBy,
    _isd.OrderByListBuilder<MemberTable>? orderByList,
    _isd.Transaction? transaction,
    MemberJsonInclude? include,
    _isd.SelectColumnsBuilder<MemberTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Member>(
      where: where?.call(Member.t),
      orderBy: orderBy?.call(Member.t),
      orderByList: orderByList?.call(Member.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Member.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _isd.DatabaseSession session,
    Object id, {
    _isd.Transaction? transaction,
    MemberJsonInclude? include,
    _isd.SelectColumnsBuilder<MemberTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Member>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Member.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Member]s in the list and returns the inserted rows.
  ///
  /// The returned [Member]s will have their `id` fields set.
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
  Future<List<Member>> insert(
    _isd.DatabaseSession session,
    List<Member> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Member>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Member] and returns the inserted row.
  ///
  /// The returned [Member] will have its `id` field set.
  Future<Member> insertRow(
    _isd.DatabaseSession session,
    Member row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<Member>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Member]s in the list and returns the resulting rows.
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
  /// The returned [Member]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Member>> upsert(
    _isd.DatabaseSession session,
    List<Member> rows, {
    required _isd.ColumnSelections<MemberTable> conflictColumns,
    _isd.ColumnSelections<MemberTable>? updateColumns,
    _isd.WhereExpressionBuilder<MemberTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Member>(
      rows,
      conflictColumns: conflictColumns(Member.t),
      updateColumns: updateColumns?.call(Member.t),
      updateWhere: updateWhere?.call(Member.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Member] and returns the resulting row.
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
  /// The returned [Member] will have its `id` field set.
  Future<Member?> upsertRow(
    _isd.DatabaseSession session,
    Member row, {
    required _isd.ColumnSelections<MemberTable> conflictColumns,
    _isd.ColumnSelections<MemberTable>? updateColumns,
    _isd.WhereExpressionBuilder<MemberTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Member>(
      row,
      conflictColumns: conflictColumns(Member.t),
      updateColumns: updateColumns?.call(Member.t),
      updateWhere: updateWhere?.call(Member.t),
      transaction: transaction,
    );
  }

  /// Updates all [Member]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Member>> update(
    _isd.DatabaseSession session,
    List<Member> rows, {
    _isd.ColumnSelections<MemberTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Member>(
      rows,
      columns: columns?.call(Member.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Member]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Member> updateRow(
    _isd.DatabaseSession session,
    Member row, {
    _isd.ColumnSelections<MemberTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<Member>(
      row,
      columns: columns?.call(Member.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Member] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Member?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<MemberUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<Member>(
      id,
      columnValues: columnValues(Member.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Member]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Member>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<MemberUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<MemberTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<MemberTable>? orderBy,
    _isd.OrderByListBuilder<MemberTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Member>(
      columnValues: columnValues(Member.t.updateTable),
      where: where(Member.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Member.t),
      orderByList: orderByList?.call(Member.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Member]s in the list and returns the deleted rows.
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
  Future<List<Member>> delete(
    _isd.DatabaseSession session,
    List<Member> rows, {
    _isd.OrderByBuilder<MemberTable>? orderBy,
    _isd.OrderByListBuilder<MemberTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Member>(
      rows,
      orderBy: orderBy?.call(Member.t),
      orderByList: orderByList?.call(Member.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Member].
  Future<Member> deleteRow(
    _isd.DatabaseSession session,
    Member row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Member>(
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
  Future<List<Member>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<MemberTable> where,
    _isd.OrderByBuilder<MemberTable>? orderBy,
    _isd.OrderByListBuilder<MemberTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Member>(
      where: where(Member.t),
      orderBy: orderBy?.call(Member.t),
      orderByList: orderByList?.call(Member.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<MemberTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<Member>(
      where: where?.call(Member.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Member] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<MemberTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Member>(
      where: where(Member.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class MemberAttachRepository {
  const MemberAttachRepository._();

  /// Creates a relation between this [Member] and the given [Blocking]s
  /// by setting each [Blocking]'s foreign key `blockedById` to refer to this [Member].
  Future<void> blocking(
    _isd.DatabaseSession session,
    Member member,
    List<_iv5rlvod.Blocking> blocking, {
    _isd.Transaction? transaction,
  }) async {
    if (blocking.any((e) => e.id == null)) {
      throw ArgumentError.notNull('blocking.id');
    }
    if (member.id == null) {
      throw ArgumentError.notNull('member.id');
    }

    var $blocking = blocking
        .map((e) => e.copyWith(blockedById: member.id))
        .toList();
    await session.db.update<_iv5rlvod.Blocking>(
      $blocking,
      columns: [_iv5rlvod.Blocking.t.blockedById],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Member] and the given [Blocking]s
  /// by setting each [Blocking]'s foreign key `blockedId` to refer to this [Member].
  Future<void> blockedBy(
    _isd.DatabaseSession session,
    Member member,
    List<_iv5rlvod.Blocking> blocking, {
    _isd.Transaction? transaction,
  }) async {
    if (blocking.any((e) => e.id == null)) {
      throw ArgumentError.notNull('blocking.id');
    }
    if (member.id == null) {
      throw ArgumentError.notNull('member.id');
    }

    var $blocking = blocking
        .map((e) => e.copyWith(blockedId: member.id))
        .toList();
    await session.db.update<_iv5rlvod.Blocking>(
      $blocking,
      columns: [_iv5rlvod.Blocking.t.blockedId],
      transaction: transaction,
    );
  }
}

class MemberAttachRowRepository {
  const MemberAttachRowRepository._();

  /// Creates a relation between this [Member] and the given [Blocking]
  /// by setting the [Blocking]'s foreign key `blockedById` to refer to this [Member].
  Future<void> blocking(
    _isd.DatabaseSession session,
    Member member,
    _iv5rlvod.Blocking blocking, {
    _isd.Transaction? transaction,
  }) async {
    if (blocking.id == null) {
      throw ArgumentError.notNull('blocking.id');
    }
    if (member.id == null) {
      throw ArgumentError.notNull('member.id');
    }

    var $blocking = blocking.copyWith(blockedById: member.id);
    await session.db.updateRow<_iv5rlvod.Blocking>(
      $blocking,
      columns: [_iv5rlvod.Blocking.t.blockedById],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Member] and the given [Blocking]
  /// by setting the [Blocking]'s foreign key `blockedId` to refer to this [Member].
  Future<void> blockedBy(
    _isd.DatabaseSession session,
    Member member,
    _iv5rlvod.Blocking blocking, {
    _isd.Transaction? transaction,
  }) async {
    if (blocking.id == null) {
      throw ArgumentError.notNull('blocking.id');
    }
    if (member.id == null) {
      throw ArgumentError.notNull('member.id');
    }

    var $blocking = blocking.copyWith(blockedId: member.id);
    await session.db.updateRow<_iv5rlvod.Blocking>(
      $blocking,
      columns: [_iv5rlvod.Blocking.t.blockedId],
      transaction: transaction,
    );
  }
}

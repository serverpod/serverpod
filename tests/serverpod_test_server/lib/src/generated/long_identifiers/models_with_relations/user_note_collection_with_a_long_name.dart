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
import '../../long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _iegdvue1;

abstract class UserNoteCollectionWithALongName
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UserNoteCollectionWithALongName._({
    this.id,
    required this.name,
    this.notes,
  });

  factory UserNoteCollectionWithALongName({
    int? id,
    required String name,
    List<_iegdvue1.UserNoteWithALongName>? notes,
  }) = _UserNoteCollectionWithALongNameImpl;

  factory UserNoteCollectionWithALongName.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UserNoteCollectionWithALongName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      notes: jsonSerialization['notes'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<List<_iegdvue1.UserNoteWithALongName>>(
                  jsonSerialization['notes'],
                ),
    );
  }

  static final t = UserNoteCollectionWithALongNameTable();

  static const db = UserNoteCollectionWithALongNameRepository._();

  @override
  int? id;

  String name;

  List<_iegdvue1.UserNoteWithALongName>? notes;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserNoteCollectionWithALongName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserNoteCollectionWithALongName copyWith({
    int? id,
    String? name,
    List<_iegdvue1.UserNoteWithALongName>? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserNoteCollectionWithALongName',
      if (id != null) 'id': id,
      'name': name,
      if (notes != null) 'notes': notes?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserNoteCollectionWithALongName',
      if (id != null) 'id': id,
      'name': name,
      if (notes != null)
        'notes': notes?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static UserNoteCollectionWithALongNameInclude include({
    _iegdvue1.UserNoteWithALongNameIncludeList? notes,
    _is.SelectColumnsBuilder<UserNoteCollectionWithALongNameTable>? select,
  }) {
    return UserNoteCollectionWithALongNameInclude._(
      notes: notes,
      selectedColumns: select?.call(UserNoteCollectionWithALongName.t),
    );
  }

  static UserNoteCollectionWithALongNameIncludeList includeList({
    _is.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserNoteCollectionWithALongNameTable>? orderBy,
    _is.OrderByListBuilder<UserNoteCollectionWithALongNameTable>? orderByList,
    UserNoteCollectionWithALongNameInclude? include,
    _is.SelectColumnsBuilder<UserNoteCollectionWithALongNameTable>? select,
  }) {
    return UserNoteCollectionWithALongNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserNoteCollectionWithALongName.t),
      orderByList: orderByList?.call(UserNoteCollectionWithALongName.t),
      include: include,
      selectedColumns: select?.call(UserNoteCollectionWithALongName.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserNoteCollectionWithALongNameImpl
    extends UserNoteCollectionWithALongName {
  _UserNoteCollectionWithALongNameImpl({
    int? id,
    required String name,
    List<_iegdvue1.UserNoteWithALongName>? notes,
  }) : super._(
         id: id,
         name: name,
         notes: notes,
       );

  /// Returns a shallow copy of this [UserNoteCollectionWithALongName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserNoteCollectionWithALongName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? notes = _Undefined,
  }) {
    return UserNoteCollectionWithALongName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      notes: notes is List<_iegdvue1.UserNoteWithALongName>?
          ? notes
          : this.notes?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class UserNoteCollectionWithALongNameUpdateTable
    extends _is.UpdateTable<UserNoteCollectionWithALongNameTable> {
  UserNoteCollectionWithALongNameUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );
}

class UserNoteCollectionWithALongNameTable extends _is.Table<int?> {
  UserNoteCollectionWithALongNameTable({super.tableRelation})
    : super(tableName: 'user_note_collection_with_a_long_name') {
    updateTable = UserNoteCollectionWithALongNameUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
  }

  late final UserNoteCollectionWithALongNameUpdateTable updateTable;

  late final _is.ColumnString name;

  _iegdvue1.UserNoteWithALongNameTable? ___notes;

  _is.ManyRelation<_iegdvue1.UserNoteWithALongNameTable>? _notes;

  _iegdvue1.UserNoteWithALongNameTable get __notes {
    if (___notes != null) return ___notes!;
    ___notes = _is.createRelationTable(
      relationFieldName: '__notes',
      field: UserNoteCollectionWithALongName.t.id,
      foreignField: _iegdvue1
          .UserNoteWithALongName
          .t
          .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iegdvue1.UserNoteWithALongNameTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return ___notes!;
  }

  _is.ManyRelation<_iegdvue1.UserNoteWithALongNameTable> get notes {
    if (_notes != null) return _notes!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'notes',
      field: UserNoteCollectionWithALongName.t.id,
      foreignField: _iegdvue1
          .UserNoteWithALongName
          .t
          .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iegdvue1.UserNoteWithALongNameTable(
            tableRelation: foreignTableRelation,
          ),
    );
    _notes = _is.ManyRelation<_iegdvue1.UserNoteWithALongNameTable>(
      tableWithRelations: relationTable,
      table: _iegdvue1.UserNoteWithALongNameTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _notes!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'notes') {
      return __notes;
    }
    return null;
  }
}

class UserNoteCollectionWithALongNameInclude extends _is.IncludeObject {
  UserNoteCollectionWithALongNameInclude._({
    _iegdvue1.UserNoteWithALongNameIncludeList? notes,
    this.selectedColumns,
  }) {
    _notes = notes;
  }

  _iegdvue1.UserNoteWithALongNameIncludeList? _notes;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'notes': _notes};

  @override
  _is.Table<int?> get table => UserNoteCollectionWithALongName.t;
}

class UserNoteCollectionWithALongNameIncludeList extends _is.IncludeList {
  UserNoteCollectionWithALongNameIncludeList._({
    _is.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(UserNoteCollectionWithALongName.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UserNoteCollectionWithALongName.t;
}

class UserNoteCollectionWithALongNameRepository {
  const UserNoteCollectionWithALongNameRepository._();

  final attach = const UserNoteCollectionWithALongNameAttachRepository._();

  final attachRow =
      const UserNoteCollectionWithALongNameAttachRowRepository._();

  final detach = const UserNoteCollectionWithALongNameDetachRepository._();

  final detachRow =
      const UserNoteCollectionWithALongNameDetachRowRepository._();

  /// Returns a list of [UserNoteCollectionWithALongName]s matching the given query parameters.
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
  Future<List<UserNoteCollectionWithALongName>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserNoteCollectionWithALongNameTable>? orderBy,
    _is.OrderByListBuilder<UserNoteCollectionWithALongNameTable>? orderByList,
    _is.Transaction? transaction,
    UserNoteCollectionWithALongNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserNoteCollectionWithALongName>(
      where: where?.call(UserNoteCollectionWithALongName.t),
      orderBy: orderBy?.call(UserNoteCollectionWithALongName.t),
      orderByList: orderByList?.call(UserNoteCollectionWithALongName.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserNoteCollectionWithALongName] matching the given query parameters.
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
  Future<UserNoteCollectionWithALongName?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    int? offset,
    _is.OrderByBuilder<UserNoteCollectionWithALongNameTable>? orderBy,
    _is.OrderByListBuilder<UserNoteCollectionWithALongNameTable>? orderByList,
    _is.Transaction? transaction,
    UserNoteCollectionWithALongNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserNoteCollectionWithALongName>(
      where: where?.call(UserNoteCollectionWithALongName.t),
      orderBy: orderBy?.call(UserNoteCollectionWithALongName.t),
      orderByList: orderByList?.call(UserNoteCollectionWithALongName.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserNoteCollectionWithALongName] by its [id] or null if no such row exists.
  Future<UserNoteCollectionWithALongName?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    UserNoteCollectionWithALongNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserNoteCollectionWithALongName>(
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserNoteCollectionWithALongNameTable>? orderBy,
    _is.OrderByListBuilder<UserNoteCollectionWithALongNameTable>? orderByList,
    _is.Transaction? transaction,
    UserNoteCollectionWithALongNameInclude? include,
    _is.SelectColumnsBuilder<UserNoteCollectionWithALongNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<UserNoteCollectionWithALongName>(
      where: where?.call(UserNoteCollectionWithALongName.t),
      orderBy: orderBy?.call(UserNoteCollectionWithALongName.t),
      orderByList: orderByList?.call(UserNoteCollectionWithALongName.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(UserNoteCollectionWithALongName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    int? offset,
    _is.OrderByBuilder<UserNoteCollectionWithALongNameTable>? orderBy,
    _is.OrderByListBuilder<UserNoteCollectionWithALongNameTable>? orderByList,
    _is.Transaction? transaction,
    UserNoteCollectionWithALongNameInclude? include,
    _is.SelectColumnsBuilder<UserNoteCollectionWithALongNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<UserNoteCollectionWithALongName>(
      where: where?.call(UserNoteCollectionWithALongName.t),
      orderBy: orderBy?.call(UserNoteCollectionWithALongName.t),
      orderByList: orderByList?.call(UserNoteCollectionWithALongName.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(UserNoteCollectionWithALongName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    UserNoteCollectionWithALongNameInclude? include,
    _is.SelectColumnsBuilder<UserNoteCollectionWithALongNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<UserNoteCollectionWithALongName>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(UserNoteCollectionWithALongName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserNoteCollectionWithALongName]s in the list and returns the inserted rows.
  ///
  /// The returned [UserNoteCollectionWithALongName]s will have their `id` fields set.
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
  Future<List<UserNoteCollectionWithALongName>> insert(
    _is.DatabaseSession session,
    List<UserNoteCollectionWithALongName> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserNoteCollectionWithALongName>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserNoteCollectionWithALongName] and returns the inserted row.
  ///
  /// The returned [UserNoteCollectionWithALongName] will have its `id` field set.
  Future<UserNoteCollectionWithALongName> insertRow(
    _is.DatabaseSession session,
    UserNoteCollectionWithALongName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserNoteCollectionWithALongName>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserNoteCollectionWithALongName]s in the list and returns the resulting rows.
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
  /// The returned [UserNoteCollectionWithALongName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserNoteCollectionWithALongName>> upsert(
    _is.DatabaseSession session,
    List<UserNoteCollectionWithALongName> rows, {
    required _is.ColumnSelections<UserNoteCollectionWithALongNameTable>
    conflictColumns,
    _is.ColumnSelections<UserNoteCollectionWithALongNameTable>? updateColumns,
    _is.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>?
    updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserNoteCollectionWithALongName>(
      rows,
      conflictColumns: conflictColumns(UserNoteCollectionWithALongName.t),
      updateColumns: updateColumns?.call(UserNoteCollectionWithALongName.t),
      updateWhere: updateWhere?.call(UserNoteCollectionWithALongName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserNoteCollectionWithALongName] and returns the resulting row.
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
  /// The returned [UserNoteCollectionWithALongName] will have its `id` field set.
  Future<UserNoteCollectionWithALongName?> upsertRow(
    _is.DatabaseSession session,
    UserNoteCollectionWithALongName row, {
    required _is.ColumnSelections<UserNoteCollectionWithALongNameTable>
    conflictColumns,
    _is.ColumnSelections<UserNoteCollectionWithALongNameTable>? updateColumns,
    _is.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>?
    updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserNoteCollectionWithALongName>(
      row,
      conflictColumns: conflictColumns(UserNoteCollectionWithALongName.t),
      updateColumns: updateColumns?.call(UserNoteCollectionWithALongName.t),
      updateWhere: updateWhere?.call(UserNoteCollectionWithALongName.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserNoteCollectionWithALongName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserNoteCollectionWithALongName>> update(
    _is.DatabaseSession session,
    List<UserNoteCollectionWithALongName> rows, {
    _is.ColumnSelections<UserNoteCollectionWithALongNameTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserNoteCollectionWithALongName>(
      rows,
      columns: columns?.call(UserNoteCollectionWithALongName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserNoteCollectionWithALongName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserNoteCollectionWithALongName> updateRow(
    _is.DatabaseSession session,
    UserNoteCollectionWithALongName row, {
    _is.ColumnSelections<UserNoteCollectionWithALongNameTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserNoteCollectionWithALongName>(
      row,
      columns: columns?.call(UserNoteCollectionWithALongName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserNoteCollectionWithALongName] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserNoteCollectionWithALongName?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<
      UserNoteCollectionWithALongNameUpdateTable
    >
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserNoteCollectionWithALongName>(
      id,
      columnValues: columnValues(UserNoteCollectionWithALongName.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserNoteCollectionWithALongName]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserNoteCollectionWithALongName>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<
      UserNoteCollectionWithALongNameUpdateTable
    >
    columnValues,
    required _is.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserNoteCollectionWithALongNameTable>? orderBy,
    _is.OrderByListBuilder<UserNoteCollectionWithALongNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserNoteCollectionWithALongName>(
      columnValues: columnValues(UserNoteCollectionWithALongName.t.updateTable),
      where: where(UserNoteCollectionWithALongName.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserNoteCollectionWithALongName.t),
      orderByList: orderByList?.call(UserNoteCollectionWithALongName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserNoteCollectionWithALongName]s in the list and returns the deleted rows.
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
  Future<List<UserNoteCollectionWithALongName>> delete(
    _is.DatabaseSession session,
    List<UserNoteCollectionWithALongName> rows, {
    _is.OrderByBuilder<UserNoteCollectionWithALongNameTable>? orderBy,
    _is.OrderByListBuilder<UserNoteCollectionWithALongNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserNoteCollectionWithALongName>(
      rows,
      orderBy: orderBy?.call(UserNoteCollectionWithALongName.t),
      orderByList: orderByList?.call(UserNoteCollectionWithALongName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserNoteCollectionWithALongName].
  Future<UserNoteCollectionWithALongName> deleteRow(
    _is.DatabaseSession session,
    UserNoteCollectionWithALongName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserNoteCollectionWithALongName>(
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
  Future<List<UserNoteCollectionWithALongName>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>
    where,
    _is.OrderByBuilder<UserNoteCollectionWithALongNameTable>? orderBy,
    _is.OrderByListBuilder<UserNoteCollectionWithALongNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserNoteCollectionWithALongName>(
      where: where(UserNoteCollectionWithALongName.t),
      orderBy: orderBy?.call(UserNoteCollectionWithALongName.t),
      orderByList: orderByList?.call(UserNoteCollectionWithALongName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserNoteCollectionWithALongName>(
      where: where?.call(UserNoteCollectionWithALongName.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserNoteCollectionWithALongName] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>
    where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserNoteCollectionWithALongName>(
      where: where(UserNoteCollectionWithALongName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class UserNoteCollectionWithALongNameAttachRepository {
  const UserNoteCollectionWithALongNameAttachRepository._();

  /// Creates a relation between this [UserNoteCollectionWithALongName] and the given [UserNoteWithALongName]s
  /// by setting each [UserNoteWithALongName]'s foreign key `_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId` to refer to this [UserNoteCollectionWithALongName].
  Future<void> notes(
    _is.DatabaseSession session,
    UserNoteCollectionWithALongName userNoteCollectionWithALongName,
    List<_iegdvue1.UserNoteWithALongName> userNoteWithALongName, {
    _is.Transaction? transaction,
  }) async {
    if (userNoteWithALongName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('userNoteWithALongName.id');
    }
    if (userNoteCollectionWithALongName.id == null) {
      throw ArgumentError.notNull('userNoteCollectionWithALongName.id');
    }

    var $userNoteWithALongName = userNoteWithALongName
        .map(
          (e) => _iegdvue1.UserNoteWithALongNameImplicit(
            e,
            $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId:
                userNoteCollectionWithALongName.id,
          ),
        )
        .toList();
    await session.db.update<_iegdvue1.UserNoteWithALongName>(
      $userNoteWithALongName,
      columns: [
        _iegdvue1
            .UserNoteWithALongName
            .t
            .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
      ],
      transaction: transaction,
    );
  }
}

class UserNoteCollectionWithALongNameAttachRowRepository {
  const UserNoteCollectionWithALongNameAttachRowRepository._();

  /// Creates a relation between this [UserNoteCollectionWithALongName] and the given [UserNoteWithALongName]
  /// by setting the [UserNoteWithALongName]'s foreign key `_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId` to refer to this [UserNoteCollectionWithALongName].
  Future<void> notes(
    _is.DatabaseSession session,
    UserNoteCollectionWithALongName userNoteCollectionWithALongName,
    _iegdvue1.UserNoteWithALongName userNoteWithALongName, {
    _is.Transaction? transaction,
  }) async {
    if (userNoteWithALongName.id == null) {
      throw ArgumentError.notNull('userNoteWithALongName.id');
    }
    if (userNoteCollectionWithALongName.id == null) {
      throw ArgumentError.notNull('userNoteCollectionWithALongName.id');
    }

    var $userNoteWithALongName = _iegdvue1.UserNoteWithALongNameImplicit(
      userNoteWithALongName,
      $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId:
          userNoteCollectionWithALongName.id,
    );
    await session.db.updateRow<_iegdvue1.UserNoteWithALongName>(
      $userNoteWithALongName,
      columns: [
        _iegdvue1
            .UserNoteWithALongName
            .t
            .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
      ],
      transaction: transaction,
    );
  }
}

class UserNoteCollectionWithALongNameDetachRepository {
  const UserNoteCollectionWithALongNameDetachRepository._();

  /// Detaches the relation between this [UserNoteCollectionWithALongName] and the given [UserNoteWithALongName]
  /// by setting the [UserNoteWithALongName]'s foreign key `_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> notes(
    _is.DatabaseSession session,
    List<_iegdvue1.UserNoteWithALongName> userNoteWithALongName, {
    _is.Transaction? transaction,
  }) async {
    if (userNoteWithALongName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('userNoteWithALongName.id');
    }

    var $userNoteWithALongName = userNoteWithALongName
        .map(
          (e) => _iegdvue1.UserNoteWithALongNameImplicit(
            e,
            $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId:
                null,
          ),
        )
        .toList();
    await session.db.update<_iegdvue1.UserNoteWithALongName>(
      $userNoteWithALongName,
      columns: [
        _iegdvue1
            .UserNoteWithALongName
            .t
            .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
      ],
      transaction: transaction,
    );
  }
}

class UserNoteCollectionWithALongNameDetachRowRepository {
  const UserNoteCollectionWithALongNameDetachRowRepository._();

  /// Detaches the relation between this [UserNoteCollectionWithALongName] and the given [UserNoteWithALongName]
  /// by setting the [UserNoteWithALongName]'s foreign key `_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> notes(
    _is.DatabaseSession session,
    _iegdvue1.UserNoteWithALongName userNoteWithALongName, {
    _is.Transaction? transaction,
  }) async {
    if (userNoteWithALongName.id == null) {
      throw ArgumentError.notNull('userNoteWithALongName.id');
    }

    var $userNoteWithALongName = _iegdvue1.UserNoteWithALongNameImplicit(
      userNoteWithALongName,
      $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId: null,
    );
    await session.db.updateRow<_iegdvue1.UserNoteWithALongName>(
      $userNoteWithALongName,
      columns: [
        _iegdvue1
            .UserNoteWithALongName
            .t
            .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
      ],
      transaction: transaction,
    );
  }
}

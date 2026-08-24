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
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart'
    as _i08l111i;
import '../../long_identifiers/models_with_relations/user_note.dart'
    as _ia9r0qbl;

abstract class UserNoteCollection
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UserNoteCollection._({
    this.id,
    required this.name,
    this.userNotesPropertyName,
  });

  factory UserNoteCollection({
    int? id,
    required String name,
    List<_ia9r0qbl.UserNote>? userNotesPropertyName,
  }) = _UserNoteCollectionImpl;

  factory UserNoteCollection.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserNoteCollection(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      userNotesPropertyName: jsonSerialization['userNotesPropertyName'] == null
          ? null
          : _i08l111i.Protocol().deserialize<List<_ia9r0qbl.UserNote>>(
              jsonSerialization['userNotesPropertyName'],
            ),
    );
  }

  static final t = UserNoteCollectionTable();

  static const db = UserNoteCollectionRepository._();

  @override
  int? id;

  String name;

  List<_ia9r0qbl.UserNote>? userNotesPropertyName;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserNoteCollection]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserNoteCollection copyWith({
    int? id,
    String? name,
    List<_ia9r0qbl.UserNote>? userNotesPropertyName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserNoteCollection',
      if (id != null) 'id': id,
      'name': name,
      if (userNotesPropertyName != null)
        'userNotesPropertyName': userNotesPropertyName?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserNoteCollection',
      if (id != null) 'id': id,
      'name': name,
      if (userNotesPropertyName != null)
        'userNotesPropertyName': userNotesPropertyName?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  static UserNoteCollectionInclude include({
    _ia9r0qbl.UserNoteIncludeList? userNotesPropertyName,
    _is.SelectColumnsBuilder<UserNoteCollectionTable>? select,
  }) {
    return UserNoteCollectionInclude.internal_(
      userNotesPropertyName: userNotesPropertyName,
      selectedColumns: select?.call(UserNoteCollection.t),
    );
  }

  static UserNoteCollectionIncludeList includeList({
    _is.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserNoteCollectionTable>? orderBy,
    _is.OrderByListBuilder<UserNoteCollectionTable>? orderByList,
    UserNoteCollectionInclude? include,
    _is.SelectColumnsBuilder<UserNoteCollectionTable>? select,
  }) {
    return UserNoteCollectionIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserNoteCollection.t),
      orderByList: orderByList?.call(UserNoteCollection.t),
      include: include,
      selectedColumns: select?.call(UserNoteCollection.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserNoteCollectionImpl extends UserNoteCollection {
  _UserNoteCollectionImpl({
    int? id,
    required String name,
    List<_ia9r0qbl.UserNote>? userNotesPropertyName,
  }) : super._(
         id: id,
         name: name,
         userNotesPropertyName: userNotesPropertyName,
       );

  /// Returns a shallow copy of this [UserNoteCollection]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserNoteCollection copyWith({
    Object? id = _Undefined,
    String? name,
    Object? userNotesPropertyName = _Undefined,
  }) {
    return UserNoteCollection(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      userNotesPropertyName: userNotesPropertyName is List<_ia9r0qbl.UserNote>?
          ? userNotesPropertyName
          : this.userNotesPropertyName?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class UserNoteCollectionUpdateTable
    extends _is.UpdateTable<UserNoteCollectionTable> {
  UserNoteCollectionUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );
}

class UserNoteCollectionTable extends _is.Table<int?> {
  UserNoteCollectionTable({super.tableRelation})
    : super(tableName: 'user_note_collections') {
    updateTable = UserNoteCollectionUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
  }

  late final UserNoteCollectionUpdateTable updateTable;

  late final _is.ColumnString name;

  _ia9r0qbl.UserNoteTable? ___userNotesPropertyName;

  _is.ManyRelation<_ia9r0qbl.UserNoteTable>? _userNotesPropertyName;

  _ia9r0qbl.UserNoteTable get __userNotesPropertyName {
    if (___userNotesPropertyName != null) return ___userNotesPropertyName!;
    ___userNotesPropertyName = _is.createRelationTable(
      relationFieldName: '__userNotesPropertyName',
      field: UserNoteCollection.t.id,
      foreignField: _ia9r0qbl
          .UserNote
          .t
          .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ia9r0qbl.UserNoteTable(tableRelation: foreignTableRelation),
    );
    return ___userNotesPropertyName!;
  }

  _is.ManyRelation<_ia9r0qbl.UserNoteTable> get userNotesPropertyName {
    if (_userNotesPropertyName != null) return _userNotesPropertyName!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'userNotesPropertyName',
      field: UserNoteCollection.t.id,
      foreignField: _ia9r0qbl
          .UserNote
          .t
          .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ia9r0qbl.UserNoteTable(tableRelation: foreignTableRelation),
    );
    _userNotesPropertyName = _is.ManyRelation<_ia9r0qbl.UserNoteTable>(
      tableWithRelations: relationTable,
      table: _ia9r0qbl.UserNoteTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _userNotesPropertyName!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'userNotesPropertyName') {
      return __userNotesPropertyName;
    }
    return null;
  }
}

class UserNoteCollectionInclude extends _is.IncludeObject {
  UserNoteCollectionInclude.internal_({
    _ia9r0qbl.UserNoteIncludeList? userNotesPropertyName,
    this.selectedColumns,
  }) {
    _userNotesPropertyName = userNotesPropertyName;
  }

  _ia9r0qbl.UserNoteIncludeList? _userNotesPropertyName;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'userNotesPropertyName': _userNotesPropertyName,
  };

  @override
  _is.Table<int?> get table => UserNoteCollection.t;
}

class UserNoteCollectionIncludeList extends _is.IncludeList {
  UserNoteCollectionIncludeList.internal_({
    _is.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(UserNoteCollection.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UserNoteCollection.t;
}

class UserNoteCollectionRepository {
  const UserNoteCollectionRepository._();

  final attach = const UserNoteCollectionAttachRepository._();

  final attachRow = const UserNoteCollectionAttachRowRepository._();

  final detach = const UserNoteCollectionDetachRepository._();

  final detachRow = const UserNoteCollectionDetachRowRepository._();

  /// Returns a list of [UserNoteCollection]s matching the given query parameters.
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
  Future<List<UserNoteCollection>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserNoteCollectionTable>? orderBy,
    _is.OrderByListBuilder<UserNoteCollectionTable>? orderByList,
    _is.Transaction? transaction,
    UserNoteCollectionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserNoteCollection>(
      where: where?.call(UserNoteCollection.t),
      orderBy: orderBy?.call(UserNoteCollection.t),
      orderByList: orderByList?.call(UserNoteCollection.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserNoteCollection] matching the given query parameters.
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
  Future<UserNoteCollection?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? offset,
    _is.OrderByBuilder<UserNoteCollectionTable>? orderBy,
    _is.OrderByListBuilder<UserNoteCollectionTable>? orderByList,
    _is.Transaction? transaction,
    UserNoteCollectionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserNoteCollection>(
      where: where?.call(UserNoteCollection.t),
      orderBy: orderBy?.call(UserNoteCollection.t),
      orderByList: orderByList?.call(UserNoteCollection.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserNoteCollection] by its [id] or null if no such row exists.
  Future<UserNoteCollection?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    UserNoteCollectionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserNoteCollection>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserNoteCollection]s in the list and returns the inserted rows.
  ///
  /// The returned [UserNoteCollection]s will have their `id` fields set.
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
  Future<List<UserNoteCollection>> insert(
    _is.DatabaseSession session,
    List<UserNoteCollection> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserNoteCollection>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserNoteCollection] and returns the inserted row.
  ///
  /// The returned [UserNoteCollection] will have its `id` field set.
  Future<UserNoteCollection> insertRow(
    _is.DatabaseSession session,
    UserNoteCollection row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserNoteCollection>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserNoteCollection]s in the list and returns the resulting rows.
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
  /// The returned [UserNoteCollection]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserNoteCollection>> upsert(
    _is.DatabaseSession session,
    List<UserNoteCollection> rows, {
    required _is.ColumnSelections<UserNoteCollectionTable> conflictColumns,
    _is.ColumnSelections<UserNoteCollectionTable>? updateColumns,
    _is.WhereExpressionBuilder<UserNoteCollectionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserNoteCollection>(
      rows,
      conflictColumns: conflictColumns(UserNoteCollection.t),
      updateColumns: updateColumns?.call(UserNoteCollection.t),
      updateWhere: updateWhere?.call(UserNoteCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserNoteCollection] and returns the resulting row.
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
  /// The returned [UserNoteCollection] will have its `id` field set.
  Future<UserNoteCollection?> upsertRow(
    _is.DatabaseSession session,
    UserNoteCollection row, {
    required _is.ColumnSelections<UserNoteCollectionTable> conflictColumns,
    _is.ColumnSelections<UserNoteCollectionTable>? updateColumns,
    _is.WhereExpressionBuilder<UserNoteCollectionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserNoteCollection>(
      row,
      conflictColumns: conflictColumns(UserNoteCollection.t),
      updateColumns: updateColumns?.call(UserNoteCollection.t),
      updateWhere: updateWhere?.call(UserNoteCollection.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserNoteCollection]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserNoteCollection>> update(
    _is.DatabaseSession session,
    List<UserNoteCollection> rows, {
    _is.ColumnSelections<UserNoteCollectionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserNoteCollection>(
      rows,
      columns: columns?.call(UserNoteCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserNoteCollection]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserNoteCollection> updateRow(
    _is.DatabaseSession session,
    UserNoteCollection row, {
    _is.ColumnSelections<UserNoteCollectionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserNoteCollection>(
      row,
      columns: columns?.call(UserNoteCollection.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserNoteCollection] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserNoteCollection?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UserNoteCollectionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserNoteCollection>(
      id,
      columnValues: columnValues(UserNoteCollection.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserNoteCollection]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserNoteCollection>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UserNoteCollectionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<UserNoteCollectionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserNoteCollectionTable>? orderBy,
    _is.OrderByListBuilder<UserNoteCollectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserNoteCollection>(
      columnValues: columnValues(UserNoteCollection.t.updateTable),
      where: where(UserNoteCollection.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserNoteCollection.t),
      orderByList: orderByList?.call(UserNoteCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserNoteCollection]s in the list and returns the deleted rows.
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
  Future<List<UserNoteCollection>> delete(
    _is.DatabaseSession session,
    List<UserNoteCollection> rows, {
    _is.OrderByBuilder<UserNoteCollectionTable>? orderBy,
    _is.OrderByListBuilder<UserNoteCollectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserNoteCollection>(
      rows,
      orderBy: orderBy?.call(UserNoteCollection.t),
      orderByList: orderByList?.call(UserNoteCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserNoteCollection].
  Future<UserNoteCollection> deleteRow(
    _is.DatabaseSession session,
    UserNoteCollection row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserNoteCollection>(
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
  Future<List<UserNoteCollection>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserNoteCollectionTable> where,
    _is.OrderByBuilder<UserNoteCollectionTable>? orderBy,
    _is.OrderByListBuilder<UserNoteCollectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserNoteCollection>(
      where: where(UserNoteCollection.t),
      orderBy: orderBy?.call(UserNoteCollection.t),
      orderByList: orderByList?.call(UserNoteCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserNoteCollection>(
      where: where?.call(UserNoteCollection.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserNoteCollection] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserNoteCollectionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserNoteCollection>(
      where: where(UserNoteCollection.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class UserNoteCollectionAttachRepository {
  const UserNoteCollectionAttachRepository._();

  /// Creates a relation between this [UserNoteCollection] and the given [UserNote]s
  /// by setting each [UserNote]'s foreign key `_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId` to refer to this [UserNoteCollection].
  Future<void> userNotesPropertyName(
    _is.DatabaseSession session,
    UserNoteCollection userNoteCollection,
    List<_ia9r0qbl.UserNote> userNote, {
    _is.Transaction? transaction,
  }) async {
    if (userNote.any((e) => e.id == null)) {
      throw ArgumentError.notNull('userNote.id');
    }
    if (userNoteCollection.id == null) {
      throw ArgumentError.notNull('userNoteCollection.id');
    }

    var $userNote = userNote
        .map(
          (e) => _ia9r0qbl.UserNoteImplicit(
            e,
            $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId:
                userNoteCollection.id,
          ),
        )
        .toList();
    await session.db.update<_ia9r0qbl.UserNote>(
      $userNote,
      columns: [
        _ia9r0qbl
            .UserNote
            .t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
      ],
      transaction: transaction,
    );
  }
}

class UserNoteCollectionAttachRowRepository {
  const UserNoteCollectionAttachRowRepository._();

  /// Creates a relation between this [UserNoteCollection] and the given [UserNote]
  /// by setting the [UserNote]'s foreign key `_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId` to refer to this [UserNoteCollection].
  Future<void> userNotesPropertyName(
    _is.DatabaseSession session,
    UserNoteCollection userNoteCollection,
    _ia9r0qbl.UserNote userNote, {
    _is.Transaction? transaction,
  }) async {
    if (userNote.id == null) {
      throw ArgumentError.notNull('userNote.id');
    }
    if (userNoteCollection.id == null) {
      throw ArgumentError.notNull('userNoteCollection.id');
    }

    var $userNote = _ia9r0qbl.UserNoteImplicit(
      userNote,
      $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId:
          userNoteCollection.id,
    );
    await session.db.updateRow<_ia9r0qbl.UserNote>(
      $userNote,
      columns: [
        _ia9r0qbl
            .UserNote
            .t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
      ],
      transaction: transaction,
    );
  }
}

class UserNoteCollectionDetachRepository {
  const UserNoteCollectionDetachRepository._();

  /// Detaches the relation between this [UserNoteCollection] and the given [UserNote]
  /// by setting the [UserNote]'s foreign key `_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> userNotesPropertyName(
    _is.DatabaseSession session,
    List<_ia9r0qbl.UserNote> userNote, {
    _is.Transaction? transaction,
  }) async {
    if (userNote.any((e) => e.id == null)) {
      throw ArgumentError.notNull('userNote.id');
    }

    var $userNote = userNote
        .map(
          (e) => _ia9r0qbl.UserNoteImplicit(
            e,
            $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId:
                null,
          ),
        )
        .toList();
    await session.db.update<_ia9r0qbl.UserNote>(
      $userNote,
      columns: [
        _ia9r0qbl
            .UserNote
            .t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
      ],
      transaction: transaction,
    );
  }
}

class UserNoteCollectionDetachRowRepository {
  const UserNoteCollectionDetachRowRepository._();

  /// Detaches the relation between this [UserNoteCollection] and the given [UserNote]
  /// by setting the [UserNote]'s foreign key `_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> userNotesPropertyName(
    _is.DatabaseSession session,
    _ia9r0qbl.UserNote userNote, {
    _is.Transaction? transaction,
  }) async {
    if (userNote.id == null) {
      throw ArgumentError.notNull('userNote.id');
    }

    var $userNote = _ia9r0qbl.UserNoteImplicit(
      userNote,
      $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId: null,
    );
    await session.db.updateRow<_ia9r0qbl.UserNote>(
      $userNote,
      columns: [
        _ia9r0qbl
            .UserNote
            .t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
      ],
      transaction: transaction,
    );
  }
}

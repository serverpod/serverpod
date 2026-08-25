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
import 'projected_author.dart' as _iq5hz6n4;

abstract class ProjectedArticle
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ProjectedArticle._({
    this.id,
    required this.title,
    required this.authorId,
    this.author,
    required this.summary,
    required this.content,
  });

  factory ProjectedArticle({
    int? id,
    required String title,
    required int authorId,
    _iq5hz6n4.ProjectedAuthor? author,
    required String summary,
    required String content,
  }) = _ProjectedArticleImpl;

  factory ProjectedArticle.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedArticle(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      authorId: jsonSerialization['authorId'] as int,
      author: jsonSerialization['author'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_iq5hz6n4.ProjectedAuthor>(
              jsonSerialization['author'],
            ),
      summary: jsonSerialization['summary'] as String,
      content: jsonSerialization['content'] as String,
    );
  }

  static final t = ProjectedArticleTable();

  static const db = ProjectedArticleRepository._();

  @override
  int? id;

  String title;

  int authorId;

  _iq5hz6n4.ProjectedAuthor? author;

  String summary;

  String content;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ProjectedArticle]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedArticle copyWith({
    int? id,
    String? title,
    int? authorId,
    _iq5hz6n4.ProjectedAuthor? author,
    String? summary,
    String? content,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedArticle',
      if (id != null) 'id': id,
      'title': title,
      'authorId': authorId,
      if (author != null) 'author': author?.toJson(),
      'summary': summary,
      'content': content,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedArticle',
      if (id != null) 'id': id,
      'title': title,
      'authorId': authorId,
      if (author != null) 'author': author?.toJsonForProtocol(),
      'summary': summary,
      'content': content,
    };
  }

  static ProjectedArticleInclude include({
    _iq5hz6n4.ProjectedAuthorInclude? author,
    _is.SelectColumnsBuilder<ProjectedArticleTable>? select,
  }) {
    return ProjectedArticleInclude._(
      author: author,
      selectedColumns: select?.call(ProjectedArticle.t),
    );
  }

  static ProjectedArticleIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedArticleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedArticleTable>? orderBy,
    _is.OrderByListBuilder<ProjectedArticleTable>? orderByList,
    ProjectedArticleInclude? include,
    _is.SelectColumnsBuilder<ProjectedArticleTable>? select,
  }) {
    return ProjectedArticleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedArticle.t),
      orderByList: orderByList?.call(ProjectedArticle.t),
      include: include,
      selectedColumns: select?.call(ProjectedArticle.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedArticleImpl extends ProjectedArticle {
  _ProjectedArticleImpl({
    int? id,
    required String title,
    required int authorId,
    _iq5hz6n4.ProjectedAuthor? author,
    required String summary,
    required String content,
  }) : super._(
         id: id,
         title: title,
         authorId: authorId,
         author: author,
         summary: summary,
         content: content,
       );

  /// Returns a shallow copy of this [ProjectedArticle]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedArticle copyWith({
    Object? id = _Undefined,
    String? title,
    int? authorId,
    Object? author = _Undefined,
    String? summary,
    String? content,
  }) {
    return ProjectedArticle(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      authorId: authorId ?? this.authorId,
      author: author is _iq5hz6n4.ProjectedAuthor?
          ? author
          : this.author?.copyWith(),
      summary: summary ?? this.summary,
      content: content ?? this.content,
    );
  }
}

class ProjectedArticleUpdateTable
    extends _is.UpdateTable<ProjectedArticleTable> {
  ProjectedArticleUpdateTable(super.table);

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<int, int> authorId(int value) => _is.ColumnValue(
    table.authorId,
    value,
  );

  _is.ColumnValue<String, String> summary(String value) => _is.ColumnValue(
    table.summary,
    value,
  );

  _is.ColumnValue<String, String> content(String value) => _is.ColumnValue(
    table.content,
    value,
  );
}

class ProjectedArticleTable extends _is.Table<int?> {
  ProjectedArticleTable({super.tableRelation})
    : super(tableName: 'projected_article') {
    updateTable = ProjectedArticleUpdateTable(this);
    title = _is.ColumnString(
      'title',
      this,
    );
    authorId = _is.ColumnInt(
      'authorId',
      this,
    );
    summary = _is.ColumnString(
      'summary',
      this,
    );
    content = _is.ColumnString(
      'content',
      this,
    );
  }

  late final ProjectedArticleUpdateTable updateTable;

  late final _is.ColumnString title;

  late final _is.ColumnInt authorId;

  _iq5hz6n4.ProjectedAuthorTable? _author;

  late final _is.ColumnString summary;

  late final _is.ColumnString content;

  _iq5hz6n4.ProjectedAuthorTable get author {
    if (_author != null) return _author!;
    _author = _is.createRelationTable(
      relationFieldName: 'author',
      field: ProjectedArticle.t.authorId,
      foreignField: _iq5hz6n4.ProjectedAuthor.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iq5hz6n4.ProjectedAuthorTable(tableRelation: foreignTableRelation),
    );
    return _author!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    title,
    authorId,
    summary,
    content,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'author') {
      return author;
    }
    return null;
  }
}

class ProjectedArticleInclude extends _is.IncludeObject {
  ProjectedArticleInclude._({
    _iq5hz6n4.ProjectedAuthorInclude? author,
    this.selectedColumns,
  }) {
    _author = author;
  }

  _iq5hz6n4.ProjectedAuthorInclude? _author;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'author': _author};

  @override
  _is.Table<int?> get table => ProjectedArticle.t;
}

class ProjectedArticleIncludeList extends _is.IncludeList {
  ProjectedArticleIncludeList._({
    _is.WhereExpressionBuilder<ProjectedArticleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ProjectedArticle.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ProjectedArticle.t;
}

class ProjectedArticleRepository {
  const ProjectedArticleRepository._();

  final attachRow = const ProjectedArticleAttachRowRepository._();

  /// Returns a list of [ProjectedArticle]s matching the given query parameters.
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
  Future<List<ProjectedArticle>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedArticleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedArticleTable>? orderBy,
    _is.OrderByListBuilder<ProjectedArticleTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedArticleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProjectedArticle>(
      where: where?.call(ProjectedArticle.t),
      orderBy: orderBy?.call(ProjectedArticle.t),
      orderByList: orderByList?.call(ProjectedArticle.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProjectedArticle] matching the given query parameters.
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
  Future<ProjectedArticle?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedArticleTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedArticleTable>? orderBy,
    _is.OrderByListBuilder<ProjectedArticleTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedArticleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProjectedArticle>(
      where: where?.call(ProjectedArticle.t),
      orderBy: orderBy?.call(ProjectedArticle.t),
      orderByList: orderByList?.call(ProjectedArticle.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProjectedArticle] by its [id] or null if no such row exists.
  Future<ProjectedArticle?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    ProjectedArticleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProjectedArticle>(
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
    _is.WhereExpressionBuilder<ProjectedArticleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedArticleTable>? orderBy,
    _is.OrderByListBuilder<ProjectedArticleTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedArticleInclude? include,
    _is.SelectColumnsBuilder<ProjectedArticleTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ProjectedArticle>(
      where: where?.call(ProjectedArticle.t),
      orderBy: orderBy?.call(ProjectedArticle.t),
      orderByList: orderByList?.call(ProjectedArticle.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(ProjectedArticle.t),
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
    _is.WhereExpressionBuilder<ProjectedArticleTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedArticleTable>? orderBy,
    _is.OrderByListBuilder<ProjectedArticleTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedArticleInclude? include,
    _is.SelectColumnsBuilder<ProjectedArticleTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ProjectedArticle>(
      where: where?.call(ProjectedArticle.t),
      orderBy: orderBy?.call(ProjectedArticle.t),
      orderByList: orderByList?.call(ProjectedArticle.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(ProjectedArticle.t),
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
    ProjectedArticleInclude? include,
    _is.SelectColumnsBuilder<ProjectedArticleTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ProjectedArticle>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(ProjectedArticle.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProjectedArticle]s in the list and returns the inserted rows.
  ///
  /// The returned [ProjectedArticle]s will have their `id` fields set.
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
  Future<List<ProjectedArticle>> insert(
    _is.DatabaseSession session,
    List<ProjectedArticle> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProjectedArticle>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProjectedArticle] and returns the inserted row.
  ///
  /// The returned [ProjectedArticle] will have its `id` field set.
  Future<ProjectedArticle> insertRow(
    _is.DatabaseSession session,
    ProjectedArticle row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProjectedArticle>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProjectedArticle]s in the list and returns the resulting rows.
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
  /// The returned [ProjectedArticle]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedArticle>> upsert(
    _is.DatabaseSession session,
    List<ProjectedArticle> rows, {
    required _is.ColumnSelections<ProjectedArticleTable> conflictColumns,
    _is.ColumnSelections<ProjectedArticleTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectedArticleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProjectedArticle>(
      rows,
      conflictColumns: conflictColumns(ProjectedArticle.t),
      updateColumns: updateColumns?.call(ProjectedArticle.t),
      updateWhere: updateWhere?.call(ProjectedArticle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProjectedArticle] and returns the resulting row.
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
  /// The returned [ProjectedArticle] will have its `id` field set.
  Future<ProjectedArticle?> upsertRow(
    _is.DatabaseSession session,
    ProjectedArticle row, {
    required _is.ColumnSelections<ProjectedArticleTable> conflictColumns,
    _is.ColumnSelections<ProjectedArticleTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectedArticleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProjectedArticle>(
      row,
      conflictColumns: conflictColumns(ProjectedArticle.t),
      updateColumns: updateColumns?.call(ProjectedArticle.t),
      updateWhere: updateWhere?.call(ProjectedArticle.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedArticle]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedArticle>> update(
    _is.DatabaseSession session,
    List<ProjectedArticle> rows, {
    _is.ColumnSelections<ProjectedArticleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProjectedArticle>(
      rows,
      columns: columns?.call(ProjectedArticle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProjectedArticle]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProjectedArticle> updateRow(
    _is.DatabaseSession session,
    ProjectedArticle row, {
    _is.ColumnSelections<ProjectedArticleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProjectedArticle>(
      row,
      columns: columns?.call(ProjectedArticle.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectedArticle] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProjectedArticle?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ProjectedArticleUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProjectedArticle>(
      id,
      columnValues: columnValues(ProjectedArticle.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedArticle]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedArticle>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProjectedArticleUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ProjectedArticleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedArticleTable>? orderBy,
    _is.OrderByListBuilder<ProjectedArticleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProjectedArticle>(
      columnValues: columnValues(ProjectedArticle.t.updateTable),
      where: where(ProjectedArticle.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedArticle.t),
      orderByList: orderByList?.call(ProjectedArticle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProjectedArticle]s in the list and returns the deleted rows.
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
  Future<List<ProjectedArticle>> delete(
    _is.DatabaseSession session,
    List<ProjectedArticle> rows, {
    _is.OrderByBuilder<ProjectedArticleTable>? orderBy,
    _is.OrderByListBuilder<ProjectedArticleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProjectedArticle>(
      rows,
      orderBy: orderBy?.call(ProjectedArticle.t),
      orderByList: orderByList?.call(ProjectedArticle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProjectedArticle].
  Future<ProjectedArticle> deleteRow(
    _is.DatabaseSession session,
    ProjectedArticle row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProjectedArticle>(
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
  Future<List<ProjectedArticle>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectedArticleTable> where,
    _is.OrderByBuilder<ProjectedArticleTable>? orderBy,
    _is.OrderByListBuilder<ProjectedArticleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProjectedArticle>(
      where: where(ProjectedArticle.t),
      orderBy: orderBy?.call(ProjectedArticle.t),
      orderByList: orderByList?.call(ProjectedArticle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedArticleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProjectedArticle>(
      where: where?.call(ProjectedArticle.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProjectedArticle] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectedArticleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProjectedArticle>(
      where: where(ProjectedArticle.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ProjectedArticleAttachRowRepository {
  const ProjectedArticleAttachRowRepository._();

  /// Creates a relation between the given [ProjectedArticle] and [ProjectedAuthor]
  /// by setting the [ProjectedArticle]'s foreign key `authorId` to refer to the [ProjectedAuthor].
  Future<void> author(
    _is.DatabaseSession session,
    ProjectedArticle projectedArticle,
    _iq5hz6n4.ProjectedAuthor author, {
    _is.Transaction? transaction,
  }) async {
    if (projectedArticle.id == null) {
      throw ArgumentError.notNull('projectedArticle.id');
    }
    if (author.id == null) {
      throw ArgumentError.notNull('author.id');
    }

    var $projectedArticle = projectedArticle.copyWith(authorId: author.id);
    await session.db.updateRow<ProjectedArticle>(
      $projectedArticle,
      columns: [ProjectedArticle.t.authorId],
      transaction: transaction,
    );
  }
}

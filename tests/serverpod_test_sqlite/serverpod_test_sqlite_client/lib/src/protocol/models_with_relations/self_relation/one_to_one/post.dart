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
import '../../../models_with_relations/self_relation/one_to_one/post.dart'
    as _ittc76ec;

abstract class Post implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  Post._({
    this.id,
    required this.content,
    this.previous,
    this.nextId,
    this.next,
  });

  factory Post({
    int? id,
    required String content,
    _ittc76ec.Post? previous,
    int? nextId,
    _ittc76ec.Post? next,
  }) = _PostImpl;

  factory Post.fromJson(Map<String, dynamic> jsonSerialization) {
    return Post(
      id: jsonSerialization['id'] as int?,
      content: jsonSerialization['content'] as String,
      previous: jsonSerialization['previous'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_ittc76ec.Post>(
              jsonSerialization['previous'],
            ),
      nextId: jsonSerialization['nextId'] as int?,
      next: jsonSerialization['next'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_ittc76ec.Post>(
              jsonSerialization['next'],
            ),
    );
  }

  static final t = PostTable();

  static const db = PostRepository._();

  @override
  int? id;

  String content;

  _ittc76ec.Post? previous;

  int? nextId;

  _ittc76ec.Post? next;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [Post]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Post copyWith({
    int? id,
    String? content,
    _ittc76ec.Post? previous,
    int? nextId,
    _ittc76ec.Post? next,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Post',
      if (id != null) 'id': id,
      'content': content,
      if (previous != null) 'previous': previous?.toJson(),
      if (nextId != null) 'nextId': nextId,
      if (next != null) 'next': next?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Post',
      if (id != null) 'id': id,
      'content': content,
      if (previous != null) 'previous': previous?.toJsonForProtocol(),
      if (nextId != null) 'nextId': nextId,
      if (next != null) 'next': next?.toJsonForProtocol(),
    };
  }

  /// Builds a complete [PostInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static PostInclude include({
    _ittc76ec.PostInclude? previous,
    _ittc76ec.PostInclude? next,
  }) {
    return PostInclude._(
      previous: previous,
      next: next,
    );
  }

  /// Builds a complete [PostIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static PostIncludeList includeList({
    _isd.WhereExpressionBuilder<PostTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<PostTable>? orderBy,
    _isd.OrderByListBuilder<PostTable>? orderByList,
    PostInclude? include,
  }) {
    return PostIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Post.t),
      orderByList: orderByList?.call(Post.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [PostJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static PostJsonInclude includeJson({
    _ittc76ec.PostJsonInclude? previous,
    _ittc76ec.PostJsonInclude? next,
    _isd.SelectColumnsBuilder<PostTable>? select,
  }) {
    return _PostJsonInclude._(
      previous: previous,
      next: next,
      selectedColumns: select?.call(Post.t),
    );
  }

  /// Builds a JSON-compatible [PostJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static PostJsonIncludeList includeJsonList({
    _isd.WhereExpressionBuilder<PostTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<PostTable>? orderBy,
    _isd.OrderByListBuilder<PostTable>? orderByList,
    PostJsonInclude? include,
    _isd.SelectColumnsBuilder<PostTable>? select,
  }) {
    return _PostJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Post.t),
      orderByList: orderByList?.call(Post.t),
      include: include,
      selectedColumns: select?.call(Post.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PostImpl extends Post {
  _PostImpl({
    int? id,
    required String content,
    _ittc76ec.Post? previous,
    int? nextId,
    _ittc76ec.Post? next,
  }) : super._(
         id: id,
         content: content,
         previous: previous,
         nextId: nextId,
         next: next,
       );

  /// Returns a shallow copy of this [Post]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Post copyWith({
    Object? id = _Undefined,
    String? content,
    Object? previous = _Undefined,
    Object? nextId = _Undefined,
    Object? next = _Undefined,
  }) {
    return Post(
      id: id is int? ? id : this.id,
      content: content ?? this.content,
      previous: previous is _ittc76ec.Post?
          ? previous
          : this.previous?.copyWith(),
      nextId: nextId is int? ? nextId : this.nextId,
      next: next is _ittc76ec.Post? ? next : this.next?.copyWith(),
    );
  }
}

class PostUpdateTable extends _isd.UpdateTable<PostTable> {
  PostUpdateTable(super.table);

  _isd.ColumnValue<String, String> content(String value) => _isd.ColumnValue(
    table.content,
    value,
  );

  _isd.ColumnValue<int, int> nextId(int? value) => _isd.ColumnValue(
    table.nextId,
    value,
  );
}

class PostTable extends _isd.Table<int?> {
  PostTable({super.tableRelation}) : super(tableName: 'post') {
    updateTable = PostUpdateTable(this);
    content = _isd.ColumnString(
      'content',
      this,
    );
    nextId = _isd.ColumnInt(
      'nextId',
      this,
    );
  }

  late final PostUpdateTable updateTable;

  late final _isd.ColumnString content;

  _ittc76ec.PostTable? _previous;

  late final _isd.ColumnInt nextId;

  _ittc76ec.PostTable? _next;

  _ittc76ec.PostTable get previous {
    if (_previous != null) return _previous!;
    _previous = _isd.createRelationTable(
      relationFieldName: 'previous',
      field: Post.t.id,
      foreignField: _ittc76ec.Post.t.nextId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ittc76ec.PostTable(tableRelation: foreignTableRelation),
    );
    return _previous!;
  }

  _ittc76ec.PostTable get next {
    if (_next != null) return _next!;
    _next = _isd.createRelationTable(
      relationFieldName: 'next',
      field: Post.t.nextId,
      foreignField: _ittc76ec.Post.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ittc76ec.PostTable(tableRelation: foreignTableRelation),
    );
    return _next!;
  }

  @override
  List<_isd.Column> get columns => [
    id,
    content,
    nextId,
  ];

  @override
  _isd.Table? getRelationTable(String relationField) {
    if (relationField == 'previous') {
      return previous;
    }
    if (relationField == 'next') {
      return next;
    }
    return null;
  }
}

abstract interface class PostJsonInclude
    implements _isd.JsonCompatibleInclude {}

abstract interface class PostJsonIncludeList
    implements _isd.JsonCompatibleInclude {}

final class PostInclude extends _isd.IncludeObject
    implements PostJsonInclude, _isd.FullModelInclude {
  PostInclude._({
    _ittc76ec.PostInclude? previous,
    _ittc76ec.PostInclude? next,
  }) {
    _previous = previous;
    _next = next;
  }

  _ittc76ec.PostInclude? _previous;

  _ittc76ec.PostInclude? _next;

  @override
  Map<String, _isd.Include?> get includes => {
    'previous': _previous,
    'next': _next,
  };

  @override
  _isd.Table<int?> get table => Post.t;
}

final class PostIncludeList extends _isd.IncludeList
    implements PostJsonIncludeList, _isd.FullModelInclude {
  PostIncludeList._({
    _isd.WhereExpressionBuilder<PostTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    PostInclude? super.include,
  }) {
    super.where = where?.call(Post.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Post.t;
}

final class _PostJsonInclude extends _isd.IncludeObject
    implements PostJsonInclude {
  _PostJsonInclude._({
    _ittc76ec.PostJsonInclude? previous,
    _ittc76ec.PostJsonInclude? next,
    this.selectedColumns,
  }) {
    _previous = previous;
    _next = next;
  }

  _ittc76ec.PostJsonInclude? _previous;

  _ittc76ec.PostJsonInclude? _next;

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {
    'previous': _previous,
    'next': _next,
  };

  @override
  _isd.Table<int?> get table => Post.t;
}

final class _PostJsonIncludeList extends _isd.IncludeList
    implements PostJsonIncludeList {
  _PostJsonIncludeList._({
    _isd.WhereExpressionBuilder<PostTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    PostJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Post.t);
  }

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Post.t;
}

class PostRepository {
  const PostRepository._();

  final attachRow = const PostAttachRowRepository._();

  final detachRow = const PostDetachRowRepository._();

  /// Returns a list of [Post]s matching the given query parameters.
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
  Future<List<Post>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<PostTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<PostTable>? orderBy,
    _isd.OrderByListBuilder<PostTable>? orderByList,
    _isd.Transaction? transaction,
    PostInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Post>(
      where: where?.call(Post.t),
      orderBy: orderBy?.call(Post.t),
      orderByList: orderByList?.call(Post.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Post] matching the given query parameters.
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
  Future<Post?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<PostTable>? where,
    int? offset,
    _isd.OrderByBuilder<PostTable>? orderBy,
    _isd.OrderByListBuilder<PostTable>? orderByList,
    _isd.Transaction? transaction,
    PostInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Post>(
      where: where?.call(Post.t),
      orderBy: orderBy?.call(Post.t),
      orderByList: orderByList?.call(Post.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Post] by its [id] or null if no such row exists.
  Future<Post?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    PostInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Post>(
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
    _isd.WhereExpressionBuilder<PostTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<PostTable>? orderBy,
    _isd.OrderByListBuilder<PostTable>? orderByList,
    _isd.Transaction? transaction,
    PostJsonInclude? include,
    _isd.SelectColumnsBuilder<PostTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Post>(
      where: where?.call(Post.t),
      orderBy: orderBy?.call(Post.t),
      orderByList: orderByList?.call(Post.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Post.t),
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
    _isd.WhereExpressionBuilder<PostTable>? where,
    int? offset,
    _isd.OrderByBuilder<PostTable>? orderBy,
    _isd.OrderByListBuilder<PostTable>? orderByList,
    _isd.Transaction? transaction,
    PostJsonInclude? include,
    _isd.SelectColumnsBuilder<PostTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Post>(
      where: where?.call(Post.t),
      orderBy: orderBy?.call(Post.t),
      orderByList: orderByList?.call(Post.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Post.t),
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
    PostJsonInclude? include,
    _isd.SelectColumnsBuilder<PostTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Post>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Post.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Post]s in the list and returns the inserted rows.
  ///
  /// The returned [Post]s will have their `id` fields set.
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
  Future<List<Post>> insert(
    _isd.DatabaseSession session,
    List<Post> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Post>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Post] and returns the inserted row.
  ///
  /// The returned [Post] will have its `id` field set.
  Future<Post> insertRow(
    _isd.DatabaseSession session,
    Post row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<Post>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Post]s in the list and returns the resulting rows.
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
  /// The returned [Post]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Post>> upsert(
    _isd.DatabaseSession session,
    List<Post> rows, {
    required _isd.ColumnSelections<PostTable> conflictColumns,
    _isd.ColumnSelections<PostTable>? updateColumns,
    _isd.WhereExpressionBuilder<PostTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Post>(
      rows,
      conflictColumns: conflictColumns(Post.t),
      updateColumns: updateColumns?.call(Post.t),
      updateWhere: updateWhere?.call(Post.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Post] and returns the resulting row.
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
  /// The returned [Post] will have its `id` field set.
  Future<Post?> upsertRow(
    _isd.DatabaseSession session,
    Post row, {
    required _isd.ColumnSelections<PostTable> conflictColumns,
    _isd.ColumnSelections<PostTable>? updateColumns,
    _isd.WhereExpressionBuilder<PostTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Post>(
      row,
      conflictColumns: conflictColumns(Post.t),
      updateColumns: updateColumns?.call(Post.t),
      updateWhere: updateWhere?.call(Post.t),
      transaction: transaction,
    );
  }

  /// Updates all [Post]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Post>> update(
    _isd.DatabaseSession session,
    List<Post> rows, {
    _isd.ColumnSelections<PostTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Post>(
      rows,
      columns: columns?.call(Post.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Post]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Post> updateRow(
    _isd.DatabaseSession session,
    Post row, {
    _isd.ColumnSelections<PostTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<Post>(
      row,
      columns: columns?.call(Post.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Post] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Post?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<PostUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<Post>(
      id,
      columnValues: columnValues(Post.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Post]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Post>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<PostUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<PostTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<PostTable>? orderBy,
    _isd.OrderByListBuilder<PostTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Post>(
      columnValues: columnValues(Post.t.updateTable),
      where: where(Post.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Post.t),
      orderByList: orderByList?.call(Post.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Post]s in the list and returns the deleted rows.
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
  Future<List<Post>> delete(
    _isd.DatabaseSession session,
    List<Post> rows, {
    _isd.OrderByBuilder<PostTable>? orderBy,
    _isd.OrderByListBuilder<PostTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Post>(
      rows,
      orderBy: orderBy?.call(Post.t),
      orderByList: orderByList?.call(Post.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Post].
  Future<Post> deleteRow(
    _isd.DatabaseSession session,
    Post row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Post>(
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
  Future<List<Post>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<PostTable> where,
    _isd.OrderByBuilder<PostTable>? orderBy,
    _isd.OrderByListBuilder<PostTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Post>(
      where: where(Post.t),
      orderBy: orderBy?.call(Post.t),
      orderByList: orderByList?.call(Post.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<PostTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<Post>(
      where: where?.call(Post.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Post] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<PostTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Post>(
      where: where(Post.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PostAttachRowRepository {
  const PostAttachRowRepository._();

  /// Creates a relation between the given [Post] and [Post]
  /// by setting the [Post]'s foreign key `id` to refer to the [Post].
  Future<void> previous(
    _isd.DatabaseSession session,
    Post post,
    _ittc76ec.Post previous, {
    _isd.Transaction? transaction,
  }) async {
    if (previous.id == null) {
      throw ArgumentError.notNull('previous.id');
    }
    if (post.id == null) {
      throw ArgumentError.notNull('post.id');
    }

    var $previous = previous.copyWith(nextId: post.id);
    await session.db.updateRow<_ittc76ec.Post>(
      $previous,
      columns: [_ittc76ec.Post.t.nextId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Post] and [Post]
  /// by setting the [Post]'s foreign key `nextId` to refer to the [Post].
  Future<void> next(
    _isd.DatabaseSession session,
    Post post,
    _ittc76ec.Post next, {
    _isd.Transaction? transaction,
  }) async {
    if (post.id == null) {
      throw ArgumentError.notNull('post.id');
    }
    if (next.id == null) {
      throw ArgumentError.notNull('next.id');
    }

    var $post = post.copyWith(nextId: next.id);
    await session.db.updateRow<Post>(
      $post,
      columns: [Post.t.nextId],
      transaction: transaction,
    );
  }
}

class PostDetachRowRepository {
  const PostDetachRowRepository._();

  /// Detaches the relation between this [Post] and the [Post] set in `previous`
  /// by setting the [Post]'s foreign key `id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> previous(
    _isd.DatabaseSession session,
    Post post, {
    _isd.Transaction? transaction,
  }) async {
    var $previous = post.previous;

    if ($previous == null) {
      throw ArgumentError.notNull('post.previous');
    }
    if ($previous.id == null) {
      throw ArgumentError.notNull('post.previous.id');
    }
    if (post.id == null) {
      throw ArgumentError.notNull('post.id');
    }

    var $$previous = $previous.copyWith(nextId: null);
    await session.db.updateRow<_ittc76ec.Post>(
      $$previous,
      columns: [_ittc76ec.Post.t.nextId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Post] and the [Post] set in `next`
  /// by setting the [Post]'s foreign key `nextId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> next(
    _isd.DatabaseSession session,
    Post post, {
    _isd.Transaction? transaction,
  }) async {
    if (post.id == null) {
      throw ArgumentError.notNull('post.id');
    }

    var $post = post.copyWith(nextId: null);
    await session.db.updateRow<Post>(
      $post,
      columns: [Post.t.nextId],
      transaction: transaction,
    );
  }
}

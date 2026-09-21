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
import '../../../models_with_relations/one_to_many/implicit/chapter.dart'
    as _ithd8abs;

abstract class Book implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Book._({
    this.id,
    required this.title,
    this.chapters,
  });

  factory Book({
    int? id,
    required String title,
    List<_ithd8abs.Chapter>? chapters,
  }) = _BookImpl;

  factory Book.fromJson(Map<String, dynamic> jsonSerialization) {
    return Book(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      chapters: jsonSerialization['chapters'] == null
          ? null
          : _i08l111i.Protocol().deserialize<List<_ithd8abs.Chapter>>(
              jsonSerialization['chapters'],
            ),
    );
  }

  static final t = BookTable();

  static const db = BookRepository._();

  @override
  int? id;

  String title;

  List<_ithd8abs.Chapter>? chapters;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Book]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Book copyWith({
    int? id,
    String? title,
    List<_ithd8abs.Chapter>? chapters,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Book',
      if (id != null) 'id': id,
      'title': title,
      if (chapters != null)
        'chapters': chapters?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Book',
      if (id != null) 'id': id,
      'title': title,
      if (chapters != null)
        'chapters': chapters?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  /// Builds a complete [BookInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static BookInclude include({_ithd8abs.ChapterIncludeList? chapters}) {
    return BookInclude._(chapters: chapters);
  }

  /// Builds a complete [BookIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static BookIncludeList includeList({
    _is.WhereExpressionBuilder<BookTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BookTable>? orderBy,
    _is.OrderByListBuilder<BookTable>? orderByList,
    BookInclude? include,
  }) {
    return BookIncludeList._(
      where: where?.call(Book.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [BookJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static BookJsonInclude includeJson({
    _ithd8abs.ChapterJsonIncludeList? chapters,
    _is.SelectColumnsBuilder<BookTable>? select,
  }) {
    return _BookJsonInclude._(
      chapters: chapters,
      selectedColumns: select?.call(Book.t),
    );
  }

  /// Builds a JSON-compatible [BookJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static BookJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<BookTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BookTable>? orderBy,
    _is.OrderByListBuilder<BookTable>? orderByList,
    BookJsonInclude? include,
    _is.SelectColumnsBuilder<BookTable>? select,
  }) {
    return _BookJsonIncludeList._(
      where: where?.call(Book.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      include: include,
      selectedColumns: select?.call(Book.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BookImpl extends Book {
  _BookImpl({
    int? id,
    required String title,
    List<_ithd8abs.Chapter>? chapters,
  }) : super._(
         id: id,
         title: title,
         chapters: chapters,
       );

  /// Returns a shallow copy of this [Book]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Book copyWith({
    Object? id = _Undefined,
    String? title,
    Object? chapters = _Undefined,
  }) {
    return Book(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      chapters: chapters is List<_ithd8abs.Chapter>?
          ? chapters
          : this.chapters?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class BookUpdateTable extends _is.UpdateTable<BookTable> {
  BookUpdateTable(super.table);

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );
}

class BookTable extends _is.Table<int?> {
  BookTable({super.tableRelation}) : super(tableName: 'book') {
    updateTable = BookUpdateTable(this);
    title = _is.ColumnString(
      'title',
      this,
    );
  }

  late final BookUpdateTable updateTable;

  late final _is.ColumnString title;

  _ithd8abs.ChapterTable? ___chapters;

  _is.ManyRelation<_ithd8abs.ChapterTable>? _chapters;

  _ithd8abs.ChapterTable get __chapters {
    if (___chapters != null) return ___chapters!;
    ___chapters = _is.createRelationTable(
      relationFieldName: '__chapters',
      field: Book.t.id,
      foreignField: _ithd8abs.Chapter.t.$_bookChaptersBookId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ithd8abs.ChapterTable(tableRelation: foreignTableRelation),
    );
    return ___chapters!;
  }

  _is.ManyRelation<_ithd8abs.ChapterTable> get chapters {
    if (_chapters != null) return _chapters!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'chapters',
      field: Book.t.id,
      foreignField: _ithd8abs.Chapter.t.$_bookChaptersBookId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ithd8abs.ChapterTable(tableRelation: foreignTableRelation),
    );
    _chapters = _is.ManyRelation<_ithd8abs.ChapterTable>(
      tableWithRelations: relationTable,
      table: _ithd8abs.ChapterTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _chapters!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    title,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'chapters') {
      return __chapters;
    }
    return null;
  }
}

abstract interface class BookJsonInclude implements _is.JsonCompatibleInclude {}

abstract interface class BookJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class BookInclude extends _is.IncludeObject
    implements BookJsonInclude, _is.FullModelInclude {
  BookInclude._({_ithd8abs.ChapterIncludeList? chapters}) {
    _chapters = chapters;
  }

  _ithd8abs.ChapterIncludeList? _chapters;

  @override
  Map<String, _is.Include?> get includes => {'chapters': _chapters};

  @override
  _is.Table<int?> get table => Book.t;
}

final class BookIncludeList extends _is.IncludeList
    implements BookJsonIncludeList, _is.FullModelInclude {
  BookIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    BookInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Book.t;
}

final class _BookJsonInclude extends _is.IncludeObject
    implements BookJsonInclude {
  _BookJsonInclude._({
    _ithd8abs.ChapterJsonIncludeList? chapters,
    this.selectedColumns,
  }) {
    _chapters = chapters;
  }

  _ithd8abs.ChapterJsonIncludeList? _chapters;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'chapters': _chapters};

  @override
  _is.Table<int?> get table => Book.t;
}

final class _BookJsonIncludeList extends _is.IncludeList
    implements BookJsonIncludeList {
  _BookJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    BookJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Book.t;
}

class BookRepository {
  const BookRepository._();

  final attach = const BookAttachRepository._();

  final attachRow = const BookAttachRowRepository._();

  final detach = const BookDetachRepository._();

  final detachRow = const BookDetachRowRepository._();

  /// Returns a list of [Book]s matching the given query parameters.
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
  Future<List<Book>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BookTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BookTable>? orderBy,
    _is.OrderByListBuilder<BookTable>? orderByList,
    _is.Transaction? transaction,
    BookInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Book>(
      where: where?.call(Book.t),
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Book] matching the given query parameters.
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
  Future<Book?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BookTable>? where,
    int? offset,
    _is.OrderByBuilder<BookTable>? orderBy,
    _is.OrderByListBuilder<BookTable>? orderByList,
    _is.Transaction? transaction,
    BookInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Book>(
      where: where?.call(Book.t),
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Book] by its [id] or null if no such row exists.
  Future<Book?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    BookInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Book>(
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BookTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BookTable>? orderBy,
    _is.OrderByListBuilder<BookTable>? orderByList,
    _is.Transaction? transaction,
    BookJsonInclude? include,
    _is.SelectColumnsBuilder<BookTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Book>(
      where: where?.call(Book.t),
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Book.t),
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BookTable>? where,
    int? offset,
    _is.OrderByBuilder<BookTable>? orderBy,
    _is.OrderByListBuilder<BookTable>? orderByList,
    _is.Transaction? transaction,
    BookJsonInclude? include,
    _is.SelectColumnsBuilder<BookTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Book>(
      where: where?.call(Book.t),
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Book.t),
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
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    BookJsonInclude? include,
    _is.SelectColumnsBuilder<BookTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Book>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Book.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Book]s in the list and returns the inserted rows.
  ///
  /// The returned [Book]s will have their `id` fields set.
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
  Future<List<Book>> insert(
    _is.DatabaseSession session,
    List<Book> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Book>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Book] and returns the inserted row.
  ///
  /// The returned [Book] will have its `id` field set.
  Future<Book> insertRow(
    _is.DatabaseSession session,
    Book row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Book>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Book]s in the list and returns the resulting rows.
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
  /// The returned [Book]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Book>> upsert(
    _is.DatabaseSession session,
    List<Book> rows, {
    required _is.ColumnSelections<BookTable> conflictColumns,
    _is.ColumnSelections<BookTable>? updateColumns,
    _is.WhereExpressionBuilder<BookTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Book>(
      rows,
      conflictColumns: conflictColumns(Book.t),
      updateColumns: updateColumns?.call(Book.t),
      updateWhere: updateWhere?.call(Book.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Book] and returns the resulting row.
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
  /// The returned [Book] will have its `id` field set.
  Future<Book?> upsertRow(
    _is.DatabaseSession session,
    Book row, {
    required _is.ColumnSelections<BookTable> conflictColumns,
    _is.ColumnSelections<BookTable>? updateColumns,
    _is.WhereExpressionBuilder<BookTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Book>(
      row,
      conflictColumns: conflictColumns(Book.t),
      updateColumns: updateColumns?.call(Book.t),
      updateWhere: updateWhere?.call(Book.t),
      transaction: transaction,
    );
  }

  /// Updates all [Book]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Book>> update(
    _is.DatabaseSession session,
    List<Book> rows, {
    _is.ColumnSelections<BookTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Book>(
      rows,
      columns: columns?.call(Book.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Book]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Book> updateRow(
    _is.DatabaseSession session,
    Book row, {
    _is.ColumnSelections<BookTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Book>(
      row,
      columns: columns?.call(Book.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Book] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Book?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<BookUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Book>(
      id,
      columnValues: columnValues(Book.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Book]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Book>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BookUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<BookTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BookTable>? orderBy,
    _is.OrderByListBuilder<BookTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Book>(
      columnValues: columnValues(Book.t.updateTable),
      where: where(Book.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Book]s in the list and returns the deleted rows.
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
  Future<List<Book>> delete(
    _is.DatabaseSession session,
    List<Book> rows, {
    _is.OrderByBuilder<BookTable>? orderBy,
    _is.OrderByListBuilder<BookTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Book>(
      rows,
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Book].
  Future<Book> deleteRow(
    _is.DatabaseSession session,
    Book row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Book>(
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
  Future<List<Book>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BookTable> where,
    _is.OrderByBuilder<BookTable>? orderBy,
    _is.OrderByListBuilder<BookTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Book>(
      where: where(Book.t),
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BookTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Book>(
      where: where?.call(Book.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Book] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BookTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Book>(
      where: where(Book.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class BookAttachRepository {
  const BookAttachRepository._();

  /// Creates a relation between this [Book] and the given [Chapter]s
  /// by setting each [Chapter]'s foreign key `_bookChaptersBookId` to refer to this [Book].
  Future<void> chapters(
    _is.DatabaseSession session,
    Book book,
    List<_ithd8abs.Chapter> chapter, {
    _is.Transaction? transaction,
  }) async {
    if (chapter.any((e) => e.id == null)) {
      throw ArgumentError.notNull('chapter.id');
    }
    if (book.id == null) {
      throw ArgumentError.notNull('book.id');
    }

    var $chapter = chapter
        .map(
          (e) => _ithd8abs.ChapterImplicit(
            e,
            $_bookChaptersBookId: book.id,
          ),
        )
        .toList();
    await session.db.update<_ithd8abs.Chapter>(
      $chapter,
      columns: [_ithd8abs.Chapter.t.$_bookChaptersBookId],
      transaction: transaction,
    );
  }
}

class BookAttachRowRepository {
  const BookAttachRowRepository._();

  /// Creates a relation between this [Book] and the given [Chapter]
  /// by setting the [Chapter]'s foreign key `_bookChaptersBookId` to refer to this [Book].
  Future<void> chapters(
    _is.DatabaseSession session,
    Book book,
    _ithd8abs.Chapter chapter, {
    _is.Transaction? transaction,
  }) async {
    if (chapter.id == null) {
      throw ArgumentError.notNull('chapter.id');
    }
    if (book.id == null) {
      throw ArgumentError.notNull('book.id');
    }

    var $chapter = _ithd8abs.ChapterImplicit(
      chapter,
      $_bookChaptersBookId: book.id,
    );
    await session.db.updateRow<_ithd8abs.Chapter>(
      $chapter,
      columns: [_ithd8abs.Chapter.t.$_bookChaptersBookId],
      transaction: transaction,
    );
  }
}

class BookDetachRepository {
  const BookDetachRepository._();

  /// Detaches the relation between this [Book] and the given [Chapter]
  /// by setting the [Chapter]'s foreign key `_bookChaptersBookId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> chapters(
    _is.DatabaseSession session,
    List<_ithd8abs.Chapter> chapter, {
    _is.Transaction? transaction,
  }) async {
    if (chapter.any((e) => e.id == null)) {
      throw ArgumentError.notNull('chapter.id');
    }

    var $chapter = chapter
        .map(
          (e) => _ithd8abs.ChapterImplicit(
            e,
            $_bookChaptersBookId: null,
          ),
        )
        .toList();
    await session.db.update<_ithd8abs.Chapter>(
      $chapter,
      columns: [_ithd8abs.Chapter.t.$_bookChaptersBookId],
      transaction: transaction,
    );
  }
}

class BookDetachRowRepository {
  const BookDetachRowRepository._();

  /// Detaches the relation between this [Book] and the given [Chapter]
  /// by setting the [Chapter]'s foreign key `_bookChaptersBookId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> chapters(
    _is.DatabaseSession session,
    _ithd8abs.Chapter chapter, {
    _is.Transaction? transaction,
  }) async {
    if (chapter.id == null) {
      throw ArgumentError.notNull('chapter.id');
    }

    var $chapter = _ithd8abs.ChapterImplicit(
      chapter,
      $_bookChaptersBookId: null,
    );
    await session.db.updateRow<_ithd8abs.Chapter>(
      $chapter,
      columns: [_ithd8abs.Chapter.t.$_bookChaptersBookId],
      transaction: transaction,
    );
  }
}

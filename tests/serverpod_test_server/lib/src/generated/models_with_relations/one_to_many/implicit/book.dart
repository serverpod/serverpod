/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../../models_with_relations/one_to_many/implicit/chapter.dart'
    as _i2;

abstract class Book implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Book._({
    this.id,
    required this.title,
    this.chapters,
  });

  factory Book({
    int? id,
    required String title,
    List<_i2.Chapter>? chapters,
  }) = _BookImpl;

  factory Book.fromJson(Map<String, dynamic> jsonSerialization) {
    return Book(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      chapters: (jsonSerialization['chapters'] as List?)
          ?.map((e) => _i2.Chapter.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = BookTable();

  static const db = BookRepository._();

  @override
  int? id;

  String title;

  List<_i2.Chapter>? chapters;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Book]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Book copyWith({
    int? id,
    String? title,
    List<_i2.Chapter>? chapters,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (chapters != null)
        'chapters': chapters?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (chapters != null)
        'chapters': chapters?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static BookInclude include({_i2.ChapterIncludeList? chapters}) {
    return BookInclude._(chapters: chapters);
  }

  static BookIncludeList includeList({
    _i1.WhereExpressionBuilder<BookTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BookTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BookTable>? orderByList,
    BookInclude? include,
  }) {
    return BookIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Book.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Book.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BookImpl extends Book {
  _BookImpl({
    int? id,
    required String title,
    List<_i2.Chapter>? chapters,
  }) : super._(
          id: id,
          title: title,
          chapters: chapters,
        );

  /// Returns a shallow copy of this [Book]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Book copyWith({
    Object? id = _Undefined,
    String? title,
    Object? chapters = _Undefined,
  }) {
    return Book(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      chapters: chapters is List<_i2.Chapter>?
          ? chapters
          : this.chapters?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class BookUpdateTable extends _i1.UpdateTable<BookTable> {
  BookUpdateTable(super.table);

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
        table.title,
        value,
      );
}

class BookTable extends _i1.Table<int?> {
  BookTable({super.tableRelation}) : super(tableName: 'book') {
    updateTable = BookUpdateTable(this);
    title = _i1.ColumnString(
      'title',
      this,
    );
  }

  late final BookUpdateTable updateTable;

  late final _i1.ColumnString title;

  _i2.ChapterTable? ___chapters;

  _i1.ManyRelation<_i2.ChapterTable>? _chapters;

  _i2.ChapterTable get __chapters {
    if (___chapters != null) return ___chapters!;
    ___chapters = _i1.createRelationTable(
      relationFieldName: '__chapters',
      field: Book.t.id,
      foreignField: _i2.Chapter.t.$_bookChaptersBookId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ChapterTable(tableRelation: foreignTableRelation),
    );
    return ___chapters!;
  }

  _i1.ManyRelation<_i2.ChapterTable> get chapters {
    if (_chapters != null) return _chapters!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'chapters',
      field: Book.t.id,
      foreignField: _i2.Chapter.t.$_bookChaptersBookId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ChapterTable(tableRelation: foreignTableRelation),
    );
    _chapters = _i1.ManyRelation<_i2.ChapterTable>(
      tableWithRelations: relationTable,
      table: _i2.ChapterTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _chapters!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        title,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'chapters') {
      return __chapters;
    }
    return null;
  }
}

class BookInclude extends _i1.IncludeObject {
  BookInclude._({_i2.ChapterIncludeList? chapters}) {
    _chapters = chapters;
  }

  _i2.ChapterIncludeList? _chapters;

  @override
  Map<String, _i1.Include?> get includes => {'chapters': _chapters};

  @override
  _i1.Table<int?> get table => Book.t;
}

class BookIncludeList extends _i1.IncludeList {
  BookIncludeList._({
    _i1.WhereExpressionBuilder<BookTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Book.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Book.t;
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BookTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BookTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BookTable>? orderByList,
    _i1.Transaction? transaction,
    BookInclude? include,
  }) async {
    return session.db.find<Book>(
      where: where?.call(Book.t),
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BookTable>? where,
    int? offset,
    _i1.OrderByBuilder<BookTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BookTable>? orderByList,
    _i1.Transaction? transaction,
    BookInclude? include,
  }) async {
    return session.db.findFirstRow<Book>(
      where: where?.call(Book.t),
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Book] by its [id] or null if no such row exists.
  Future<Book?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    BookInclude? include,
  }) async {
    return session.db.findById<Book>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Book]s in the list and returns the inserted rows.
  ///
  /// The returned [Book]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Book>> insert(
    _i1.Session session,
    List<Book> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Book>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Book] and returns the inserted row.
  ///
  /// The returned [Book] will have its `id` field set.
  Future<Book> insertRow(
    _i1.Session session,
    Book row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Book>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Book]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Book>> update(
    _i1.Session session,
    List<Book> rows, {
    _i1.ColumnSelections<BookTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Book>(
      rows,
      columns: columns?.call(Book.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Book]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Book> updateRow(
    _i1.Session session,
    Book row, {
    _i1.ColumnSelections<BookTable>? columns,
    _i1.Transaction? transaction,
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
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<BookUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Book>(
      id,
      columnValues: columnValues(Book.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Book]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Book>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<BookUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BookTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BookTable>? orderBy,
    _i1.OrderByListBuilder<BookTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Book>(
      columnValues: columnValues(Book.t.updateTable),
      where: where(Book.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Book]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Book>> delete(
    _i1.Session session,
    List<Book> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Book>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Book].
  Future<Book> deleteRow(
    _i1.Session session,
    Book row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Book>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Book>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BookTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Book>(
      where: where(Book.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BookTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Book>(
      where: where?.call(Book.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class BookAttachRepository {
  const BookAttachRepository._();

  /// Creates a relation between this [Book] and the given [Chapter]s
  /// by setting each [Chapter]'s foreign key `_bookChaptersBookId` to refer to this [Book].
  Future<void> chapters(
    _i1.Session session,
    Book book,
    List<_i2.Chapter> chapter, {
    _i1.Transaction? transaction,
  }) async {
    if (chapter.any((e) => e.id == null)) {
      throw ArgumentError.notNull('chapter.id');
    }
    if (book.id == null) {
      throw ArgumentError.notNull('book.id');
    }

    var $chapter = chapter
        .map((e) => _i2.ChapterImplicit(
              e,
              $_bookChaptersBookId: book.id,
            ))
        .toList();
    await session.db.update<_i2.Chapter>(
      $chapter,
      columns: [_i2.Chapter.t.$_bookChaptersBookId],
      transaction: transaction,
    );
  }
}

class BookAttachRowRepository {
  const BookAttachRowRepository._();

  /// Creates a relation between this [Book] and the given [Chapter]
  /// by setting the [Chapter]'s foreign key `_bookChaptersBookId` to refer to this [Book].
  Future<void> chapters(
    _i1.Session session,
    Book book,
    _i2.Chapter chapter, {
    _i1.Transaction? transaction,
  }) async {
    if (chapter.id == null) {
      throw ArgumentError.notNull('chapter.id');
    }
    if (book.id == null) {
      throw ArgumentError.notNull('book.id');
    }

    var $chapter = _i2.ChapterImplicit(
      chapter,
      $_bookChaptersBookId: book.id,
    );
    await session.db.updateRow<_i2.Chapter>(
      $chapter,
      columns: [_i2.Chapter.t.$_bookChaptersBookId],
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
    _i1.Session session,
    List<_i2.Chapter> chapter, {
    _i1.Transaction? transaction,
  }) async {
    if (chapter.any((e) => e.id == null)) {
      throw ArgumentError.notNull('chapter.id');
    }

    var $chapter = chapter
        .map((e) => _i2.ChapterImplicit(
              e,
              $_bookChaptersBookId: null,
            ))
        .toList();
    await session.db.update<_i2.Chapter>(
      $chapter,
      columns: [_i2.Chapter.t.$_bookChaptersBookId],
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
    _i1.Session session,
    _i2.Chapter chapter, {
    _i1.Transaction? transaction,
  }) async {
    if (chapter.id == null) {
      throw ArgumentError.notNull('chapter.id');
    }

    var $chapter = _i2.ChapterImplicit(
      chapter,
      $_bookChaptersBookId: null,
    );
    await session.db.updateRow<_i2.Chapter>(
      $chapter,
      columns: [_i2.Chapter.t.$_bookChaptersBookId],
      transaction: transaction,
    );
  }
}

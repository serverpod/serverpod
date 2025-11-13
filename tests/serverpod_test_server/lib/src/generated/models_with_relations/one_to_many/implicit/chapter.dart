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

abstract class Chapter
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Chapter._({
    this.id,
    required this.title,
  }) : _bookChaptersBookId = null;

  factory Chapter({
    int? id,
    required String title,
  }) = _ChapterImpl;

  factory Chapter.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChapterImplicit._(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      $_bookChaptersBookId: jsonSerialization['_bookChaptersBookId'] as int?,
    );
  }

  static final t = ChapterTable();

  static const db = ChapterRepository._();

  @override
  int? id;

  String title;

  final int? _bookChaptersBookId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Chapter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Chapter copyWith({
    int? id,
    String? title,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (_bookChaptersBookId != null)
        '_bookChaptersBookId': _bookChaptersBookId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'title': title,
    };
  }

  static ChapterInclude include() {
    return ChapterInclude._();
  }

  static ChapterIncludeList includeList({
    _i1.WhereExpressionBuilder<ChapterTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChapterTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChapterTable>? orderByList,
    ChapterInclude? include,
  }) {
    return ChapterIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Chapter.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Chapter.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChapterImpl extends Chapter {
  _ChapterImpl({
    int? id,
    required String title,
  }) : super._(
         id: id,
         title: title,
       );

  /// Returns a shallow copy of this [Chapter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Chapter copyWith({
    Object? id = _Undefined,
    String? title,
  }) {
    return ChapterImplicit._(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      $_bookChaptersBookId: this._bookChaptersBookId,
    );
  }
}

class ChapterImplicit extends _ChapterImpl {
  ChapterImplicit._({
    int? id,
    required String title,
    int? $_bookChaptersBookId,
  }) : _bookChaptersBookId = $_bookChaptersBookId,
       super(
         id: id,
         title: title,
       );

  factory ChapterImplicit(
    Chapter chapter, {
    int? $_bookChaptersBookId,
  }) {
    return ChapterImplicit._(
      id: chapter.id,
      title: chapter.title,
      $_bookChaptersBookId: $_bookChaptersBookId,
    );
  }

  @override
  final int? _bookChaptersBookId;
}

class ChapterUpdateTable extends _i1.UpdateTable<ChapterTable> {
  ChapterUpdateTable(super.table);

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<int, int> $_bookChaptersBookId(int? value) => _i1.ColumnValue(
    table.$_bookChaptersBookId,
    value,
  );
}

class ChapterTable extends _i1.Table<int?> {
  ChapterTable({super.tableRelation}) : super(tableName: 'chapter') {
    updateTable = ChapterUpdateTable(this);
    title = _i1.ColumnString(
      'title',
      this,
    );
    $_bookChaptersBookId = _i1.ColumnInt(
      '_bookChaptersBookId',
      this,
    );
  }

  late final ChapterUpdateTable updateTable;

  late final _i1.ColumnString title;

  late final _i1.ColumnInt $_bookChaptersBookId;

  @override
  List<_i1.Column> get columns => [
    id,
    title,
    $_bookChaptersBookId,
  ];

  @override
  List<_i1.Column> get managedColumns => [
    id,
    title,
  ];
}

class ChapterInclude extends _i1.IncludeObject {
  ChapterInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Chapter.t;
}

class ChapterIncludeList extends _i1.IncludeList {
  ChapterIncludeList._({
    _i1.WhereExpressionBuilder<ChapterTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Chapter.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Chapter.t;
}

class ChapterRepository {
  const ChapterRepository._();

  /// Returns a list of [Chapter]s matching the given query parameters.
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
  Future<List<Chapter>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChapterTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChapterTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChapterTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Chapter>(
      where: where?.call(Chapter.t),
      orderBy: orderBy?.call(Chapter.t),
      orderByList: orderByList?.call(Chapter.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Chapter] matching the given query parameters.
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
  Future<Chapter?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChapterTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChapterTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChapterTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Chapter>(
      where: where?.call(Chapter.t),
      orderBy: orderBy?.call(Chapter.t),
      orderByList: orderByList?.call(Chapter.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Chapter] by its [id] or null if no such row exists.
  Future<Chapter?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Chapter>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Chapter]s in the list and returns the inserted rows.
  ///
  /// The returned [Chapter]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Chapter>> insert(
    _i1.Session session,
    List<Chapter> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Chapter>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Chapter] and returns the inserted row.
  ///
  /// The returned [Chapter] will have its `id` field set.
  Future<Chapter> insertRow(
    _i1.Session session,
    Chapter row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Chapter>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Chapter]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Chapter>> update(
    _i1.Session session,
    List<Chapter> rows, {
    _i1.ColumnSelections<ChapterTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Chapter>(
      rows,
      columns: columns?.call(Chapter.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Chapter]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Chapter> updateRow(
    _i1.Session session,
    Chapter row, {
    _i1.ColumnSelections<ChapterTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Chapter>(
      row,
      columns: columns?.call(Chapter.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Chapter] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Chapter?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ChapterUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Chapter>(
      id,
      columnValues: columnValues(Chapter.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Chapter]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Chapter>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ChapterUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ChapterTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChapterTable>? orderBy,
    _i1.OrderByListBuilder<ChapterTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Chapter>(
      columnValues: columnValues(Chapter.t.updateTable),
      where: where(Chapter.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Chapter.t),
      orderByList: orderByList?.call(Chapter.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Chapter]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Chapter>> delete(
    _i1.Session session,
    List<Chapter> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Chapter>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Chapter].
  Future<Chapter> deleteRow(
    _i1.Session session,
    Chapter row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Chapter>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Chapter>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChapterTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Chapter>(
      where: where(Chapter.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChapterTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Chapter>(
      where: where?.call(Chapter.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

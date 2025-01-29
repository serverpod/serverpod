/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Just some simple data.
abstract class SimpleDateTime
    implements _i1.TableRow, _i1.ProtocolSerialization {
  SimpleDateTime._({
    this.id,
    required this.dateTime,
  });

  factory SimpleDateTime({
    int? id,
    required DateTime dateTime,
  }) = _SimpleDateTimeImpl;

  factory SimpleDateTime.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimpleDateTime(
      id: jsonSerialization['id'] as int?,
      dateTime:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dateTime']),
    );
  }

  static final t = SimpleDateTimeTable();

  static const db = SimpleDateTimeRepository._();

  @override
  int? id;

  /// The only field of [SimpleDateTime]
  DateTime dateTime;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [SimpleDateTime]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SimpleDateTime copyWith({
    int? id,
    DateTime? dateTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'dateTime': dateTime.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'dateTime': dateTime.toJson(),
    };
  }

  static SimpleDateTimeInclude include() {
    return SimpleDateTimeInclude._();
  }

  static SimpleDateTimeIncludeList includeList({
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SimpleDateTimeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SimpleDateTimeTable>? orderByList,
    SimpleDateTimeInclude? include,
  }) {
    return SimpleDateTimeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SimpleDateTime.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SimpleDateTime.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SimpleDateTimeImpl extends SimpleDateTime {
  _SimpleDateTimeImpl({
    int? id,
    required DateTime dateTime,
  }) : super._(
          id: id,
          dateTime: dateTime,
        );

  /// Returns a shallow copy of this [SimpleDateTime]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SimpleDateTime copyWith({
    Object? id = _Undefined,
    DateTime? dateTime,
  }) {
    return SimpleDateTime(
      id: id is int? ? id : this.id,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}

class SimpleDateTimeTable extends _i1.Table {
  SimpleDateTimeTable({super.tableRelation})
      : super(tableName: 'simple_date_time') {
    dateTime = _i1.ColumnDateTime(
      'dateTime',
      this,
    );
  }

  /// The only field of [SimpleDateTime]
  late final _i1.ColumnDateTime dateTime;

  @override
  List<_i1.Column> get columns => [
        id,
        dateTime,
      ];
}

class SimpleDateTimeInclude extends _i1.IncludeObject {
  SimpleDateTimeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => SimpleDateTime.t;
}

class SimpleDateTimeIncludeList extends _i1.IncludeList {
  SimpleDateTimeIncludeList._({
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SimpleDateTime.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => SimpleDateTime.t;
}

class SimpleDateTimeRepository {
  const SimpleDateTimeRepository._();

  /// Returns a list of [SimpleDateTime]s matching the given query parameters.
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
  Future<List<SimpleDateTime>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SimpleDateTimeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SimpleDateTimeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SimpleDateTime>(
      where: where?.call(SimpleDateTime.t),
      orderBy: orderBy?.call(SimpleDateTime.t),
      orderByList: orderByList?.call(SimpleDateTime.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SimpleDateTime] matching the given query parameters.
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
  Future<SimpleDateTime?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? offset,
    _i1.OrderByBuilder<SimpleDateTimeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SimpleDateTimeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SimpleDateTime>(
      where: where?.call(SimpleDateTime.t),
      orderBy: orderBy?.call(SimpleDateTime.t),
      orderByList: orderByList?.call(SimpleDateTime.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SimpleDateTime] by its [id] or null if no such row exists.
  Future<SimpleDateTime?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SimpleDateTime>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SimpleDateTime]s in the list and returns the inserted rows.
  ///
  /// The returned [SimpleDateTime]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SimpleDateTime>> insert(
    _i1.Session session,
    List<SimpleDateTime> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SimpleDateTime>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SimpleDateTime] and returns the inserted row.
  ///
  /// The returned [SimpleDateTime] will have its `id` field set.
  Future<SimpleDateTime> insertRow(
    _i1.Session session,
    SimpleDateTime row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SimpleDateTime>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SimpleDateTime]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SimpleDateTime>> update(
    _i1.Session session,
    List<SimpleDateTime> rows, {
    _i1.ColumnSelections<SimpleDateTimeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SimpleDateTime>(
      rows,
      columns: columns?.call(SimpleDateTime.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SimpleDateTime]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SimpleDateTime> updateRow(
    _i1.Session session,
    SimpleDateTime row, {
    _i1.ColumnSelections<SimpleDateTimeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SimpleDateTime>(
      row,
      columns: columns?.call(SimpleDateTime.t),
      transaction: transaction,
    );
  }

  /// Deletes all [SimpleDateTime]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SimpleDateTime>> delete(
    _i1.Session session,
    List<SimpleDateTime> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SimpleDateTime>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SimpleDateTime].
  Future<SimpleDateTime> deleteRow(
    _i1.Session session,
    SimpleDateTime row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SimpleDateTime>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SimpleDateTime>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SimpleDateTimeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SimpleDateTime>(
      where: where(SimpleDateTime.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SimpleDateTime>(
      where: where?.call(SimpleDateTime.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

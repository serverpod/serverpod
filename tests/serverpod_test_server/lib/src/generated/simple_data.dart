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
abstract class SimpleData implements _i1.TableRow, _i1.ProtocolSerialization {
  SimpleData._({
    this.id,
    required this.num,
  });

  factory SimpleData({
    int? id,
    required int num,
  }) = _SimpleDataImpl;

  factory SimpleData.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimpleData(
      id: jsonSerialization['id'] as int?,
      num: jsonSerialization['num'] as int,
    );
  }

  static final t = SimpleDataTable();

  static const db = SimpleDataRepository._();

  @override
  int? id;

  /// The only field of [SimpleData]
  ///
  /// Second Value Extra Text
  int num;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [SimpleData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SimpleData copyWith({
    int? id,
    int? num,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'num': num,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'num': num,
    };
  }

  static SimpleDataInclude include() {
    return SimpleDataInclude._();
  }

  static SimpleDataIncludeList includeList({
    _i1.WhereExpressionBuilder<SimpleDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SimpleDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SimpleDataTable>? orderByList,
    SimpleDataInclude? include,
  }) {
    return SimpleDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SimpleData.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SimpleData.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SimpleDataImpl extends SimpleData {
  _SimpleDataImpl({
    int? id,
    required int num,
  }) : super._(
          id: id,
          num: num,
        );

  /// Returns a shallow copy of this [SimpleData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SimpleData copyWith({
    Object? id = _Undefined,
    int? num,
  }) {
    return SimpleData(
      id: id is int? ? id : this.id,
      num: num ?? this.num,
    );
  }
}

class SimpleDataTable extends _i1.Table {
  SimpleDataTable({super.tableRelation}) : super(tableName: 'simple_data') {
    num = _i1.ColumnInt(
      'num',
      this,
    );
  }

  /// The only field of [SimpleData]
  ///
  /// Second Value Extra Text
  late final _i1.ColumnInt num;

  @override
  List<_i1.Column> get columns => [
        id,
        num,
      ];
}

class SimpleDataInclude extends _i1.IncludeObject {
  SimpleDataInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => SimpleData.t;
}

class SimpleDataIncludeList extends _i1.IncludeList {
  SimpleDataIncludeList._({
    _i1.WhereExpressionBuilder<SimpleDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SimpleData.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => SimpleData.t;
}

class SimpleDataRepository {
  const SimpleDataRepository._();

  /// Returns a list of [SimpleData]s matching the given query parameters.
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
  Future<List<SimpleData>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SimpleDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SimpleDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SimpleData>(
      where: where?.call(SimpleData.t),
      orderBy: orderBy?.call(SimpleData.t),
      orderByList: orderByList?.call(SimpleData.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SimpleData] matching the given query parameters.
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
  Future<SimpleData?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDataTable>? where,
    int? offset,
    _i1.OrderByBuilder<SimpleDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SimpleDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SimpleData>(
      where: where?.call(SimpleData.t),
      orderBy: orderBy?.call(SimpleData.t),
      orderByList: orderByList?.call(SimpleData.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SimpleData] by its [id] or null if no such row exists.
  Future<SimpleData?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SimpleData>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SimpleData]s in the list and returns the inserted rows.
  ///
  /// The returned [SimpleData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SimpleData>> insert(
    _i1.Session session,
    List<SimpleData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SimpleData>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SimpleData] and returns the inserted row.
  ///
  /// The returned [SimpleData] will have its `id` field set.
  Future<SimpleData> insertRow(
    _i1.Session session,
    SimpleData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SimpleData>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SimpleData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SimpleData>> update(
    _i1.Session session,
    List<SimpleData> rows, {
    _i1.ColumnSelections<SimpleDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SimpleData>(
      rows,
      columns: columns?.call(SimpleData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SimpleData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SimpleData> updateRow(
    _i1.Session session,
    SimpleData row, {
    _i1.ColumnSelections<SimpleDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SimpleData>(
      row,
      columns: columns?.call(SimpleData.t),
      transaction: transaction,
    );
  }

  /// Deletes all [SimpleData]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SimpleData>> delete(
    _i1.Session session,
    List<SimpleData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SimpleData>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SimpleData].
  Future<SimpleData> deleteRow(
    _i1.Session session,
    SimpleData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SimpleData>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SimpleData>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SimpleDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SimpleData>(
      where: where(SimpleData.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SimpleData>(
      where: where?.call(SimpleData.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

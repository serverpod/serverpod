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

abstract class DoubleDefault
    implements _i1.TableRow, _i1.ProtocolSerialization {
  DoubleDefault._({
    this.id,
    double? doubleDefault,
    double? doubleDefaultNull,
  })  : doubleDefault = doubleDefault ?? 10.5,
        doubleDefaultNull = doubleDefaultNull ?? 20.5;

  factory DoubleDefault({
    int? id,
    double? doubleDefault,
    double? doubleDefaultNull,
  }) = _DoubleDefaultImpl;

  factory DoubleDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoubleDefault(
      id: jsonSerialization['id'] as int?,
      doubleDefault: (jsonSerialization['doubleDefault'] as num).toDouble(),
      doubleDefaultNull:
          (jsonSerialization['doubleDefaultNull'] as num?)?.toDouble(),
    );
  }

  static final t = DoubleDefaultTable();

  static const db = DoubleDefaultRepository._();

  @override
  int? id;

  double doubleDefault;

  double? doubleDefaultNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [DoubleDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DoubleDefault copyWith({
    int? id,
    double? doubleDefault,
    double? doubleDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'doubleDefault': doubleDefault,
      if (doubleDefaultNull != null) 'doubleDefaultNull': doubleDefaultNull,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'doubleDefault': doubleDefault,
      if (doubleDefaultNull != null) 'doubleDefaultNull': doubleDefaultNull,
    };
  }

  static DoubleDefaultInclude include() {
    return DoubleDefaultInclude._();
  }

  static DoubleDefaultIncludeList includeList({
    _i1.WhereExpressionBuilder<DoubleDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultTable>? orderByList,
    DoubleDefaultInclude? include,
  }) {
    return DoubleDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoubleDefault.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DoubleDefault.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoubleDefaultImpl extends DoubleDefault {
  _DoubleDefaultImpl({
    int? id,
    double? doubleDefault,
    double? doubleDefaultNull,
  }) : super._(
          id: id,
          doubleDefault: doubleDefault,
          doubleDefaultNull: doubleDefaultNull,
        );

  /// Returns a shallow copy of this [DoubleDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DoubleDefault copyWith({
    Object? id = _Undefined,
    double? doubleDefault,
    Object? doubleDefaultNull = _Undefined,
  }) {
    return DoubleDefault(
      id: id is int? ? id : this.id,
      doubleDefault: doubleDefault ?? this.doubleDefault,
      doubleDefaultNull: doubleDefaultNull is double?
          ? doubleDefaultNull
          : this.doubleDefaultNull,
    );
  }
}

class DoubleDefaultTable extends _i1.Table {
  DoubleDefaultTable({super.tableRelation})
      : super(tableName: 'double_default') {
    doubleDefault = _i1.ColumnDouble(
      'doubleDefault',
      this,
      hasDefault: true,
    );
    doubleDefaultNull = _i1.ColumnDouble(
      'doubleDefaultNull',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnDouble doubleDefault;

  late final _i1.ColumnDouble doubleDefaultNull;

  @override
  List<_i1.Column> get columns => [
        id,
        doubleDefault,
        doubleDefaultNull,
      ];
}

class DoubleDefaultInclude extends _i1.IncludeObject {
  DoubleDefaultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DoubleDefault.t;
}

class DoubleDefaultIncludeList extends _i1.IncludeList {
  DoubleDefaultIncludeList._({
    _i1.WhereExpressionBuilder<DoubleDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DoubleDefault.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DoubleDefault.t;
}

class DoubleDefaultRepository {
  const DoubleDefaultRepository._();

  /// Returns a list of [DoubleDefault]s matching the given query parameters.
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
  Future<List<DoubleDefault>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoubleDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DoubleDefault>(
      where: where?.call(DoubleDefault.t),
      orderBy: orderBy?.call(DoubleDefault.t),
      orderByList: orderByList?.call(DoubleDefault.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [DoubleDefault] matching the given query parameters.
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
  Future<DoubleDefault?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoubleDefaultTable>? where,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DoubleDefault>(
      where: where?.call(DoubleDefault.t),
      orderBy: orderBy?.call(DoubleDefault.t),
      orderByList: orderByList?.call(DoubleDefault.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [DoubleDefault] by its [id] or null if no such row exists.
  Future<DoubleDefault?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DoubleDefault>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [DoubleDefault]s in the list and returns the inserted rows.
  ///
  /// The returned [DoubleDefault]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<DoubleDefault>> insert(
    _i1.Session session,
    List<DoubleDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DoubleDefault>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [DoubleDefault] and returns the inserted row.
  ///
  /// The returned [DoubleDefault] will have its `id` field set.
  Future<DoubleDefault> insertRow(
    _i1.Session session,
    DoubleDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DoubleDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DoubleDefault]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DoubleDefault>> update(
    _i1.Session session,
    List<DoubleDefault> rows, {
    _i1.ColumnSelections<DoubleDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DoubleDefault>(
      rows,
      columns: columns?.call(DoubleDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DoubleDefault]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DoubleDefault> updateRow(
    _i1.Session session,
    DoubleDefault row, {
    _i1.ColumnSelections<DoubleDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DoubleDefault>(
      row,
      columns: columns?.call(DoubleDefault.t),
      transaction: transaction,
    );
  }

  /// Deletes all [DoubleDefault]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DoubleDefault>> delete(
    _i1.Session session,
    List<DoubleDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DoubleDefault>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DoubleDefault].
  Future<DoubleDefault> deleteRow(
    _i1.Session session,
    DoubleDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DoubleDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DoubleDefault>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DoubleDefaultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DoubleDefault>(
      where: where(DoubleDefault.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoubleDefaultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DoubleDefault>(
      where: where?.call(DoubleDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

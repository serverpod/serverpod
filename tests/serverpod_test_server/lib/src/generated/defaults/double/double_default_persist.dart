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

abstract class DoubleDefaultPersist
    implements _i1.TableRow, _i1.ProtocolSerialization {
  DoubleDefaultPersist._({
    this.id,
    this.doubleDefaultPersist,
  });

  factory DoubleDefaultPersist({
    int? id,
    double? doubleDefaultPersist,
  }) = _DoubleDefaultPersistImpl;

  factory DoubleDefaultPersist.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DoubleDefaultPersist(
      id: jsonSerialization['id'] as int?,
      doubleDefaultPersist:
          (jsonSerialization['doubleDefaultPersist'] as num?)?.toDouble(),
    );
  }

  static final t = DoubleDefaultPersistTable();

  static const db = DoubleDefaultPersistRepository._();

  @override
  int? id;

  double? doubleDefaultPersist;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [DoubleDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DoubleDefaultPersist copyWith({
    int? id,
    double? doubleDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (doubleDefaultPersist != null)
        'doubleDefaultPersist': doubleDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (doubleDefaultPersist != null)
        'doubleDefaultPersist': doubleDefaultPersist,
    };
  }

  static DoubleDefaultPersistInclude include() {
    return DoubleDefaultPersistInclude._();
  }

  static DoubleDefaultPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    DoubleDefaultPersistInclude? include,
  }) {
    return DoubleDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoubleDefaultPersistImpl extends DoubleDefaultPersist {
  _DoubleDefaultPersistImpl({
    int? id,
    double? doubleDefaultPersist,
  }) : super._(
          id: id,
          doubleDefaultPersist: doubleDefaultPersist,
        );

  /// Returns a shallow copy of this [DoubleDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DoubleDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? doubleDefaultPersist = _Undefined,
  }) {
    return DoubleDefaultPersist(
      id: id is int? ? id : this.id,
      doubleDefaultPersist: doubleDefaultPersist is double?
          ? doubleDefaultPersist
          : this.doubleDefaultPersist,
    );
  }
}

class DoubleDefaultPersistTable extends _i1.Table {
  DoubleDefaultPersistTable({super.tableRelation})
      : super(tableName: 'double_default_persist') {
    doubleDefaultPersist = _i1.ColumnDouble(
      'doubleDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnDouble doubleDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        doubleDefaultPersist,
      ];
}

class DoubleDefaultPersistInclude extends _i1.IncludeObject {
  DoubleDefaultPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DoubleDefaultPersist.t;
}

class DoubleDefaultPersistIncludeList extends _i1.IncludeList {
  DoubleDefaultPersistIncludeList._({
    _i1.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DoubleDefaultPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DoubleDefaultPersist.t;
}

class DoubleDefaultPersistRepository {
  const DoubleDefaultPersistRepository._();

  /// Returns a list of [DoubleDefaultPersist]s matching the given query parameters.
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
  Future<List<DoubleDefaultPersist>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DoubleDefaultPersist>(
      where: where?.call(DoubleDefaultPersist.t),
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [DoubleDefaultPersist] matching the given query parameters.
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
  Future<DoubleDefaultPersist?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DoubleDefaultPersist>(
      where: where?.call(DoubleDefaultPersist.t),
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [DoubleDefaultPersist] by its [id] or null if no such row exists.
  Future<DoubleDefaultPersist?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DoubleDefaultPersist>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [DoubleDefaultPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [DoubleDefaultPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<DoubleDefaultPersist>> insert(
    _i1.Session session,
    List<DoubleDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DoubleDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [DoubleDefaultPersist] and returns the inserted row.
  ///
  /// The returned [DoubleDefaultPersist] will have its `id` field set.
  Future<DoubleDefaultPersist> insertRow(
    _i1.Session session,
    DoubleDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DoubleDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DoubleDefaultPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DoubleDefaultPersist>> update(
    _i1.Session session,
    List<DoubleDefaultPersist> rows, {
    _i1.ColumnSelections<DoubleDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DoubleDefaultPersist>(
      rows,
      columns: columns?.call(DoubleDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DoubleDefaultPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DoubleDefaultPersist> updateRow(
    _i1.Session session,
    DoubleDefaultPersist row, {
    _i1.ColumnSelections<DoubleDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DoubleDefaultPersist>(
      row,
      columns: columns?.call(DoubleDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Deletes all [DoubleDefaultPersist]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DoubleDefaultPersist>> delete(
    _i1.Session session,
    List<DoubleDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DoubleDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DoubleDefaultPersist].
  Future<DoubleDefaultPersist> deleteRow(
    _i1.Session session,
    DoubleDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DoubleDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DoubleDefaultPersist>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DoubleDefaultPersistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DoubleDefaultPersist>(
      where: where(DoubleDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DoubleDefaultPersist>(
      where: where?.call(DoubleDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

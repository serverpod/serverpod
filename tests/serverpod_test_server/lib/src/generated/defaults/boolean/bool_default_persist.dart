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

abstract class BoolDefaultPersist
    implements _i1.TableRow, _i1.ProtocolSerialization {
  BoolDefaultPersist._({
    this.id,
    this.boolDefaultPersistTrue,
    this.boolDefaultPersistFalse,
  });

  factory BoolDefaultPersist({
    int? id,
    bool? boolDefaultPersistTrue,
    bool? boolDefaultPersistFalse,
  }) = _BoolDefaultPersistImpl;

  factory BoolDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoolDefaultPersist(
      id: jsonSerialization['id'] as int?,
      boolDefaultPersistTrue:
          jsonSerialization['boolDefaultPersistTrue'] as bool?,
      boolDefaultPersistFalse:
          jsonSerialization['boolDefaultPersistFalse'] as bool?,
    );
  }

  static final t = BoolDefaultPersistTable();

  static const db = BoolDefaultPersistRepository._();

  @override
  int? id;

  bool? boolDefaultPersistTrue;

  bool? boolDefaultPersistFalse;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [BoolDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoolDefaultPersist copyWith({
    int? id,
    bool? boolDefaultPersistTrue,
    bool? boolDefaultPersistFalse,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (boolDefaultPersistTrue != null)
        'boolDefaultPersistTrue': boolDefaultPersistTrue,
      if (boolDefaultPersistFalse != null)
        'boolDefaultPersistFalse': boolDefaultPersistFalse,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (boolDefaultPersistTrue != null)
        'boolDefaultPersistTrue': boolDefaultPersistTrue,
      if (boolDefaultPersistFalse != null)
        'boolDefaultPersistFalse': boolDefaultPersistFalse,
    };
  }

  static BoolDefaultPersistInclude include() {
    return BoolDefaultPersistInclude._();
  }

  static BoolDefaultPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<BoolDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultPersistTable>? orderByList,
    BoolDefaultPersistInclude? include,
  }) {
    return BoolDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoolDefaultPersist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BoolDefaultPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoolDefaultPersistImpl extends BoolDefaultPersist {
  _BoolDefaultPersistImpl({
    int? id,
    bool? boolDefaultPersistTrue,
    bool? boolDefaultPersistFalse,
  }) : super._(
          id: id,
          boolDefaultPersistTrue: boolDefaultPersistTrue,
          boolDefaultPersistFalse: boolDefaultPersistFalse,
        );

  /// Returns a shallow copy of this [BoolDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoolDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? boolDefaultPersistTrue = _Undefined,
    Object? boolDefaultPersistFalse = _Undefined,
  }) {
    return BoolDefaultPersist(
      id: id is int? ? id : this.id,
      boolDefaultPersistTrue: boolDefaultPersistTrue is bool?
          ? boolDefaultPersistTrue
          : this.boolDefaultPersistTrue,
      boolDefaultPersistFalse: boolDefaultPersistFalse is bool?
          ? boolDefaultPersistFalse
          : this.boolDefaultPersistFalse,
    );
  }
}

class BoolDefaultPersistTable extends _i1.Table {
  BoolDefaultPersistTable({super.tableRelation})
      : super(tableName: 'bool_default_persist') {
    boolDefaultPersistTrue = _i1.ColumnBool(
      'boolDefaultPersistTrue',
      this,
      hasDefault: true,
    );
    boolDefaultPersistFalse = _i1.ColumnBool(
      'boolDefaultPersistFalse',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnBool boolDefaultPersistTrue;

  late final _i1.ColumnBool boolDefaultPersistFalse;

  @override
  List<_i1.Column> get columns => [
        id,
        boolDefaultPersistTrue,
        boolDefaultPersistFalse,
      ];
}

class BoolDefaultPersistInclude extends _i1.IncludeObject {
  BoolDefaultPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => BoolDefaultPersist.t;
}

class BoolDefaultPersistIncludeList extends _i1.IncludeList {
  BoolDefaultPersistIncludeList._({
    _i1.WhereExpressionBuilder<BoolDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BoolDefaultPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => BoolDefaultPersist.t;
}

class BoolDefaultPersistRepository {
  const BoolDefaultPersistRepository._();

  /// Returns a list of [BoolDefaultPersist]s matching the given query parameters.
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
  Future<List<BoolDefaultPersist>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoolDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BoolDefaultPersist>(
      where: where?.call(BoolDefaultPersist.t),
      orderBy: orderBy?.call(BoolDefaultPersist.t),
      orderByList: orderByList?.call(BoolDefaultPersist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BoolDefaultPersist] matching the given query parameters.
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
  Future<BoolDefaultPersist?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoolDefaultPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BoolDefaultPersist>(
      where: where?.call(BoolDefaultPersist.t),
      orderBy: orderBy?.call(BoolDefaultPersist.t),
      orderByList: orderByList?.call(BoolDefaultPersist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BoolDefaultPersist] by its [id] or null if no such row exists.
  Future<BoolDefaultPersist?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BoolDefaultPersist>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BoolDefaultPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [BoolDefaultPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BoolDefaultPersist>> insert(
    _i1.Session session,
    List<BoolDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BoolDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BoolDefaultPersist] and returns the inserted row.
  ///
  /// The returned [BoolDefaultPersist] will have its `id` field set.
  Future<BoolDefaultPersist> insertRow(
    _i1.Session session,
    BoolDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BoolDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BoolDefaultPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BoolDefaultPersist>> update(
    _i1.Session session,
    List<BoolDefaultPersist> rows, {
    _i1.ColumnSelections<BoolDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BoolDefaultPersist>(
      rows,
      columns: columns?.call(BoolDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BoolDefaultPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BoolDefaultPersist> updateRow(
    _i1.Session session,
    BoolDefaultPersist row, {
    _i1.ColumnSelections<BoolDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BoolDefaultPersist>(
      row,
      columns: columns?.call(BoolDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Deletes all [BoolDefaultPersist]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BoolDefaultPersist>> delete(
    _i1.Session session,
    List<BoolDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BoolDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BoolDefaultPersist].
  Future<BoolDefaultPersist> deleteRow(
    _i1.Session session,
    BoolDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BoolDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BoolDefaultPersist>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BoolDefaultPersistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BoolDefaultPersist>(
      where: where(BoolDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoolDefaultPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BoolDefaultPersist>(
      where: where?.call(BoolDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

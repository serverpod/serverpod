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

abstract class BigIntDefaultPersist
    implements _i1.TableRow, _i1.ProtocolSerialization {
  BigIntDefaultPersist._({
    this.id,
    this.bigIntDefaultPersistStr,
  });

  factory BigIntDefaultPersist({
    int? id,
    BigInt? bigIntDefaultPersistStr,
  }) = _BigIntDefaultPersistImpl;

  factory BigIntDefaultPersist.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return BigIntDefaultPersist(
      id: jsonSerialization['id'] as int?,
      bigIntDefaultPersistStr:
          jsonSerialization['bigIntDefaultPersistStr'] == null
              ? null
              : _i1.BigIntJsonExtension.fromJson(
                  jsonSerialization['bigIntDefaultPersistStr']),
    );
  }

  static final t = BigIntDefaultPersistTable();

  static const db = BigIntDefaultPersistRepository._();

  @override
  int? id;

  BigInt? bigIntDefaultPersistStr;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [BigIntDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BigIntDefaultPersist copyWith({
    int? id,
    BigInt? bigIntDefaultPersistStr,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (bigIntDefaultPersistStr != null)
        'bigIntDefaultPersistStr': bigIntDefaultPersistStr?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (bigIntDefaultPersistStr != null)
        'bigIntDefaultPersistStr': bigIntDefaultPersistStr?.toJson(),
    };
  }

  static BigIntDefaultPersistInclude include() {
    return BigIntDefaultPersistInclude._();
  }

  static BigIntDefaultPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<BigIntDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BigIntDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BigIntDefaultPersistTable>? orderByList,
    BigIntDefaultPersistInclude? include,
  }) {
    return BigIntDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BigIntDefaultPersist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BigIntDefaultPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BigIntDefaultPersistImpl extends BigIntDefaultPersist {
  _BigIntDefaultPersistImpl({
    int? id,
    BigInt? bigIntDefaultPersistStr,
  }) : super._(
          id: id,
          bigIntDefaultPersistStr: bigIntDefaultPersistStr,
        );

  /// Returns a shallow copy of this [BigIntDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BigIntDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? bigIntDefaultPersistStr = _Undefined,
  }) {
    return BigIntDefaultPersist(
      id: id is int? ? id : this.id,
      bigIntDefaultPersistStr: bigIntDefaultPersistStr is BigInt?
          ? bigIntDefaultPersistStr
          : this.bigIntDefaultPersistStr,
    );
  }
}

class BigIntDefaultPersistTable extends _i1.Table {
  BigIntDefaultPersistTable({super.tableRelation})
      : super(tableName: 'bigint_default_persist') {
    bigIntDefaultPersistStr = _i1.ColumnBigInt(
      'bigIntDefaultPersistStr',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnBigInt bigIntDefaultPersistStr;

  @override
  List<_i1.Column> get columns => [
        id,
        bigIntDefaultPersistStr,
      ];
}

class BigIntDefaultPersistInclude extends _i1.IncludeObject {
  BigIntDefaultPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => BigIntDefaultPersist.t;
}

class BigIntDefaultPersistIncludeList extends _i1.IncludeList {
  BigIntDefaultPersistIncludeList._({
    _i1.WhereExpressionBuilder<BigIntDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BigIntDefaultPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => BigIntDefaultPersist.t;
}

class BigIntDefaultPersistRepository {
  const BigIntDefaultPersistRepository._();

  /// Returns a list of [BigIntDefaultPersist]s matching the given query parameters.
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
  Future<List<BigIntDefaultPersist>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BigIntDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BigIntDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BigIntDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BigIntDefaultPersist>(
      where: where?.call(BigIntDefaultPersist.t),
      orderBy: orderBy?.call(BigIntDefaultPersist.t),
      orderByList: orderByList?.call(BigIntDefaultPersist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BigIntDefaultPersist] matching the given query parameters.
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
  Future<BigIntDefaultPersist?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BigIntDefaultPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<BigIntDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BigIntDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BigIntDefaultPersist>(
      where: where?.call(BigIntDefaultPersist.t),
      orderBy: orderBy?.call(BigIntDefaultPersist.t),
      orderByList: orderByList?.call(BigIntDefaultPersist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BigIntDefaultPersist] by its [id] or null if no such row exists.
  Future<BigIntDefaultPersist?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BigIntDefaultPersist>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BigIntDefaultPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [BigIntDefaultPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BigIntDefaultPersist>> insert(
    _i1.Session session,
    List<BigIntDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BigIntDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BigIntDefaultPersist] and returns the inserted row.
  ///
  /// The returned [BigIntDefaultPersist] will have its `id` field set.
  Future<BigIntDefaultPersist> insertRow(
    _i1.Session session,
    BigIntDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BigIntDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BigIntDefaultPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BigIntDefaultPersist>> update(
    _i1.Session session,
    List<BigIntDefaultPersist> rows, {
    _i1.ColumnSelections<BigIntDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BigIntDefaultPersist>(
      rows,
      columns: columns?.call(BigIntDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BigIntDefaultPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BigIntDefaultPersist> updateRow(
    _i1.Session session,
    BigIntDefaultPersist row, {
    _i1.ColumnSelections<BigIntDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BigIntDefaultPersist>(
      row,
      columns: columns?.call(BigIntDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Deletes all [BigIntDefaultPersist]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BigIntDefaultPersist>> delete(
    _i1.Session session,
    List<BigIntDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BigIntDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BigIntDefaultPersist].
  Future<BigIntDefaultPersist> deleteRow(
    _i1.Session session,
    BigIntDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BigIntDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BigIntDefaultPersist>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BigIntDefaultPersistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BigIntDefaultPersist>(
      where: where(BigIntDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BigIntDefaultPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BigIntDefaultPersist>(
      where: where?.call(BigIntDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

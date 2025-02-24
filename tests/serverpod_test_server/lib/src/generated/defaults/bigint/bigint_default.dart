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

abstract class BigIntDefault
    implements _i1.TableRow, _i1.ProtocolSerialization {
  BigIntDefault._({
    this.id,
    BigInt? bigintDefaultStr,
    BigInt? bigintDefaultStrNull,
  })  : bigintDefaultStr =
            bigintDefaultStr ?? BigInt.parse('-1234567890123456789099999999'),
        bigintDefaultStrNull = bigintDefaultStrNull ??
            BigInt.parse('1234567890123456789099999999');

  factory BigIntDefault({
    int? id,
    BigInt? bigintDefaultStr,
    BigInt? bigintDefaultStrNull,
  }) = _BigIntDefaultImpl;

  factory BigIntDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return BigIntDefault(
      id: jsonSerialization['id'] as int?,
      bigintDefaultStr: _i1.BigIntJsonExtension.fromJson(
          jsonSerialization['bigintDefaultStr']),
      bigintDefaultStrNull: jsonSerialization['bigintDefaultStrNull'] == null
          ? null
          : _i1.BigIntJsonExtension.fromJson(
              jsonSerialization['bigintDefaultStrNull']),
    );
  }

  static final t = BigIntDefaultTable();

  static const db = BigIntDefaultRepository._();

  @override
  int? id;

  BigInt bigintDefaultStr;

  BigInt? bigintDefaultStrNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [BigIntDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BigIntDefault copyWith({
    int? id,
    BigInt? bigintDefaultStr,
    BigInt? bigintDefaultStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'bigintDefaultStr': bigintDefaultStr.toJson(),
      if (bigintDefaultStrNull != null)
        'bigintDefaultStrNull': bigintDefaultStrNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'bigintDefaultStr': bigintDefaultStr.toJson(),
      if (bigintDefaultStrNull != null)
        'bigintDefaultStrNull': bigintDefaultStrNull?.toJson(),
    };
  }

  static BigIntDefaultInclude include() {
    return BigIntDefaultInclude._();
  }

  static BigIntDefaultIncludeList includeList({
    _i1.WhereExpressionBuilder<BigIntDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BigIntDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BigIntDefaultTable>? orderByList,
    BigIntDefaultInclude? include,
  }) {
    return BigIntDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BigIntDefault.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BigIntDefault.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BigIntDefaultImpl extends BigIntDefault {
  _BigIntDefaultImpl({
    int? id,
    BigInt? bigintDefaultStr,
    BigInt? bigintDefaultStrNull,
  }) : super._(
          id: id,
          bigintDefaultStr: bigintDefaultStr,
          bigintDefaultStrNull: bigintDefaultStrNull,
        );

  /// Returns a shallow copy of this [BigIntDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BigIntDefault copyWith({
    Object? id = _Undefined,
    BigInt? bigintDefaultStr,
    Object? bigintDefaultStrNull = _Undefined,
  }) {
    return BigIntDefault(
      id: id is int? ? id : this.id,
      bigintDefaultStr: bigintDefaultStr ?? this.bigintDefaultStr,
      bigintDefaultStrNull: bigintDefaultStrNull is BigInt?
          ? bigintDefaultStrNull
          : this.bigintDefaultStrNull,
    );
  }
}

class BigIntDefaultTable extends _i1.Table {
  BigIntDefaultTable({super.tableRelation})
      : super(tableName: 'bigint_default') {
    bigintDefaultStr = _i1.ColumnBigInt(
      'bigintDefaultStr',
      this,
      hasDefault: true,
    );
    bigintDefaultStrNull = _i1.ColumnBigInt(
      'bigintDefaultStrNull',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnBigInt bigintDefaultStr;

  late final _i1.ColumnBigInt bigintDefaultStrNull;

  @override
  List<_i1.Column> get columns => [
        id,
        bigintDefaultStr,
        bigintDefaultStrNull,
      ];
}

class BigIntDefaultInclude extends _i1.IncludeObject {
  BigIntDefaultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => BigIntDefault.t;
}

class BigIntDefaultIncludeList extends _i1.IncludeList {
  BigIntDefaultIncludeList._({
    _i1.WhereExpressionBuilder<BigIntDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BigIntDefault.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => BigIntDefault.t;
}

class BigIntDefaultRepository {
  const BigIntDefaultRepository._();

  /// Returns a list of [BigIntDefault]s matching the given query parameters.
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
  Future<List<BigIntDefault>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BigIntDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BigIntDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BigIntDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BigIntDefault>(
      where: where?.call(BigIntDefault.t),
      orderBy: orderBy?.call(BigIntDefault.t),
      orderByList: orderByList?.call(BigIntDefault.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BigIntDefault] matching the given query parameters.
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
  Future<BigIntDefault?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BigIntDefaultTable>? where,
    int? offset,
    _i1.OrderByBuilder<BigIntDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BigIntDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BigIntDefault>(
      where: where?.call(BigIntDefault.t),
      orderBy: orderBy?.call(BigIntDefault.t),
      orderByList: orderByList?.call(BigIntDefault.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BigIntDefault] by its [id] or null if no such row exists.
  Future<BigIntDefault?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BigIntDefault>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BigIntDefault]s in the list and returns the inserted rows.
  ///
  /// The returned [BigIntDefault]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BigIntDefault>> insert(
    _i1.Session session,
    List<BigIntDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BigIntDefault>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BigIntDefault] and returns the inserted row.
  ///
  /// The returned [BigIntDefault] will have its `id` field set.
  Future<BigIntDefault> insertRow(
    _i1.Session session,
    BigIntDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BigIntDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BigIntDefault]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BigIntDefault>> update(
    _i1.Session session,
    List<BigIntDefault> rows, {
    _i1.ColumnSelections<BigIntDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BigIntDefault>(
      rows,
      columns: columns?.call(BigIntDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BigIntDefault]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BigIntDefault> updateRow(
    _i1.Session session,
    BigIntDefault row, {
    _i1.ColumnSelections<BigIntDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BigIntDefault>(
      row,
      columns: columns?.call(BigIntDefault.t),
      transaction: transaction,
    );
  }

  /// Deletes all [BigIntDefault]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BigIntDefault>> delete(
    _i1.Session session,
    List<BigIntDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BigIntDefault>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BigIntDefault].
  Future<BigIntDefault> deleteRow(
    _i1.Session session,
    BigIntDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BigIntDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BigIntDefault>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BigIntDefaultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BigIntDefault>(
      where: where(BigIntDefault.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BigIntDefaultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BigIntDefault>(
      where: where?.call(BigIntDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

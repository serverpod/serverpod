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

abstract class BigIntDefaultMix
    implements _i1.TableRow, _i1.ProtocolSerialization {
  BigIntDefaultMix._({
    this.id,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  })  : bigIntDefaultAndDefaultModel =
            bigIntDefaultAndDefaultModel ?? BigInt.parse('2'),
        bigIntDefaultAndDefaultPersist = bigIntDefaultAndDefaultPersist ??
            BigInt.parse('-12345678901234567890'),
        bigIntDefaultModelAndDefaultPersist =
            bigIntDefaultModelAndDefaultPersist ??
                BigInt.parse('1234567890123456789099999999');

  factory BigIntDefaultMix({
    int? id,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  }) = _BigIntDefaultMixImpl;

  factory BigIntDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return BigIntDefaultMix(
      id: jsonSerialization['id'] as int?,
      bigIntDefaultAndDefaultModel: _i1.BigIntJsonExtension.fromJson(
          jsonSerialization['bigIntDefaultAndDefaultModel']),
      bigIntDefaultAndDefaultPersist: _i1.BigIntJsonExtension.fromJson(
          jsonSerialization['bigIntDefaultAndDefaultPersist']),
      bigIntDefaultModelAndDefaultPersist: _i1.BigIntJsonExtension.fromJson(
          jsonSerialization['bigIntDefaultModelAndDefaultPersist']),
    );
  }

  static final t = BigIntDefaultMixTable();

  static const db = BigIntDefaultMixRepository._();

  @override
  int? id;

  BigInt bigIntDefaultAndDefaultModel;

  BigInt bigIntDefaultAndDefaultPersist;

  BigInt bigIntDefaultModelAndDefaultPersist;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [BigIntDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BigIntDefaultMix copyWith({
    int? id,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'bigIntDefaultAndDefaultModel': bigIntDefaultAndDefaultModel.toJson(),
      'bigIntDefaultAndDefaultPersist': bigIntDefaultAndDefaultPersist.toJson(),
      'bigIntDefaultModelAndDefaultPersist':
          bigIntDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'bigIntDefaultAndDefaultModel': bigIntDefaultAndDefaultModel.toJson(),
      'bigIntDefaultAndDefaultPersist': bigIntDefaultAndDefaultPersist.toJson(),
      'bigIntDefaultModelAndDefaultPersist':
          bigIntDefaultModelAndDefaultPersist.toJson(),
    };
  }

  static BigIntDefaultMixInclude include() {
    return BigIntDefaultMixInclude._();
  }

  static BigIntDefaultMixIncludeList includeList({
    _i1.WhereExpressionBuilder<BigIntDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BigIntDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BigIntDefaultMixTable>? orderByList,
    BigIntDefaultMixInclude? include,
  }) {
    return BigIntDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BigIntDefaultMix.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BigIntDefaultMix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BigIntDefaultMixImpl extends BigIntDefaultMix {
  _BigIntDefaultMixImpl({
    int? id,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          bigIntDefaultAndDefaultModel: bigIntDefaultAndDefaultModel,
          bigIntDefaultAndDefaultPersist: bigIntDefaultAndDefaultPersist,
          bigIntDefaultModelAndDefaultPersist:
              bigIntDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [BigIntDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BigIntDefaultMix copyWith({
    Object? id = _Undefined,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  }) {
    return BigIntDefaultMix(
      id: id is int? ? id : this.id,
      bigIntDefaultAndDefaultModel:
          bigIntDefaultAndDefaultModel ?? this.bigIntDefaultAndDefaultModel,
      bigIntDefaultAndDefaultPersist:
          bigIntDefaultAndDefaultPersist ?? this.bigIntDefaultAndDefaultPersist,
      bigIntDefaultModelAndDefaultPersist:
          bigIntDefaultModelAndDefaultPersist ??
              this.bigIntDefaultModelAndDefaultPersist,
    );
  }
}

class BigIntDefaultMixTable extends _i1.Table {
  BigIntDefaultMixTable({super.tableRelation})
      : super(tableName: 'bigint_default_mix') {
    bigIntDefaultAndDefaultModel = _i1.ColumnBigInt(
      'bigIntDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    bigIntDefaultAndDefaultPersist = _i1.ColumnBigInt(
      'bigIntDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    bigIntDefaultModelAndDefaultPersist = _i1.ColumnBigInt(
      'bigIntDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnBigInt bigIntDefaultAndDefaultModel;

  late final _i1.ColumnBigInt bigIntDefaultAndDefaultPersist;

  late final _i1.ColumnBigInt bigIntDefaultModelAndDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        bigIntDefaultAndDefaultModel,
        bigIntDefaultAndDefaultPersist,
        bigIntDefaultModelAndDefaultPersist,
      ];
}

class BigIntDefaultMixInclude extends _i1.IncludeObject {
  BigIntDefaultMixInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => BigIntDefaultMix.t;
}

class BigIntDefaultMixIncludeList extends _i1.IncludeList {
  BigIntDefaultMixIncludeList._({
    _i1.WhereExpressionBuilder<BigIntDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BigIntDefaultMix.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => BigIntDefaultMix.t;
}

class BigIntDefaultMixRepository {
  const BigIntDefaultMixRepository._();

  /// Returns a list of [BigIntDefaultMix]s matching the given query parameters.
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
  Future<List<BigIntDefaultMix>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BigIntDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BigIntDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BigIntDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BigIntDefaultMix>(
      where: where?.call(BigIntDefaultMix.t),
      orderBy: orderBy?.call(BigIntDefaultMix.t),
      orderByList: orderByList?.call(BigIntDefaultMix.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BigIntDefaultMix] matching the given query parameters.
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
  Future<BigIntDefaultMix?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BigIntDefaultMixTable>? where,
    int? offset,
    _i1.OrderByBuilder<BigIntDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BigIntDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BigIntDefaultMix>(
      where: where?.call(BigIntDefaultMix.t),
      orderBy: orderBy?.call(BigIntDefaultMix.t),
      orderByList: orderByList?.call(BigIntDefaultMix.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BigIntDefaultMix] by its [id] or null if no such row exists.
  Future<BigIntDefaultMix?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BigIntDefaultMix>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BigIntDefaultMix]s in the list and returns the inserted rows.
  ///
  /// The returned [BigIntDefaultMix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BigIntDefaultMix>> insert(
    _i1.Session session,
    List<BigIntDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BigIntDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BigIntDefaultMix] and returns the inserted row.
  ///
  /// The returned [BigIntDefaultMix] will have its `id` field set.
  Future<BigIntDefaultMix> insertRow(
    _i1.Session session,
    BigIntDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BigIntDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BigIntDefaultMix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BigIntDefaultMix>> update(
    _i1.Session session,
    List<BigIntDefaultMix> rows, {
    _i1.ColumnSelections<BigIntDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BigIntDefaultMix>(
      rows,
      columns: columns?.call(BigIntDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BigIntDefaultMix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BigIntDefaultMix> updateRow(
    _i1.Session session,
    BigIntDefaultMix row, {
    _i1.ColumnSelections<BigIntDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BigIntDefaultMix>(
      row,
      columns: columns?.call(BigIntDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Deletes all [BigIntDefaultMix]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BigIntDefaultMix>> delete(
    _i1.Session session,
    List<BigIntDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BigIntDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BigIntDefaultMix].
  Future<BigIntDefaultMix> deleteRow(
    _i1.Session session,
    BigIntDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BigIntDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BigIntDefaultMix>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BigIntDefaultMixTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BigIntDefaultMix>(
      where: where(BigIntDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BigIntDefaultMixTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BigIntDefaultMix>(
      where: where?.call(BigIntDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

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

abstract class BoolDefaultMix
    implements _i1.TableRow, _i1.ProtocolSerialization {
  BoolDefaultMix._({
    this.id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  })  : boolDefaultAndDefaultModel = boolDefaultAndDefaultModel ?? false,
        boolDefaultAndDefaultPersist = boolDefaultAndDefaultPersist ?? true,
        boolDefaultModelAndDefaultPersist =
            boolDefaultModelAndDefaultPersist ?? true;

  factory BoolDefaultMix({
    int? id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  }) = _BoolDefaultMixImpl;

  factory BoolDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoolDefaultMix(
      id: jsonSerialization['id'] as int?,
      boolDefaultAndDefaultModel:
          jsonSerialization['boolDefaultAndDefaultModel'] as bool,
      boolDefaultAndDefaultPersist:
          jsonSerialization['boolDefaultAndDefaultPersist'] as bool,
      boolDefaultModelAndDefaultPersist:
          jsonSerialization['boolDefaultModelAndDefaultPersist'] as bool,
    );
  }

  static final t = BoolDefaultMixTable();

  static const db = BoolDefaultMixRepository._();

  @override
  int? id;

  bool boolDefaultAndDefaultModel;

  bool boolDefaultAndDefaultPersist;

  bool boolDefaultModelAndDefaultPersist;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [BoolDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoolDefaultMix copyWith({
    int? id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'boolDefaultAndDefaultModel': boolDefaultAndDefaultModel,
      'boolDefaultAndDefaultPersist': boolDefaultAndDefaultPersist,
      'boolDefaultModelAndDefaultPersist': boolDefaultModelAndDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'boolDefaultAndDefaultModel': boolDefaultAndDefaultModel,
      'boolDefaultAndDefaultPersist': boolDefaultAndDefaultPersist,
      'boolDefaultModelAndDefaultPersist': boolDefaultModelAndDefaultPersist,
    };
  }

  static BoolDefaultMixInclude include() {
    return BoolDefaultMixInclude._();
  }

  static BoolDefaultMixIncludeList includeList({
    _i1.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    BoolDefaultMixInclude? include,
  }) {
    return BoolDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BoolDefaultMix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoolDefaultMixImpl extends BoolDefaultMix {
  _BoolDefaultMixImpl({
    int? id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          boolDefaultAndDefaultModel: boolDefaultAndDefaultModel,
          boolDefaultAndDefaultPersist: boolDefaultAndDefaultPersist,
          boolDefaultModelAndDefaultPersist: boolDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [BoolDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoolDefaultMix copyWith({
    Object? id = _Undefined,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  }) {
    return BoolDefaultMix(
      id: id is int? ? id : this.id,
      boolDefaultAndDefaultModel:
          boolDefaultAndDefaultModel ?? this.boolDefaultAndDefaultModel,
      boolDefaultAndDefaultPersist:
          boolDefaultAndDefaultPersist ?? this.boolDefaultAndDefaultPersist,
      boolDefaultModelAndDefaultPersist: boolDefaultModelAndDefaultPersist ??
          this.boolDefaultModelAndDefaultPersist,
    );
  }
}

class BoolDefaultMixTable extends _i1.Table {
  BoolDefaultMixTable({super.tableRelation})
      : super(tableName: 'bool_default_mix') {
    boolDefaultAndDefaultModel = _i1.ColumnBool(
      'boolDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    boolDefaultAndDefaultPersist = _i1.ColumnBool(
      'boolDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    boolDefaultModelAndDefaultPersist = _i1.ColumnBool(
      'boolDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnBool boolDefaultAndDefaultModel;

  late final _i1.ColumnBool boolDefaultAndDefaultPersist;

  late final _i1.ColumnBool boolDefaultModelAndDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        boolDefaultAndDefaultModel,
        boolDefaultAndDefaultPersist,
        boolDefaultModelAndDefaultPersist,
      ];
}

class BoolDefaultMixInclude extends _i1.IncludeObject {
  BoolDefaultMixInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => BoolDefaultMix.t;
}

class BoolDefaultMixIncludeList extends _i1.IncludeList {
  BoolDefaultMixIncludeList._({
    _i1.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BoolDefaultMix.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => BoolDefaultMix.t;
}

class BoolDefaultMixRepository {
  const BoolDefaultMixRepository._();

  /// Returns a list of [BoolDefaultMix]s matching the given query parameters.
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
  Future<List<BoolDefaultMix>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BoolDefaultMix>(
      where: where?.call(BoolDefaultMix.t),
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderByList: orderByList?.call(BoolDefaultMix.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BoolDefaultMix] matching the given query parameters.
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
  Future<BoolDefaultMix?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BoolDefaultMix>(
      where: where?.call(BoolDefaultMix.t),
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderByList: orderByList?.call(BoolDefaultMix.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BoolDefaultMix] by its [id] or null if no such row exists.
  Future<BoolDefaultMix?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BoolDefaultMix>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BoolDefaultMix]s in the list and returns the inserted rows.
  ///
  /// The returned [BoolDefaultMix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BoolDefaultMix>> insert(
    _i1.Session session,
    List<BoolDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BoolDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BoolDefaultMix] and returns the inserted row.
  ///
  /// The returned [BoolDefaultMix] will have its `id` field set.
  Future<BoolDefaultMix> insertRow(
    _i1.Session session,
    BoolDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BoolDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BoolDefaultMix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BoolDefaultMix>> update(
    _i1.Session session,
    List<BoolDefaultMix> rows, {
    _i1.ColumnSelections<BoolDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BoolDefaultMix>(
      rows,
      columns: columns?.call(BoolDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BoolDefaultMix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BoolDefaultMix> updateRow(
    _i1.Session session,
    BoolDefaultMix row, {
    _i1.ColumnSelections<BoolDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BoolDefaultMix>(
      row,
      columns: columns?.call(BoolDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Deletes all [BoolDefaultMix]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BoolDefaultMix>> delete(
    _i1.Session session,
    List<BoolDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BoolDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BoolDefaultMix].
  Future<BoolDefaultMix> deleteRow(
    _i1.Session session,
    BoolDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BoolDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BoolDefaultMix>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BoolDefaultMixTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BoolDefaultMix>(
      where: where(BoolDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BoolDefaultMix>(
      where: where?.call(BoolDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

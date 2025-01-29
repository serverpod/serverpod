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

abstract class DoubleDefaultMix
    implements _i1.TableRow, _i1.ProtocolSerialization {
  DoubleDefaultMix._({
    this.id,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  })  : doubleDefaultAndDefaultModel = doubleDefaultAndDefaultModel ?? 20.5,
        doubleDefaultAndDefaultPersist = doubleDefaultAndDefaultPersist ?? 10.5,
        doubleDefaultModelAndDefaultPersist =
            doubleDefaultModelAndDefaultPersist ?? 10.5;

  factory DoubleDefaultMix({
    int? id,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  }) = _DoubleDefaultMixImpl;

  factory DoubleDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoubleDefaultMix(
      id: jsonSerialization['id'] as int?,
      doubleDefaultAndDefaultModel:
          (jsonSerialization['doubleDefaultAndDefaultModel'] as num).toDouble(),
      doubleDefaultAndDefaultPersist:
          (jsonSerialization['doubleDefaultAndDefaultPersist'] as num)
              .toDouble(),
      doubleDefaultModelAndDefaultPersist:
          (jsonSerialization['doubleDefaultModelAndDefaultPersist'] as num)
              .toDouble(),
    );
  }

  static final t = DoubleDefaultMixTable();

  static const db = DoubleDefaultMixRepository._();

  @override
  int? id;

  double doubleDefaultAndDefaultModel;

  double doubleDefaultAndDefaultPersist;

  double doubleDefaultModelAndDefaultPersist;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [DoubleDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DoubleDefaultMix copyWith({
    int? id,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'doubleDefaultAndDefaultModel': doubleDefaultAndDefaultModel,
      'doubleDefaultAndDefaultPersist': doubleDefaultAndDefaultPersist,
      'doubleDefaultModelAndDefaultPersist':
          doubleDefaultModelAndDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'doubleDefaultAndDefaultModel': doubleDefaultAndDefaultModel,
      'doubleDefaultAndDefaultPersist': doubleDefaultAndDefaultPersist,
      'doubleDefaultModelAndDefaultPersist':
          doubleDefaultModelAndDefaultPersist,
    };
  }

  static DoubleDefaultMixInclude include() {
    return DoubleDefaultMixInclude._();
  }

  static DoubleDefaultMixIncludeList includeList({
    _i1.WhereExpressionBuilder<DoubleDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultMixTable>? orderByList,
    DoubleDefaultMixInclude? include,
  }) {
    return DoubleDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoubleDefaultMix.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DoubleDefaultMix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoubleDefaultMixImpl extends DoubleDefaultMix {
  _DoubleDefaultMixImpl({
    int? id,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          doubleDefaultAndDefaultModel: doubleDefaultAndDefaultModel,
          doubleDefaultAndDefaultPersist: doubleDefaultAndDefaultPersist,
          doubleDefaultModelAndDefaultPersist:
              doubleDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [DoubleDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DoubleDefaultMix copyWith({
    Object? id = _Undefined,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  }) {
    return DoubleDefaultMix(
      id: id is int? ? id : this.id,
      doubleDefaultAndDefaultModel:
          doubleDefaultAndDefaultModel ?? this.doubleDefaultAndDefaultModel,
      doubleDefaultAndDefaultPersist:
          doubleDefaultAndDefaultPersist ?? this.doubleDefaultAndDefaultPersist,
      doubleDefaultModelAndDefaultPersist:
          doubleDefaultModelAndDefaultPersist ??
              this.doubleDefaultModelAndDefaultPersist,
    );
  }
}

class DoubleDefaultMixTable extends _i1.Table {
  DoubleDefaultMixTable({super.tableRelation})
      : super(tableName: 'double_default_mix') {
    doubleDefaultAndDefaultModel = _i1.ColumnDouble(
      'doubleDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    doubleDefaultAndDefaultPersist = _i1.ColumnDouble(
      'doubleDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    doubleDefaultModelAndDefaultPersist = _i1.ColumnDouble(
      'doubleDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnDouble doubleDefaultAndDefaultModel;

  late final _i1.ColumnDouble doubleDefaultAndDefaultPersist;

  late final _i1.ColumnDouble doubleDefaultModelAndDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        doubleDefaultAndDefaultModel,
        doubleDefaultAndDefaultPersist,
        doubleDefaultModelAndDefaultPersist,
      ];
}

class DoubleDefaultMixInclude extends _i1.IncludeObject {
  DoubleDefaultMixInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DoubleDefaultMix.t;
}

class DoubleDefaultMixIncludeList extends _i1.IncludeList {
  DoubleDefaultMixIncludeList._({
    _i1.WhereExpressionBuilder<DoubleDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DoubleDefaultMix.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DoubleDefaultMix.t;
}

class DoubleDefaultMixRepository {
  const DoubleDefaultMixRepository._();

  /// Returns a list of [DoubleDefaultMix]s matching the given query parameters.
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
  Future<List<DoubleDefaultMix>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoubleDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DoubleDefaultMix>(
      where: where?.call(DoubleDefaultMix.t),
      orderBy: orderBy?.call(DoubleDefaultMix.t),
      orderByList: orderByList?.call(DoubleDefaultMix.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [DoubleDefaultMix] matching the given query parameters.
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
  Future<DoubleDefaultMix?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoubleDefaultMixTable>? where,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DoubleDefaultMix>(
      where: where?.call(DoubleDefaultMix.t),
      orderBy: orderBy?.call(DoubleDefaultMix.t),
      orderByList: orderByList?.call(DoubleDefaultMix.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [DoubleDefaultMix] by its [id] or null if no such row exists.
  Future<DoubleDefaultMix?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DoubleDefaultMix>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [DoubleDefaultMix]s in the list and returns the inserted rows.
  ///
  /// The returned [DoubleDefaultMix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<DoubleDefaultMix>> insert(
    _i1.Session session,
    List<DoubleDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DoubleDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [DoubleDefaultMix] and returns the inserted row.
  ///
  /// The returned [DoubleDefaultMix] will have its `id` field set.
  Future<DoubleDefaultMix> insertRow(
    _i1.Session session,
    DoubleDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DoubleDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DoubleDefaultMix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DoubleDefaultMix>> update(
    _i1.Session session,
    List<DoubleDefaultMix> rows, {
    _i1.ColumnSelections<DoubleDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DoubleDefaultMix>(
      rows,
      columns: columns?.call(DoubleDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DoubleDefaultMix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DoubleDefaultMix> updateRow(
    _i1.Session session,
    DoubleDefaultMix row, {
    _i1.ColumnSelections<DoubleDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DoubleDefaultMix>(
      row,
      columns: columns?.call(DoubleDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Deletes all [DoubleDefaultMix]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DoubleDefaultMix>> delete(
    _i1.Session session,
    List<DoubleDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DoubleDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DoubleDefaultMix].
  Future<DoubleDefaultMix> deleteRow(
    _i1.Session session,
    DoubleDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DoubleDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DoubleDefaultMix>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DoubleDefaultMixTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DoubleDefaultMix>(
      where: where(DoubleDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoubleDefaultMixTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DoubleDefaultMix>(
      where: where?.call(DoubleDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

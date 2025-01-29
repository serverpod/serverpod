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

abstract class DoubleDefaultModel
    implements _i1.TableRow, _i1.ProtocolSerialization {
  DoubleDefaultModel._({
    this.id,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  })  : doubleDefaultModel = doubleDefaultModel ?? 10.5,
        doubleDefaultModelNull = doubleDefaultModelNull ?? 20.5;

  factory DoubleDefaultModel({
    int? id,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  }) = _DoubleDefaultModelImpl;

  factory DoubleDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoubleDefaultModel(
      id: jsonSerialization['id'] as int?,
      doubleDefaultModel:
          (jsonSerialization['doubleDefaultModel'] as num).toDouble(),
      doubleDefaultModelNull:
          (jsonSerialization['doubleDefaultModelNull'] as num).toDouble(),
    );
  }

  static final t = DoubleDefaultModelTable();

  static const db = DoubleDefaultModelRepository._();

  @override
  int? id;

  double doubleDefaultModel;

  double doubleDefaultModelNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [DoubleDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DoubleDefaultModel copyWith({
    int? id,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'doubleDefaultModel': doubleDefaultModel,
      'doubleDefaultModelNull': doubleDefaultModelNull,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'doubleDefaultModel': doubleDefaultModel,
      'doubleDefaultModelNull': doubleDefaultModelNull,
    };
  }

  static DoubleDefaultModelInclude include() {
    return DoubleDefaultModelInclude._();
  }

  static DoubleDefaultModelIncludeList includeList({
    _i1.WhereExpressionBuilder<DoubleDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultModelTable>? orderByList,
    DoubleDefaultModelInclude? include,
  }) {
    return DoubleDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoubleDefaultModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DoubleDefaultModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoubleDefaultModelImpl extends DoubleDefaultModel {
  _DoubleDefaultModelImpl({
    int? id,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  }) : super._(
          id: id,
          doubleDefaultModel: doubleDefaultModel,
          doubleDefaultModelNull: doubleDefaultModelNull,
        );

  /// Returns a shallow copy of this [DoubleDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DoubleDefaultModel copyWith({
    Object? id = _Undefined,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  }) {
    return DoubleDefaultModel(
      id: id is int? ? id : this.id,
      doubleDefaultModel: doubleDefaultModel ?? this.doubleDefaultModel,
      doubleDefaultModelNull:
          doubleDefaultModelNull ?? this.doubleDefaultModelNull,
    );
  }
}

class DoubleDefaultModelTable extends _i1.Table {
  DoubleDefaultModelTable({super.tableRelation})
      : super(tableName: 'double_default_model') {
    doubleDefaultModel = _i1.ColumnDouble(
      'doubleDefaultModel',
      this,
    );
    doubleDefaultModelNull = _i1.ColumnDouble(
      'doubleDefaultModelNull',
      this,
    );
  }

  late final _i1.ColumnDouble doubleDefaultModel;

  late final _i1.ColumnDouble doubleDefaultModelNull;

  @override
  List<_i1.Column> get columns => [
        id,
        doubleDefaultModel,
        doubleDefaultModelNull,
      ];
}

class DoubleDefaultModelInclude extends _i1.IncludeObject {
  DoubleDefaultModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DoubleDefaultModel.t;
}

class DoubleDefaultModelIncludeList extends _i1.IncludeList {
  DoubleDefaultModelIncludeList._({
    _i1.WhereExpressionBuilder<DoubleDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DoubleDefaultModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DoubleDefaultModel.t;
}

class DoubleDefaultModelRepository {
  const DoubleDefaultModelRepository._();

  /// Returns a list of [DoubleDefaultModel]s matching the given query parameters.
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
  Future<List<DoubleDefaultModel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoubleDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DoubleDefaultModel>(
      where: where?.call(DoubleDefaultModel.t),
      orderBy: orderBy?.call(DoubleDefaultModel.t),
      orderByList: orderByList?.call(DoubleDefaultModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [DoubleDefaultModel] matching the given query parameters.
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
  Future<DoubleDefaultModel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoubleDefaultModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DoubleDefaultModel>(
      where: where?.call(DoubleDefaultModel.t),
      orderBy: orderBy?.call(DoubleDefaultModel.t),
      orderByList: orderByList?.call(DoubleDefaultModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [DoubleDefaultModel] by its [id] or null if no such row exists.
  Future<DoubleDefaultModel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DoubleDefaultModel>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [DoubleDefaultModel]s in the list and returns the inserted rows.
  ///
  /// The returned [DoubleDefaultModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<DoubleDefaultModel>> insert(
    _i1.Session session,
    List<DoubleDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DoubleDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [DoubleDefaultModel] and returns the inserted row.
  ///
  /// The returned [DoubleDefaultModel] will have its `id` field set.
  Future<DoubleDefaultModel> insertRow(
    _i1.Session session,
    DoubleDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DoubleDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DoubleDefaultModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DoubleDefaultModel>> update(
    _i1.Session session,
    List<DoubleDefaultModel> rows, {
    _i1.ColumnSelections<DoubleDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DoubleDefaultModel>(
      rows,
      columns: columns?.call(DoubleDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DoubleDefaultModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DoubleDefaultModel> updateRow(
    _i1.Session session,
    DoubleDefaultModel row, {
    _i1.ColumnSelections<DoubleDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DoubleDefaultModel>(
      row,
      columns: columns?.call(DoubleDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Deletes all [DoubleDefaultModel]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DoubleDefaultModel>> delete(
    _i1.Session session,
    List<DoubleDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DoubleDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DoubleDefaultModel].
  Future<DoubleDefaultModel> deleteRow(
    _i1.Session session,
    DoubleDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DoubleDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DoubleDefaultModel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DoubleDefaultModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DoubleDefaultModel>(
      where: where(DoubleDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoubleDefaultModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DoubleDefaultModel>(
      where: where?.call(DoubleDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

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

abstract class IntDefaultModel
    implements _i1.TableRow, _i1.ProtocolSerialization {
  IntDefaultModel._({
    this.id,
    int? intDefaultModel,
    int? intDefaultModelNull,
  })  : intDefaultModel = intDefaultModel ?? 10,
        intDefaultModelNull = intDefaultModelNull ?? 20;

  factory IntDefaultModel({
    int? id,
    int? intDefaultModel,
    int? intDefaultModelNull,
  }) = _IntDefaultModelImpl;

  factory IntDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return IntDefaultModel(
      id: jsonSerialization['id'] as int?,
      intDefaultModel: jsonSerialization['intDefaultModel'] as int,
      intDefaultModelNull: jsonSerialization['intDefaultModelNull'] as int,
    );
  }

  static final t = IntDefaultModelTable();

  static const db = IntDefaultModelRepository._();

  @override
  int? id;

  int intDefaultModel;

  int intDefaultModelNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [IntDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IntDefaultModel copyWith({
    int? id,
    int? intDefaultModel,
    int? intDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'intDefaultModel': intDefaultModel,
      'intDefaultModelNull': intDefaultModelNull,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'intDefaultModel': intDefaultModel,
      'intDefaultModelNull': intDefaultModelNull,
    };
  }

  static IntDefaultModelInclude include() {
    return IntDefaultModelInclude._();
  }

  static IntDefaultModelIncludeList includeList({
    _i1.WhereExpressionBuilder<IntDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IntDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultModelTable>? orderByList,
    IntDefaultModelInclude? include,
  }) {
    return IntDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntDefaultModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(IntDefaultModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IntDefaultModelImpl extends IntDefaultModel {
  _IntDefaultModelImpl({
    int? id,
    int? intDefaultModel,
    int? intDefaultModelNull,
  }) : super._(
          id: id,
          intDefaultModel: intDefaultModel,
          intDefaultModelNull: intDefaultModelNull,
        );

  /// Returns a shallow copy of this [IntDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IntDefaultModel copyWith({
    Object? id = _Undefined,
    int? intDefaultModel,
    int? intDefaultModelNull,
  }) {
    return IntDefaultModel(
      id: id is int? ? id : this.id,
      intDefaultModel: intDefaultModel ?? this.intDefaultModel,
      intDefaultModelNull: intDefaultModelNull ?? this.intDefaultModelNull,
    );
  }
}

class IntDefaultModelTable extends _i1.Table {
  IntDefaultModelTable({super.tableRelation})
      : super(tableName: 'int_default_model') {
    intDefaultModel = _i1.ColumnInt(
      'intDefaultModel',
      this,
    );
    intDefaultModelNull = _i1.ColumnInt(
      'intDefaultModelNull',
      this,
    );
  }

  late final _i1.ColumnInt intDefaultModel;

  late final _i1.ColumnInt intDefaultModelNull;

  @override
  List<_i1.Column> get columns => [
        id,
        intDefaultModel,
        intDefaultModelNull,
      ];
}

class IntDefaultModelInclude extends _i1.IncludeObject {
  IntDefaultModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => IntDefaultModel.t;
}

class IntDefaultModelIncludeList extends _i1.IncludeList {
  IntDefaultModelIncludeList._({
    _i1.WhereExpressionBuilder<IntDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IntDefaultModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => IntDefaultModel.t;
}

class IntDefaultModelRepository {
  const IntDefaultModelRepository._();

  /// Returns a list of [IntDefaultModel]s matching the given query parameters.
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
  Future<List<IntDefaultModel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IntDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IntDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<IntDefaultModel>(
      where: where?.call(IntDefaultModel.t),
      orderBy: orderBy?.call(IntDefaultModel.t),
      orderByList: orderByList?.call(IntDefaultModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [IntDefaultModel] matching the given query parameters.
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
  Future<IntDefaultModel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IntDefaultModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<IntDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<IntDefaultModel>(
      where: where?.call(IntDefaultModel.t),
      orderBy: orderBy?.call(IntDefaultModel.t),
      orderByList: orderByList?.call(IntDefaultModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [IntDefaultModel] by its [id] or null if no such row exists.
  Future<IntDefaultModel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<IntDefaultModel>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [IntDefaultModel]s in the list and returns the inserted rows.
  ///
  /// The returned [IntDefaultModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<IntDefaultModel>> insert(
    _i1.Session session,
    List<IntDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<IntDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [IntDefaultModel] and returns the inserted row.
  ///
  /// The returned [IntDefaultModel] will have its `id` field set.
  Future<IntDefaultModel> insertRow(
    _i1.Session session,
    IntDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<IntDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [IntDefaultModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<IntDefaultModel>> update(
    _i1.Session session,
    List<IntDefaultModel> rows, {
    _i1.ColumnSelections<IntDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<IntDefaultModel>(
      rows,
      columns: columns?.call(IntDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IntDefaultModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IntDefaultModel> updateRow(
    _i1.Session session,
    IntDefaultModel row, {
    _i1.ColumnSelections<IntDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<IntDefaultModel>(
      row,
      columns: columns?.call(IntDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Deletes all [IntDefaultModel]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<IntDefaultModel>> delete(
    _i1.Session session,
    List<IntDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<IntDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [IntDefaultModel].
  Future<IntDefaultModel> deleteRow(
    _i1.Session session,
    IntDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IntDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<IntDefaultModel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<IntDefaultModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<IntDefaultModel>(
      where: where(IntDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IntDefaultModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<IntDefaultModel>(
      where: where?.call(IntDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

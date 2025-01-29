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

abstract class DurationDefaultModel
    implements _i1.TableRow, _i1.ProtocolSerialization {
  DurationDefaultModel._({
    this.id,
    Duration? durationDefaultModel,
    Duration? durationDefaultModelNull,
  })  : durationDefaultModel = durationDefaultModel ??
            Duration(
              days: 1,
              hours: 2,
              minutes: 10,
              seconds: 30,
              milliseconds: 100,
            ),
        durationDefaultModelNull = durationDefaultModelNull ??
            Duration(
              days: 2,
              hours: 1,
              minutes: 20,
              seconds: 40,
              milliseconds: 100,
            );

  factory DurationDefaultModel({
    int? id,
    Duration? durationDefaultModel,
    Duration? durationDefaultModelNull,
  }) = _DurationDefaultModelImpl;

  factory DurationDefaultModel.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DurationDefaultModel(
      id: jsonSerialization['id'] as int?,
      durationDefaultModel: _i1.DurationJsonExtension.fromJson(
          jsonSerialization['durationDefaultModel']),
      durationDefaultModelNull:
          jsonSerialization['durationDefaultModelNull'] == null
              ? null
              : _i1.DurationJsonExtension.fromJson(
                  jsonSerialization['durationDefaultModelNull']),
    );
  }

  static final t = DurationDefaultModelTable();

  static const db = DurationDefaultModelRepository._();

  @override
  int? id;

  Duration durationDefaultModel;

  Duration? durationDefaultModelNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [DurationDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DurationDefaultModel copyWith({
    int? id,
    Duration? durationDefaultModel,
    Duration? durationDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'durationDefaultModel': durationDefaultModel.toJson(),
      if (durationDefaultModelNull != null)
        'durationDefaultModelNull': durationDefaultModelNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'durationDefaultModel': durationDefaultModel.toJson(),
      if (durationDefaultModelNull != null)
        'durationDefaultModelNull': durationDefaultModelNull?.toJson(),
    };
  }

  static DurationDefaultModelInclude include() {
    return DurationDefaultModelInclude._();
  }

  static DurationDefaultModelIncludeList includeList({
    _i1.WhereExpressionBuilder<DurationDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DurationDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DurationDefaultModelTable>? orderByList,
    DurationDefaultModelInclude? include,
  }) {
    return DurationDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DurationDefaultModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DurationDefaultModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DurationDefaultModelImpl extends DurationDefaultModel {
  _DurationDefaultModelImpl({
    int? id,
    Duration? durationDefaultModel,
    Duration? durationDefaultModelNull,
  }) : super._(
          id: id,
          durationDefaultModel: durationDefaultModel,
          durationDefaultModelNull: durationDefaultModelNull,
        );

  /// Returns a shallow copy of this [DurationDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DurationDefaultModel copyWith({
    Object? id = _Undefined,
    Duration? durationDefaultModel,
    Object? durationDefaultModelNull = _Undefined,
  }) {
    return DurationDefaultModel(
      id: id is int? ? id : this.id,
      durationDefaultModel: durationDefaultModel ?? this.durationDefaultModel,
      durationDefaultModelNull: durationDefaultModelNull is Duration?
          ? durationDefaultModelNull
          : this.durationDefaultModelNull,
    );
  }
}

class DurationDefaultModelTable extends _i1.Table {
  DurationDefaultModelTable({super.tableRelation})
      : super(tableName: 'duration_default_model') {
    durationDefaultModel = _i1.ColumnDuration(
      'durationDefaultModel',
      this,
    );
    durationDefaultModelNull = _i1.ColumnDuration(
      'durationDefaultModelNull',
      this,
    );
  }

  late final _i1.ColumnDuration durationDefaultModel;

  late final _i1.ColumnDuration durationDefaultModelNull;

  @override
  List<_i1.Column> get columns => [
        id,
        durationDefaultModel,
        durationDefaultModelNull,
      ];
}

class DurationDefaultModelInclude extends _i1.IncludeObject {
  DurationDefaultModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DurationDefaultModel.t;
}

class DurationDefaultModelIncludeList extends _i1.IncludeList {
  DurationDefaultModelIncludeList._({
    _i1.WhereExpressionBuilder<DurationDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DurationDefaultModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DurationDefaultModel.t;
}

class DurationDefaultModelRepository {
  const DurationDefaultModelRepository._();

  /// Returns a list of [DurationDefaultModel]s matching the given query parameters.
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
  Future<List<DurationDefaultModel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DurationDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DurationDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DurationDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DurationDefaultModel>(
      where: where?.call(DurationDefaultModel.t),
      orderBy: orderBy?.call(DurationDefaultModel.t),
      orderByList: orderByList?.call(DurationDefaultModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [DurationDefaultModel] matching the given query parameters.
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
  Future<DurationDefaultModel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DurationDefaultModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<DurationDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DurationDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DurationDefaultModel>(
      where: where?.call(DurationDefaultModel.t),
      orderBy: orderBy?.call(DurationDefaultModel.t),
      orderByList: orderByList?.call(DurationDefaultModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [DurationDefaultModel] by its [id] or null if no such row exists.
  Future<DurationDefaultModel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DurationDefaultModel>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [DurationDefaultModel]s in the list and returns the inserted rows.
  ///
  /// The returned [DurationDefaultModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<DurationDefaultModel>> insert(
    _i1.Session session,
    List<DurationDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DurationDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [DurationDefaultModel] and returns the inserted row.
  ///
  /// The returned [DurationDefaultModel] will have its `id` field set.
  Future<DurationDefaultModel> insertRow(
    _i1.Session session,
    DurationDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DurationDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DurationDefaultModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DurationDefaultModel>> update(
    _i1.Session session,
    List<DurationDefaultModel> rows, {
    _i1.ColumnSelections<DurationDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DurationDefaultModel>(
      rows,
      columns: columns?.call(DurationDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DurationDefaultModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DurationDefaultModel> updateRow(
    _i1.Session session,
    DurationDefaultModel row, {
    _i1.ColumnSelections<DurationDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DurationDefaultModel>(
      row,
      columns: columns?.call(DurationDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Deletes all [DurationDefaultModel]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DurationDefaultModel>> delete(
    _i1.Session session,
    List<DurationDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DurationDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DurationDefaultModel].
  Future<DurationDefaultModel> deleteRow(
    _i1.Session session,
    DurationDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DurationDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DurationDefaultModel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DurationDefaultModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DurationDefaultModel>(
      where: where(DurationDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DurationDefaultModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DurationDefaultModel>(
      where: where?.call(DurationDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

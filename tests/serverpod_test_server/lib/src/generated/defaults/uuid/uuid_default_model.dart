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

abstract class UuidDefaultModel
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UuidDefaultModel._({
    this.id,
    _i1.UuidValue? uuidDefaultModelRandom,
    _i1.UuidValue? uuidDefaultModelRandomV7,
    _i1.UuidValue? uuidDefaultModelRandomNull,
    _i1.UuidValue? uuidDefaultModelStr,
    _i1.UuidValue? uuidDefaultModelStrNull,
  })  : uuidDefaultModelRandom = uuidDefaultModelRandom ?? _i1.Uuid().v4obj(),
        uuidDefaultModelRandomV7 =
            uuidDefaultModelRandomV7 ?? _i1.Uuid().v7obj(),
        uuidDefaultModelRandomNull =
            uuidDefaultModelRandomNull ?? _i1.Uuid().v4obj(),
        uuidDefaultModelStr = uuidDefaultModelStr ??
            _i1.UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        uuidDefaultModelStrNull = uuidDefaultModelStrNull ??
            _i1.UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');

  factory UuidDefaultModel({
    int? id,
    _i1.UuidValue? uuidDefaultModelRandom,
    _i1.UuidValue? uuidDefaultModelRandomV7,
    _i1.UuidValue? uuidDefaultModelRandomNull,
    _i1.UuidValue? uuidDefaultModelStr,
    _i1.UuidValue? uuidDefaultModelStrNull,
  }) = _UuidDefaultModelImpl;

  factory UuidDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefaultModel(
      id: jsonSerialization['id'] as int?,
      uuidDefaultModelRandom: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultModelRandom']),
      uuidDefaultModelRandomV7: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultModelRandomV7']),
      uuidDefaultModelRandomNull:
          jsonSerialization['uuidDefaultModelRandomNull'] == null
              ? null
              : _i1.UuidValueJsonExtension.fromJson(
                  jsonSerialization['uuidDefaultModelRandomNull']),
      uuidDefaultModelStr: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultModelStr']),
      uuidDefaultModelStrNull:
          jsonSerialization['uuidDefaultModelStrNull'] == null
              ? null
              : _i1.UuidValueJsonExtension.fromJson(
                  jsonSerialization['uuidDefaultModelStrNull']),
    );
  }

  static final t = UuidDefaultModelTable();

  static const db = UuidDefaultModelRepository._();

  @override
  int? id;

  _i1.UuidValue uuidDefaultModelRandom;

  _i1.UuidValue uuidDefaultModelRandomV7;

  _i1.UuidValue? uuidDefaultModelRandomNull;

  _i1.UuidValue uuidDefaultModelStr;

  _i1.UuidValue? uuidDefaultModelStrNull;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UuidDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UuidDefaultModel copyWith({
    int? id,
    _i1.UuidValue? uuidDefaultModelRandom,
    _i1.UuidValue? uuidDefaultModelRandomV7,
    _i1.UuidValue? uuidDefaultModelRandomNull,
    _i1.UuidValue? uuidDefaultModelStr,
    _i1.UuidValue? uuidDefaultModelStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uuidDefaultModelRandom': uuidDefaultModelRandom.toJson(),
      'uuidDefaultModelRandomV7': uuidDefaultModelRandomV7.toJson(),
      if (uuidDefaultModelRandomNull != null)
        'uuidDefaultModelRandomNull': uuidDefaultModelRandomNull?.toJson(),
      'uuidDefaultModelStr': uuidDefaultModelStr.toJson(),
      if (uuidDefaultModelStrNull != null)
        'uuidDefaultModelStrNull': uuidDefaultModelStrNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'uuidDefaultModelRandom': uuidDefaultModelRandom.toJson(),
      'uuidDefaultModelRandomV7': uuidDefaultModelRandomV7.toJson(),
      if (uuidDefaultModelRandomNull != null)
        'uuidDefaultModelRandomNull': uuidDefaultModelRandomNull?.toJson(),
      'uuidDefaultModelStr': uuidDefaultModelStr.toJson(),
      if (uuidDefaultModelStrNull != null)
        'uuidDefaultModelStrNull': uuidDefaultModelStrNull?.toJson(),
    };
  }

  static UuidDefaultModelInclude include() {
    return UuidDefaultModelInclude._();
  }

  static UuidDefaultModelIncludeList includeList({
    _i1.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultModelTable>? orderByList,
    UuidDefaultModelInclude? include,
  }) {
    return UuidDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UuidDefaultModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UuidDefaultModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultModelImpl extends UuidDefaultModel {
  _UuidDefaultModelImpl({
    int? id,
    _i1.UuidValue? uuidDefaultModelRandom,
    _i1.UuidValue? uuidDefaultModelRandomV7,
    _i1.UuidValue? uuidDefaultModelRandomNull,
    _i1.UuidValue? uuidDefaultModelStr,
    _i1.UuidValue? uuidDefaultModelStrNull,
  }) : super._(
          id: id,
          uuidDefaultModelRandom: uuidDefaultModelRandom,
          uuidDefaultModelRandomV7: uuidDefaultModelRandomV7,
          uuidDefaultModelRandomNull: uuidDefaultModelRandomNull,
          uuidDefaultModelStr: uuidDefaultModelStr,
          uuidDefaultModelStrNull: uuidDefaultModelStrNull,
        );

  /// Returns a shallow copy of this [UuidDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UuidDefaultModel copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuidDefaultModelRandom,
    _i1.UuidValue? uuidDefaultModelRandomV7,
    Object? uuidDefaultModelRandomNull = _Undefined,
    _i1.UuidValue? uuidDefaultModelStr,
    Object? uuidDefaultModelStrNull = _Undefined,
  }) {
    return UuidDefaultModel(
      id: id is int? ? id : this.id,
      uuidDefaultModelRandom:
          uuidDefaultModelRandom ?? this.uuidDefaultModelRandom,
      uuidDefaultModelRandomV7:
          uuidDefaultModelRandomV7 ?? this.uuidDefaultModelRandomV7,
      uuidDefaultModelRandomNull: uuidDefaultModelRandomNull is _i1.UuidValue?
          ? uuidDefaultModelRandomNull
          : this.uuidDefaultModelRandomNull,
      uuidDefaultModelStr: uuidDefaultModelStr ?? this.uuidDefaultModelStr,
      uuidDefaultModelStrNull: uuidDefaultModelStrNull is _i1.UuidValue?
          ? uuidDefaultModelStrNull
          : this.uuidDefaultModelStrNull,
    );
  }
}

class UuidDefaultModelTable extends _i1.Table<int?> {
  UuidDefaultModelTable({super.tableRelation})
      : super(tableName: 'uuid_default_model') {
    uuidDefaultModelRandom = _i1.ColumnUuid(
      'uuidDefaultModelRandom',
      this,
    );
    uuidDefaultModelRandomV7 = _i1.ColumnUuid(
      'uuidDefaultModelRandomV7',
      this,
    );
    uuidDefaultModelRandomNull = _i1.ColumnUuid(
      'uuidDefaultModelRandomNull',
      this,
    );
    uuidDefaultModelStr = _i1.ColumnUuid(
      'uuidDefaultModelStr',
      this,
    );
    uuidDefaultModelStrNull = _i1.ColumnUuid(
      'uuidDefaultModelStrNull',
      this,
    );
  }

  late final _i1.ColumnUuid uuidDefaultModelRandom;

  late final _i1.ColumnUuid uuidDefaultModelRandomV7;

  late final _i1.ColumnUuid uuidDefaultModelRandomNull;

  late final _i1.ColumnUuid uuidDefaultModelStr;

  late final _i1.ColumnUuid uuidDefaultModelStrNull;

  @override
  List<_i1.Column> get columns => [
        id,
        uuidDefaultModelRandom,
        uuidDefaultModelRandomV7,
        uuidDefaultModelRandomNull,
        uuidDefaultModelStr,
        uuidDefaultModelStrNull,
      ];
}

class UuidDefaultModelInclude extends _i1.IncludeObject {
  UuidDefaultModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UuidDefaultModel.t;
}

class UuidDefaultModelIncludeList extends _i1.IncludeList {
  UuidDefaultModelIncludeList._({
    _i1.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UuidDefaultModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UuidDefaultModel.t;
}

class UuidDefaultModelRepository {
  const UuidDefaultModelRepository._();

  /// Returns a list of [UuidDefaultModel]s matching the given query parameters.
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
  Future<List<UuidDefaultModel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UuidDefaultModel>(
      where: where?.call(UuidDefaultModel.t),
      orderBy: orderBy?.call(UuidDefaultModel.t),
      orderByList: orderByList?.call(UuidDefaultModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UuidDefaultModel] matching the given query parameters.
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
  Future<UuidDefaultModel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UuidDefaultModel>(
      where: where?.call(UuidDefaultModel.t),
      orderBy: orderBy?.call(UuidDefaultModel.t),
      orderByList: orderByList?.call(UuidDefaultModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UuidDefaultModel] by its [id] or null if no such row exists.
  Future<UuidDefaultModel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UuidDefaultModel>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UuidDefaultModel]s in the list and returns the inserted rows.
  ///
  /// The returned [UuidDefaultModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UuidDefaultModel>> insert(
    _i1.Session session,
    List<UuidDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UuidDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UuidDefaultModel] and returns the inserted row.
  ///
  /// The returned [UuidDefaultModel] will have its `id` field set.
  Future<UuidDefaultModel> insertRow(
    _i1.Session session,
    UuidDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UuidDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UuidDefaultModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UuidDefaultModel>> update(
    _i1.Session session,
    List<UuidDefaultModel> rows, {
    _i1.ColumnSelections<UuidDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UuidDefaultModel>(
      rows,
      columns: columns?.call(UuidDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UuidDefaultModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UuidDefaultModel> updateRow(
    _i1.Session session,
    UuidDefaultModel row, {
    _i1.ColumnSelections<UuidDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UuidDefaultModel>(
      row,
      columns: columns?.call(UuidDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UuidDefaultModel]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UuidDefaultModel>> delete(
    _i1.Session session,
    List<UuidDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UuidDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UuidDefaultModel].
  Future<UuidDefaultModel> deleteRow(
    _i1.Session session,
    UuidDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UuidDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UuidDefaultModel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UuidDefaultModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UuidDefaultModel>(
      where: where(UuidDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UuidDefaultModel>(
      where: where?.call(UuidDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

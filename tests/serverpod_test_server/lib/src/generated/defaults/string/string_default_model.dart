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

abstract class StringDefaultModel
    implements _i1.TableRow, _i1.ProtocolSerialization {
  StringDefaultModel._({
    this.id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  })  : stringDefaultModel =
            stringDefaultModel ?? 'This is a default model value',
        stringDefaultModelNull =
            stringDefaultModelNull ?? 'This is a default model null value';

  factory StringDefaultModel({
    int? id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  }) = _StringDefaultModelImpl;

  factory StringDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return StringDefaultModel(
      id: jsonSerialization['id'] as int?,
      stringDefaultModel: jsonSerialization['stringDefaultModel'] as String,
      stringDefaultModelNull:
          jsonSerialization['stringDefaultModelNull'] as String,
    );
  }

  static final t = StringDefaultModelTable();

  static const db = StringDefaultModelRepository._();

  @override
  int? id;

  String stringDefaultModel;

  String stringDefaultModelNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [StringDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StringDefaultModel copyWith({
    int? id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'stringDefaultModel': stringDefaultModel,
      'stringDefaultModelNull': stringDefaultModelNull,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'stringDefaultModel': stringDefaultModel,
      'stringDefaultModelNull': stringDefaultModelNull,
    };
  }

  static StringDefaultModelInclude include() {
    return StringDefaultModelInclude._();
  }

  static StringDefaultModelIncludeList includeList({
    _i1.WhereExpressionBuilder<StringDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StringDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultModelTable>? orderByList,
    StringDefaultModelInclude? include,
  }) {
    return StringDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefaultModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(StringDefaultModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultModelImpl extends StringDefaultModel {
  _StringDefaultModelImpl({
    int? id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  }) : super._(
          id: id,
          stringDefaultModel: stringDefaultModel,
          stringDefaultModelNull: stringDefaultModelNull,
        );

  /// Returns a shallow copy of this [StringDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StringDefaultModel copyWith({
    Object? id = _Undefined,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  }) {
    return StringDefaultModel(
      id: id is int? ? id : this.id,
      stringDefaultModel: stringDefaultModel ?? this.stringDefaultModel,
      stringDefaultModelNull:
          stringDefaultModelNull ?? this.stringDefaultModelNull,
    );
  }
}

class StringDefaultModelTable extends _i1.Table {
  StringDefaultModelTable({super.tableRelation})
      : super(tableName: 'string_default_model') {
    stringDefaultModel = _i1.ColumnString(
      'stringDefaultModel',
      this,
    );
    stringDefaultModelNull = _i1.ColumnString(
      'stringDefaultModelNull',
      this,
    );
  }

  late final _i1.ColumnString stringDefaultModel;

  late final _i1.ColumnString stringDefaultModelNull;

  @override
  List<_i1.Column> get columns => [
        id,
        stringDefaultModel,
        stringDefaultModelNull,
      ];
}

class StringDefaultModelInclude extends _i1.IncludeObject {
  StringDefaultModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => StringDefaultModel.t;
}

class StringDefaultModelIncludeList extends _i1.IncludeList {
  StringDefaultModelIncludeList._({
    _i1.WhereExpressionBuilder<StringDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StringDefaultModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => StringDefaultModel.t;
}

class StringDefaultModelRepository {
  const StringDefaultModelRepository._();

  /// Returns a list of [StringDefaultModel]s matching the given query parameters.
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
  Future<List<StringDefaultModel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StringDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<StringDefaultModel>(
      where: where?.call(StringDefaultModel.t),
      orderBy: orderBy?.call(StringDefaultModel.t),
      orderByList: orderByList?.call(StringDefaultModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [StringDefaultModel] matching the given query parameters.
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
  Future<StringDefaultModel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<StringDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<StringDefaultModel>(
      where: where?.call(StringDefaultModel.t),
      orderBy: orderBy?.call(StringDefaultModel.t),
      orderByList: orderByList?.call(StringDefaultModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [StringDefaultModel] by its [id] or null if no such row exists.
  Future<StringDefaultModel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<StringDefaultModel>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [StringDefaultModel]s in the list and returns the inserted rows.
  ///
  /// The returned [StringDefaultModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<StringDefaultModel>> insert(
    _i1.Session session,
    List<StringDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<StringDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [StringDefaultModel] and returns the inserted row.
  ///
  /// The returned [StringDefaultModel] will have its `id` field set.
  Future<StringDefaultModel> insertRow(
    _i1.Session session,
    StringDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<StringDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [StringDefaultModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<StringDefaultModel>> update(
    _i1.Session session,
    List<StringDefaultModel> rows, {
    _i1.ColumnSelections<StringDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<StringDefaultModel>(
      rows,
      columns: columns?.call(StringDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StringDefaultModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StringDefaultModel> updateRow(
    _i1.Session session,
    StringDefaultModel row, {
    _i1.ColumnSelections<StringDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<StringDefaultModel>(
      row,
      columns: columns?.call(StringDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Deletes all [StringDefaultModel]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<StringDefaultModel>> delete(
    _i1.Session session,
    List<StringDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<StringDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [StringDefaultModel].
  Future<StringDefaultModel> deleteRow(
    _i1.Session session,
    StringDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StringDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<StringDefaultModel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StringDefaultModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<StringDefaultModel>(
      where: where(StringDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<StringDefaultModel>(
      where: where?.call(StringDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

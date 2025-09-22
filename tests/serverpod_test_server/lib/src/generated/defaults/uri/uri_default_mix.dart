/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class UriDefaultMix
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UriDefaultMix._({
    this.id,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  })  : uriDefaultAndDefaultModel = uriDefaultAndDefaultModel ??
            Uri.parse('https://serverpod.dev/defaultModel'),
        uriDefaultAndDefaultPersist = uriDefaultAndDefaultPersist ??
            Uri.parse('https://serverpod.dev/default'),
        uriDefaultModelAndDefaultPersist = uriDefaultModelAndDefaultPersist ??
            Uri.parse('https://serverpod.dev/defaultModel');

  factory UriDefaultMix({
    int? id,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  }) = _UriDefaultMixImpl;

  factory UriDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return UriDefaultMix(
      id: jsonSerialization['id'] as int?,
      uriDefaultAndDefaultModel: _i1.UriJsonExtension.fromJson(
          jsonSerialization['uriDefaultAndDefaultModel']),
      uriDefaultAndDefaultPersist: _i1.UriJsonExtension.fromJson(
          jsonSerialization['uriDefaultAndDefaultPersist']),
      uriDefaultModelAndDefaultPersist: _i1.UriJsonExtension.fromJson(
          jsonSerialization['uriDefaultModelAndDefaultPersist']),
    );
  }

  static final t = UriDefaultMixTable();

  static const db = UriDefaultMixRepository._();

  @override
  int? id;

  Uri uriDefaultAndDefaultModel;

  Uri uriDefaultAndDefaultPersist;

  Uri uriDefaultModelAndDefaultPersist;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UriDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UriDefaultMix copyWith({
    int? id,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uriDefaultAndDefaultModel': uriDefaultAndDefaultModel.toJson(),
      'uriDefaultAndDefaultPersist': uriDefaultAndDefaultPersist.toJson(),
      'uriDefaultModelAndDefaultPersist':
          uriDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'uriDefaultAndDefaultModel': uriDefaultAndDefaultModel.toJson(),
      'uriDefaultAndDefaultPersist': uriDefaultAndDefaultPersist.toJson(),
      'uriDefaultModelAndDefaultPersist':
          uriDefaultModelAndDefaultPersist.toJson(),
    };
  }

  static UriDefaultMixInclude include() {
    return UriDefaultMixInclude._();
  }

  static UriDefaultMixIncludeList includeList({
    _i1.WhereExpressionBuilder<UriDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UriDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UriDefaultMixTable>? orderByList,
    UriDefaultMixInclude? include,
  }) {
    return UriDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UriDefaultMix.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UriDefaultMix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UriDefaultMixImpl extends UriDefaultMix {
  _UriDefaultMixImpl({
    int? id,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          uriDefaultAndDefaultModel: uriDefaultAndDefaultModel,
          uriDefaultAndDefaultPersist: uriDefaultAndDefaultPersist,
          uriDefaultModelAndDefaultPersist: uriDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [UriDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UriDefaultMix copyWith({
    Object? id = _Undefined,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  }) {
    return UriDefaultMix(
      id: id is int? ? id : this.id,
      uriDefaultAndDefaultModel:
          uriDefaultAndDefaultModel ?? this.uriDefaultAndDefaultModel,
      uriDefaultAndDefaultPersist:
          uriDefaultAndDefaultPersist ?? this.uriDefaultAndDefaultPersist,
      uriDefaultModelAndDefaultPersist: uriDefaultModelAndDefaultPersist ??
          this.uriDefaultModelAndDefaultPersist,
    );
  }
}

class UriDefaultMixUpdateTable extends _i1.UpdateTable<UriDefaultMixTable> {
  UriDefaultMixUpdateTable(super.table);

  _i1.ColumnValue<Uri, Uri> uriDefaultAndDefaultModel(Uri value) =>
      _i1.ColumnValue(
        table.uriDefaultAndDefaultModel,
        value,
      );

  _i1.ColumnValue<Uri, Uri> uriDefaultAndDefaultPersist(Uri value) =>
      _i1.ColumnValue(
        table.uriDefaultAndDefaultPersist,
        value,
      );

  _i1.ColumnValue<Uri, Uri> uriDefaultModelAndDefaultPersist(Uri value) =>
      _i1.ColumnValue(
        table.uriDefaultModelAndDefaultPersist,
        value,
      );
}

class UriDefaultMixTable extends _i1.Table<int?> {
  UriDefaultMixTable({super.tableRelation})
      : super(tableName: 'uri_default_mix') {
    updateTable = UriDefaultMixUpdateTable(this);
    uriDefaultAndDefaultModel = _i1.ColumnUri(
      'uriDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    uriDefaultAndDefaultPersist = _i1.ColumnUri(
      'uriDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    uriDefaultModelAndDefaultPersist = _i1.ColumnUri(
      'uriDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final UriDefaultMixUpdateTable updateTable;

  late final _i1.ColumnUri uriDefaultAndDefaultModel;

  late final _i1.ColumnUri uriDefaultAndDefaultPersist;

  late final _i1.ColumnUri uriDefaultModelAndDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        uriDefaultAndDefaultModel,
        uriDefaultAndDefaultPersist,
        uriDefaultModelAndDefaultPersist,
      ];
}

class UriDefaultMixInclude extends _i1.IncludeObject {
  UriDefaultMixInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UriDefaultMix.t;
}

class UriDefaultMixIncludeList extends _i1.IncludeList {
  UriDefaultMixIncludeList._({
    _i1.WhereExpressionBuilder<UriDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UriDefaultMix.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UriDefaultMix.t;
}

class UriDefaultMixRepository {
  const UriDefaultMixRepository._();

  /// Returns a list of [UriDefaultMix]s matching the given query parameters.
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
  Future<List<UriDefaultMix>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UriDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UriDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UriDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UriDefaultMix>(
      where: where?.call(UriDefaultMix.t),
      orderBy: orderBy?.call(UriDefaultMix.t),
      orderByList: orderByList?.call(UriDefaultMix.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UriDefaultMix] matching the given query parameters.
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
  Future<UriDefaultMix?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UriDefaultMixTable>? where,
    int? offset,
    _i1.OrderByBuilder<UriDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UriDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UriDefaultMix>(
      where: where?.call(UriDefaultMix.t),
      orderBy: orderBy?.call(UriDefaultMix.t),
      orderByList: orderByList?.call(UriDefaultMix.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UriDefaultMix] by its [id] or null if no such row exists.
  Future<UriDefaultMix?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UriDefaultMix>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UriDefaultMix]s in the list and returns the inserted rows.
  ///
  /// The returned [UriDefaultMix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UriDefaultMix>> insert(
    _i1.Session session,
    List<UriDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UriDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UriDefaultMix] and returns the inserted row.
  ///
  /// The returned [UriDefaultMix] will have its `id` field set.
  Future<UriDefaultMix> insertRow(
    _i1.Session session,
    UriDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UriDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UriDefaultMix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UriDefaultMix>> update(
    _i1.Session session,
    List<UriDefaultMix> rows, {
    _i1.ColumnSelections<UriDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UriDefaultMix>(
      rows,
      columns: columns?.call(UriDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UriDefaultMix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UriDefaultMix> updateRow(
    _i1.Session session,
    UriDefaultMix row, {
    _i1.ColumnSelections<UriDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UriDefaultMix>(
      row,
      columns: columns?.call(UriDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UriDefaultMix] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UriDefaultMix?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UriDefaultMixUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UriDefaultMix>(
      id,
      columnValues: columnValues(UriDefaultMix.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UriDefaultMix]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UriDefaultMix>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UriDefaultMixUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UriDefaultMixTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UriDefaultMixTable>? orderBy,
    _i1.OrderByListBuilder<UriDefaultMixTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UriDefaultMix>(
      columnValues: columnValues(UriDefaultMix.t.updateTable),
      where: where(UriDefaultMix.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UriDefaultMix.t),
      orderByList: orderByList?.call(UriDefaultMix.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UriDefaultMix]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UriDefaultMix>> delete(
    _i1.Session session,
    List<UriDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UriDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UriDefaultMix].
  Future<UriDefaultMix> deleteRow(
    _i1.Session session,
    UriDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UriDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UriDefaultMix>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UriDefaultMixTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UriDefaultMix>(
      where: where(UriDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UriDefaultMixTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UriDefaultMix>(
      where: where?.call(UriDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

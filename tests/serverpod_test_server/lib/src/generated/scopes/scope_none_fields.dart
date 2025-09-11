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
import '../simple_data.dart' as _i2;

abstract class ScopeNoneFields
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ScopeNoneFields._({this.id})
      : _name = null,
        _object = null;

  factory ScopeNoneFields({int? id}) = _ScopeNoneFieldsImpl;

  factory ScopeNoneFields.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScopeNoneFieldsImplicit._(
      id: jsonSerialization['id'] as int?,
      $name: jsonSerialization['name'] as String?,
      $object: jsonSerialization['object'] == null
          ? null
          : _i2.SimpleData.fromJson(
              (jsonSerialization['object'] as Map<String, dynamic>)),
    );
  }

  static final t = ScopeNoneFieldsTable();

  static const db = ScopeNoneFieldsRepository._();

  @override
  int? id;

  final String? _name;

  final _i2.SimpleData? _object;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ScopeNoneFields]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScopeNoneFields copyWith({int? id});
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (_name != null) 'name': _name,
      if (_object != null) 'object': _object.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id};
  }

  static ScopeNoneFieldsInclude include() {
    return ScopeNoneFieldsInclude._();
  }

  static ScopeNoneFieldsIncludeList includeList({
    _i1.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    ScopeNoneFieldsInclude? include,
  }) {
    return ScopeNoneFieldsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ScopeNoneFields.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScopeNoneFieldsImpl extends ScopeNoneFields {
  _ScopeNoneFieldsImpl({int? id}) : super._(id: id);

  /// Returns a shallow copy of this [ScopeNoneFields]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScopeNoneFields copyWith({Object? id = _Undefined}) {
    return ScopeNoneFieldsImplicit._(
      id: id is int? ? id : this.id,
      $name: this._name,
      $object: this._object?.copyWith(),
    );
  }
}

class ScopeNoneFieldsImplicit extends _ScopeNoneFieldsImpl {
  ScopeNoneFieldsImplicit._({
    int? id,
    String? $name,
    _i2.SimpleData? $object,
  })  : _name = $name,
        _object = $object,
        super(id: id);

  factory ScopeNoneFieldsImplicit(
    ScopeNoneFields scopeNoneFields, {
    String? $name,
    _i2.SimpleData? $object,
  }) {
    return ScopeNoneFieldsImplicit._(
      id: scopeNoneFields.id,
      $name: $name,
      $object: $object,
    );
  }

  @override
  final String? _name;

  @override
  final _i2.SimpleData? _object;
}

class ScopeNoneFieldsUpdateTable extends _i1.UpdateTable<ScopeNoneFieldsTable> {
  ScopeNoneFieldsUpdateTable(super.table);

  _i1.ColumnValue<String, String> $name(String? value) => _i1.ColumnValue(
        table.$name,
        value,
      );

  _i1.ColumnValue<_i2.SimpleData, _i2.SimpleData> $object(
          _i2.SimpleData? value) =>
      _i1.ColumnValue(
        table.$object,
        value,
      );
}

class ScopeNoneFieldsTable extends _i1.Table<int?> {
  ScopeNoneFieldsTable({super.tableRelation})
      : super(tableName: 'scope_none_fields') {
    updateTable = ScopeNoneFieldsUpdateTable(this);
    $name = _i1.ColumnString(
      'name',
      this,
    );
    $object = _i1.ColumnSerializable<_i2.SimpleData>(
      'object',
      this,
    );
  }

  late final ScopeNoneFieldsUpdateTable updateTable;

  late final _i1.ColumnString $name;

  late final _i1.ColumnSerializable<_i2.SimpleData> $object;

  @override
  List<_i1.Column> get columns => [
        id,
        $name,
        $object,
      ];

  @override
  List<_i1.Column> get managedColumns => [id];
}

class ScopeNoneFieldsInclude extends _i1.IncludeObject {
  ScopeNoneFieldsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ScopeNoneFields.t;
}

class ScopeNoneFieldsIncludeList extends _i1.IncludeList {
  ScopeNoneFieldsIncludeList._({
    _i1.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScopeNoneFields.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ScopeNoneFields.t;
}

class ScopeNoneFieldsRepository {
  const ScopeNoneFieldsRepository._();

  /// Returns a list of [ScopeNoneFields]s matching the given query parameters.
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
  Future<List<ScopeNoneFields>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ScopeNoneFields>(
      where: where?.call(ScopeNoneFields.t),
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderByList: orderByList?.call(ScopeNoneFields.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ScopeNoneFields] matching the given query parameters.
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
  Future<ScopeNoneFields?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? offset,
    _i1.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ScopeNoneFields>(
      where: where?.call(ScopeNoneFields.t),
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderByList: orderByList?.call(ScopeNoneFields.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ScopeNoneFields] by its [id] or null if no such row exists.
  Future<ScopeNoneFields?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ScopeNoneFields>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ScopeNoneFields]s in the list and returns the inserted rows.
  ///
  /// The returned [ScopeNoneFields]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ScopeNoneFields>> insert(
    _i1.Session session,
    List<ScopeNoneFields> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ScopeNoneFields>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ScopeNoneFields] and returns the inserted row.
  ///
  /// The returned [ScopeNoneFields] will have its `id` field set.
  Future<ScopeNoneFields> insertRow(
    _i1.Session session,
    ScopeNoneFields row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScopeNoneFields>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ScopeNoneFields]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ScopeNoneFields>> update(
    _i1.Session session,
    List<ScopeNoneFields> rows, {
    _i1.ColumnSelections<ScopeNoneFieldsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ScopeNoneFields>(
      rows,
      columns: columns?.call(ScopeNoneFields.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScopeNoneFields]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScopeNoneFields> updateRow(
    _i1.Session session,
    ScopeNoneFields row, {
    _i1.ColumnSelections<ScopeNoneFieldsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScopeNoneFields>(
      row,
      columns: columns?.call(ScopeNoneFields.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScopeNoneFields] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ScopeNoneFields?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ScopeNoneFieldsUpdateTable>
        columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ScopeNoneFields>(
      id,
      columnValues: columnValues(ScopeNoneFields.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ScopeNoneFields]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ScopeNoneFields>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ScopeNoneFieldsUpdateTable>
        columnValues,
    required _i1.WhereExpressionBuilder<ScopeNoneFieldsTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    _i1.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ScopeNoneFields>(
      columnValues: columnValues(ScopeNoneFields.t.updateTable),
      where: where(ScopeNoneFields.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderByList: orderByList?.call(ScopeNoneFields.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ScopeNoneFields]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ScopeNoneFields>> delete(
    _i1.Session session,
    List<ScopeNoneFields> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ScopeNoneFields>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ScopeNoneFields].
  Future<ScopeNoneFields> deleteRow(
    _i1.Session session,
    ScopeNoneFields row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScopeNoneFields>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ScopeNoneFields>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ScopeNoneFieldsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ScopeNoneFields>(
      where: where(ScopeNoneFields.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ScopeNoneFields>(
      where: where?.call(ScopeNoneFields.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

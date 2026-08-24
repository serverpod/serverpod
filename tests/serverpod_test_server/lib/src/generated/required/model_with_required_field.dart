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
import 'package:serverpod/serverpod.dart' as _is;

abstract class ModelWithRequiredField
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ModelWithRequiredField._({
    this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory ModelWithRequiredField({
    int? id,
    required String name,
    required String? email,
    String? phone,
  }) = _ModelWithRequiredFieldImpl;

  factory ModelWithRequiredField.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ModelWithRequiredField(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
    );
  }

  static final t = ModelWithRequiredFieldTable();

  static const db = ModelWithRequiredFieldRepository._();

  @override
  int? id;

  String name;

  String? email;

  String? phone;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ModelWithRequiredField]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ModelWithRequiredField copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ModelWithRequiredField',
      if (id != null) 'id': id,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ModelWithRequiredField',
      if (id != null) 'id': id,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    };
  }

  static ModelWithRequiredFieldInclude include({
    _is.SelectColumnsBuilder<ModelWithRequiredFieldTable>? select,
  }) {
    return ModelWithRequiredFieldInclude.internal_(
      selectedColumns: select?.call(ModelWithRequiredField.t),
    );
  }

  static ModelWithRequiredFieldIncludeList includeList({
    _is.WhereExpressionBuilder<ModelWithRequiredFieldTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ModelWithRequiredFieldTable>? orderBy,
    _is.OrderByListBuilder<ModelWithRequiredFieldTable>? orderByList,
    ModelWithRequiredFieldInclude? include,
    _is.SelectColumnsBuilder<ModelWithRequiredFieldTable>? select,
  }) {
    return ModelWithRequiredFieldIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ModelWithRequiredField.t),
      orderByList: orderByList?.call(ModelWithRequiredField.t),
      include: include,
      selectedColumns: select?.call(ModelWithRequiredField.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ModelWithRequiredFieldImpl extends ModelWithRequiredField {
  _ModelWithRequiredFieldImpl({
    int? id,
    required String name,
    required String? email,
    String? phone,
  }) : super._(
         id: id,
         name: name,
         email: email,
         phone: phone,
       );

  /// Returns a shallow copy of this [ModelWithRequiredField]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ModelWithRequiredField copyWith({
    Object? id = _Undefined,
    String? name,
    Object? email = _Undefined,
    Object? phone = _Undefined,
  }) {
    return ModelWithRequiredField(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
    );
  }
}

class ModelWithRequiredFieldUpdateTable
    extends _is.UpdateTable<ModelWithRequiredFieldTable> {
  ModelWithRequiredFieldUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> email(String? value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> phone(String? value) => _is.ColumnValue(
    table.phone,
    value,
  );
}

class ModelWithRequiredFieldTable extends _is.Table<int?> {
  ModelWithRequiredFieldTable({super.tableRelation})
    : super(tableName: 'model_with_required_field') {
    updateTable = ModelWithRequiredFieldUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    phone = _is.ColumnString(
      'phone',
      this,
    );
  }

  late final ModelWithRequiredFieldUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString email;

  late final _is.ColumnString phone;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    email,
    phone,
  ];
}

class ModelWithRequiredFieldInclude extends _is.IncludeObject {
  ModelWithRequiredFieldInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ModelWithRequiredField.t;
}

class ModelWithRequiredFieldIncludeList extends _is.IncludeList {
  ModelWithRequiredFieldIncludeList.internal_({
    _is.WhereExpressionBuilder<ModelWithRequiredFieldTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ModelWithRequiredField.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ModelWithRequiredField.t;
}

class ModelWithRequiredFieldRepository {
  const ModelWithRequiredFieldRepository._();

  /// Returns a list of [ModelWithRequiredField]s matching the given query parameters.
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
  Future<List<ModelWithRequiredField>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ModelWithRequiredFieldTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ModelWithRequiredFieldTable>? orderBy,
    _is.OrderByListBuilder<ModelWithRequiredFieldTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ModelWithRequiredField>(
      where: where?.call(ModelWithRequiredField.t),
      orderBy: orderBy?.call(ModelWithRequiredField.t),
      orderByList: orderByList?.call(ModelWithRequiredField.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ModelWithRequiredField] matching the given query parameters.
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
  Future<ModelWithRequiredField?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ModelWithRequiredFieldTable>? where,
    int? offset,
    _is.OrderByBuilder<ModelWithRequiredFieldTable>? orderBy,
    _is.OrderByListBuilder<ModelWithRequiredFieldTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ModelWithRequiredField>(
      where: where?.call(ModelWithRequiredField.t),
      orderBy: orderBy?.call(ModelWithRequiredField.t),
      orderByList: orderByList?.call(ModelWithRequiredField.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ModelWithRequiredField] by its [id] or null if no such row exists.
  Future<ModelWithRequiredField?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ModelWithRequiredField>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ModelWithRequiredField]s in the list and returns the inserted rows.
  ///
  /// The returned [ModelWithRequiredField]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ModelWithRequiredField>> insert(
    _is.DatabaseSession session,
    List<ModelWithRequiredField> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ModelWithRequiredField>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ModelWithRequiredField] and returns the inserted row.
  ///
  /// The returned [ModelWithRequiredField] will have its `id` field set.
  Future<ModelWithRequiredField> insertRow(
    _is.DatabaseSession session,
    ModelWithRequiredField row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ModelWithRequiredField>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ModelWithRequiredField]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [ModelWithRequiredField]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ModelWithRequiredField>> upsert(
    _is.DatabaseSession session,
    List<ModelWithRequiredField> rows, {
    required _is.ColumnSelections<ModelWithRequiredFieldTable> conflictColumns,
    _is.ColumnSelections<ModelWithRequiredFieldTable>? updateColumns,
    _is.WhereExpressionBuilder<ModelWithRequiredFieldTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ModelWithRequiredField>(
      rows,
      conflictColumns: conflictColumns(ModelWithRequiredField.t),
      updateColumns: updateColumns?.call(ModelWithRequiredField.t),
      updateWhere: updateWhere?.call(ModelWithRequiredField.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ModelWithRequiredField] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [ModelWithRequiredField] will have its `id` field set.
  Future<ModelWithRequiredField?> upsertRow(
    _is.DatabaseSession session,
    ModelWithRequiredField row, {
    required _is.ColumnSelections<ModelWithRequiredFieldTable> conflictColumns,
    _is.ColumnSelections<ModelWithRequiredFieldTable>? updateColumns,
    _is.WhereExpressionBuilder<ModelWithRequiredFieldTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ModelWithRequiredField>(
      row,
      conflictColumns: conflictColumns(ModelWithRequiredField.t),
      updateColumns: updateColumns?.call(ModelWithRequiredField.t),
      updateWhere: updateWhere?.call(ModelWithRequiredField.t),
      transaction: transaction,
    );
  }

  /// Updates all [ModelWithRequiredField]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ModelWithRequiredField>> update(
    _is.DatabaseSession session,
    List<ModelWithRequiredField> rows, {
    _is.ColumnSelections<ModelWithRequiredFieldTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ModelWithRequiredField>(
      rows,
      columns: columns?.call(ModelWithRequiredField.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ModelWithRequiredField]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ModelWithRequiredField> updateRow(
    _is.DatabaseSession session,
    ModelWithRequiredField row, {
    _is.ColumnSelections<ModelWithRequiredFieldTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ModelWithRequiredField>(
      row,
      columns: columns?.call(ModelWithRequiredField.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ModelWithRequiredField] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ModelWithRequiredField?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ModelWithRequiredFieldUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ModelWithRequiredField>(
      id,
      columnValues: columnValues(ModelWithRequiredField.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ModelWithRequiredField]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ModelWithRequiredField>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ModelWithRequiredFieldUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ModelWithRequiredFieldTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ModelWithRequiredFieldTable>? orderBy,
    _is.OrderByListBuilder<ModelWithRequiredFieldTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ModelWithRequiredField>(
      columnValues: columnValues(ModelWithRequiredField.t.updateTable),
      where: where(ModelWithRequiredField.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ModelWithRequiredField.t),
      orderByList: orderByList?.call(ModelWithRequiredField.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ModelWithRequiredField]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ModelWithRequiredField>> delete(
    _is.DatabaseSession session,
    List<ModelWithRequiredField> rows, {
    _is.OrderByBuilder<ModelWithRequiredFieldTable>? orderBy,
    _is.OrderByListBuilder<ModelWithRequiredFieldTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ModelWithRequiredField>(
      rows,
      orderBy: orderBy?.call(ModelWithRequiredField.t),
      orderByList: orderByList?.call(ModelWithRequiredField.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ModelWithRequiredField].
  Future<ModelWithRequiredField> deleteRow(
    _is.DatabaseSession session,
    ModelWithRequiredField row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ModelWithRequiredField>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ModelWithRequiredField>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ModelWithRequiredFieldTable> where,
    _is.OrderByBuilder<ModelWithRequiredFieldTable>? orderBy,
    _is.OrderByListBuilder<ModelWithRequiredFieldTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ModelWithRequiredField>(
      where: where(ModelWithRequiredField.t),
      orderBy: orderBy?.call(ModelWithRequiredField.t),
      orderByList: orderByList?.call(ModelWithRequiredField.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ModelWithRequiredFieldTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ModelWithRequiredField>(
      where: where?.call(ModelWithRequiredField.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ModelWithRequiredField] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ModelWithRequiredFieldTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ModelWithRequiredField>(
      where: where(ModelWithRequiredField.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

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

abstract class ModelWithRequiredField
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ModelWithRequiredField]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ModelWithRequiredField copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    };
  }

  static ModelWithRequiredFieldInclude include() {
    return ModelWithRequiredFieldInclude._();
  }

  static ModelWithRequiredFieldIncludeList includeList({
    _i1.WhereExpressionBuilder<ModelWithRequiredFieldTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ModelWithRequiredFieldTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ModelWithRequiredFieldTable>? orderByList,
    ModelWithRequiredFieldInclude? include,
  }) {
    return ModelWithRequiredFieldIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ModelWithRequiredField.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ModelWithRequiredField.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
  @_i1.useResult
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
    extends _i1.UpdateTable<ModelWithRequiredFieldTable> {
  ModelWithRequiredFieldUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> email(String? value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> phone(String? value) => _i1.ColumnValue(
    table.phone,
    value,
  );
}

class ModelWithRequiredFieldTable extends _i1.Table<int?> {
  ModelWithRequiredFieldTable({super.tableRelation})
    : super(tableName: 'model_with_required_field') {
    updateTable = ModelWithRequiredFieldUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    phone = _i1.ColumnString(
      'phone',
      this,
    );
  }

  late final ModelWithRequiredFieldUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString email;

  late final _i1.ColumnString phone;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    email,
    phone,
  ];
}

class ModelWithRequiredFieldInclude extends _i1.IncludeObject {
  ModelWithRequiredFieldInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ModelWithRequiredField.t;
}

class ModelWithRequiredFieldIncludeList extends _i1.IncludeList {
  ModelWithRequiredFieldIncludeList._({
    _i1.WhereExpressionBuilder<ModelWithRequiredFieldTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ModelWithRequiredField.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ModelWithRequiredField.t;
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ModelWithRequiredFieldTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ModelWithRequiredFieldTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ModelWithRequiredFieldTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ModelWithRequiredField>(
      where: where?.call(ModelWithRequiredField.t),
      orderBy: orderBy?.call(ModelWithRequiredField.t),
      orderByList: orderByList?.call(ModelWithRequiredField.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ModelWithRequiredFieldTable>? where,
    int? offset,
    _i1.OrderByBuilder<ModelWithRequiredFieldTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ModelWithRequiredFieldTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ModelWithRequiredField>(
      where: where?.call(ModelWithRequiredField.t),
      orderBy: orderBy?.call(ModelWithRequiredField.t),
      orderByList: orderByList?.call(ModelWithRequiredField.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ModelWithRequiredField] by its [id] or null if no such row exists.
  Future<ModelWithRequiredField?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ModelWithRequiredField>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ModelWithRequiredField]s in the list and returns the inserted rows.
  ///
  /// The returned [ModelWithRequiredField]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ModelWithRequiredField>> insert(
    _i1.Session session,
    List<ModelWithRequiredField> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ModelWithRequiredField>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ModelWithRequiredField] and returns the inserted row.
  ///
  /// The returned [ModelWithRequiredField] will have its `id` field set.
  Future<ModelWithRequiredField> insertRow(
    _i1.Session session,
    ModelWithRequiredField row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ModelWithRequiredField>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ModelWithRequiredField]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ModelWithRequiredField>> update(
    _i1.Session session,
    List<ModelWithRequiredField> rows, {
    _i1.ColumnSelections<ModelWithRequiredFieldTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ModelWithRequiredField>(
      rows,
      columns: columns?.call(ModelWithRequiredField.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ModelWithRequiredField]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ModelWithRequiredField> updateRow(
    _i1.Session session,
    ModelWithRequiredField row, {
    _i1.ColumnSelections<ModelWithRequiredFieldTable>? columns,
    _i1.Transaction? transaction,
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
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ModelWithRequiredFieldUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ModelWithRequiredField>(
      id,
      columnValues: columnValues(ModelWithRequiredField.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ModelWithRequiredField]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ModelWithRequiredField>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ModelWithRequiredFieldUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ModelWithRequiredFieldTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ModelWithRequiredFieldTable>? orderBy,
    _i1.OrderByListBuilder<ModelWithRequiredFieldTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ModelWithRequiredField>(
      columnValues: columnValues(ModelWithRequiredField.t.updateTable),
      where: where(ModelWithRequiredField.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ModelWithRequiredField.t),
      orderByList: orderByList?.call(ModelWithRequiredField.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ModelWithRequiredField]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ModelWithRequiredField>> delete(
    _i1.Session session,
    List<ModelWithRequiredField> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ModelWithRequiredField>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ModelWithRequiredField].
  Future<ModelWithRequiredField> deleteRow(
    _i1.Session session,
    ModelWithRequiredField row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ModelWithRequiredField>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ModelWithRequiredField>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ModelWithRequiredFieldTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ModelWithRequiredField>(
      where: where(ModelWithRequiredField.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ModelWithRequiredFieldTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ModelWithRequiredField>(
      where: where?.call(ModelWithRequiredField.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

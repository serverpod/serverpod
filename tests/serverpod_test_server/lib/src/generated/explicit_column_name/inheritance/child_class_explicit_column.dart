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
import '../../protocol.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;

abstract class ChildClassExplicitColumn extends _i1.NonTableParentClass
    implements _i2.TableRow<int?>, _i2.ProtocolSerialization {
  ChildClassExplicitColumn._({
    this.id,
    required super.nonTableParentField,
    required this.childField,
  });

  factory ChildClassExplicitColumn({
    int? id,
    required String nonTableParentField,
    required String childField,
  }) = _ChildClassExplicitColumnImpl;

  factory ChildClassExplicitColumn.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ChildClassExplicitColumn(
      id: jsonSerialization['id'] as int?,
      nonTableParentField: jsonSerialization['nonTableParentField'] as String,
      childField: jsonSerialization['childField'] as String,
    );
  }

  static final t = ChildClassExplicitColumnTable();

  static const db = ChildClassExplicitColumnRepository._();

  @override
  int? id;

  String childField;

  @override
  _i2.Table<int?> get table => t;

  /// Returns a shallow copy of this [ChildClassExplicitColumn]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  ChildClassExplicitColumn copyWith({
    int? id,
    String? nonTableParentField,
    String? childField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChildClassExplicitColumn',
      if (id != null) 'id': id,
      'nonTableParentField': nonTableParentField,
      'childField': childField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChildClassExplicitColumn',
      if (id != null) 'id': id,
      'nonTableParentField': nonTableParentField,
      'childField': childField,
    };
  }

  static ChildClassExplicitColumnInclude include() {
    return ChildClassExplicitColumnInclude._();
  }

  static ChildClassExplicitColumnIncludeList includeList({
    _i2.WhereExpressionBuilder<ChildClassExplicitColumnTable>? where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<ChildClassExplicitColumnTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ChildClassExplicitColumnTable>? orderByList,
    ChildClassExplicitColumnInclude? include,
  }) {
    return ChildClassExplicitColumnIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildClassExplicitColumn.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ChildClassExplicitColumn.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildClassExplicitColumnImpl extends ChildClassExplicitColumn {
  _ChildClassExplicitColumnImpl({
    int? id,
    required String nonTableParentField,
    required String childField,
  }) : super._(
         id: id,
         nonTableParentField: nonTableParentField,
         childField: childField,
       );

  /// Returns a shallow copy of this [ChildClassExplicitColumn]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ChildClassExplicitColumn copyWith({
    Object? id = _Undefined,
    String? nonTableParentField,
    String? childField,
  }) {
    return ChildClassExplicitColumn(
      id: id is int? ? id : this.id,
      nonTableParentField: nonTableParentField ?? this.nonTableParentField,
      childField: childField ?? this.childField,
    );
  }
}

class ChildClassExplicitColumnUpdateTable
    extends _i2.UpdateTable<ChildClassExplicitColumnTable> {
  ChildClassExplicitColumnUpdateTable(super.table);

  _i2.ColumnValue<String, String> nonTableParentField(String value) =>
      _i2.ColumnValue(
        table.nonTableParentField,
        value,
      );

  _i2.ColumnValue<String, String> childField(String value) => _i2.ColumnValue(
    table.childField,
    value,
  );
}

class ChildClassExplicitColumnTable extends _i2.Table<int?> {
  ChildClassExplicitColumnTable({super.tableRelation})
    : super(tableName: 'child_table_explicit_column') {
    updateTable = ChildClassExplicitColumnUpdateTable(this);
    nonTableParentField = _i2.ColumnString(
      'non_table_parent_field',
      this,
      fieldName: 'nonTableParentField',
    );
    childField = _i2.ColumnString(
      'child_field',
      this,
      fieldName: 'childField',
    );
  }

  late final ChildClassExplicitColumnUpdateTable updateTable;

  late final _i2.ColumnString nonTableParentField;

  late final _i2.ColumnString childField;

  @override
  List<_i2.Column> get columns => [
    id,
    nonTableParentField,
    childField,
  ];
}

class ChildClassExplicitColumnInclude extends _i2.IncludeObject {
  ChildClassExplicitColumnInclude._();

  @override
  Map<String, _i2.Include?> get includes => {};

  @override
  _i2.Table<int?> get table => ChildClassExplicitColumn.t;
}

class ChildClassExplicitColumnIncludeList extends _i2.IncludeList {
  ChildClassExplicitColumnIncludeList._({
    _i2.WhereExpressionBuilder<ChildClassExplicitColumnTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChildClassExplicitColumn.t);
  }

  @override
  Map<String, _i2.Include?> get includes => include?.includes ?? {};

  @override
  _i2.Table<int?> get table => ChildClassExplicitColumn.t;
}

class ChildClassExplicitColumnRepository {
  const ChildClassExplicitColumnRepository._();

  /// Returns a list of [ChildClassExplicitColumn]s matching the given query parameters.
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
  Future<List<ChildClassExplicitColumn>> find(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ChildClassExplicitColumnTable>? where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<ChildClassExplicitColumnTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ChildClassExplicitColumnTable>? orderByList,
    _i2.Transaction? transaction,
  }) async {
    return session.db.find<ChildClassExplicitColumn>(
      where: where?.call(ChildClassExplicitColumn.t),
      orderBy: orderBy?.call(ChildClassExplicitColumn.t),
      orderByList: orderByList?.call(ChildClassExplicitColumn.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ChildClassExplicitColumn] matching the given query parameters.
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
  Future<ChildClassExplicitColumn?> findFirstRow(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ChildClassExplicitColumnTable>? where,
    int? offset,
    _i2.OrderByBuilder<ChildClassExplicitColumnTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ChildClassExplicitColumnTable>? orderByList,
    _i2.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ChildClassExplicitColumn>(
      where: where?.call(ChildClassExplicitColumn.t),
      orderBy: orderBy?.call(ChildClassExplicitColumn.t),
      orderByList: orderByList?.call(ChildClassExplicitColumn.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ChildClassExplicitColumn] by its [id] or null if no such row exists.
  Future<ChildClassExplicitColumn?> findById(
    _i2.Session session,
    int id, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.findById<ChildClassExplicitColumn>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ChildClassExplicitColumn]s in the list and returns the inserted rows.
  ///
  /// The returned [ChildClassExplicitColumn]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ChildClassExplicitColumn>> insert(
    _i2.Session session,
    List<ChildClassExplicitColumn> rows, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.insert<ChildClassExplicitColumn>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ChildClassExplicitColumn] and returns the inserted row.
  ///
  /// The returned [ChildClassExplicitColumn] will have its `id` field set.
  Future<ChildClassExplicitColumn> insertRow(
    _i2.Session session,
    ChildClassExplicitColumn row, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChildClassExplicitColumn>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ChildClassExplicitColumn]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ChildClassExplicitColumn>> update(
    _i2.Session session,
    List<ChildClassExplicitColumn> rows, {
    _i2.ColumnSelections<ChildClassExplicitColumnTable>? columns,
    _i2.Transaction? transaction,
  }) async {
    return session.db.update<ChildClassExplicitColumn>(
      rows,
      columns: columns?.call(ChildClassExplicitColumn.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChildClassExplicitColumn]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChildClassExplicitColumn> updateRow(
    _i2.Session session,
    ChildClassExplicitColumn row, {
    _i2.ColumnSelections<ChildClassExplicitColumnTable>? columns,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChildClassExplicitColumn>(
      row,
      columns: columns?.call(ChildClassExplicitColumn.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChildClassExplicitColumn] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChildClassExplicitColumn?> updateById(
    _i2.Session session,
    int id, {
    required _i2.ColumnValueListBuilder<ChildClassExplicitColumnUpdateTable>
    columnValues,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateById<ChildClassExplicitColumn>(
      id,
      columnValues: columnValues(ChildClassExplicitColumn.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChildClassExplicitColumn]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ChildClassExplicitColumn>> updateWhere(
    _i2.Session session, {
    required _i2.ColumnValueListBuilder<ChildClassExplicitColumnUpdateTable>
    columnValues,
    required _i2.WhereExpressionBuilder<ChildClassExplicitColumnTable> where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<ChildClassExplicitColumnTable>? orderBy,
    _i2.OrderByListBuilder<ChildClassExplicitColumnTable>? orderByList,
    bool orderDescending = false,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ChildClassExplicitColumn>(
      columnValues: columnValues(ChildClassExplicitColumn.t.updateTable),
      where: where(ChildClassExplicitColumn.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildClassExplicitColumn.t),
      orderByList: orderByList?.call(ChildClassExplicitColumn.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ChildClassExplicitColumn]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ChildClassExplicitColumn>> delete(
    _i2.Session session,
    List<ChildClassExplicitColumn> rows, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.delete<ChildClassExplicitColumn>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ChildClassExplicitColumn].
  Future<ChildClassExplicitColumn> deleteRow(
    _i2.Session session,
    ChildClassExplicitColumn row, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChildClassExplicitColumn>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ChildClassExplicitColumn>> deleteWhere(
    _i2.Session session, {
    required _i2.WhereExpressionBuilder<ChildClassExplicitColumnTable> where,
    _i2.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ChildClassExplicitColumn>(
      where: where(ChildClassExplicitColumn.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ChildClassExplicitColumnTable>? where,
    int? limit,
    _i2.Transaction? transaction,
  }) async {
    return session.db.count<ChildClassExplicitColumn>(
      where: where?.call(ChildClassExplicitColumn.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

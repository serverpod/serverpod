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
import '../protocol.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;

abstract class ChildClassWithoutId extends _i1.ParentClassWithoutId
    implements _i2.TableRow<_i2.UuidValue?>, _i2.ProtocolSerialization {
  ChildClassWithoutId._({
    this.id,
    required super.grandParentField,
    required super.parentField,
    required this.childField,
  });

  factory ChildClassWithoutId({
    _i2.UuidValue? id,
    required String grandParentField,
    required String parentField,
    required String childField,
  }) = _ChildClassWithoutIdImpl;

  factory ChildClassWithoutId.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChildClassWithoutId(
      id: jsonSerialization['id'] == null
          ? null
          : _i2.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      grandParentField: jsonSerialization['grandParentField'] as String,
      parentField: jsonSerialization['parentField'] as String,
      childField: jsonSerialization['childField'] as String,
    );
  }

  static final t = ChildClassWithoutIdTable();

  static const db = ChildClassWithoutIdRepository._();

  @override
  _i2.UuidValue? id;

  String childField;

  @override
  _i2.Table<_i2.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ChildClassWithoutId]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  ChildClassWithoutId copyWith({
    Object? id,
    String? grandParentField,
    String? parentField,
    String? childField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'grandParentField': grandParentField,
      'parentField': parentField,
      'childField': childField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id?.toJson(),
      'grandParentField': grandParentField,
      'parentField': parentField,
      'childField': childField,
    };
  }

  static ChildClassWithoutIdInclude include() {
    return ChildClassWithoutIdInclude._();
  }

  static ChildClassWithoutIdIncludeList includeList({
    _i2.WhereExpressionBuilder<ChildClassWithoutIdTable>? where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<ChildClassWithoutIdTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ChildClassWithoutIdTable>? orderByList,
    ChildClassWithoutIdInclude? include,
  }) {
    return ChildClassWithoutIdIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildClassWithoutId.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ChildClassWithoutId.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildClassWithoutIdImpl extends ChildClassWithoutId {
  _ChildClassWithoutIdImpl({
    _i2.UuidValue? id,
    required String grandParentField,
    required String parentField,
    required String childField,
  }) : super._(
          id: id,
          grandParentField: grandParentField,
          parentField: parentField,
          childField: childField,
        );

  /// Returns a shallow copy of this [ChildClassWithoutId]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ChildClassWithoutId copyWith({
    Object? id = _Undefined,
    String? grandParentField,
    String? parentField,
    String? childField,
  }) {
    return ChildClassWithoutId(
      id: id is _i2.UuidValue? ? id : this.id,
      grandParentField: grandParentField ?? this.grandParentField,
      parentField: parentField ?? this.parentField,
      childField: childField ?? this.childField,
    );
  }
}

class ChildClassWithoutIdUpdateTable
    extends _i2.UpdateTable<ChildClassWithoutIdTable> {
  ChildClassWithoutIdUpdateTable(super.table);

  _i2.ColumnValue<String, String> grandParentField(String value) =>
      _i2.ColumnValue(
        table.grandParentField,
        value,
      );

  _i2.ColumnValue<String, String> parentField(String value) => _i2.ColumnValue(
        table.parentField,
        value,
      );

  _i2.ColumnValue<String, String> childField(String value) => _i2.ColumnValue(
        table.childField,
        value,
      );
}

class ChildClassWithoutIdTable extends _i2.Table<_i2.UuidValue?> {
  ChildClassWithoutIdTable({super.tableRelation})
      : super(tableName: 'child_table_with_inherited_id') {
    updateTable = ChildClassWithoutIdUpdateTable(this);
    grandParentField = _i2.ColumnString(
      'grandParentField',
      this,
    );
    parentField = _i2.ColumnString(
      'parentField',
      this,
    );
    childField = _i2.ColumnString(
      'childField',
      this,
    );
  }

  late final ChildClassWithoutIdUpdateTable updateTable;

  late final _i2.ColumnString grandParentField;

  late final _i2.ColumnString parentField;

  late final _i2.ColumnString childField;

  @override
  List<_i2.Column> get columns => [
        id,
        grandParentField,
        parentField,
        childField,
      ];
}

class ChildClassWithoutIdInclude extends _i2.IncludeObject {
  ChildClassWithoutIdInclude._();

  @override
  Map<String, _i2.Include?> get includes => {};

  @override
  _i2.Table<_i2.UuidValue?> get table => ChildClassWithoutId.t;
}

class ChildClassWithoutIdIncludeList extends _i2.IncludeList {
  ChildClassWithoutIdIncludeList._({
    _i2.WhereExpressionBuilder<ChildClassWithoutIdTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChildClassWithoutId.t);
  }

  @override
  Map<String, _i2.Include?> get includes => include?.includes ?? {};

  @override
  _i2.Table<_i2.UuidValue?> get table => ChildClassWithoutId.t;
}

class ChildClassWithoutIdRepository {
  const ChildClassWithoutIdRepository._();

  /// Returns a list of [ChildClassWithoutId]s matching the given query parameters.
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
  Future<List<ChildClassWithoutId>> find(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ChildClassWithoutIdTable>? where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<ChildClassWithoutIdTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ChildClassWithoutIdTable>? orderByList,
    _i2.Transaction? transaction,
  }) async {
    return session.db.find<ChildClassWithoutId>(
      where: where?.call(ChildClassWithoutId.t),
      orderBy: orderBy?.call(ChildClassWithoutId.t),
      orderByList: orderByList?.call(ChildClassWithoutId.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ChildClassWithoutId] matching the given query parameters.
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
  Future<ChildClassWithoutId?> findFirstRow(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ChildClassWithoutIdTable>? where,
    int? offset,
    _i2.OrderByBuilder<ChildClassWithoutIdTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ChildClassWithoutIdTable>? orderByList,
    _i2.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ChildClassWithoutId>(
      where: where?.call(ChildClassWithoutId.t),
      orderBy: orderBy?.call(ChildClassWithoutId.t),
      orderByList: orderByList?.call(ChildClassWithoutId.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ChildClassWithoutId] by its [id] or null if no such row exists.
  Future<ChildClassWithoutId?> findById(
    _i2.Session session,
    _i2.UuidValue id, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.findById<ChildClassWithoutId>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ChildClassWithoutId]s in the list and returns the inserted rows.
  ///
  /// The returned [ChildClassWithoutId]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ChildClassWithoutId>> insert(
    _i2.Session session,
    List<ChildClassWithoutId> rows, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.insert<ChildClassWithoutId>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ChildClassWithoutId] and returns the inserted row.
  ///
  /// The returned [ChildClassWithoutId] will have its `id` field set.
  Future<ChildClassWithoutId> insertRow(
    _i2.Session session,
    ChildClassWithoutId row, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChildClassWithoutId>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ChildClassWithoutId]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ChildClassWithoutId>> update(
    _i2.Session session,
    List<ChildClassWithoutId> rows, {
    _i2.ColumnSelections<ChildClassWithoutIdTable>? columns,
    _i2.Transaction? transaction,
  }) async {
    return session.db.update<ChildClassWithoutId>(
      rows,
      columns: columns?.call(ChildClassWithoutId.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChildClassWithoutId]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChildClassWithoutId> updateRow(
    _i2.Session session,
    ChildClassWithoutId row, {
    _i2.ColumnSelections<ChildClassWithoutIdTable>? columns,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChildClassWithoutId>(
      row,
      columns: columns?.call(ChildClassWithoutId.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChildClassWithoutId] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChildClassWithoutId?> updateById(
    _i2.Session session,
    _i2.UuidValue id, {
    required _i2.ColumnValueListBuilder<ChildClassWithoutIdUpdateTable>
        columnValues,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateById<ChildClassWithoutId>(
      id,
      columnValues: columnValues(ChildClassWithoutId.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChildClassWithoutId]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ChildClassWithoutId>> updateWhere(
    _i2.Session session, {
    required _i2.ColumnValueListBuilder<ChildClassWithoutIdUpdateTable>
        columnValues,
    required _i2.WhereExpressionBuilder<ChildClassWithoutIdTable> where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<ChildClassWithoutIdTable>? orderBy,
    _i2.OrderByListBuilder<ChildClassWithoutIdTable>? orderByList,
    bool orderDescending = false,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ChildClassWithoutId>(
      columnValues: columnValues(ChildClassWithoutId.t.updateTable),
      where: where(ChildClassWithoutId.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildClassWithoutId.t),
      orderByList: orderByList?.call(ChildClassWithoutId.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ChildClassWithoutId]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ChildClassWithoutId>> delete(
    _i2.Session session,
    List<ChildClassWithoutId> rows, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.delete<ChildClassWithoutId>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ChildClassWithoutId].
  Future<ChildClassWithoutId> deleteRow(
    _i2.Session session,
    ChildClassWithoutId row, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChildClassWithoutId>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ChildClassWithoutId>> deleteWhere(
    _i2.Session session, {
    required _i2.WhereExpressionBuilder<ChildClassWithoutIdTable> where,
    _i2.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ChildClassWithoutId>(
      where: where(ChildClassWithoutId.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ChildClassWithoutIdTable>? where,
    int? limit,
    _i2.Transaction? transaction,
  }) async {
    return session.db.count<ChildClassWithoutId>(
      where: where?.call(ChildClassWithoutId.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

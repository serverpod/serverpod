/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'projected_address.dart' as _i2;
import 'projected_order.dart' as _i3;
import 'projected_json_field.dart' as _i4;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i5;
import 'package:meta/meta.dart' as _i6;

abstract class ProjectedUser
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ProjectedUser._({
    this.id,
    required this.name,
    required this.addressId,
    this.address,
    this.orders,
    this.jsonField,
  });

  factory ProjectedUser({
    int? id,
    required String name,
    required int addressId,
    _i2.ProjectedAddress? address,
    List<_i3.ProjectedOrder>? orders,
    _i4.ProjectedJsonField? jsonField,
  }) = _ProjectedUserImpl;

  factory ProjectedUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedUser(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      addressId: jsonSerialization['addressId'] as int,
      address: jsonSerialization['address'] == null
          ? null
          : _i5.Protocol().deserialize<_i2.ProjectedAddress>(
              jsonSerialization['address'],
            ),
      orders: jsonSerialization['orders'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i3.ProjectedOrder>>(
              jsonSerialization['orders'],
            ),
      jsonField: jsonSerialization['jsonField'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.ProjectedJsonField>(
              jsonSerialization['jsonField'],
            ),
    );
  }

  static final t = ProjectedUserTable();

  static const db = ProjectedUserRepository._();

  @override
  int? id;

  String name;

  int addressId;

  _i2.ProjectedAddress? address;

  List<_i3.ProjectedOrder>? orders;

  _i4.ProjectedJsonField? jsonField;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ProjectedUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedUser copyWith({
    int? id,
    String? name,
    int? addressId,
    _i2.ProjectedAddress? address,
    List<_i3.ProjectedOrder>? orders,
    _i4.ProjectedJsonField? jsonField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUser',
      if (id != null) 'id': id,
      'name': name,
      'addressId': addressId,
      if (address != null) 'address': address?.toJson(),
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJson()),
      if (jsonField != null) 'jsonField': jsonField?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUser',
      if (id != null) 'id': id,
      'name': name,
      'addressId': addressId,
      if (address != null) 'address': address?.toJsonForProtocol(),
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (jsonField != null) 'jsonField': jsonField?.toJsonForProtocol(),
    };
  }

  static ProjectedUserInclude include({
    _i2.ProjectedAddressInclude? address,
    _i3.ProjectedOrderIncludeList? orders,
  }) {
    return ProjectedUserInclude.internal_(
      address: address,
      orders: orders,
    );
  }

  static ProjectedUserIncludeList includeList({
    _i1.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedUserTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedUserTable>? orderByList,
    ProjectedUserInclude? include,
  }) {
    return ProjectedUserIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedUser.t),
      orderByList: orderByList?.call(ProjectedUser.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserImpl extends ProjectedUser {
  _ProjectedUserImpl({
    int? id,
    required String name,
    required int addressId,
    _i2.ProjectedAddress? address,
    List<_i3.ProjectedOrder>? orders,
    _i4.ProjectedJsonField? jsonField,
  }) : super._(
         id: id,
         name: name,
         addressId: addressId,
         address: address,
         orders: orders,
         jsonField: jsonField,
       );

  /// Returns a shallow copy of this [ProjectedUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedUser copyWith({
    Object? id = _Undefined,
    String? name,
    int? addressId,
    Object? address = _Undefined,
    Object? orders = _Undefined,
    Object? jsonField = _Undefined,
  }) {
    return ProjectedUser(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      addressId: addressId ?? this.addressId,
      address: address is _i2.ProjectedAddress?
          ? address
          : this.address?.copyWith(),
      orders: orders is List<_i3.ProjectedOrder>?
          ? orders
          : this.orders?.map((e0) => e0.copyWith()).toList(),
      jsonField: jsonField is _i4.ProjectedJsonField?
          ? jsonField
          : this.jsonField?.copyWith(),
    );
  }
}

class ProjectedUserUpdateTable extends _i1.UpdateTable<ProjectedUserTable> {
  ProjectedUserUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<int, int> addressId(int value) => _i1.ColumnValue(
    table.addressId,
    value,
  );

  _i1.ColumnValue<_i4.ProjectedJsonField, _i4.ProjectedJsonField> jsonField(
    _i4.ProjectedJsonField? value,
  ) => _i1.ColumnValue(
    table.jsonField,
    value,
  );
}

class ProjectedUserTable extends _i1.Table<int?> {
  ProjectedUserTable({super.tableRelation})
    : super(tableName: 'projected_user') {
    updateTable = ProjectedUserUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    addressId = _i1.ColumnInt(
      'addressId',
      this,
    );
    jsonField = _i1.ColumnSerializable<_i4.ProjectedJsonField>(
      'jsonField',
      this,
    );
  }

  late final ProjectedUserUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnInt addressId;

  _i2.ProjectedAddressTable? _address;

  _i3.ProjectedOrderTable? ___orders;

  _i1.ManyRelation<_i3.ProjectedOrderTable>? _orders;

  late final _i1.ColumnSerializable<_i4.ProjectedJsonField> jsonField;

  _i2.ProjectedAddressTable get address {
    if (_address != null) return _address!;
    _address = _i1.createRelationTable(
      relationFieldName: 'address',
      field: ProjectedUser.t.addressId,
      foreignField: _i2.ProjectedAddress.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ProjectedAddressTable(tableRelation: foreignTableRelation),
    );
    return _address!;
  }

  _i3.ProjectedOrderTable get __orders {
    if (___orders != null) return ___orders!;
    ___orders = _i1.createRelationTable(
      relationFieldName: '__orders',
      field: ProjectedUser.t.id,
      foreignField: _i3.ProjectedOrder.t.$_projectedUserOrdersProjectedUserId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ProjectedOrderTable(tableRelation: foreignTableRelation),
    );
    return ___orders!;
  }

  _i1.ManyRelation<_i3.ProjectedOrderTable> get orders {
    if (_orders != null) return _orders!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'orders',
      field: ProjectedUser.t.id,
      foreignField: _i3.ProjectedOrder.t.$_projectedUserOrdersProjectedUserId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ProjectedOrderTable(tableRelation: foreignTableRelation),
    );
    _orders = _i1.ManyRelation<_i3.ProjectedOrderTable>(
      tableWithRelations: relationTable,
      table: _i3.ProjectedOrderTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _orders!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    addressId,
    jsonField,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'address') {
      return address;
    }
    if (relationField == 'orders') {
      return __orders;
    }
    return null;
  }
}

class ProjectedUserInclude extends _i1.IncludeObject {
  @_i6.internal
  ProjectedUserInclude.internal_({
    _i2.ProjectedAddressInclude? address,
    _i3.ProjectedOrderIncludeList? orders,
    List<_i1.Column>? this.selectedColumns,
  }) {
    _address = address;
    _orders = orders;
  }

  _i2.ProjectedAddressInclude? _address;

  _i3.ProjectedOrderIncludeList? _orders;

  final List<_i1.Column>? selectedColumns;

  @override
  Map<String, _i1.Include?> get includes => {
    'address': _address,
    'orders': _orders,
  };

  @override
  _i1.Table<int?> get table => ProjectedUser.t;
}

class ProjectedUserIncludeList extends _i1.IncludeList {
  @_i6.internal
  ProjectedUserIncludeList.internal_({
    _i1.WhereExpressionBuilder<ProjectedUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    List<_i1.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(ProjectedUser.t);
  }

  final List<_i1.Column>? selectedColumns;

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ProjectedUser.t;
}

class ProjectedUserRepository {
  const ProjectedUserRepository._();

  final attach = const ProjectedUserAttachRepository._();

  final attachRow = const ProjectedUserAttachRowRepository._();

  final detach = const ProjectedUserDetachRepository._();

  final detachRow = const ProjectedUserDetachRowRepository._();

  /// Returns a list of [ProjectedUser]s matching the given query parameters.
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
  Future<List<ProjectedUser>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedUserTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _i1.Transaction? transaction,
    ProjectedUserInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProjectedUser>(
      where: where?.call(ProjectedUser.t),
      orderBy: orderBy?.call(ProjectedUser.t),
      orderByList: orderByList?.call(ProjectedUser.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProjectedUser] matching the given query parameters.
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
  Future<ProjectedUser?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProjectedUserTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _i1.Transaction? transaction,
    ProjectedUserInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProjectedUser>(
      where: where?.call(ProjectedUser.t),
      orderBy: orderBy?.call(ProjectedUser.t),
      orderByList: orderByList?.call(ProjectedUser.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProjectedUser] by its [id] or null if no such row exists.
  Future<ProjectedUser?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    ProjectedUserInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProjectedUser>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProjectedUser]s in the list and returns the inserted rows.
  ///
  /// The returned [ProjectedUser]s will have their `id` fields set.
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
  Future<List<ProjectedUser>> insert(
    _i1.DatabaseSession session,
    List<ProjectedUser> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProjectedUser>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProjectedUser] and returns the inserted row.
  ///
  /// The returned [ProjectedUser] will have its `id` field set.
  Future<ProjectedUser> insertRow(
    _i1.DatabaseSession session,
    ProjectedUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProjectedUser>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProjectedUser]s in the list and returns the resulting rows.
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
  /// The returned [ProjectedUser]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedUser>> upsert(
    _i1.DatabaseSession session,
    List<ProjectedUser> rows, {
    required _i1.ColumnSelections<ProjectedUserTable> conflictColumns,
    _i1.ColumnSelections<ProjectedUserTable>? updateColumns,
    _i1.WhereExpressionBuilder<ProjectedUserTable>? updateWhere,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProjectedUser>(
      rows,
      conflictColumns: conflictColumns(ProjectedUser.t),
      updateColumns: updateColumns?.call(ProjectedUser.t),
      updateWhere: updateWhere?.call(ProjectedUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProjectedUser] and returns the resulting row.
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
  /// The returned [ProjectedUser] will have its `id` field set.
  Future<ProjectedUser?> upsertRow(
    _i1.DatabaseSession session,
    ProjectedUser row, {
    required _i1.ColumnSelections<ProjectedUserTable> conflictColumns,
    _i1.ColumnSelections<ProjectedUserTable>? updateColumns,
    _i1.WhereExpressionBuilder<ProjectedUserTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProjectedUser>(
      row,
      conflictColumns: conflictColumns(ProjectedUser.t),
      updateColumns: updateColumns?.call(ProjectedUser.t),
      updateWhere: updateWhere?.call(ProjectedUser.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedUser]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedUser>> update(
    _i1.DatabaseSession session,
    List<ProjectedUser> rows, {
    _i1.ColumnSelections<ProjectedUserTable>? columns,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProjectedUser>(
      rows,
      columns: columns?.call(ProjectedUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProjectedUser]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProjectedUser> updateRow(
    _i1.DatabaseSession session,
    ProjectedUser row, {
    _i1.ColumnSelections<ProjectedUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProjectedUser>(
      row,
      columns: columns?.call(ProjectedUser.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectedUser] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProjectedUser?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ProjectedUserUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ProjectedUser>(
      id,
      columnValues: columnValues(ProjectedUser.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedUser]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedUser>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ProjectedUserUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ProjectedUserTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedUserTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProjectedUser>(
      columnValues: columnValues(ProjectedUser.t.updateTable),
      where: where(ProjectedUser.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedUser.t),
      orderByList: orderByList?.call(ProjectedUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProjectedUser]s in the list and returns the deleted rows.
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
  Future<List<ProjectedUser>> delete(
    _i1.DatabaseSession session,
    List<ProjectedUser> rows, {
    _i1.OrderByBuilder<ProjectedUserTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProjectedUser>(
      rows,
      orderBy: orderBy?.call(ProjectedUser.t),
      orderByList: orderByList?.call(ProjectedUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProjectedUser].
  Future<ProjectedUser> deleteRow(
    _i1.DatabaseSession session,
    ProjectedUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProjectedUser>(
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
  Future<List<ProjectedUser>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProjectedUserTable> where,
    _i1.OrderByBuilder<ProjectedUserTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProjectedUser>(
      where: where(ProjectedUser.t),
      orderBy: orderBy?.call(ProjectedUser.t),
      orderByList: orderByList?.call(ProjectedUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ProjectedUser>(
      where: where?.call(ProjectedUser.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProjectedUser] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProjectedUserTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProjectedUser>(
      where: where(ProjectedUser.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ProjectedUserAttachRepository {
  const ProjectedUserAttachRepository._();

  /// Creates a relation between this [ProjectedUser] and the given [ProjectedOrder]s
  /// by setting each [ProjectedOrder]'s foreign key `_projectedUserOrdersProjectedUserId` to refer to this [ProjectedUser].
  Future<void> orders(
    _i1.DatabaseSession session,
    ProjectedUser projectedUser,
    List<_i3.ProjectedOrder> projectedOrder, {
    _i1.Transaction? transaction,
  }) async {
    if (projectedOrder.any((e) => e.id == null)) {
      throw ArgumentError.notNull('projectedOrder.id');
    }
    if (projectedUser.id == null) {
      throw ArgumentError.notNull('projectedUser.id');
    }

    var $projectedOrder = projectedOrder
        .map(
          (e) => _i3.ProjectedOrderImplicit(
            e,
            $_projectedUserOrdersProjectedUserId: projectedUser.id,
          ),
        )
        .toList();
    await session.db.update<_i3.ProjectedOrder>(
      $projectedOrder,
      columns: [_i3.ProjectedOrder.t.$_projectedUserOrdersProjectedUserId],
      transaction: transaction,
    );
  }
}

class ProjectedUserAttachRowRepository {
  const ProjectedUserAttachRowRepository._();

  /// Creates a relation between the given [ProjectedUser] and [ProjectedAddress]
  /// by setting the [ProjectedUser]'s foreign key `addressId` to refer to the [ProjectedAddress].
  Future<void> address(
    _i1.DatabaseSession session,
    ProjectedUser projectedUser,
    _i2.ProjectedAddress address, {
    _i1.Transaction? transaction,
  }) async {
    if (projectedUser.id == null) {
      throw ArgumentError.notNull('projectedUser.id');
    }
    if (address.id == null) {
      throw ArgumentError.notNull('address.id');
    }

    var $projectedUser = projectedUser.copyWith(addressId: address.id);
    await session.db.updateRow<ProjectedUser>(
      $projectedUser,
      columns: [ProjectedUser.t.addressId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [ProjectedUser] and the given [ProjectedOrder]
  /// by setting the [ProjectedOrder]'s foreign key `_projectedUserOrdersProjectedUserId` to refer to this [ProjectedUser].
  Future<void> orders(
    _i1.DatabaseSession session,
    ProjectedUser projectedUser,
    _i3.ProjectedOrder projectedOrder, {
    _i1.Transaction? transaction,
  }) async {
    if (projectedOrder.id == null) {
      throw ArgumentError.notNull('projectedOrder.id');
    }
    if (projectedUser.id == null) {
      throw ArgumentError.notNull('projectedUser.id');
    }

    var $projectedOrder = _i3.ProjectedOrderImplicit(
      projectedOrder,
      $_projectedUserOrdersProjectedUserId: projectedUser.id,
    );
    await session.db.updateRow<_i3.ProjectedOrder>(
      $projectedOrder,
      columns: [_i3.ProjectedOrder.t.$_projectedUserOrdersProjectedUserId],
      transaction: transaction,
    );
  }
}

class ProjectedUserDetachRepository {
  const ProjectedUserDetachRepository._();

  /// Detaches the relation between this [ProjectedUser] and the given [ProjectedOrder]
  /// by setting the [ProjectedOrder]'s foreign key `_projectedUserOrdersProjectedUserId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> orders(
    _i1.DatabaseSession session,
    List<_i3.ProjectedOrder> projectedOrder, {
    _i1.Transaction? transaction,
  }) async {
    if (projectedOrder.any((e) => e.id == null)) {
      throw ArgumentError.notNull('projectedOrder.id');
    }

    var $projectedOrder = projectedOrder
        .map(
          (e) => _i3.ProjectedOrderImplicit(
            e,
            $_projectedUserOrdersProjectedUserId: null,
          ),
        )
        .toList();
    await session.db.update<_i3.ProjectedOrder>(
      $projectedOrder,
      columns: [_i3.ProjectedOrder.t.$_projectedUserOrdersProjectedUserId],
      transaction: transaction,
    );
  }
}

class ProjectedUserDetachRowRepository {
  const ProjectedUserDetachRowRepository._();

  /// Detaches the relation between this [ProjectedUser] and the given [ProjectedOrder]
  /// by setting the [ProjectedOrder]'s foreign key `_projectedUserOrdersProjectedUserId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> orders(
    _i1.DatabaseSession session,
    _i3.ProjectedOrder projectedOrder, {
    _i1.Transaction? transaction,
  }) async {
    if (projectedOrder.id == null) {
      throw ArgumentError.notNull('projectedOrder.id');
    }

    var $projectedOrder = _i3.ProjectedOrderImplicit(
      projectedOrder,
      $_projectedUserOrdersProjectedUserId: null,
    );
    await session.db.updateRow<_i3.ProjectedOrder>(
      $projectedOrder,
      columns: [_i3.ProjectedOrder.t.$_projectedUserOrdersProjectedUserId],
      transaction: transaction,
    );
  }
}

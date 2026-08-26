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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import 'projected_address.dart' as _iegbxll6;
import 'projected_json_field.dart' as _irlz4dmd;
import 'projected_order.dart' as _i8r3x6pe;

abstract class ProjectedUser
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ProjectedUser._({
    this.id,
    required this.name,
    required this.addressId,
    this.address,
    this.orders,
    this.jsonField,
  });

  factory ProjectedUser({
    _is.UuidValue? id,
    required String name,
    required int addressId,
    _iegbxll6.ProjectedAddress? address,
    List<_i8r3x6pe.ProjectedOrder>? orders,
    _irlz4dmd.ProjectedJsonField? jsonField,
  }) = _ProjectedUserImpl;

  factory ProjectedUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedUser(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      addressId: jsonSerialization['addressId'] as int,
      address: jsonSerialization['address'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_iegbxll6.ProjectedAddress>(
              jsonSerialization['address'],
            ),
      orders: jsonSerialization['orders'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<_i8r3x6pe.ProjectedOrder>>(
              jsonSerialization['orders'],
            ),
      jsonField: jsonSerialization['jsonField'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_irlz4dmd.ProjectedJsonField>(
              jsonSerialization['jsonField'],
            ),
    );
  }

  static final t = ProjectedUserTable();

  static const db = ProjectedUserRepository._();

  @override
  _is.UuidValue? id;

  String name;

  int addressId;

  _iegbxll6.ProjectedAddress? address;

  List<_i8r3x6pe.ProjectedOrder>? orders;

  _irlz4dmd.ProjectedJsonField? jsonField;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ProjectedUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedUser copyWith({
    _is.UuidValue? id,
    String? name,
    int? addressId,
    _iegbxll6.ProjectedAddress? address,
    List<_i8r3x6pe.ProjectedOrder>? orders,
    _irlz4dmd.ProjectedJsonField? jsonField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUser',
      if (id != null) 'id': id?.toJson(),
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
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'addressId': addressId,
      if (address != null) 'address': address?.toJsonForProtocol(),
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (jsonField != null) 'jsonField': jsonField?.toJsonForProtocol(),
    };
  }

  /// Builds a complete [ProjectedUserInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ProjectedUserInclude include({
    _iegbxll6.ProjectedAddressInclude? address,
    _i8r3x6pe.ProjectedOrderIncludeList? orders,
  }) {
    return ProjectedUserInclude._(
      address: address,
      orders: orders,
    );
  }

  /// Builds a complete [ProjectedUserIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ProjectedUserIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
    ProjectedUserInclude? include,
  }) {
    return ProjectedUserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedUser.t),
      orderByList: orderByList?.call(ProjectedUser.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [ProjectedUserJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static ProjectedUserJsonInclude includeJson({
    _iegbxll6.ProjectedAddressJsonInclude? address,
    _i8r3x6pe.ProjectedOrderJsonIncludeList? orders,
    _is.SelectColumnsBuilder<ProjectedUserTable>? select,
  }) {
    return _ProjectedUserJsonInclude._(
      address: address,
      orders: orders,
      selectedColumns: select?.call(ProjectedUser.t),
    );
  }

  /// Builds a JSON-compatible [ProjectedUserJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static ProjectedUserJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
    ProjectedUserJsonInclude? include,
    _is.SelectColumnsBuilder<ProjectedUserTable>? select,
  }) {
    return _ProjectedUserJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedUser.t),
      orderByList: orderByList?.call(ProjectedUser.t),
      include: include,
      selectedColumns: select?.call(ProjectedUser.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserImpl extends ProjectedUser {
  _ProjectedUserImpl({
    _is.UuidValue? id,
    required String name,
    required int addressId,
    _iegbxll6.ProjectedAddress? address,
    List<_i8r3x6pe.ProjectedOrder>? orders,
    _irlz4dmd.ProjectedJsonField? jsonField,
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
  @_is.useResult
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
      id: id is _is.UuidValue? ? id : this.id,
      name: name ?? this.name,
      addressId: addressId ?? this.addressId,
      address: address is _iegbxll6.ProjectedAddress?
          ? address
          : this.address?.copyWith(),
      orders: orders is List<_i8r3x6pe.ProjectedOrder>?
          ? orders
          : this.orders?.map((e0) => e0.copyWith()).toList(),
      jsonField: jsonField is _irlz4dmd.ProjectedJsonField?
          ? jsonField
          : this.jsonField?.copyWith(),
    );
  }
}

class ProjectedUserUpdateTable extends _is.UpdateTable<ProjectedUserTable> {
  ProjectedUserUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> addressId(int value) => _is.ColumnValue(
    table.addressId,
    value,
  );

  _is.ColumnValue<_irlz4dmd.ProjectedJsonField, _irlz4dmd.ProjectedJsonField>
  jsonField(_irlz4dmd.ProjectedJsonField? value) => _is.ColumnValue(
    table.jsonField,
    value,
  );
}

class ProjectedUserTable extends _is.Table<_is.UuidValue?> {
  ProjectedUserTable({super.tableRelation})
    : super(tableName: 'projected_user') {
    updateTable = ProjectedUserUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    addressId = _is.ColumnInt(
      'addressId',
      this,
    );
    jsonField = _is.ColumnSerializable<_irlz4dmd.ProjectedJsonField>(
      'jsonField',
      this,
    );
  }

  late final ProjectedUserUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnInt addressId;

  _iegbxll6.ProjectedAddressTable? _address;

  _i8r3x6pe.ProjectedOrderTable? ___orders;

  _is.ManyRelation<_i8r3x6pe.ProjectedOrderTable>? _orders;

  late final _is.ColumnSerializable<_irlz4dmd.ProjectedJsonField> jsonField;

  _iegbxll6.ProjectedAddressTable get address {
    if (_address != null) return _address!;
    _address = _is.createRelationTable(
      relationFieldName: 'address',
      field: ProjectedUser.t.addressId,
      foreignField: _iegbxll6.ProjectedAddress.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iegbxll6.ProjectedAddressTable(tableRelation: foreignTableRelation),
    );
    return _address!;
  }

  _i8r3x6pe.ProjectedOrderTable get __orders {
    if (___orders != null) return ___orders!;
    ___orders = _is.createRelationTable(
      relationFieldName: '__orders',
      field: ProjectedUser.t.id,
      foreignField:
          _i8r3x6pe.ProjectedOrder.t.$_projectedUserOrdersProjectedUserId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i8r3x6pe.ProjectedOrderTable(tableRelation: foreignTableRelation),
    );
    return ___orders!;
  }

  _is.ManyRelation<_i8r3x6pe.ProjectedOrderTable> get orders {
    if (_orders != null) return _orders!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'orders',
      field: ProjectedUser.t.id,
      foreignField:
          _i8r3x6pe.ProjectedOrder.t.$_projectedUserOrdersProjectedUserId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i8r3x6pe.ProjectedOrderTable(tableRelation: foreignTableRelation),
    );
    _orders = _is.ManyRelation<_i8r3x6pe.ProjectedOrderTable>(
      tableWithRelations: relationTable,
      table: _i8r3x6pe.ProjectedOrderTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _orders!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    addressId,
    jsonField,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'address') {
      return address;
    }
    if (relationField == 'orders') {
      return __orders;
    }
    return null;
  }
}

abstract interface class ProjectedUserJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class ProjectedUserJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class ProjectedUserInclude extends _is.IncludeObject
    implements ProjectedUserJsonInclude, _is.FullModelInclude {
  ProjectedUserInclude._({
    _iegbxll6.ProjectedAddressInclude? address,
    _i8r3x6pe.ProjectedOrderIncludeList? orders,
  }) {
    _address = address;
    _orders = orders;
  }

  _iegbxll6.ProjectedAddressInclude? _address;

  _i8r3x6pe.ProjectedOrderIncludeList? _orders;

  @override
  Map<String, _is.Include?> get includes => {
    'address': _address,
    'orders': _orders,
  };

  @override
  _is.Table<_is.UuidValue?> get table => ProjectedUser.t;
}

final class ProjectedUserIncludeList extends _is.IncludeList
    implements ProjectedUserJsonIncludeList, _is.FullModelInclude {
  ProjectedUserIncludeList._({
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ProjectedUserInclude? super.include,
  }) {
    super.where = where?.call(ProjectedUser.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ProjectedUser.t;
}

final class _ProjectedUserJsonInclude extends _is.IncludeObject
    implements ProjectedUserJsonInclude {
  _ProjectedUserJsonInclude._({
    _iegbxll6.ProjectedAddressJsonInclude? address,
    _i8r3x6pe.ProjectedOrderJsonIncludeList? orders,
    this.selectedColumns,
  }) {
    _address = address;
    _orders = orders;
  }

  _iegbxll6.ProjectedAddressJsonInclude? _address;

  _i8r3x6pe.ProjectedOrderJsonIncludeList? _orders;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'address': _address,
    'orders': _orders,
  };

  @override
  _is.Table<_is.UuidValue?> get table => ProjectedUser.t;
}

final class _ProjectedUserJsonIncludeList extends _is.IncludeList
    implements ProjectedUserJsonIncludeList {
  _ProjectedUserJsonIncludeList._({
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ProjectedUserJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ProjectedUser.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ProjectedUser.t;
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedUserInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedUserInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    ProjectedUserInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProjectedUser>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedUserJsonInclude? include,
    _is.SelectColumnsBuilder<ProjectedUserTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ProjectedUser>(
      where: where?.call(ProjectedUser.t),
      orderBy: orderBy?.call(ProjectedUser.t),
      orderByList: orderByList?.call(ProjectedUser.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(ProjectedUser.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedUserJsonInclude? include,
    _is.SelectColumnsBuilder<ProjectedUserTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ProjectedUser>(
      where: where?.call(ProjectedUser.t),
      orderBy: orderBy?.call(ProjectedUser.t),
      orderByList: orderByList?.call(ProjectedUser.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(ProjectedUser.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    ProjectedUserJsonInclude? include,
    _is.SelectColumnsBuilder<ProjectedUserTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ProjectedUser>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(ProjectedUser.t),
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
    _is.DatabaseSession session,
    List<ProjectedUser> rows, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    ProjectedUser row, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<ProjectedUser> rows, {
    required _is.ColumnSelections<ProjectedUserTable> conflictColumns,
    _is.ColumnSelections<ProjectedUserTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectedUserTable>? updateWhere,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    ProjectedUser row, {
    required _is.ColumnSelections<ProjectedUserTable> conflictColumns,
    _is.ColumnSelections<ProjectedUserTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectedUserTable>? updateWhere,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<ProjectedUser> rows, {
    _is.ColumnSelections<ProjectedUserTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    ProjectedUser row, {
    _is.ColumnSelections<ProjectedUserTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ProjectedUserUpdateTable> columnValues,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProjectedUserUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ProjectedUserTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<ProjectedUser> rows, {
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    ProjectedUser row, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectedUserTable> where,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProjectedUser>(
      where: where?.call(ProjectedUser.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProjectedUser] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectedUserTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
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
    _is.DatabaseSession session,
    ProjectedUser projectedUser,
    List<_i8r3x6pe.ProjectedOrder> projectedOrder, {
    _is.Transaction? transaction,
  }) async {
    if (projectedOrder.any((e) => e.id == null)) {
      throw ArgumentError.notNull('projectedOrder.id');
    }
    if (projectedUser.id == null) {
      throw ArgumentError.notNull('projectedUser.id');
    }

    var $projectedOrder = projectedOrder
        .map(
          (e) => _i8r3x6pe.ProjectedOrderImplicit(
            e,
            $_projectedUserOrdersProjectedUserId: projectedUser.id,
          ),
        )
        .toList();
    await session.db.update<_i8r3x6pe.ProjectedOrder>(
      $projectedOrder,
      columns: [
        _i8r3x6pe.ProjectedOrder.t.$_projectedUserOrdersProjectedUserId,
      ],
      transaction: transaction,
    );
  }
}

class ProjectedUserAttachRowRepository {
  const ProjectedUserAttachRowRepository._();

  /// Creates a relation between the given [ProjectedUser] and [ProjectedAddress]
  /// by setting the [ProjectedUser]'s foreign key `addressId` to refer to the [ProjectedAddress].
  Future<void> address(
    _is.DatabaseSession session,
    ProjectedUser projectedUser,
    _iegbxll6.ProjectedAddress address, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    ProjectedUser projectedUser,
    _i8r3x6pe.ProjectedOrder projectedOrder, {
    _is.Transaction? transaction,
  }) async {
    if (projectedOrder.id == null) {
      throw ArgumentError.notNull('projectedOrder.id');
    }
    if (projectedUser.id == null) {
      throw ArgumentError.notNull('projectedUser.id');
    }

    var $projectedOrder = _i8r3x6pe.ProjectedOrderImplicit(
      projectedOrder,
      $_projectedUserOrdersProjectedUserId: projectedUser.id,
    );
    await session.db.updateRow<_i8r3x6pe.ProjectedOrder>(
      $projectedOrder,
      columns: [
        _i8r3x6pe.ProjectedOrder.t.$_projectedUserOrdersProjectedUserId,
      ],
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
    _is.DatabaseSession session,
    List<_i8r3x6pe.ProjectedOrder> projectedOrder, {
    _is.Transaction? transaction,
  }) async {
    if (projectedOrder.any((e) => e.id == null)) {
      throw ArgumentError.notNull('projectedOrder.id');
    }

    var $projectedOrder = projectedOrder
        .map(
          (e) => _i8r3x6pe.ProjectedOrderImplicit(
            e,
            $_projectedUserOrdersProjectedUserId: null,
          ),
        )
        .toList();
    await session.db.update<_i8r3x6pe.ProjectedOrder>(
      $projectedOrder,
      columns: [
        _i8r3x6pe.ProjectedOrder.t.$_projectedUserOrdersProjectedUserId,
      ],
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
    _is.DatabaseSession session,
    _i8r3x6pe.ProjectedOrder projectedOrder, {
    _is.Transaction? transaction,
  }) async {
    if (projectedOrder.id == null) {
      throw ArgumentError.notNull('projectedOrder.id');
    }

    var $projectedOrder = _i8r3x6pe.ProjectedOrderImplicit(
      projectedOrder,
      $_projectedUserOrdersProjectedUserId: null,
    );
    await session.db.updateRow<_i8r3x6pe.ProjectedOrder>(
      $projectedOrder,
      columns: [
        _i8r3x6pe.ProjectedOrder.t.$_projectedUserOrdersProjectedUserId,
      ],
      transaction: transaction,
    );
  }
}

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

abstract class Service
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Service._({
    this.id,
    required this.name,
    this.description,
  });

  factory Service({
    int? id,
    required String name,
    String? description,
  }) = _ServiceImpl;

  factory Service.fromJson(Map<String, dynamic> jsonSerialization) {
    return Service(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
    );
  }

  static final t = ServiceTable();

  static const db = ServiceRepository._();

  @override
  int? id;

  String name;

  String? description;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Service]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Service copyWith({
    int? id,
    String? name,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Service',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Service',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
    };
  }

  static ServiceInclude include() {
    return ServiceInclude._();
  }

  static ServiceIncludeList includeList({
    _i1.WhereExpressionBuilder<ServiceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServiceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServiceTable>? orderByList,
    ServiceInclude? include,
  }) {
    return ServiceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Service.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Service.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServiceImpl extends Service {
  _ServiceImpl({
    int? id,
    required String name,
    String? description,
  }) : super._(
         id: id,
         name: name,
         description: description,
       );

  /// Returns a shallow copy of this [Service]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Service copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
  }) {
    return Service(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
    );
  }
}

class ServiceUpdateTable extends _i1.UpdateTable<ServiceTable> {
  ServiceUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );
}

class ServiceTable extends _i1.Table<int?> {
  ServiceTable({super.tableRelation}) : super(tableName: 'service') {
    updateTable = ServiceUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
  }

  late final ServiceUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    description,
  ];
}

class ServiceInclude extends _i1.IncludeObject {
  ServiceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Service.t;
}

class ServiceIncludeList extends _i1.IncludeList {
  ServiceIncludeList._({
    _i1.WhereExpressionBuilder<ServiceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Service.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Service.t;
}

class ServiceRepository {
  const ServiceRepository._();

  /// Returns a list of [Service]s matching the given query parameters.
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
  Future<List<Service>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServiceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServiceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServiceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Service>(
      where: where?.call(Service.t),
      orderBy: orderBy?.call(Service.t),
      orderByList: orderByList?.call(Service.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Service] matching the given query parameters.
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
  Future<Service?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServiceTable>? where,
    int? offset,
    _i1.OrderByBuilder<ServiceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServiceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Service>(
      where: where?.call(Service.t),
      orderBy: orderBy?.call(Service.t),
      orderByList: orderByList?.call(Service.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Service] by its [id] or null if no such row exists.
  Future<Service?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Service>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Service]s in the list and returns the inserted rows.
  ///
  /// The returned [Service]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Service>> insert(
    _i1.Session session,
    List<Service> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Service>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Service] and returns the inserted row.
  ///
  /// The returned [Service] will have its `id` field set.
  Future<Service> insertRow(
    _i1.Session session,
    Service row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Service>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Service]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Service>> update(
    _i1.Session session,
    List<Service> rows, {
    _i1.ColumnSelections<ServiceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Service>(
      rows,
      columns: columns?.call(Service.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Service]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Service> updateRow(
    _i1.Session session,
    Service row, {
    _i1.ColumnSelections<ServiceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Service>(
      row,
      columns: columns?.call(Service.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Service] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Service?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ServiceUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Service>(
      id,
      columnValues: columnValues(Service.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Service]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Service>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ServiceUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ServiceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServiceTable>? orderBy,
    _i1.OrderByListBuilder<ServiceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Service>(
      columnValues: columnValues(Service.t.updateTable),
      where: where(Service.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Service.t),
      orderByList: orderByList?.call(Service.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Service]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Service>> delete(
    _i1.Session session,
    List<Service> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Service>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Service].
  Future<Service> deleteRow(
    _i1.Session session,
    Service row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Service>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Service>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ServiceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Service>(
      where: where(Service.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServiceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Service>(
      where: where?.call(Service.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Service] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ServiceTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Service>(
      where: where(Service.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

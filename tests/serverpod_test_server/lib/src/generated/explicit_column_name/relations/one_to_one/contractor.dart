/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../../explicit_column_name/relations/one_to_one/service.dart' as _i2;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i3;

abstract class Contractor
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Contractor._({
    this.id,
    required this.name,
    this.serviceIdField,
    this.service,
  });

  factory Contractor({
    int? id,
    required String name,
    int? serviceIdField,
    _i2.Service? service,
  }) = _ContractorImpl;

  factory Contractor.fromJson(Map<String, dynamic> jsonSerialization) {
    return Contractor(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      serviceIdField: jsonSerialization['serviceIdField'] as int?,
      service: jsonSerialization['service'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Service>(
              jsonSerialization['service'],
            ),
    );
  }

  static final t = ContractorTable();

  static const db = ContractorRepository._();

  @override
  int? id;

  String name;

  int? serviceIdField;

  _i2.Service? service;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Contractor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Contractor copyWith({
    int? id,
    String? name,
    int? serviceIdField,
    _i2.Service? service,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Contractor',
      if (id != null) 'id': id,
      'name': name,
      if (serviceIdField != null) 'serviceIdField': serviceIdField,
      if (service != null) 'service': service?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Contractor',
      if (id != null) 'id': id,
      'name': name,
      if (serviceIdField != null) 'serviceIdField': serviceIdField,
      if (service != null) 'service': service?.toJsonForProtocol(),
    };
  }

  static ContractorInclude include({_i2.ServiceInclude? service}) {
    return ContractorInclude._(service: service);
  }

  static ContractorIncludeList includeList({
    _i1.WhereExpressionBuilder<ContractorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ContractorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ContractorTable>? orderByList,
    ContractorInclude? include,
  }) {
    return ContractorIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Contractor.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Contractor.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ContractorImpl extends Contractor {
  _ContractorImpl({
    int? id,
    required String name,
    int? serviceIdField,
    _i2.Service? service,
  }) : super._(
         id: id,
         name: name,
         serviceIdField: serviceIdField,
         service: service,
       );

  /// Returns a shallow copy of this [Contractor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Contractor copyWith({
    Object? id = _Undefined,
    String? name,
    Object? serviceIdField = _Undefined,
    Object? service = _Undefined,
  }) {
    return Contractor(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      serviceIdField: serviceIdField is int?
          ? serviceIdField
          : this.serviceIdField,
      service: service is _i2.Service? ? service : this.service?.copyWith(),
    );
  }
}

class ContractorUpdateTable extends _i1.UpdateTable<ContractorTable> {
  ContractorUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<int, int> serviceIdField(int? value) => _i1.ColumnValue(
    table.serviceIdField,
    value,
  );
}

class ContractorTable extends _i1.Table<int?> {
  ContractorTable({super.tableRelation}) : super(tableName: 'contractor') {
    updateTable = ContractorUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    serviceIdField = _i1.ColumnInt(
      'fk_contractor_service_id',
      this,
      fieldName: 'serviceIdField',
    );
  }

  late final ContractorUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnInt serviceIdField;

  _i2.ServiceTable? _service;

  _i2.ServiceTable get service {
    if (_service != null) return _service!;
    _service = _i1.createRelationTable(
      relationFieldName: 'service',
      field: Contractor.t.serviceIdField,
      foreignField: _i2.Service.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ServiceTable(tableRelation: foreignTableRelation),
    );
    return _service!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    serviceIdField,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'service') {
      return service;
    }
    return null;
  }
}

class ContractorInclude extends _i1.IncludeObject {
  ContractorInclude._({_i2.ServiceInclude? service}) {
    _service = service;
  }

  _i2.ServiceInclude? _service;

  @override
  Map<String, _i1.Include?> get includes => {'service': _service};

  @override
  _i1.Table<int?> get table => Contractor.t;
}

class ContractorIncludeList extends _i1.IncludeList {
  ContractorIncludeList._({
    _i1.WhereExpressionBuilder<ContractorTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Contractor.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Contractor.t;
}

class ContractorRepository {
  const ContractorRepository._();

  final attachRow = const ContractorAttachRowRepository._();

  final detachRow = const ContractorDetachRowRepository._();

  /// Returns a list of [Contractor]s matching the given query parameters.
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
  Future<List<Contractor>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ContractorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ContractorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ContractorTable>? orderByList,
    _i1.Transaction? transaction,
    ContractorInclude? include,
  }) async {
    return session.db.find<Contractor>(
      where: where?.call(Contractor.t),
      orderBy: orderBy?.call(Contractor.t),
      orderByList: orderByList?.call(Contractor.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Contractor] matching the given query parameters.
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
  Future<Contractor?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ContractorTable>? where,
    int? offset,
    _i1.OrderByBuilder<ContractorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ContractorTable>? orderByList,
    _i1.Transaction? transaction,
    ContractorInclude? include,
  }) async {
    return session.db.findFirstRow<Contractor>(
      where: where?.call(Contractor.t),
      orderBy: orderBy?.call(Contractor.t),
      orderByList: orderByList?.call(Contractor.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Contractor] by its [id] or null if no such row exists.
  Future<Contractor?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ContractorInclude? include,
  }) async {
    return session.db.findById<Contractor>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Contractor]s in the list and returns the inserted rows.
  ///
  /// The returned [Contractor]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Contractor>> insert(
    _i1.Session session,
    List<Contractor> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Contractor>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Contractor] and returns the inserted row.
  ///
  /// The returned [Contractor] will have its `id` field set.
  Future<Contractor> insertRow(
    _i1.Session session,
    Contractor row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Contractor>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Contractor]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Contractor>> update(
    _i1.Session session,
    List<Contractor> rows, {
    _i1.ColumnSelections<ContractorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Contractor>(
      rows,
      columns: columns?.call(Contractor.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Contractor]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Contractor> updateRow(
    _i1.Session session,
    Contractor row, {
    _i1.ColumnSelections<ContractorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Contractor>(
      row,
      columns: columns?.call(Contractor.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Contractor] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Contractor?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ContractorUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Contractor>(
      id,
      columnValues: columnValues(Contractor.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Contractor]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Contractor>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ContractorUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ContractorTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ContractorTable>? orderBy,
    _i1.OrderByListBuilder<ContractorTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Contractor>(
      columnValues: columnValues(Contractor.t.updateTable),
      where: where(Contractor.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Contractor.t),
      orderByList: orderByList?.call(Contractor.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Contractor]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Contractor>> delete(
    _i1.Session session,
    List<Contractor> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Contractor>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Contractor].
  Future<Contractor> deleteRow(
    _i1.Session session,
    Contractor row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Contractor>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Contractor>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ContractorTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Contractor>(
      where: where(Contractor.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ContractorTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Contractor>(
      where: where?.call(Contractor.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ContractorAttachRowRepository {
  const ContractorAttachRowRepository._();

  /// Creates a relation between the given [Contractor] and [Service]
  /// by setting the [Contractor]'s foreign key `serviceIdField` to refer to the [Service].
  Future<void> service(
    _i1.Session session,
    Contractor contractor,
    _i2.Service service, {
    _i1.Transaction? transaction,
  }) async {
    if (contractor.id == null) {
      throw ArgumentError.notNull('contractor.id');
    }
    if (service.id == null) {
      throw ArgumentError.notNull('service.id');
    }

    var $contractor = contractor.copyWith(serviceIdField: service.id);
    await session.db.updateRow<Contractor>(
      $contractor,
      columns: [Contractor.t.serviceIdField],
      transaction: transaction,
    );
  }
}

class ContractorDetachRowRepository {
  const ContractorDetachRowRepository._();

  /// Detaches the relation between this [Contractor] and the [Service] set in `service`
  /// by setting the [Contractor]'s foreign key `serviceIdField` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> service(
    _i1.Session session,
    Contractor contractor, {
    _i1.Transaction? transaction,
  }) async {
    if (contractor.id == null) {
      throw ArgumentError.notNull('contractor.id');
    }

    var $contractor = contractor.copyWith(serviceIdField: null);
    await session.db.updateRow<Contractor>(
      $contractor,
      columns: [Contractor.t.serviceIdField],
      transaction: transaction,
    );
  }
}

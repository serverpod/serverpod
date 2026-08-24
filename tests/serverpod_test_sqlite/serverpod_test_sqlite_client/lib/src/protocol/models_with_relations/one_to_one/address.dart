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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import '../../models_with_relations/one_to_one/citizen.dart' as _igho3lba;

abstract class Address
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  Address._({
    this.id,
    required this.street,
    this.inhabitantId,
    this.inhabitant,
  });

  factory Address({
    int? id,
    required String street,
    int? inhabitantId,
    _igho3lba.Citizen? inhabitant,
  }) = _AddressImpl;

  factory Address.fromJson(Map<String, dynamic> jsonSerialization) {
    return Address(
      id: jsonSerialization['id'] as int?,
      street: jsonSerialization['street'] as String,
      inhabitantId: jsonSerialization['inhabitantId'] as int?,
      inhabitant: jsonSerialization['inhabitant'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_igho3lba.Citizen>(
              jsonSerialization['inhabitant'],
            ),
    );
  }

  static final t = AddressTable();

  static const db = AddressRepository._();

  @override
  int? id;

  String street;

  int? inhabitantId;

  _igho3lba.Citizen? inhabitant;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [Address]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Address copyWith({
    int? id,
    String? street,
    int? inhabitantId,
    _igho3lba.Citizen? inhabitant,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Address',
      if (id != null) 'id': id,
      'street': street,
      if (inhabitantId != null) 'inhabitantId': inhabitantId,
      if (inhabitant != null) 'inhabitant': inhabitant?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Address',
      if (id != null) 'id': id,
      'street': street,
      if (inhabitantId != null) 'inhabitantId': inhabitantId,
      if (inhabitant != null) 'inhabitant': inhabitant?.toJsonForProtocol(),
    };
  }

  static AddressInclude include({
    _igho3lba.CitizenInclude? inhabitant,
    _isd.SelectColumnsBuilder<AddressTable>? select,
  }) {
    return AddressInclude.internal_(
      inhabitant: inhabitant,
      selectedColumns: select?.call(Address.t),
    );
  }

  static AddressIncludeList includeList({
    _isd.WhereExpressionBuilder<AddressTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<AddressTable>? orderBy,
    _isd.OrderByListBuilder<AddressTable>? orderByList,
    AddressInclude? include,
    _isd.SelectColumnsBuilder<AddressTable>? select,
  }) {
    return AddressIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Address.t),
      orderByList: orderByList?.call(Address.t),
      include: include,
      selectedColumns: select?.call(Address.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AddressImpl extends Address {
  _AddressImpl({
    int? id,
    required String street,
    int? inhabitantId,
    _igho3lba.Citizen? inhabitant,
  }) : super._(
         id: id,
         street: street,
         inhabitantId: inhabitantId,
         inhabitant: inhabitant,
       );

  /// Returns a shallow copy of this [Address]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Address copyWith({
    Object? id = _Undefined,
    String? street,
    Object? inhabitantId = _Undefined,
    Object? inhabitant = _Undefined,
  }) {
    return Address(
      id: id is int? ? id : this.id,
      street: street ?? this.street,
      inhabitantId: inhabitantId is int? ? inhabitantId : this.inhabitantId,
      inhabitant: inhabitant is _igho3lba.Citizen?
          ? inhabitant
          : this.inhabitant?.copyWith(),
    );
  }
}

class AddressUpdateTable extends _isd.UpdateTable<AddressTable> {
  AddressUpdateTable(super.table);

  _isd.ColumnValue<String, String> street(String value) => _isd.ColumnValue(
    table.street,
    value,
  );

  _isd.ColumnValue<int, int> inhabitantId(int? value) => _isd.ColumnValue(
    table.inhabitantId,
    value,
  );
}

class AddressTable extends _isd.Table<int?> {
  AddressTable({super.tableRelation}) : super(tableName: 'address') {
    updateTable = AddressUpdateTable(this);
    street = _isd.ColumnString(
      'street',
      this,
    );
    inhabitantId = _isd.ColumnInt(
      'inhabitantId',
      this,
    );
  }

  late final AddressUpdateTable updateTable;

  late final _isd.ColumnString street;

  late final _isd.ColumnInt inhabitantId;

  _igho3lba.CitizenTable? _inhabitant;

  _igho3lba.CitizenTable get inhabitant {
    if (_inhabitant != null) return _inhabitant!;
    _inhabitant = _isd.createRelationTable(
      relationFieldName: 'inhabitant',
      field: Address.t.inhabitantId,
      foreignField: _igho3lba.Citizen.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _igho3lba.CitizenTable(tableRelation: foreignTableRelation),
    );
    return _inhabitant!;
  }

  @override
  List<_isd.Column> get columns => [
    id,
    street,
    inhabitantId,
  ];

  @override
  _isd.Table? getRelationTable(String relationField) {
    if (relationField == 'inhabitant') {
      return inhabitant;
    }
    return null;
  }
}

class AddressInclude extends _isd.IncludeObject {
  AddressInclude.internal_({
    _igho3lba.CitizenInclude? inhabitant,
    this.selectedColumns,
  }) {
    _inhabitant = inhabitant;
  }

  _igho3lba.CitizenInclude? _inhabitant;

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {'inhabitant': _inhabitant};

  @override
  _isd.Table<int?> get table => Address.t;
}

class AddressIncludeList extends _isd.IncludeList {
  AddressIncludeList.internal_({
    _isd.WhereExpressionBuilder<AddressTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Address.t);
  }

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Address.t;
}

class AddressRepository {
  const AddressRepository._();

  final attachRow = const AddressAttachRowRepository._();

  final detachRow = const AddressDetachRowRepository._();

  /// Returns a list of [Address]s matching the given query parameters.
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
  Future<List<Address>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<AddressTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<AddressTable>? orderBy,
    _isd.OrderByListBuilder<AddressTable>? orderByList,
    _isd.Transaction? transaction,
    AddressInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Address>(
      where: where?.call(Address.t),
      orderBy: orderBy?.call(Address.t),
      orderByList: orderByList?.call(Address.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Address] matching the given query parameters.
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
  Future<Address?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<AddressTable>? where,
    int? offset,
    _isd.OrderByBuilder<AddressTable>? orderBy,
    _isd.OrderByListBuilder<AddressTable>? orderByList,
    _isd.Transaction? transaction,
    AddressInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Address>(
      where: where?.call(Address.t),
      orderBy: orderBy?.call(Address.t),
      orderByList: orderByList?.call(Address.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Address] by its [id] or null if no such row exists.
  Future<Address?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    AddressInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Address>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Address]s in the list and returns the inserted rows.
  ///
  /// The returned [Address]s will have their `id` fields set.
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
  Future<List<Address>> insert(
    _isd.DatabaseSession session,
    List<Address> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Address>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Address] and returns the inserted row.
  ///
  /// The returned [Address] will have its `id` field set.
  Future<Address> insertRow(
    _isd.DatabaseSession session,
    Address row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<Address>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Address]s in the list and returns the resulting rows.
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
  /// The returned [Address]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Address>> upsert(
    _isd.DatabaseSession session,
    List<Address> rows, {
    required _isd.ColumnSelections<AddressTable> conflictColumns,
    _isd.ColumnSelections<AddressTable>? updateColumns,
    _isd.WhereExpressionBuilder<AddressTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Address>(
      rows,
      conflictColumns: conflictColumns(Address.t),
      updateColumns: updateColumns?.call(Address.t),
      updateWhere: updateWhere?.call(Address.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Address] and returns the resulting row.
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
  /// The returned [Address] will have its `id` field set.
  Future<Address?> upsertRow(
    _isd.DatabaseSession session,
    Address row, {
    required _isd.ColumnSelections<AddressTable> conflictColumns,
    _isd.ColumnSelections<AddressTable>? updateColumns,
    _isd.WhereExpressionBuilder<AddressTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Address>(
      row,
      conflictColumns: conflictColumns(Address.t),
      updateColumns: updateColumns?.call(Address.t),
      updateWhere: updateWhere?.call(Address.t),
      transaction: transaction,
    );
  }

  /// Updates all [Address]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Address>> update(
    _isd.DatabaseSession session,
    List<Address> rows, {
    _isd.ColumnSelections<AddressTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Address>(
      rows,
      columns: columns?.call(Address.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Address]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Address> updateRow(
    _isd.DatabaseSession session,
    Address row, {
    _isd.ColumnSelections<AddressTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<Address>(
      row,
      columns: columns?.call(Address.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Address] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Address?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<AddressUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<Address>(
      id,
      columnValues: columnValues(Address.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Address]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Address>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<AddressUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<AddressTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<AddressTable>? orderBy,
    _isd.OrderByListBuilder<AddressTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Address>(
      columnValues: columnValues(Address.t.updateTable),
      where: where(Address.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Address.t),
      orderByList: orderByList?.call(Address.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Address]s in the list and returns the deleted rows.
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
  Future<List<Address>> delete(
    _isd.DatabaseSession session,
    List<Address> rows, {
    _isd.OrderByBuilder<AddressTable>? orderBy,
    _isd.OrderByListBuilder<AddressTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Address>(
      rows,
      orderBy: orderBy?.call(Address.t),
      orderByList: orderByList?.call(Address.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Address].
  Future<Address> deleteRow(
    _isd.DatabaseSession session,
    Address row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Address>(
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
  Future<List<Address>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<AddressTable> where,
    _isd.OrderByBuilder<AddressTable>? orderBy,
    _isd.OrderByListBuilder<AddressTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Address>(
      where: where(Address.t),
      orderBy: orderBy?.call(Address.t),
      orderByList: orderByList?.call(Address.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<AddressTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<Address>(
      where: where?.call(Address.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Address] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<AddressTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Address>(
      where: where(Address.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AddressAttachRowRepository {
  const AddressAttachRowRepository._();

  /// Creates a relation between the given [Address] and [Citizen]
  /// by setting the [Address]'s foreign key `inhabitantId` to refer to the [Citizen].
  Future<void> inhabitant(
    _isd.DatabaseSession session,
    Address address,
    _igho3lba.Citizen inhabitant, {
    _isd.Transaction? transaction,
  }) async {
    if (address.id == null) {
      throw ArgumentError.notNull('address.id');
    }
    if (inhabitant.id == null) {
      throw ArgumentError.notNull('inhabitant.id');
    }

    var $address = address.copyWith(inhabitantId: inhabitant.id);
    await session.db.updateRow<Address>(
      $address,
      columns: [Address.t.inhabitantId],
      transaction: transaction,
    );
  }
}

class AddressDetachRowRepository {
  const AddressDetachRowRepository._();

  /// Detaches the relation between this [Address] and the [Citizen] set in `inhabitant`
  /// by setting the [Address]'s foreign key `inhabitantId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> inhabitant(
    _isd.DatabaseSession session,
    Address address, {
    _isd.Transaction? transaction,
  }) async {
    if (address.id == null) {
      throw ArgumentError.notNull('address.id');
    }

    var $address = address.copyWith(inhabitantId: null);
    await session.db.updateRow<Address>(
      $address,
      columns: [Address.t.inhabitantId],
      transaction: transaction,
    );
  }
}

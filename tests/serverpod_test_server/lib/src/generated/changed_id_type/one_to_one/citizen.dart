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
import '../../changed_id_type/one_to_one/address.dart' as _i2;
import '../../changed_id_type/one_to_one/company.dart' as _i3;

abstract class CitizenInt
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CitizenInt._({
    this.id,
    required this.name,
    this.address,
    required this.companyId,
    this.company,
    this.oldCompanyId,
    this.oldCompany,
  });

  factory CitizenInt({
    int? id,
    required String name,
    _i2.AddressUuid? address,
    required _i1.UuidValue companyId,
    _i3.CompanyUuid? company,
    _i1.UuidValue? oldCompanyId,
    _i3.CompanyUuid? oldCompany,
  }) = _CitizenIntImpl;

  factory CitizenInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return CitizenInt(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] == null
          ? null
          : _i2.AddressUuid.fromJson(
              (jsonSerialization['address'] as Map<String, dynamic>)),
      companyId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['companyId']),
      company: jsonSerialization['company'] == null
          ? null
          : _i3.CompanyUuid.fromJson(
              (jsonSerialization['company'] as Map<String, dynamic>)),
      oldCompanyId: jsonSerialization['oldCompanyId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['oldCompanyId']),
      oldCompany: jsonSerialization['oldCompany'] == null
          ? null
          : _i3.CompanyUuid.fromJson(
              (jsonSerialization['oldCompany'] as Map<String, dynamic>)),
    );
  }

  static final t = CitizenIntTable();

  static const db = CitizenIntRepository._();

  @override
  int? id;

  String name;

  _i2.AddressUuid? address;

  _i1.UuidValue companyId;

  _i3.CompanyUuid? company;

  _i1.UuidValue? oldCompanyId;

  _i3.CompanyUuid? oldCompany;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CitizenInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CitizenInt copyWith({
    int? id,
    String? name,
    _i2.AddressUuid? address,
    _i1.UuidValue? companyId,
    _i3.CompanyUuid? company,
    _i1.UuidValue? oldCompanyId,
    _i3.CompanyUuid? oldCompany,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (address != null) 'address': address?.toJson(),
      'companyId': companyId.toJson(),
      if (company != null) 'company': company?.toJson(),
      if (oldCompanyId != null) 'oldCompanyId': oldCompanyId?.toJson(),
      if (oldCompany != null) 'oldCompany': oldCompany?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (address != null) 'address': address?.toJsonForProtocol(),
      'companyId': companyId.toJson(),
      if (company != null) 'company': company?.toJsonForProtocol(),
      if (oldCompanyId != null) 'oldCompanyId': oldCompanyId?.toJson(),
      if (oldCompany != null) 'oldCompany': oldCompany?.toJsonForProtocol(),
    };
  }

  static CitizenIntInclude include({
    _i2.AddressUuidInclude? address,
    _i3.CompanyUuidInclude? company,
    _i3.CompanyUuidInclude? oldCompany,
  }) {
    return CitizenIntInclude._(
      address: address,
      company: company,
      oldCompany: oldCompany,
    );
  }

  static CitizenIntIncludeList includeList({
    _i1.WhereExpressionBuilder<CitizenIntTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CitizenIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CitizenIntTable>? orderByList,
    CitizenIntInclude? include,
  }) {
    return CitizenIntIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CitizenInt.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CitizenInt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CitizenIntImpl extends CitizenInt {
  _CitizenIntImpl({
    int? id,
    required String name,
    _i2.AddressUuid? address,
    required _i1.UuidValue companyId,
    _i3.CompanyUuid? company,
    _i1.UuidValue? oldCompanyId,
    _i3.CompanyUuid? oldCompany,
  }) : super._(
          id: id,
          name: name,
          address: address,
          companyId: companyId,
          company: company,
          oldCompanyId: oldCompanyId,
          oldCompany: oldCompany,
        );

  /// Returns a shallow copy of this [CitizenInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CitizenInt copyWith({
    Object? id = _Undefined,
    String? name,
    Object? address = _Undefined,
    _i1.UuidValue? companyId,
    Object? company = _Undefined,
    Object? oldCompanyId = _Undefined,
    Object? oldCompany = _Undefined,
  }) {
    return CitizenInt(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      address: address is _i2.AddressUuid? ? address : this.address?.copyWith(),
      companyId: companyId ?? this.companyId,
      company: company is _i3.CompanyUuid? ? company : this.company?.copyWith(),
      oldCompanyId:
          oldCompanyId is _i1.UuidValue? ? oldCompanyId : this.oldCompanyId,
      oldCompany: oldCompany is _i3.CompanyUuid?
          ? oldCompany
          : this.oldCompany?.copyWith(),
    );
  }
}

class CitizenIntUpdateTable extends _i1.UpdateTable<CitizenIntTable> {
  CitizenIntUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
        table.name,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> companyId(
          _i1.UuidValue value) =>
      _i1.ColumnValue(
        table.companyId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> oldCompanyId(
          _i1.UuidValue? value) =>
      _i1.ColumnValue(
        table.oldCompanyId,
        value,
      );
}

class CitizenIntTable extends _i1.Table<int?> {
  CitizenIntTable({super.tableRelation}) : super(tableName: 'citizen_int') {
    updateTable = CitizenIntUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    companyId = _i1.ColumnUuid(
      'companyId',
      this,
    );
    oldCompanyId = _i1.ColumnUuid(
      'oldCompanyId',
      this,
    );
  }

  late final CitizenIntUpdateTable updateTable;

  late final _i1.ColumnString name;

  _i2.AddressUuidTable? _address;

  late final _i1.ColumnUuid companyId;

  _i3.CompanyUuidTable? _company;

  late final _i1.ColumnUuid oldCompanyId;

  _i3.CompanyUuidTable? _oldCompany;

  _i2.AddressUuidTable get address {
    if (_address != null) return _address!;
    _address = _i1.createRelationTable(
      relationFieldName: 'address',
      field: CitizenInt.t.id,
      foreignField: _i2.AddressUuid.t.inhabitantId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AddressUuidTable(tableRelation: foreignTableRelation),
    );
    return _address!;
  }

  _i3.CompanyUuidTable get company {
    if (_company != null) return _company!;
    _company = _i1.createRelationTable(
      relationFieldName: 'company',
      field: CitizenInt.t.companyId,
      foreignField: _i3.CompanyUuid.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.CompanyUuidTable(tableRelation: foreignTableRelation),
    );
    return _company!;
  }

  _i3.CompanyUuidTable get oldCompany {
    if (_oldCompany != null) return _oldCompany!;
    _oldCompany = _i1.createRelationTable(
      relationFieldName: 'oldCompany',
      field: CitizenInt.t.oldCompanyId,
      foreignField: _i3.CompanyUuid.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.CompanyUuidTable(tableRelation: foreignTableRelation),
    );
    return _oldCompany!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        companyId,
        oldCompanyId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'address') {
      return address;
    }
    if (relationField == 'company') {
      return company;
    }
    if (relationField == 'oldCompany') {
      return oldCompany;
    }
    return null;
  }
}

class CitizenIntInclude extends _i1.IncludeObject {
  CitizenIntInclude._({
    _i2.AddressUuidInclude? address,
    _i3.CompanyUuidInclude? company,
    _i3.CompanyUuidInclude? oldCompany,
  }) {
    _address = address;
    _company = company;
    _oldCompany = oldCompany;
  }

  _i2.AddressUuidInclude? _address;

  _i3.CompanyUuidInclude? _company;

  _i3.CompanyUuidInclude? _oldCompany;

  @override
  Map<String, _i1.Include?> get includes => {
        'address': _address,
        'company': _company,
        'oldCompany': _oldCompany,
      };

  @override
  _i1.Table<int?> get table => CitizenInt.t;
}

class CitizenIntIncludeList extends _i1.IncludeList {
  CitizenIntIncludeList._({
    _i1.WhereExpressionBuilder<CitizenIntTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CitizenInt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CitizenInt.t;
}

class CitizenIntRepository {
  const CitizenIntRepository._();

  final attachRow = const CitizenIntAttachRowRepository._();

  final detachRow = const CitizenIntDetachRowRepository._();

  /// Returns a list of [CitizenInt]s matching the given query parameters.
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
  Future<List<CitizenInt>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CitizenIntTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CitizenIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CitizenIntTable>? orderByList,
    _i1.Transaction? transaction,
    CitizenIntInclude? include,
  }) async {
    return session.db.find<CitizenInt>(
      where: where?.call(CitizenInt.t),
      orderBy: orderBy?.call(CitizenInt.t),
      orderByList: orderByList?.call(CitizenInt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [CitizenInt] matching the given query parameters.
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
  Future<CitizenInt?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CitizenIntTable>? where,
    int? offset,
    _i1.OrderByBuilder<CitizenIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CitizenIntTable>? orderByList,
    _i1.Transaction? transaction,
    CitizenIntInclude? include,
  }) async {
    return session.db.findFirstRow<CitizenInt>(
      where: where?.call(CitizenInt.t),
      orderBy: orderBy?.call(CitizenInt.t),
      orderByList: orderByList?.call(CitizenInt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [CitizenInt] by its [id] or null if no such row exists.
  Future<CitizenInt?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    CitizenIntInclude? include,
  }) async {
    return session.db.findById<CitizenInt>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [CitizenInt]s in the list and returns the inserted rows.
  ///
  /// The returned [CitizenInt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CitizenInt>> insert(
    _i1.Session session,
    List<CitizenInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CitizenInt>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CitizenInt] and returns the inserted row.
  ///
  /// The returned [CitizenInt] will have its `id` field set.
  Future<CitizenInt> insertRow(
    _i1.Session session,
    CitizenInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CitizenInt>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CitizenInt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CitizenInt>> update(
    _i1.Session session,
    List<CitizenInt> rows, {
    _i1.ColumnSelections<CitizenIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CitizenInt>(
      rows,
      columns: columns?.call(CitizenInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CitizenInt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CitizenInt> updateRow(
    _i1.Session session,
    CitizenInt row, {
    _i1.ColumnSelections<CitizenIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CitizenInt>(
      row,
      columns: columns?.call(CitizenInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CitizenInt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CitizenInt?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CitizenIntUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CitizenInt>(
      id,
      columnValues: columnValues(CitizenInt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CitizenInt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CitizenInt>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CitizenIntUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CitizenIntTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CitizenIntTable>? orderBy,
    _i1.OrderByListBuilder<CitizenIntTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CitizenInt>(
      columnValues: columnValues(CitizenInt.t.updateTable),
      where: where(CitizenInt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CitizenInt.t),
      orderByList: orderByList?.call(CitizenInt.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CitizenInt]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CitizenInt>> delete(
    _i1.Session session,
    List<CitizenInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CitizenInt>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CitizenInt].
  Future<CitizenInt> deleteRow(
    _i1.Session session,
    CitizenInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CitizenInt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CitizenInt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CitizenIntTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CitizenInt>(
      where: where(CitizenInt.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CitizenIntTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CitizenInt>(
      where: where?.call(CitizenInt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CitizenIntAttachRowRepository {
  const CitizenIntAttachRowRepository._();

  /// Creates a relation between the given [CitizenInt] and [AddressUuid]
  /// by setting the [CitizenInt]'s foreign key `id` to refer to the [AddressUuid].
  Future<void> address(
    _i1.Session session,
    CitizenInt citizenInt,
    _i2.AddressUuid address, {
    _i1.Transaction? transaction,
  }) async {
    if (address.id == null) {
      throw ArgumentError.notNull('address.id');
    }
    if (citizenInt.id == null) {
      throw ArgumentError.notNull('citizenInt.id');
    }

    var $address = address.copyWith(inhabitantId: citizenInt.id);
    await session.db.updateRow<_i2.AddressUuid>(
      $address,
      columns: [_i2.AddressUuid.t.inhabitantId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [CitizenInt] and [CompanyUuid]
  /// by setting the [CitizenInt]'s foreign key `companyId` to refer to the [CompanyUuid].
  Future<void> company(
    _i1.Session session,
    CitizenInt citizenInt,
    _i3.CompanyUuid company, {
    _i1.Transaction? transaction,
  }) async {
    if (citizenInt.id == null) {
      throw ArgumentError.notNull('citizenInt.id');
    }
    if (company.id == null) {
      throw ArgumentError.notNull('company.id');
    }

    var $citizenInt = citizenInt.copyWith(companyId: company.id);
    await session.db.updateRow<CitizenInt>(
      $citizenInt,
      columns: [CitizenInt.t.companyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [CitizenInt] and [CompanyUuid]
  /// by setting the [CitizenInt]'s foreign key `oldCompanyId` to refer to the [CompanyUuid].
  Future<void> oldCompany(
    _i1.Session session,
    CitizenInt citizenInt,
    _i3.CompanyUuid oldCompany, {
    _i1.Transaction? transaction,
  }) async {
    if (citizenInt.id == null) {
      throw ArgumentError.notNull('citizenInt.id');
    }
    if (oldCompany.id == null) {
      throw ArgumentError.notNull('oldCompany.id');
    }

    var $citizenInt = citizenInt.copyWith(oldCompanyId: oldCompany.id);
    await session.db.updateRow<CitizenInt>(
      $citizenInt,
      columns: [CitizenInt.t.oldCompanyId],
      transaction: transaction,
    );
  }
}

class CitizenIntDetachRowRepository {
  const CitizenIntDetachRowRepository._();

  /// Detaches the relation between this [CitizenInt] and the [AddressUuid] set in `address`
  /// by setting the [CitizenInt]'s foreign key `id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> address(
    _i1.Session session,
    CitizenInt citizenInt, {
    _i1.Transaction? transaction,
  }) async {
    var $address = citizenInt.address;

    if ($address == null) {
      throw ArgumentError.notNull('citizenInt.address');
    }
    if ($address.id == null) {
      throw ArgumentError.notNull('citizenInt.address.id');
    }
    if (citizenInt.id == null) {
      throw ArgumentError.notNull('citizenInt.id');
    }

    var $$address = $address.copyWith(inhabitantId: null);
    await session.db.updateRow<_i2.AddressUuid>(
      $$address,
      columns: [_i2.AddressUuid.t.inhabitantId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [CitizenInt] and the [CompanyUuid] set in `oldCompany`
  /// by setting the [CitizenInt]'s foreign key `oldCompanyId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> oldCompany(
    _i1.Session session,
    CitizenInt citizenInt, {
    _i1.Transaction? transaction,
  }) async {
    if (citizenInt.id == null) {
      throw ArgumentError.notNull('citizenInt.id');
    }

    var $citizenInt = citizenInt.copyWith(oldCompanyId: null);
    await session.db.updateRow<CitizenInt>(
      $citizenInt,
      columns: [CitizenInt.t.oldCompanyId],
      transaction: transaction,
    );
  }
}

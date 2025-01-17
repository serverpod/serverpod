/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../changed_id_type/one_to_one/address.dart' as _i2;
import '../../changed_id_type/one_to_one/company.dart' as _i3;

abstract class CitizenInt
    implements _i1.TableRow<int>, _i1.ProtocolSerialization {
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
  _i1.Table<int> get table => t;

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

class CitizenIntTable extends _i1.Table<int> {
  CitizenIntTable({super.tableRelation}) : super(tableName: 'citizen_int') {
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
  _i1.Table<int> get table => CitizenInt.t;
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
  _i1.Table<int> get table => CitizenInt.t;
}

class CitizenIntRepository {
  const CitizenIntRepository._();

  final attachRow = const CitizenIntAttachRowRepository._();

  final detachRow = const CitizenIntDetachRowRepository._();

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
    return session.db.find<int, CitizenInt>(
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
    return session.db.findFirstRow<int, CitizenInt>(
      where: where?.call(CitizenInt.t),
      orderBy: orderBy?.call(CitizenInt.t),
      orderByList: orderByList?.call(CitizenInt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<CitizenInt?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    CitizenIntInclude? include,
  }) async {
    return session.db.findById<int, CitizenInt>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<CitizenInt>> insert(
    _i1.Session session,
    List<CitizenInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<int, CitizenInt>(
      rows,
      transaction: transaction,
    );
  }

  Future<CitizenInt> insertRow(
    _i1.Session session,
    CitizenInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<int, CitizenInt>(
      row,
      transaction: transaction,
    );
  }

  Future<List<CitizenInt>> update(
    _i1.Session session,
    List<CitizenInt> rows, {
    _i1.ColumnSelections<CitizenIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<int, CitizenInt>(
      rows,
      columns: columns?.call(CitizenInt.t),
      transaction: transaction,
    );
  }

  Future<CitizenInt> updateRow(
    _i1.Session session,
    CitizenInt row, {
    _i1.ColumnSelections<CitizenIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<int, CitizenInt>(
      row,
      columns: columns?.call(CitizenInt.t),
      transaction: transaction,
    );
  }

  Future<List<CitizenInt>> delete(
    _i1.Session session,
    List<CitizenInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<int, CitizenInt>(
      rows,
      transaction: transaction,
    );
  }

  Future<CitizenInt> deleteRow(
    _i1.Session session,
    CitizenInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<int, CitizenInt>(
      row,
      transaction: transaction,
    );
  }

  Future<List<CitizenInt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CitizenIntTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<int, CitizenInt>(
      where: where(CitizenInt.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CitizenIntTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<int, CitizenInt>(
      where: where?.call(CitizenInt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CitizenIntAttachRowRepository {
  const CitizenIntAttachRowRepository._();

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
    await session.db.updateRow<_i1.UuidValue, _i2.AddressUuid>(
      $address,
      columns: [_i2.AddressUuid.t.inhabitantId],
      transaction: transaction,
    );
  }

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
    await session.db.updateRow<int, CitizenInt>(
      $citizenInt,
      columns: [CitizenInt.t.companyId],
      transaction: transaction,
    );
  }

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
    await session.db.updateRow<int, CitizenInt>(
      $citizenInt,
      columns: [CitizenInt.t.oldCompanyId],
      transaction: transaction,
    );
  }
}

class CitizenIntDetachRowRepository {
  const CitizenIntDetachRowRepository._();

  Future<void> address(
    _i1.Session session,
    CitizenInt citizenint, {
    _i1.Transaction? transaction,
  }) async {
    var $address = citizenint.address;

    if ($address == null) {
      throw ArgumentError.notNull('citizenint.address');
    }
    if ($address.id == null) {
      throw ArgumentError.notNull('citizenint.address.id');
    }
    if (citizenint.id == null) {
      throw ArgumentError.notNull('citizenint.id');
    }

    var $$address = $address.copyWith(inhabitantId: null);
    await session.db.updateRow<_i1.UuidValue, _i2.AddressUuid>(
      $$address,
      columns: [_i2.AddressUuid.t.inhabitantId],
      transaction: transaction,
    );
  }

  Future<void> oldCompany(
    _i1.Session session,
    CitizenInt citizenint, {
    _i1.Transaction? transaction,
  }) async {
    if (citizenint.id == null) {
      throw ArgumentError.notNull('citizenint.id');
    }

    var $citizenint = citizenint.copyWith(oldCompanyId: null);
    await session.db.updateRow<int, CitizenInt>(
      $citizenint,
      columns: [CitizenInt.t.oldCompanyId],
      transaction: transaction,
    );
  }
}

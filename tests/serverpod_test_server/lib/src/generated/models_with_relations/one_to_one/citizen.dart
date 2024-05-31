/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Citizen extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  Citizen._({
    int? id,
    required this.name,
    this.address,
    required this.companyId,
    this.company,
    this.oldCompanyId,
    this.oldCompany,
  }) : super(id);

  factory Citizen({
    int? id,
    required String name,
    _i2.Address? address,
    required int companyId,
    _i2.Company? company,
    int? oldCompanyId,
    _i2.Company? oldCompany,
  }) = _CitizenImpl;

  factory Citizen.fromJson(Map<String, dynamic> jsonSerialization) {
    return Citizen(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] == null
          ? null
          : _i2.Address.fromJson(
              (jsonSerialization['address'] as Map<String, dynamic>)),
      companyId: jsonSerialization['companyId'] as int,
      company: jsonSerialization['company'] == null
          ? null
          : _i2.Company.fromJson(
              (jsonSerialization['company'] as Map<String, dynamic>)),
      oldCompanyId: jsonSerialization['oldCompanyId'] as int?,
      oldCompany: jsonSerialization['oldCompany'] == null
          ? null
          : _i2.Company.fromJson(
              (jsonSerialization['oldCompany'] as Map<String, dynamic>)),
    );
  }

  static final t = CitizenTable();

  static const db = CitizenRepository._();

  String name;

  _i2.Address? address;

  int companyId;

  _i2.Company? company;

  int? oldCompanyId;

  _i2.Company? oldCompany;

  @override
  _i1.Table get table => t;

  Citizen copyWith({
    int? id,
    String? name,
    _i2.Address? address,
    int? companyId,
    _i2.Company? company,
    int? oldCompanyId,
    _i2.Company? oldCompany,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (address != null) 'address': address?.toJson(),
      'companyId': companyId,
      if (company != null) 'company': company?.toJson(),
      if (oldCompanyId != null) 'oldCompanyId': oldCompanyId,
      if (oldCompany != null) 'oldCompany': oldCompany?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (address != null) 'address': address?.toJsonForProtocol(),
      'companyId': companyId,
      if (company != null) 'company': company?.toJsonForProtocol(),
      if (oldCompanyId != null) 'oldCompanyId': oldCompanyId,
      if (oldCompany != null) 'oldCompany': oldCompany?.toJsonForProtocol(),
    };
  }

  static CitizenInclude include({
    _i2.AddressInclude? address,
    _i2.CompanyInclude? company,
    _i2.CompanyInclude? oldCompany,
  }) {
    return CitizenInclude._(
      address: address,
      company: company,
      oldCompany: oldCompany,
    );
  }

  static CitizenIncludeList includeList({
    _i1.WhereExpressionBuilder<CitizenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CitizenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CitizenTable>? orderByList,
    CitizenInclude? include,
  }) {
    return CitizenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Citizen.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Citizen.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CitizenImpl extends Citizen {
  _CitizenImpl({
    int? id,
    required String name,
    _i2.Address? address,
    required int companyId,
    _i2.Company? company,
    int? oldCompanyId,
    _i2.Company? oldCompany,
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
  Citizen copyWith({
    Object? id = _Undefined,
    String? name,
    Object? address = _Undefined,
    int? companyId,
    Object? company = _Undefined,
    Object? oldCompanyId = _Undefined,
    Object? oldCompany = _Undefined,
  }) {
    return Citizen(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      address: address is _i2.Address? ? address : this.address?.copyWith(),
      companyId: companyId ?? this.companyId,
      company: company is _i2.Company? ? company : this.company?.copyWith(),
      oldCompanyId: oldCompanyId is int? ? oldCompanyId : this.oldCompanyId,
      oldCompany:
          oldCompany is _i2.Company? ? oldCompany : this.oldCompany?.copyWith(),
    );
  }
}

class CitizenTable extends _i1.Table {
  CitizenTable({super.tableRelation}) : super(tableName: 'citizen') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    companyId = _i1.ColumnInt(
      'companyId',
      this,
    );
    oldCompanyId = _i1.ColumnInt(
      'oldCompanyId',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.AddressTable? _address;

  late final _i1.ColumnInt companyId;

  _i2.CompanyTable? _company;

  late final _i1.ColumnInt oldCompanyId;

  _i2.CompanyTable? _oldCompany;

  _i2.AddressTable get address {
    if (_address != null) return _address!;
    _address = _i1.createRelationTable(
      relationFieldName: 'address',
      field: Citizen.t.id,
      foreignField: _i2.Address.t.inhabitantId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AddressTable(tableRelation: foreignTableRelation),
    );
    return _address!;
  }

  _i2.CompanyTable get company {
    if (_company != null) return _company!;
    _company = _i1.createRelationTable(
      relationFieldName: 'company',
      field: Citizen.t.companyId,
      foreignField: _i2.Company.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CompanyTable(tableRelation: foreignTableRelation),
    );
    return _company!;
  }

  _i2.CompanyTable get oldCompany {
    if (_oldCompany != null) return _oldCompany!;
    _oldCompany = _i1.createRelationTable(
      relationFieldName: 'oldCompany',
      field: Citizen.t.oldCompanyId,
      foreignField: _i2.Company.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CompanyTable(tableRelation: foreignTableRelation),
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

class CitizenInclude extends _i1.IncludeObject {
  CitizenInclude._({
    _i2.AddressInclude? address,
    _i2.CompanyInclude? company,
    _i2.CompanyInclude? oldCompany,
  }) {
    _address = address;
    _company = company;
    _oldCompany = oldCompany;
  }

  _i2.AddressInclude? _address;

  _i2.CompanyInclude? _company;

  _i2.CompanyInclude? _oldCompany;

  @override
  Map<String, _i1.Include?> get includes => {
        'address': _address,
        'company': _company,
        'oldCompany': _oldCompany,
      };

  @override
  _i1.Table get table => Citizen.t;
}

class CitizenIncludeList extends _i1.IncludeList {
  CitizenIncludeList._({
    _i1.WhereExpressionBuilder<CitizenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Citizen.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Citizen.t;
}

class CitizenRepository {
  const CitizenRepository._();

  final attachRow = const CitizenAttachRowRepository._();

  final detachRow = const CitizenDetachRowRepository._();

  Future<List<Citizen>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CitizenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CitizenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CitizenTable>? orderByList,
    _i1.Transaction? transaction,
    CitizenInclude? include,
  }) async {
    return session.db.find<Citizen>(
      where: where?.call(Citizen.t),
      orderBy: orderBy?.call(Citizen.t),
      orderByList: orderByList?.call(Citizen.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Citizen?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CitizenTable>? where,
    int? offset,
    _i1.OrderByBuilder<CitizenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CitizenTable>? orderByList,
    _i1.Transaction? transaction,
    CitizenInclude? include,
  }) async {
    return session.db.findFirstRow<Citizen>(
      where: where?.call(Citizen.t),
      orderBy: orderBy?.call(Citizen.t),
      orderByList: orderByList?.call(Citizen.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Citizen?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    CitizenInclude? include,
  }) async {
    return session.db.findById<Citizen>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Citizen>> insert(
    _i1.Session session,
    List<Citizen> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Citizen>(
      rows,
      transaction: transaction,
    );
  }

  Future<Citizen> insertRow(
    _i1.Session session,
    Citizen row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Citizen>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Citizen>> update(
    _i1.Session session,
    List<Citizen> rows, {
    _i1.ColumnSelections<CitizenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Citizen>(
      rows,
      columns: columns?.call(Citizen.t),
      transaction: transaction,
    );
  }

  Future<Citizen> updateRow(
    _i1.Session session,
    Citizen row, {
    _i1.ColumnSelections<CitizenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Citizen>(
      row,
      columns: columns?.call(Citizen.t),
      transaction: transaction,
    );
  }

  Future<List<Citizen>> delete(
    _i1.Session session,
    List<Citizen> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Citizen>(
      rows,
      transaction: transaction,
    );
  }

  Future<Citizen> deleteRow(
    _i1.Session session,
    Citizen row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Citizen>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Citizen>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CitizenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Citizen>(
      where: where(Citizen.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CitizenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Citizen>(
      where: where?.call(Citizen.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CitizenAttachRowRepository {
  const CitizenAttachRowRepository._();

  Future<void> address(
    _i1.Session session,
    Citizen citizen,
    _i2.Address address,
  ) async {
    if (address.id == null) {
      throw ArgumentError.notNull('address.id');
    }
    if (citizen.id == null) {
      throw ArgumentError.notNull('citizen.id');
    }

    var $address = address.copyWith(inhabitantId: citizen.id);
    await session.db.updateRow<_i2.Address>(
      $address,
      columns: [_i2.Address.t.inhabitantId],
    );
  }

  Future<void> company(
    _i1.Session session,
    Citizen citizen,
    _i2.Company company,
  ) async {
    if (citizen.id == null) {
      throw ArgumentError.notNull('citizen.id');
    }
    if (company.id == null) {
      throw ArgumentError.notNull('company.id');
    }

    var $citizen = citizen.copyWith(companyId: company.id);
    await session.db.updateRow<Citizen>(
      $citizen,
      columns: [Citizen.t.companyId],
    );
  }

  Future<void> oldCompany(
    _i1.Session session,
    Citizen citizen,
    _i2.Company oldCompany,
  ) async {
    if (citizen.id == null) {
      throw ArgumentError.notNull('citizen.id');
    }
    if (oldCompany.id == null) {
      throw ArgumentError.notNull('oldCompany.id');
    }

    var $citizen = citizen.copyWith(oldCompanyId: oldCompany.id);
    await session.db.updateRow<Citizen>(
      $citizen,
      columns: [Citizen.t.oldCompanyId],
    );
  }
}

class CitizenDetachRowRepository {
  const CitizenDetachRowRepository._();

  Future<void> address(
    _i1.Session session,
    Citizen citizen,
  ) async {
    var $address = citizen.address;

    if ($address == null) {
      throw ArgumentError.notNull('citizen.address');
    }
    if ($address.id == null) {
      throw ArgumentError.notNull('citizen.address.id');
    }
    if (citizen.id == null) {
      throw ArgumentError.notNull('citizen.id');
    }

    var $$address = $address.copyWith(inhabitantId: null);
    await session.db.updateRow<_i2.Address>(
      $$address,
      columns: [_i2.Address.t.inhabitantId],
    );
  }

  Future<void> oldCompany(
    _i1.Session session,
    Citizen citizen,
  ) async {
    if (citizen.id == null) {
      throw ArgumentError.notNull('citizen.id');
    }

    var $citizen = citizen.copyWith(oldCompanyId: null);
    await session.db.updateRow<Citizen>(
      $citizen,
      columns: [Citizen.t.oldCompanyId],
    );
  }
}

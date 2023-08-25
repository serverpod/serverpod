/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

class Citizen extends _i1.TableRow {
  Citizen({
    int? id,
    required this.name,
    required this.companyId,
    this.company,
    this.oldCompanyId,
    this.oldCompany,
  }) : super(id);

  factory Citizen.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Citizen(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      companyId:
          serializationManager.deserialize<int>(jsonSerialization['companyId']),
      company: serializationManager
          .deserialize<_i2.Company?>(jsonSerialization['company']),
      oldCompanyId: serializationManager
          .deserialize<int?>(jsonSerialization['oldCompanyId']),
      oldCompany: serializationManager
          .deserialize<_i2.Company?>(jsonSerialization['oldCompany']),
    );
  }

  static final t = CitizenTable();

  String name;

  int companyId;

  _i2.Company? company;

  int? oldCompanyId;

  _i2.Company? oldCompany;

  @override
  String get tableName => 'citizen';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'companyId': companyId,
      'company': company,
      'oldCompanyId': oldCompanyId,
      'oldCompany': oldCompany,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
      'companyId': companyId,
      'oldCompanyId': oldCompanyId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'name': name,
      'companyId': companyId,
      'company': company,
      'oldCompanyId': oldCompanyId,
      'oldCompany': oldCompany,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'name':
        name = value;
        return;
      case 'companyId':
        companyId = value;
        return;
      case 'oldCompanyId':
        oldCompanyId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<Citizen>> find(
    _i1.Session session, {
    CitizenExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    CitizenInclude? include,
  }) async {
    return session.db.find<Citizen>(
      where: where != null ? where(Citizen.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<Citizen?> findSingleRow(
    _i1.Session session, {
    CitizenExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    CitizenInclude? include,
  }) async {
    return session.db.findSingleRow<Citizen>(
      where: where != null ? where(Citizen.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<Citizen?> findById(
    _i1.Session session,
    int id, {
    CitizenInclude? include,
  }) async {
    return session.db.findById<Citizen>(
      id,
      include: include,
    );
  }

  static Future<int> delete(
    _i1.Session session, {
    required CitizenExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Citizen>(
      where: where(Citizen.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    Citizen row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    Citizen row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    Citizen row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    CitizenExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Citizen>(
      where: where != null ? where(Citizen.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef CitizenExpressionBuilder = _i1.Expression Function(CitizenTable);

class CitizenTable extends _i1.Table {
  CitizenTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'citizen') {
    id = _i1.ColumnInt(
      'id',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    name = _i1.ColumnString(
      'name',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    companyId = _i1.ColumnInt(
      'companyId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    oldCompanyId = _i1.ColumnInt(
      'oldCompanyId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  late final _i1.ColumnInt id;

  late final _i1.ColumnString name;

  late final _i1.ColumnInt companyId;

  _i2.CompanyTable? _company;

  late final _i1.ColumnInt oldCompanyId;

  _i2.CompanyTable? _oldCompany;

  _i2.CompanyTable get company {
    if (_company != null) return _company!;
    _company = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'company',
      foreignTableName: _i2.Company.t.tableName,
      column: companyId,
      foreignColumnName: _i2.Company.t.id.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.CompanyTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
    );
    return _company!;
  }

  _i2.CompanyTable get oldCompany {
    if (_oldCompany != null) return _oldCompany!;
    _oldCompany = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'oldCompany',
      foreignTableName: _i2.Company.t.tableName,
      column: oldCompanyId,
      foreignColumnName: _i2.Company.t.id.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.CompanyTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
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
    if (relationField == 'company') {
      return company;
    }
    if (relationField == 'oldCompany') {
      return oldCompany;
    }
    return null;
  }
}

@Deprecated('Use CitizenTable.t instead.')
CitizenTable tCitizen = CitizenTable();

class CitizenInclude extends _i1.Include {
  CitizenInclude({
    this.company,
    this.oldCompany,
  });

  _i2.CompanyInclude? company;

  _i2.CompanyInclude? oldCompany;

  @override
  Map<String, _i1.Include?> get includes => {
        'company': company,
        'oldCompany': oldCompany,
      };
  @override
  _i1.Table get table => Citizen.t;
}

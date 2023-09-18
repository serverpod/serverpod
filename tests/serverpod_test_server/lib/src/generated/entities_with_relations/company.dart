/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

abstract class Company extends _i1.TableRow {
  Company._({
    int? id,
    required this.name,
    required this.townId,
    this.town,
  }) : super(id);

  factory Company({
    int? id,
    required String name,
    required int townId,
    _i2.Town? town,
  }) = _CompanyImpl;

  factory Company.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Company(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      townId:
          serializationManager.deserialize<int>(jsonSerialization['townId']),
      town: serializationManager
          .deserialize<_i2.Town?>(jsonSerialization['town']),
    );
  }

  static final t = CompanyTable();

  String name;

  int townId;

  _i2.Town? town;

  @override
  String get tableName => 'company';
  Company copyWith({
    int? id,
    String? name,
    int? townId,
    _i2.Town? town,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'townId': townId,
      'town': town,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
      'townId': townId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'name': name,
      'townId': townId,
      'town': town,
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
      case 'townId':
        townId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<Company>> find(
    _i1.Session session, {
    CompanyExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    CompanyInclude? include,
  }) async {
    return session.db.find<Company>(
      where: where != null ? where(Company.t) : null,
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

  static Future<Company?> findSingleRow(
    _i1.Session session, {
    CompanyExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    CompanyInclude? include,
  }) async {
    return session.db.findSingleRow<Company>(
      where: where != null ? where(Company.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<Company?> findById(
    _i1.Session session,
    int id, {
    CompanyInclude? include,
  }) async {
    return session.db.findById<Company>(
      id,
      include: include,
    );
  }

  static Future<int> delete(
    _i1.Session session, {
    required CompanyExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Company>(
      where: where(Company.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    Company row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    Company row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    Company row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    CompanyExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Company>(
      where: where != null ? where(Company.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static CompanyInclude include({_i2.TownInclude? town}) {
    return CompanyInclude._(town: town);
  }
}

class _Undefined {}

class _CompanyImpl extends Company {
  _CompanyImpl({
    int? id,
    required String name,
    required int townId,
    _i2.Town? town,
  }) : super._(
          id: id,
          name: name,
          townId: townId,
          town: town,
        );

  @override
  Company copyWith({
    Object? id = _Undefined,
    String? name,
    int? townId,
    Object? town = _Undefined,
  }) {
    return Company(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      townId: townId ?? this.townId,
      town: town is _i2.Town? ? town : this.town?.copyWith(),
    );
  }
}

typedef CompanyExpressionBuilder = _i1.Expression Function(CompanyTable);

class CompanyTable extends _i1.Table {
  CompanyTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'company') {
    name = _i1.ColumnString(
      'name',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    townId = _i1.ColumnInt(
      'townId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt townId;

  _i2.TownTable? _town;

  _i2.TownTable get town {
    if (_town != null) return _town!;
    _town = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'town',
      foreignTableName: _i2.Town.t.tableName,
      column: townId,
      foreignColumnName: _i2.Town.t.id.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.TownTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
    );
    return _town!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        townId,
      ];
  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'town') {
      return town;
    }
    return null;
  }
}

@Deprecated('Use CompanyTable.t instead.')
CompanyTable tCompany = CompanyTable();

class CompanyInclude extends _i1.Include {
  CompanyInclude._({_i2.TownInclude? town}) {
    _town = town;
  }

  _i2.TownInclude? _town;

  @override
  Map<String, _i1.Include?> get includes => {'town': _town};
  @override
  _i1.Table get table => Company.t;
}

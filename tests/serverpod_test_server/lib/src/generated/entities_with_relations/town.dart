/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

class Town extends _i1.TableRow {
  Town({
    int? id,
    required this.name,
    this.mayorId,
    this.mayor,
  }) : super(id);

  factory Town.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Town(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      mayorId:
          serializationManager.deserialize<int?>(jsonSerialization['mayorId']),
      mayor: serializationManager
          .deserialize<_i2.Citizen?>(jsonSerialization['mayor']),
    );
  }

  static final t = TownTable();

  String name;

  int? mayorId;

  _i2.Citizen? mayor;

  @override
  String get tableName => 'town';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mayorId': mayorId,
      'mayor': mayor,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
      'mayorId': mayorId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'name': name,
      'mayorId': mayorId,
      'mayor': mayor,
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
      case 'mayorId':
        mayorId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<Town>> find(
    _i1.Session session, {
    TownExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    TownInclude? include,
  }) async {
    return session.db.find<Town>(
      where: where != null ? where(Town.t) : null,
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

  static Future<Town?> findSingleRow(
    _i1.Session session, {
    TownExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    TownInclude? include,
  }) async {
    return session.db.findSingleRow<Town>(
      where: where != null ? where(Town.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<Town?> findById(
    _i1.Session session,
    int id, {
    TownInclude? include,
  }) async {
    return session.db.findById<Town>(
      id,
      include: include,
    );
  }

  static Future<int> delete(
    _i1.Session session, {
    required TownExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Town>(
      where: where(Town.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    Town row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    Town row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    Town row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    TownExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Town>(
      where: where != null ? where(Town.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef TownExpressionBuilder = _i1.Expression Function(TownTable);

class TownTable extends _i1.Table {
  TownTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'town') {
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
    mayorId = _i1.ColumnInt(
      'mayorId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  late final _i1.ColumnInt id;

  late final _i1.ColumnString name;

  late final _i1.ColumnInt mayorId;

  _i2.CitizenTable? _mayor;

  _i2.CitizenTable get mayor {
    if (_mayor != null) return _mayor!;
    _mayor = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'mayor',
      foreignTableName: _i2.Citizen.t.tableName,
      column: mayorId,
      foreignColumnName: _i2.Citizen.t.id.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.CitizenTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
    );
    return _mayor!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        mayorId,
      ];
  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'mayor') {
      return mayor;
    }
    return null;
  }
}

@Deprecated('Use TownTable.t instead.')
TownTable tTown = TownTable();

class TownInclude extends _i1.Include {
  TownInclude({this.mayor});

  _i2.CitizenInclude? mayor;

  @override
  Map<String, _i1.Include?> get includes => {'mayor': mayor};
  @override
  _i1.Table get table => Town.t;
}

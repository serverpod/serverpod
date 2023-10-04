/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

abstract class Town extends _i1.TableRow {
  Town._({
    int? id,
    required this.name,
    this.mayorId,
    this.mayor,
  }) : super(id);

  factory Town({
    int? id,
    required String name,
    int? mayorId,
    _i2.Citizen? mayor,
  }) = _TownImpl;

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

  static const db = TownRepository._();

  String name;

  int? mayorId;

  _i2.Citizen? mayor;

  @override
  _i1.Table get table => t;

  Town copyWith({
    int? id,
    String? name,
    int? mayorId,
    _i2.Citizen? mayor,
  });
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
  @Deprecated('Will be removed in 2.0.0')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
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

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
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

  static TownInclude include({_i2.CitizenInclude? mayor}) {
    return TownInclude._(mayor: mayor);
  }
}

class _Undefined {}

class _TownImpl extends Town {
  _TownImpl({
    int? id,
    required String name,
    int? mayorId,
    _i2.Citizen? mayor,
  }) : super._(
          id: id,
          name: name,
          mayorId: mayorId,
          mayor: mayor,
        );

  @override
  Town copyWith({
    Object? id = _Undefined,
    String? name,
    Object? mayorId = _Undefined,
    Object? mayor = _Undefined,
  }) {
    return Town(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      mayorId: mayorId is int? ? mayorId : this.mayorId,
      mayor: mayor is _i2.Citizen? ? mayor : this.mayor?.copyWith(),
    );
  }
}

typedef TownExpressionBuilder = _i1.Expression Function(TownTable);

class TownTable extends _i1.Table {
  TownTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'town') {
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
  TownInclude._({_i2.CitizenInclude? mayor}) {
    _mayor = mayor;
  }

  _i2.CitizenInclude? _mayor;

  @override
  Map<String, _i1.Include?> get includes => {'mayor': _mayor};

  @override
  _i1.Table get table => Town.t;
}

class TownRepository {
  const TownRepository._();

  final attachRow = const TownAttachRowRepository._();

  final detachRow = const TownDetachRowRepository._();

  Future<List<Town>> find(
    _i1.Session session, {
    TownExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
    TownInclude? include,
  }) async {
    return session.dbNext.find<Town>(
      where: where?.call(Town.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
      include: include,
    );
  }

  Future<Town?> findRow(
    _i1.Session session, {
    TownExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
    TownInclude? include,
  }) async {
    return session.dbNext.findRow<Town>(
      where: where?.call(Town.t),
      transaction: transaction,
      include: include,
    );
  }

  Future<Town?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    TownInclude? include,
  }) async {
    return session.dbNext.findById<Town>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Town>> insert(
    _i1.Session session,
    List<Town> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<Town>(
      rows,
      transaction: transaction,
    );
  }

  Future<Town> insertRow(
    _i1.Session session,
    Town row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Town>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Town>> update(
    _i1.Session session,
    List<Town> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Town>(
      rows,
      transaction: transaction,
    );
  }

  Future<Town> updateRow(
    _i1.Session session,
    Town row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Town>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Town> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Town>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Town row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Town>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required TownExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Town>(
      where: where(Town.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    TownExpressionBuilder? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Town>(
      where: where?.call(Town.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class TownAttachRowRepository {
  const TownAttachRowRepository._();

  Future<void> mayor(
    _i1.Session session,
    Town town,
    _i2.Citizen mayor,
  ) async {
    if (town.id == null) {
      throw ArgumentError.notNull('town.id');
    }
    if (mayor.id == null) {
      throw ArgumentError.notNull('mayor.id');
    }

    var $town = town.copyWith(mayorId: mayor.id);
    await session.dbNext.updateRow<Town>(
      $town,
      columns: [Town.t.mayorId],
    );
  }
}

class TownDetachRowRepository {
  const TownDetachRowRepository._();

  Future<void> mayor(
    _i1.Session session,
    Town town,
  ) async {
    if (town.id == null) {
      throw ArgumentError.notNull('town.id');
    }

    var $town = town.copyWith(mayorId: null);
    await session.dbNext.updateRow<Town>(
      $town,
      columns: [Town.t.mayorId],
    );
  }
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class ParentData extends _i1.TableRow {
  ParentData({
    int? id,
    required this.name,
  }) : super(id);

  factory ParentData.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ParentData(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
    );
  }

  static final t = ParentDataTable();

  String name;

  @override
  String get tableName => 'parent_data';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'name': name,
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
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<ParentData>> find(
    _i1.Session session, {
    ParentDataExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ParentData>(
      where: where != null ? where(ParentData.t) : null,
      limit: limit,
      viewTable: false,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ParentData?> findSingleRow(
    _i1.Session session, {
    ParentDataExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ParentData>(
      where: where != null ? where(ParentData.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ParentData?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ParentData>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ParentDataExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ParentData>(
      where: where(ParentData.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    ParentData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    ParentData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    ParentData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    ParentDataExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ParentData>(
      where: where != null ? where(ParentData.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ParentDataExpressionBuilder = _i1.Expression Function(ParentDataTable);

class ParentDataTable extends _i1.Table {
  ParentDataTable() : super(tableName: 'parent_data');

  final id = _i1.ColumnInt('id');

  final name = _i1.ColumnString('name');

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];
}

@Deprecated('Use ParentDataTable.t instead.')
ParentDataTable tParentData = ParentDataTable();

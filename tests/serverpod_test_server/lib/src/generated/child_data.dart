/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class ChildData extends _i1.TableRow {
  ChildData({
    int? id,
    required this.description,
    required this.createdBy,
    this.modifiedBy,
  }) : super(id);

  factory ChildData.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChildData(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      description: serializationManager
          .deserialize<String>(jsonSerialization['description']),
      createdBy:
          serializationManager.deserialize<int>(jsonSerialization['createdBy']),
      modifiedBy: serializationManager
          .deserialize<int?>(jsonSerialization['modifiedBy']),
    );
  }

  static final t = ChildDataTable();

  String description;

  int createdBy;

  int? modifiedBy;

  @override
  String get tableName => 'child_data';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'description': description,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'description': description,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
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
      case 'description':
        description = value;
        return;
      case 'createdBy':
        createdBy = value;
        return;
      case 'modifiedBy':
        modifiedBy = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<ChildData>> find(
    _i1.Session session, {
    ChildDataExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ChildData>(
      where: where != null ? where(ChildData.t) : null,
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

  static Future<ChildData?> findSingleRow(
    _i1.Session session, {
    ChildDataExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ChildData>(
      where: where != null ? where(ChildData.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ChildData?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ChildData>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ChildDataExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ChildData>(
      where: where(ChildData.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    ChildData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    ChildData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    ChildData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    ChildDataExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ChildData>(
      where: where != null ? where(ChildData.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ChildDataExpressionBuilder = _i1.Expression Function(ChildDataTable);

class ChildDataTable extends _i1.Table {
  ChildDataTable() : super(tableName: 'child_data');

  final id = _i1.ColumnInt('id');

  final description = _i1.ColumnString('description');

  final createdBy = _i1.ColumnInt('createdBy');

  final modifiedBy = _i1.ColumnInt('modifiedBy');

  @override
  List<_i1.Column> get columns => [
        id,
        description,
        createdBy,
        modifiedBy,
      ];
}

@Deprecated('Use ChildDataTable.t instead.')
ChildDataTable tChildData = ChildDataTable();

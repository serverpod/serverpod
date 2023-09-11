/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ObjectWithIndex extends _i1.TableRow {
  ObjectWithIndex._({
    int? id,
    required this.indexed,
    required this.indexed2,
  }) : super(id);

  factory ObjectWithIndex({
    int? id,
    required int indexed,
    required int indexed2,
  }) = _ObjectWithIndexImpl;

  factory ObjectWithIndex.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithIndex(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      indexed:
          serializationManager.deserialize<int>(jsonSerialization['indexed']),
      indexed2:
          serializationManager.deserialize<int>(jsonSerialization['indexed2']),
    );
  }

  static final t = ObjectWithIndexTable();

  int indexed;

  int indexed2;

  @override
  String get tableName => 'object_with_index';
  ObjectWithIndex copyWith({
    int? id,
    int? indexed,
    int? indexed2,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'indexed': indexed,
      'indexed2': indexed2,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'indexed': indexed,
      'indexed2': indexed2,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'indexed': indexed,
      'indexed2': indexed2,
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
      case 'indexed':
        indexed = value;
        return;
      case 'indexed2':
        indexed2 = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<ObjectWithIndex>> find(
    _i1.Session session, {
    ObjectWithIndexExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithIndex>(
      where: where != null ? where(ObjectWithIndex.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithIndex?> findSingleRow(
    _i1.Session session, {
    ObjectWithIndexExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectWithIndex>(
      where: where != null ? where(ObjectWithIndex.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithIndex?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithIndex>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ObjectWithIndexExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithIndex>(
      where: where(ObjectWithIndex.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    ObjectWithIndex row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    ObjectWithIndex row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    ObjectWithIndex row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    ObjectWithIndexExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithIndex>(
      where: where != null ? where(ObjectWithIndex.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static ObjectWithIndexInclude include() {
    return ObjectWithIndexInclude._();
  }
}

class _Undefined {}

class _ObjectWithIndexImpl extends ObjectWithIndex {
  _ObjectWithIndexImpl({
    int? id,
    required int indexed,
    required int indexed2,
  }) : super._(
          id: id,
          indexed: indexed,
          indexed2: indexed2,
        );

  @override
  ObjectWithIndex copyWith({
    Object? id = _Undefined,
    int? indexed,
    int? indexed2,
  }) {
    return ObjectWithIndex(
      id: id is! int? ? this.id : id,
      indexed: indexed ?? this.indexed,
      indexed2: indexed2 ?? this.indexed2,
    );
  }
}

typedef ObjectWithIndexExpressionBuilder = _i1.Expression Function(
    ObjectWithIndexTable);

class ObjectWithIndexTable extends _i1.Table {
  ObjectWithIndexTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'object_with_index') {
    indexed = _i1.ColumnInt(
      'indexed',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    indexed2 = _i1.ColumnInt(
      'indexed2',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  late final _i1.ColumnInt indexed;

  late final _i1.ColumnInt indexed2;

  @override
  List<_i1.Column> get columns => [
        id,
        indexed,
        indexed2,
      ];
}

@Deprecated('Use ObjectWithIndexTable.t instead.')
ObjectWithIndexTable tObjectWithIndex = ObjectWithIndexTable();

class ObjectWithIndexInclude extends _i1.Include {
  ObjectWithIndexInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => ObjectWithIndex.t;
}

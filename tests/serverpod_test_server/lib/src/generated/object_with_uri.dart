/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class ObjectWithUri extends _i1.TableRow {
  ObjectWithUri({
    int? id,
    this.url,
  }) : super(id);

  factory ObjectWithUri.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithUri(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      url: serializationManager.deserialize<Uri?>(jsonSerialization['url']),
    );
  }

  static final t = ObjectWithUriTable();

  Uri? url;

  @override
  String get tableName => 'object_with_uri';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'url': url,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'url': url,
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
      case 'url':
        url = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<ObjectWithUri>> find(
    _i1.Session session, {
    ObjectWithUriExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithUri>(
      where: where != null ? where(ObjectWithUri.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithUri?> findSingleRow(
    _i1.Session session, {
    ObjectWithUriExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectWithUri>(
      where: where != null ? where(ObjectWithUri.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithUri?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithUri>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ObjectWithUriExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithUri>(
      where: where(ObjectWithUri.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    ObjectWithUri row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    ObjectWithUri row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    ObjectWithUri row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    ObjectWithUriExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithUri>(
      where: where != null ? where(ObjectWithUri.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ObjectWithUriExpressionBuilder = _i1.Expression Function(
    ObjectWithUriTable);

class ObjectWithUriTable extends _i1.Table {
  ObjectWithUriTable() : super(tableName: 'object_with_uri');

  final id = _i1.ColumnInt('id');

  final url = _i1.ColumnSerializable('url');

  @override
  List<_i1.Column> get columns => [
        id,
        url,
      ];
}

@Deprecated('Use ObjectWithUriTable.t instead.')
ObjectWithUriTable tObjectWithUri = ObjectWithUriTable();

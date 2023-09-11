/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ObjectWithSelfParent extends _i1.TableRow {
  ObjectWithSelfParent._({
    int? id,
    this.other,
  }) : super(id);

  factory ObjectWithSelfParent({
    int? id,
    int? other,
  }) = _ObjectWithSelfParentImpl;

  factory ObjectWithSelfParent.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithSelfParent(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      other: serializationManager.deserialize<int?>(jsonSerialization['other']),
    );
  }

  static final t = ObjectWithSelfParentTable();

  int? other;

  @override
  String get tableName => 'object_with_self_parent';
  ObjectWithSelfParent copyWith({
    int? id,
    int? other,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'other': other,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'other': other,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'other': other,
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
      case 'other':
        other = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<ObjectWithSelfParent>> find(
    _i1.Session session, {
    ObjectWithSelfParentExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithSelfParent>(
      where: where != null ? where(ObjectWithSelfParent.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithSelfParent?> findSingleRow(
    _i1.Session session, {
    ObjectWithSelfParentExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectWithSelfParent>(
      where: where != null ? where(ObjectWithSelfParent.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithSelfParent?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithSelfParent>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ObjectWithSelfParentExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithSelfParent>(
      where: where(ObjectWithSelfParent.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    ObjectWithSelfParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    ObjectWithSelfParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    ObjectWithSelfParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    ObjectWithSelfParentExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithSelfParent>(
      where: where != null ? where(ObjectWithSelfParent.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static ObjectWithSelfParentInclude include() {
    return ObjectWithSelfParentInclude._();
  }
}

class _Undefined {}

class _ObjectWithSelfParentImpl extends ObjectWithSelfParent {
  _ObjectWithSelfParentImpl({
    int? id,
    int? other,
  }) : super._(
          id: id,
          other: other,
        );

  @override
  ObjectWithSelfParent copyWith({
    Object? id = _Undefined,
    Object? other = _Undefined,
  }) {
    return ObjectWithSelfParent(
      id: id is! int? ? this.id : id,
      other: other is! int? ? this.other : other,
    );
  }
}

typedef ObjectWithSelfParentExpressionBuilder = _i1.Expression Function(
    ObjectWithSelfParentTable);

class ObjectWithSelfParentTable extends _i1.Table {
  ObjectWithSelfParentTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'object_with_self_parent') {
    other = _i1.ColumnInt(
      'other',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  late final _i1.ColumnInt other;

  @override
  List<_i1.Column> get columns => [
        id,
        other,
      ];
}

@Deprecated('Use ObjectWithSelfParentTable.t instead.')
ObjectWithSelfParentTable tObjectWithSelfParent = ObjectWithSelfParentTable();

class ObjectWithSelfParentInclude extends _i1.Include {
  ObjectWithSelfParentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => ObjectWithSelfParent.t;
}

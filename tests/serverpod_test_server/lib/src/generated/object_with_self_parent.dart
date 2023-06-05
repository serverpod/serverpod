/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef ObjectWithSelfParentExpressionBuilder = _i1.Expression Function(
    ObjectWithSelfParentTable);

abstract class ObjectWithSelfParent extends _i1.TableRow {
  const ObjectWithSelfParent._();

  const factory ObjectWithSelfParent({
    int? id,
    int? other,
  }) = _ObjectWithSelfParent;

  factory ObjectWithSelfParent.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithSelfParent(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      other: serializationManager.deserialize<int?>(jsonSerialization['other']),
    );
  }

  static const t = ObjectWithSelfParentTable();

  ObjectWithSelfParent copyWith({
    int? id,
    int? other,
  });
  @override
  String get tableName => 'object_with_self_parent';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'other': other,
    };
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

  /// Inserts a row into the database.
  /// Returns updated row with the id set.
  static Future<ObjectWithSelfParent> insert(
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

  int? get other;
}

class _Undefined {}

class _ObjectWithSelfParent extends ObjectWithSelfParent {
  const _ObjectWithSelfParent({
    int? id,
    this.other,
  }) : super._();

  @override
  final int? other;

  @override
  String get tableName => 'object_with_self_parent';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'other': other,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ObjectWithSelfParent &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.other,
                  other,
                ) ||
                other.other == other));
  }

  @override
  int get hashCode => Object.hash(
        id,
        other,
      );

  @override
  ObjectWithSelfParent copyWith({
    Object? id = _Undefined,
    Object? other = _Undefined,
  }) {
    return ObjectWithSelfParent(
      id: id == _Undefined ? this.id : (id as int?),
      other: other == _Undefined ? this.other : (other as int?),
    );
  }
}

class ObjectWithSelfParentTable extends _i1.Table {
  const ObjectWithSelfParentTable()
      : super(tableName: 'object_with_self_parent');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  final other = const _i1.ColumnInt('other');

  @override
  List<_i1.Column> get columns => [
        id,
        other,
      ];
}

@Deprecated('Use ObjectWithSelfParentTable.t instead.')
ObjectWithSelfParentTable tObjectWithSelfParent =
    const ObjectWithSelfParentTable();

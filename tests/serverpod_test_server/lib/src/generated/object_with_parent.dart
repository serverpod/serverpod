/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef ObjectWithParentExpressionBuilder = _i1.Expression Function(
    ObjectWithParentTable);

abstract class ObjectWithParent extends _i1.TableRow {
  const ObjectWithParent._();

  const factory ObjectWithParent({
    int? id,
    required int other,
  }) = _ObjectWithParent;

  factory ObjectWithParent.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithParent(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      other: serializationManager.deserialize<int>(jsonSerialization['other']),
    );
  }

  static const t = ObjectWithParentTable();

  ObjectWithParent copyWith({
    int? id,
    int? other,
  });
  @override
  String get tableName => 'object_with_parent';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'other': other,
    };
  }

  static Future<List<ObjectWithParent>> find(
    _i1.Session session, {
    ObjectWithParentExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithParent>(
      where: where != null ? where(ObjectWithParent.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithParent?> findSingleRow(
    _i1.Session session, {
    ObjectWithParentExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectWithParent>(
      where: where != null ? where(ObjectWithParent.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithParent?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithParent>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ObjectWithParentExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithParent>(
      where: where(ObjectWithParent.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    ObjectWithParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    ObjectWithParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    ObjectWithParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    ObjectWithParentExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithParent>(
      where: where != null ? where(ObjectWithParent.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  int get other;
}

class _Undefined {}

class _ObjectWithParent extends ObjectWithParent {
  const _ObjectWithParent({
    int? id,
    required this.other,
  }) : super._();

  @override
  final int other;

  @override
  String get tableName => 'object_with_parent';
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
        (other is ObjectWithParent &&
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
  ObjectWithParent copyWith({
    Object? id = _Undefined,
    int? other,
  }) {
    return ObjectWithParent(
      id: id == _Undefined ? this.id : (id as int?),
      other: other ?? this.other,
    );
  }
}

class ObjectWithParentTable extends _i1.Table {
  const ObjectWithParentTable() : super(tableName: 'object_with_parent');

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

@Deprecated('Use ObjectWithParentTable.t instead.')
ObjectWithParentTable tObjectWithParent = const ObjectWithParentTable();

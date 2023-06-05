/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

class _Undefined {}

class ObjectWithEnum extends _i1.TableRow {
  ObjectWithEnum({
    int? id,
    required this.testEnum,
    this.nullableEnum,
    required this.enumList,
    required this.nullableEnumList,
    required this.enumListList,
  }) : super(id);

  factory ObjectWithEnum.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithEnum(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      testEnum: serializationManager
          .deserialize<_i2.TestEnum>(jsonSerialization['testEnum']),
      nullableEnum: serializationManager
          .deserialize<_i2.TestEnum?>(jsonSerialization['nullableEnum']),
      enumList: serializationManager
          .deserialize<List<_i2.TestEnum>>(jsonSerialization['enumList']),
      nullableEnumList: serializationManager.deserialize<List<_i2.TestEnum?>>(
          jsonSerialization['nullableEnumList']),
      enumListList: serializationManager.deserialize<List<List<_i2.TestEnum>>>(
          jsonSerialization['enumListList']),
    );
  }

  static var t = ObjectWithEnumTable();

  final _i2.TestEnum testEnum;

  final _i2.TestEnum? nullableEnum;

  final List<_i2.TestEnum> enumList;

  final List<_i2.TestEnum?> nullableEnumList;

  final List<List<_i2.TestEnum>> enumListList;

  late Function({
    int? id,
    _i2.TestEnum? testEnum,
    _i2.TestEnum? nullableEnum,
    List<_i2.TestEnum>? enumList,
    List<_i2.TestEnum?>? nullableEnumList,
    List<List<_i2.TestEnum>>? enumListList,
  }) copyWith = _copyWith;

  @override
  String get tableName => 'object_with_enum';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testEnum': testEnum,
      'nullableEnum': nullableEnum,
      'enumList': enumList,
      'nullableEnumList': nullableEnumList,
      'enumListList': enumListList,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ObjectWithEnum &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.testEnum,
                  testEnum,
                ) ||
                other.testEnum == testEnum) &&
            (identical(
                  other.nullableEnum,
                  nullableEnum,
                ) ||
                other.nullableEnum == nullableEnum) &&
            const _i3.DeepCollectionEquality().equals(
              enumList,
              other.enumList,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              nullableEnumList,
              other.nullableEnumList,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              enumListList,
              other.enumListList,
            ));
  }

  @override
  int get hashCode => Object.hash(
        id,
        testEnum,
        nullableEnum,
        const _i3.DeepCollectionEquality().hash(enumList),
        const _i3.DeepCollectionEquality().hash(nullableEnumList),
        const _i3.DeepCollectionEquality().hash(enumListList),
      );

  ObjectWithEnum _copyWith({
    Object? id = _Undefined,
    _i2.TestEnum? testEnum,
    Object? nullableEnum = _Undefined,
    List<_i2.TestEnum>? enumList,
    List<_i2.TestEnum?>? nullableEnumList,
    List<List<_i2.TestEnum>>? enumListList,
  }) {
    return ObjectWithEnum(
      id: id == _Undefined ? this.id : (id as int?),
      testEnum: testEnum ?? this.testEnum,
      nullableEnum: nullableEnum == _Undefined
          ? this.nullableEnum
          : (nullableEnum as _i2.TestEnum?),
      enumList: enumList ?? this.enumList,
      nullableEnumList: nullableEnumList ?? this.nullableEnumList,
      enumListList: enumListList ?? this.enumListList,
    );
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'testEnum': testEnum,
      'nullableEnum': nullableEnum,
      'enumList': enumList,
      'nullableEnumList': nullableEnumList,
      'enumListList': enumListList,
    };
  }

  static Future<List<ObjectWithEnum>> find(
    _i1.Session session, {
    ObjectWithEnumExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithEnum>(
      where: where != null ? where(ObjectWithEnum.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithEnum?> findSingleRow(
    _i1.Session session, {
    ObjectWithEnumExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectWithEnum>(
      where: where != null ? where(ObjectWithEnum.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithEnum?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithEnum>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ObjectWithEnumExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithEnum>(
      where: where(ObjectWithEnum.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    ObjectWithEnum row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    ObjectWithEnum row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    ObjectWithEnum row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    ObjectWithEnumExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithEnum>(
      where: where != null ? where(ObjectWithEnum.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ObjectWithEnumExpressionBuilder = _i1.Expression Function(
    ObjectWithEnumTable);

class ObjectWithEnumTable extends _i1.Table {
  ObjectWithEnumTable() : super(tableName: 'object_with_enum');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = _i1.ColumnInt('id');

  final testEnum = _i1.ColumnEnum('testEnum');

  final nullableEnum = _i1.ColumnEnum('nullableEnum');

  final enumList = _i1.ColumnSerializable('enumList');

  final nullableEnumList = _i1.ColumnSerializable('nullableEnumList');

  final enumListList = _i1.ColumnSerializable('enumListList');

  @override
  List<_i1.Column> get columns => [
        id,
        testEnum,
        nullableEnum,
        enumList,
        nullableEnumList,
        enumListList,
      ];
}

@Deprecated('Use ObjectWithEnumTable.t instead.')
ObjectWithEnumTable tObjectWithEnum = ObjectWithEnumTable();

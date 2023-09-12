/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

abstract class ObjectWithEnum extends _i1.TableRow {
  ObjectWithEnum._({
    int? id,
    required this.testEnum,
    this.nullableEnum,
    required this.enumList,
    required this.nullableEnumList,
    required this.enumListList,
  }) : super(id);

  factory ObjectWithEnum({
    int? id,
    required _i2.TestEnum testEnum,
    _i2.TestEnum? nullableEnum,
    required List<_i2.TestEnum> enumList,
    required List<_i2.TestEnum?> nullableEnumList,
    required List<List<_i2.TestEnum>> enumListList,
  }) = _ObjectWithEnumImpl;

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

  static final t = ObjectWithEnumTable();

  _i2.TestEnum testEnum;

  _i2.TestEnum? nullableEnum;

  List<_i2.TestEnum> enumList;

  List<_i2.TestEnum?> nullableEnumList;

  List<List<_i2.TestEnum>> enumListList;

  @override
  String get tableName => 'object_with_enum';
  ObjectWithEnum copyWith({
    int? id,
    _i2.TestEnum? testEnum,
    _i2.TestEnum? nullableEnum,
    List<_i2.TestEnum>? enumList,
    List<_i2.TestEnum?>? nullableEnumList,
    List<List<_i2.TestEnum>>? enumListList,
  });
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

  @override
  Map<String, dynamic> allToJson() {
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
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'testEnum':
        testEnum = value;
        return;
      case 'nullableEnum':
        nullableEnum = value;
        return;
      case 'enumList':
        enumList = value;
        return;
      case 'nullableEnumList':
        nullableEnumList = value;
        return;
      case 'enumListList':
        enumListList = value;
        return;
      default:
        throw UnimplementedError();
    }
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

  static ObjectWithEnumInclude include() {
    return ObjectWithEnumInclude._();
  }
}

class _Undefined {}

class _ObjectWithEnumImpl extends ObjectWithEnum {
  _ObjectWithEnumImpl({
    int? id,
    required _i2.TestEnum testEnum,
    _i2.TestEnum? nullableEnum,
    required List<_i2.TestEnum> enumList,
    required List<_i2.TestEnum?> nullableEnumList,
    required List<List<_i2.TestEnum>> enumListList,
  }) : super._(
          id: id,
          testEnum: testEnum,
          nullableEnum: nullableEnum,
          enumList: enumList,
          nullableEnumList: nullableEnumList,
          enumListList: enumListList,
        );

  @override
  ObjectWithEnum copyWith({
    Object? id = _Undefined,
    _i2.TestEnum? testEnum,
    Object? nullableEnum = _Undefined,
    List<_i2.TestEnum>? enumList,
    List<_i2.TestEnum?>? nullableEnumList,
    List<List<_i2.TestEnum>>? enumListList,
  }) {
    return ObjectWithEnum(
      id: id is! int? ? this.id : id,
      testEnum: testEnum ?? this.testEnum,
      nullableEnum:
          nullableEnum is! _i2.TestEnum? ? this.nullableEnum : nullableEnum,
      enumList: enumList ?? this.enumList.clone(),
      nullableEnumList: nullableEnumList ?? this.nullableEnumList.clone(),
      enumListList: enumListList ?? this.enumListList.clone(),
    );
  }
}

typedef ObjectWithEnumExpressionBuilder = _i1.Expression Function(
    ObjectWithEnumTable);

class ObjectWithEnumTable extends _i1.Table {
  ObjectWithEnumTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'object_with_enum') {
    testEnum = _i1.ColumnEnum<_i2.TestEnum>(
      'testEnum',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    nullableEnum = _i1.ColumnEnum<_i2.TestEnum>(
      'nullableEnum',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    enumList = _i1.ColumnSerializable(
      'enumList',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    nullableEnumList = _i1.ColumnSerializable(
      'nullableEnumList',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    enumListList = _i1.ColumnSerializable(
      'enumListList',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  late final _i1.ColumnEnum<_i2.TestEnum> testEnum;

  late final _i1.ColumnEnum<_i2.TestEnum> nullableEnum;

  late final _i1.ColumnSerializable enumList;

  late final _i1.ColumnSerializable nullableEnumList;

  late final _i1.ColumnSerializable enumListList;

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

class ObjectWithEnumInclude extends _i1.Include {
  ObjectWithEnumInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => ObjectWithEnum.t;
}

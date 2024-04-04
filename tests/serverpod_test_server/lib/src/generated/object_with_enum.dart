/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

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

  factory ObjectWithEnum.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithEnum(
      id: jsonSerialization['id'] as int?,
      testEnum: _i2.TestEnum.fromJson((jsonSerialization['testEnum'] as int)),
      nullableEnum: jsonSerialization.containsKey('nullableEnum')
          ? _i2.TestEnum.fromJson((jsonSerialization['nullableEnum'] as int))
          : null,
      enumList: (jsonSerialization['enumList'] as List<dynamic>)
          .map((e) => _i2.TestEnum.fromJson((e as int)))
          .toList(),
      nullableEnumList: (jsonSerialization['nullableEnumList'] as List<dynamic>)
          .map((e) => _i2.TestEnum.fromJson((e as int)))
          .toList(),
      enumListList: (jsonSerialization['enumListList'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => _i2.TestEnum.fromJson((e as int)))
              .toList())
          .toList(),
    );
  }

  static final t = ObjectWithEnumTable();

  static const db = ObjectWithEnumRepository._();

  _i2.TestEnum testEnum;

  _i2.TestEnum? nullableEnum;

  List<_i2.TestEnum> enumList;

  List<_i2.TestEnum?> nullableEnumList;

  List<List<_i2.TestEnum>> enumListList;

  @override
  _i1.Table get table => t;

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
      if (id != null) 'id': id,
      'testEnum': testEnum.toJson(),
      if (nullableEnum != null) 'nullableEnum': nullableEnum?.toJson(),
      'enumList': enumList.toJson(valueToJson: (v) => v.toJson()),
      'nullableEnumList':
          nullableEnumList.toJson(valueToJson: (v) => v?.toJson()),
      'enumListList': enumListList.toJson(
          valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson())),
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'testEnum': testEnum.toJson(),
      if (nullableEnum != null) 'nullableEnum': nullableEnum?.toJson(),
      'enumList': enumList.toJson(valueToJson: (v) => v.toJson()),
      'nullableEnumList':
          nullableEnumList.toJson(valueToJson: (v) => v?.toJson()),
      'enumListList': enumListList.toJson(
          valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson())),
    };
  }

  static ObjectWithEnumInclude include() {
    return ObjectWithEnumInclude._();
  }

  static ObjectWithEnumIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithEnumTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithEnumTable>? orderByList,
    ObjectWithEnumInclude? include,
  }) {
    return ObjectWithEnumIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithEnum.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithEnum.t),
      include: include,
    );
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
      id: id is int? ? id : this.id,
      testEnum: testEnum ?? this.testEnum,
      nullableEnum:
          nullableEnum is _i2.TestEnum? ? nullableEnum : this.nullableEnum,
      enumList: enumList ?? this.enumList.clone(),
      nullableEnumList: nullableEnumList ?? this.nullableEnumList.clone(),
      enumListList: enumListList ?? this.enumListList.clone(),
    );
  }
}

class ObjectWithEnumTable extends _i1.Table {
  ObjectWithEnumTable({super.tableRelation})
      : super(tableName: 'object_with_enum') {
    testEnum = _i1.ColumnEnum(
      'testEnum',
      this,
      _i1.EnumSerialization.byIndex,
    );
    nullableEnum = _i1.ColumnEnum(
      'nullableEnum',
      this,
      _i1.EnumSerialization.byIndex,
    );
    enumList = _i1.ColumnSerializable(
      'enumList',
      this,
    );
    nullableEnumList = _i1.ColumnSerializable(
      'nullableEnumList',
      this,
    );
    enumListList = _i1.ColumnSerializable(
      'enumListList',
      this,
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

class ObjectWithEnumInclude extends _i1.IncludeObject {
  ObjectWithEnumInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectWithEnum.t;
}

class ObjectWithEnumIncludeList extends _i1.IncludeList {
  ObjectWithEnumIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithEnum.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectWithEnum.t;
}

class ObjectWithEnumRepository {
  const ObjectWithEnumRepository._();

  Future<List<ObjectWithEnum>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithEnumTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithEnumTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithEnum>(
      where: where?.call(ObjectWithEnum.t),
      orderBy: orderBy?.call(ObjectWithEnum.t),
      orderByList: orderByList?.call(ObjectWithEnum.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectWithEnum?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithEnumTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithEnumTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithEnum>(
      where: where?.call(ObjectWithEnum.t),
      orderBy: orderBy?.call(ObjectWithEnum.t),
      orderByList: orderByList?.call(ObjectWithEnum.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectWithEnum?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithEnum>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithEnum>> insert(
    _i1.Session session,
    List<ObjectWithEnum> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithEnum>(
      rows,
      transaction: transaction,
    );
  }

  Future<ObjectWithEnum> insertRow(
    _i1.Session session,
    ObjectWithEnum row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithEnum>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithEnum>> update(
    _i1.Session session,
    List<ObjectWithEnum> rows, {
    _i1.ColumnSelections<ObjectWithEnumTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithEnum>(
      rows,
      columns: columns?.call(ObjectWithEnum.t),
      transaction: transaction,
    );
  }

  Future<ObjectWithEnum> updateRow(
    _i1.Session session,
    ObjectWithEnum row, {
    _i1.ColumnSelections<ObjectWithEnumTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithEnum>(
      row,
      columns: columns?.call(ObjectWithEnum.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<ObjectWithEnum> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithEnum>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ObjectWithEnum row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithEnum>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithEnumTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithEnum>(
      where: where(ObjectWithEnum.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithEnum>(
      where: where?.call(ObjectWithEnum.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

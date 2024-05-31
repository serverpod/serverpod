/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;
import 'protocol.dart' as _i3;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class Types extends _i1.TableRow implements _i1.ProtocolSerialization {
  Types._({
    int? id,
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
    this.aByteData,
    this.aDuration,
    this.aUuid,
    this.anEnum,
    this.aStringifiedEnum,
  }) : super(id);

  factory Types({
    int? id,
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
    _i2.ByteData? aByteData,
    Duration? aDuration,
    _i1.UuidValue? aUuid,
    _i3.TestEnum? anEnum,
    _i3.TestEnumStringified? aStringifiedEnum,
  }) = _TypesImpl;

  factory Types.fromJson(Map<String, dynamic> jsonSerialization) {
    return Types(
      id: jsonSerialization['id'] as int?,
      anInt: jsonSerialization['anInt'] as int?,
      aBool: jsonSerialization['aBool'] as bool?,
      aDouble: (jsonSerialization['aDouble'] as num?)?.toDouble(),
      aDateTime: jsonSerialization['aDateTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['aDateTime']),
      aString: jsonSerialization['aString'] as String?,
      aByteData: jsonSerialization['aByteData'] == null
          ? null
          : _i1.ByteDataJsonExtension.fromJson(jsonSerialization['aByteData']),
      aDuration: jsonSerialization['aDuration'] == null
          ? null
          : _i1.DurationJsonExtension.fromJson(jsonSerialization['aDuration']),
      aUuid: jsonSerialization['aUuid'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['aUuid']),
      anEnum: jsonSerialization['anEnum'] == null
          ? null
          : _i3.TestEnum.fromJson((jsonSerialization['anEnum'] as int)),
      aStringifiedEnum: jsonSerialization['aStringifiedEnum'] == null
          ? null
          : _i3.TestEnumStringified.fromJson(
              (jsonSerialization['aStringifiedEnum'] as String)),
    );
  }

  static final t = TypesTable();

  static const db = TypesRepository._();

  int? anInt;

  bool? aBool;

  double? aDouble;

  DateTime? aDateTime;

  String? aString;

  _i2.ByteData? aByteData;

  Duration? aDuration;

  _i1.UuidValue? aUuid;

  _i3.TestEnum? anEnum;

  _i3.TestEnumStringified? aStringifiedEnum;

  @override
  _i1.Table get table => t;

  Types copyWith({
    int? id,
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
    _i2.ByteData? aByteData,
    Duration? aDuration,
    _i1.UuidValue? aUuid,
    _i3.TestEnum? anEnum,
    _i3.TestEnumStringified? aStringifiedEnum,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (anInt != null) 'anInt': anInt,
      if (aBool != null) 'aBool': aBool,
      if (aDouble != null) 'aDouble': aDouble,
      if (aDateTime != null) 'aDateTime': aDateTime?.toJson(),
      if (aString != null) 'aString': aString,
      if (aByteData != null) 'aByteData': aByteData?.toJson(),
      if (aDuration != null) 'aDuration': aDuration?.toJson(),
      if (aUuid != null) 'aUuid': aUuid?.toJson(),
      if (anEnum != null) 'anEnum': anEnum?.toJson(),
      if (aStringifiedEnum != null)
        'aStringifiedEnum': aStringifiedEnum?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (anInt != null) 'anInt': anInt,
      if (aBool != null) 'aBool': aBool,
      if (aDouble != null) 'aDouble': aDouble,
      if (aDateTime != null) 'aDateTime': aDateTime?.toJson(),
      if (aString != null) 'aString': aString,
      if (aByteData != null) 'aByteData': aByteData?.toJson(),
      if (aDuration != null) 'aDuration': aDuration?.toJson(),
      if (aUuid != null) 'aUuid': aUuid?.toJson(),
      if (anEnum != null) 'anEnum': anEnum?.toJson(),
      if (aStringifiedEnum != null)
        'aStringifiedEnum': aStringifiedEnum?.toJson(),
    };
  }

  static TypesInclude include() {
    return TypesInclude._();
  }

  static TypesIncludeList includeList({
    _i1.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TypesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TypesTable>? orderByList,
    TypesInclude? include,
  }) {
    return TypesIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Types.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Types.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TypesImpl extends Types {
  _TypesImpl({
    int? id,
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
    _i2.ByteData? aByteData,
    Duration? aDuration,
    _i1.UuidValue? aUuid,
    _i3.TestEnum? anEnum,
    _i3.TestEnumStringified? aStringifiedEnum,
  }) : super._(
          id: id,
          anInt: anInt,
          aBool: aBool,
          aDouble: aDouble,
          aDateTime: aDateTime,
          aString: aString,
          aByteData: aByteData,
          aDuration: aDuration,
          aUuid: aUuid,
          anEnum: anEnum,
          aStringifiedEnum: aStringifiedEnum,
        );

  @override
  Types copyWith({
    Object? id = _Undefined,
    Object? anInt = _Undefined,
    Object? aBool = _Undefined,
    Object? aDouble = _Undefined,
    Object? aDateTime = _Undefined,
    Object? aString = _Undefined,
    Object? aByteData = _Undefined,
    Object? aDuration = _Undefined,
    Object? aUuid = _Undefined,
    Object? anEnum = _Undefined,
    Object? aStringifiedEnum = _Undefined,
  }) {
    return Types(
      id: id is int? ? id : this.id,
      anInt: anInt is int? ? anInt : this.anInt,
      aBool: aBool is bool? ? aBool : this.aBool,
      aDouble: aDouble is double? ? aDouble : this.aDouble,
      aDateTime: aDateTime is DateTime? ? aDateTime : this.aDateTime,
      aString: aString is String? ? aString : this.aString,
      aByteData:
          aByteData is _i2.ByteData? ? aByteData : this.aByteData?.clone(),
      aDuration: aDuration is Duration? ? aDuration : this.aDuration,
      aUuid: aUuid is _i1.UuidValue? ? aUuid : this.aUuid,
      anEnum: anEnum is _i3.TestEnum? ? anEnum : this.anEnum,
      aStringifiedEnum: aStringifiedEnum is _i3.TestEnumStringified?
          ? aStringifiedEnum
          : this.aStringifiedEnum,
    );
  }
}

class TypesTable extends _i1.Table {
  TypesTable({super.tableRelation}) : super(tableName: 'types') {
    anInt = _i1.ColumnInt(
      'anInt',
      this,
    );
    aBool = _i1.ColumnBool(
      'aBool',
      this,
    );
    aDouble = _i1.ColumnDouble(
      'aDouble',
      this,
    );
    aDateTime = _i1.ColumnDateTime(
      'aDateTime',
      this,
    );
    aString = _i1.ColumnString(
      'aString',
      this,
    );
    aByteData = _i1.ColumnByteData(
      'aByteData',
      this,
    );
    aDuration = _i1.ColumnDuration(
      'aDuration',
      this,
    );
    aUuid = _i1.ColumnUuid(
      'aUuid',
      this,
    );
    anEnum = _i1.ColumnEnum(
      'anEnum',
      this,
      _i1.EnumSerialization.byIndex,
    );
    aStringifiedEnum = _i1.ColumnEnum(
      'aStringifiedEnum',
      this,
      _i1.EnumSerialization.byName,
    );
  }

  late final _i1.ColumnInt anInt;

  late final _i1.ColumnBool aBool;

  late final _i1.ColumnDouble aDouble;

  late final _i1.ColumnDateTime aDateTime;

  late final _i1.ColumnString aString;

  late final _i1.ColumnByteData aByteData;

  late final _i1.ColumnDuration aDuration;

  late final _i1.ColumnUuid aUuid;

  late final _i1.ColumnEnum<_i3.TestEnum> anEnum;

  late final _i1.ColumnEnum<_i3.TestEnumStringified> aStringifiedEnum;

  @override
  List<_i1.Column> get columns => [
        id,
        anInt,
        aBool,
        aDouble,
        aDateTime,
        aString,
        aByteData,
        aDuration,
        aUuid,
        anEnum,
        aStringifiedEnum,
      ];
}

class TypesInclude extends _i1.IncludeObject {
  TypesInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => Types.t;
}

class TypesIncludeList extends _i1.IncludeList {
  TypesIncludeList._({
    _i1.WhereExpressionBuilder<TypesTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Types.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Types.t;
}

class TypesRepository {
  const TypesRepository._();

  Future<List<Types>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TypesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TypesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Types>(
      where: where?.call(Types.t),
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<Types?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesTable>? where,
    int? offset,
    _i1.OrderByBuilder<TypesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TypesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Types>(
      where: where?.call(Types.t),
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<Types?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Types>(
      id,
      transaction: transaction,
    );
  }

  Future<List<Types>> insert(
    _i1.Session session,
    List<Types> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Types>(
      rows,
      transaction: transaction,
    );
  }

  Future<Types> insertRow(
    _i1.Session session,
    Types row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Types>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Types>> update(
    _i1.Session session,
    List<Types> rows, {
    _i1.ColumnSelections<TypesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Types>(
      rows,
      columns: columns?.call(Types.t),
      transaction: transaction,
    );
  }

  Future<Types> updateRow(
    _i1.Session session,
    Types row, {
    _i1.ColumnSelections<TypesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Types>(
      row,
      columns: columns?.call(Types.t),
      transaction: transaction,
    );
  }

  Future<List<Types>> delete(
    _i1.Session session,
    List<Types> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Types>(
      rows,
      transaction: transaction,
    );
  }

  Future<Types> deleteRow(
    _i1.Session session,
    Types row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Types>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Types>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TypesTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Types>(
      where: where(Types.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Types>(
      where: where?.call(Types.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

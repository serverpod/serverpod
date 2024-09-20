/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class EnumDefault extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  EnumDefault._({
    int? id,
    _i2.ByNameEnum? byNameEnumDefault,
    _i2.ByNameEnum? byNameEnumDefaultNull,
    _i2.ByIndexEnum? byIndexEnumDefault,
    _i2.ByIndexEnum? byIndexEnumDefaultNull,
  })  : byNameEnumDefault = byNameEnumDefault ?? _i2.ByNameEnum.byName1,
        byNameEnumDefaultNull = byNameEnumDefaultNull ?? _i2.ByNameEnum.byName2,
        byIndexEnumDefault = byIndexEnumDefault ?? _i2.ByIndexEnum.byIndex1,
        byIndexEnumDefaultNull =
            byIndexEnumDefaultNull ?? _i2.ByIndexEnum.byIndex2,
        super(id);

  factory EnumDefault({
    int? id,
    _i2.ByNameEnum? byNameEnumDefault,
    _i2.ByNameEnum? byNameEnumDefaultNull,
    _i2.ByIndexEnum? byIndexEnumDefault,
    _i2.ByIndexEnum? byIndexEnumDefaultNull,
  }) = _EnumDefaultImpl;

  factory EnumDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnumDefault(
      id: jsonSerialization['id'] as int?,
      byNameEnumDefault: _i2.ByNameEnum.fromJson(
          (jsonSerialization['byNameEnumDefault'] as String)),
      byNameEnumDefaultNull: jsonSerialization['byNameEnumDefaultNull'] == null
          ? null
          : _i2.ByNameEnum.fromJson(
              (jsonSerialization['byNameEnumDefaultNull'] as String)),
      byIndexEnumDefault: _i2.ByIndexEnum.fromJson(
          (jsonSerialization['byIndexEnumDefault'] as int)),
      byIndexEnumDefaultNull:
          jsonSerialization['byIndexEnumDefaultNull'] == null
              ? null
              : _i2.ByIndexEnum.fromJson(
                  (jsonSerialization['byIndexEnumDefaultNull'] as int)),
    );
  }

  static final t = EnumDefaultTable();

  static const db = EnumDefaultRepository._();

  _i2.ByNameEnum byNameEnumDefault;

  _i2.ByNameEnum? byNameEnumDefaultNull;

  _i2.ByIndexEnum byIndexEnumDefault;

  _i2.ByIndexEnum? byIndexEnumDefaultNull;

  @override
  _i1.Table get table => t;

  EnumDefault copyWith({
    int? id,
    _i2.ByNameEnum? byNameEnumDefault,
    _i2.ByNameEnum? byNameEnumDefaultNull,
    _i2.ByIndexEnum? byIndexEnumDefault,
    _i2.ByIndexEnum? byIndexEnumDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'byNameEnumDefault': byNameEnumDefault.toJson(),
      if (byNameEnumDefaultNull != null)
        'byNameEnumDefaultNull': byNameEnumDefaultNull?.toJson(),
      'byIndexEnumDefault': byIndexEnumDefault.toJson(),
      if (byIndexEnumDefaultNull != null)
        'byIndexEnumDefaultNull': byIndexEnumDefaultNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'byNameEnumDefault': byNameEnumDefault.toJson(),
      if (byNameEnumDefaultNull != null)
        'byNameEnumDefaultNull': byNameEnumDefaultNull?.toJson(),
      'byIndexEnumDefault': byIndexEnumDefault.toJson(),
      if (byIndexEnumDefaultNull != null)
        'byIndexEnumDefaultNull': byIndexEnumDefaultNull?.toJson(),
    };
  }

  static EnumDefaultInclude include() {
    return EnumDefaultInclude._();
  }

  static EnumDefaultIncludeList includeList({
    _i1.WhereExpressionBuilder<EnumDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnumDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnumDefaultTable>? orderByList,
    EnumDefaultInclude? include,
  }) {
    return EnumDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnumDefault.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EnumDefault.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnumDefaultImpl extends EnumDefault {
  _EnumDefaultImpl({
    int? id,
    _i2.ByNameEnum? byNameEnumDefault,
    _i2.ByNameEnum? byNameEnumDefaultNull,
    _i2.ByIndexEnum? byIndexEnumDefault,
    _i2.ByIndexEnum? byIndexEnumDefaultNull,
  }) : super._(
          id: id,
          byNameEnumDefault: byNameEnumDefault,
          byNameEnumDefaultNull: byNameEnumDefaultNull,
          byIndexEnumDefault: byIndexEnumDefault,
          byIndexEnumDefaultNull: byIndexEnumDefaultNull,
        );

  @override
  EnumDefault copyWith({
    Object? id = _Undefined,
    _i2.ByNameEnum? byNameEnumDefault,
    Object? byNameEnumDefaultNull = _Undefined,
    _i2.ByIndexEnum? byIndexEnumDefault,
    Object? byIndexEnumDefaultNull = _Undefined,
  }) {
    return EnumDefault(
      id: id is int? ? id : this.id,
      byNameEnumDefault: byNameEnumDefault ?? this.byNameEnumDefault,
      byNameEnumDefaultNull: byNameEnumDefaultNull is _i2.ByNameEnum?
          ? byNameEnumDefaultNull
          : this.byNameEnumDefaultNull,
      byIndexEnumDefault: byIndexEnumDefault ?? this.byIndexEnumDefault,
      byIndexEnumDefaultNull: byIndexEnumDefaultNull is _i2.ByIndexEnum?
          ? byIndexEnumDefaultNull
          : this.byIndexEnumDefaultNull,
    );
  }
}

class EnumDefaultTable extends _i1.Table {
  EnumDefaultTable({super.tableRelation}) : super(tableName: 'enum_default') {
    byNameEnumDefault = _i1.ColumnEnum(
      'byNameEnumDefault',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    byNameEnumDefaultNull = _i1.ColumnEnum(
      'byNameEnumDefaultNull',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    byIndexEnumDefault = _i1.ColumnEnum(
      'byIndexEnumDefault',
      this,
      _i1.EnumSerialization.byIndex,
      hasDefault: true,
    );
    byIndexEnumDefaultNull = _i1.ColumnEnum(
      'byIndexEnumDefaultNull',
      this,
      _i1.EnumSerialization.byIndex,
      hasDefault: true,
    );
  }

  late final _i1.ColumnEnum<_i2.ByNameEnum> byNameEnumDefault;

  late final _i1.ColumnEnum<_i2.ByNameEnum> byNameEnumDefaultNull;

  late final _i1.ColumnEnum<_i2.ByIndexEnum> byIndexEnumDefault;

  late final _i1.ColumnEnum<_i2.ByIndexEnum> byIndexEnumDefaultNull;

  @override
  List<_i1.Column> get columns => [
        id,
        byNameEnumDefault,
        byNameEnumDefaultNull,
        byIndexEnumDefault,
        byIndexEnumDefaultNull,
      ];
}

class EnumDefaultInclude extends _i1.IncludeObject {
  EnumDefaultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => EnumDefault.t;
}

class EnumDefaultIncludeList extends _i1.IncludeList {
  EnumDefaultIncludeList._({
    _i1.WhereExpressionBuilder<EnumDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EnumDefault.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => EnumDefault.t;
}

class EnumDefaultRepository {
  const EnumDefaultRepository._();

  Future<List<EnumDefault>> find(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<EnumDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnumDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnumDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.find<EnumDefault>(
      where: where?.call(EnumDefault.t),
      orderBy: orderBy?.call(EnumDefault.t),
      orderByList: orderByList?.call(EnumDefault.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<EnumDefault?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<EnumDefaultTable>? where,
    int? offset,
    _i1.OrderByBuilder<EnumDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnumDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findFirstRow<EnumDefault>(
      where: where?.call(EnumDefault.t),
      orderBy: orderBy?.call(EnumDefault.t),
      orderByList: orderByList?.call(EnumDefault.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<EnumDefault?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findById<EnumDefault>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<EnumDefault>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<EnumDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<EnumDefault>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<EnumDefault> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    EnumDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<EnumDefault>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<EnumDefault>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<EnumDefault> rows, {
    _i1.ColumnSelections<EnumDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<EnumDefault>(
      rows,
      columns: columns?.call(EnumDefault.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<EnumDefault> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    EnumDefault row, {
    _i1.ColumnSelections<EnumDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<EnumDefault>(
      row,
      columns: columns?.call(EnumDefault.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<EnumDefault>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<EnumDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<EnumDefault>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<EnumDefault> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    EnumDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<EnumDefault>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<EnumDefault>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<EnumDefaultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<EnumDefault>(
      where: where(EnumDefault.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<EnumDefaultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<EnumDefault>(
      where: where?.call(EnumDefault.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

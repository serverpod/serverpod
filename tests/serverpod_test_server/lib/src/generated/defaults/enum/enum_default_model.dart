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
import '../../defaults/enum/enums/by_name_enum.dart' as _i2;
import '../../defaults/enum/enums/by_index_enum.dart' as _i3;

abstract class EnumDefaultModel
    implements _i1.TableRow, _i1.ProtocolSerialization {
  EnumDefaultModel._({
    this.id,
    _i2.ByNameEnum? byNameEnumDefaultModel,
    _i2.ByNameEnum? byNameEnumDefaultModelNull,
    _i3.ByIndexEnum? byIndexEnumDefaultModel,
    _i3.ByIndexEnum? byIndexEnumDefaultModelNull,
  })  : byNameEnumDefaultModel =
            byNameEnumDefaultModel ?? _i2.ByNameEnum.byName1,
        byNameEnumDefaultModelNull =
            byNameEnumDefaultModelNull ?? _i2.ByNameEnum.byName2,
        byIndexEnumDefaultModel =
            byIndexEnumDefaultModel ?? _i3.ByIndexEnum.byIndex1,
        byIndexEnumDefaultModelNull =
            byIndexEnumDefaultModelNull ?? _i3.ByIndexEnum.byIndex2;

  factory EnumDefaultModel({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultModel,
    _i2.ByNameEnum? byNameEnumDefaultModelNull,
    _i3.ByIndexEnum? byIndexEnumDefaultModel,
    _i3.ByIndexEnum? byIndexEnumDefaultModelNull,
  }) = _EnumDefaultModelImpl;

  factory EnumDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnumDefaultModel(
      id: jsonSerialization['id'] as int?,
      byNameEnumDefaultModel: _i2.ByNameEnum.fromJson(
          (jsonSerialization['byNameEnumDefaultModel'] as String)),
      byNameEnumDefaultModelNull:
          jsonSerialization['byNameEnumDefaultModelNull'] == null
              ? null
              : _i2.ByNameEnum.fromJson(
                  (jsonSerialization['byNameEnumDefaultModelNull'] as String)),
      byIndexEnumDefaultModel: _i3.ByIndexEnum.fromJson(
          (jsonSerialization['byIndexEnumDefaultModel'] as int)),
      byIndexEnumDefaultModelNull:
          jsonSerialization['byIndexEnumDefaultModelNull'] == null
              ? null
              : _i3.ByIndexEnum.fromJson(
                  (jsonSerialization['byIndexEnumDefaultModelNull'] as int)),
    );
  }

  static final t = EnumDefaultModelTable();

  static const db = EnumDefaultModelRepository._();

  @override
  int? id;

  _i2.ByNameEnum byNameEnumDefaultModel;

  _i2.ByNameEnum? byNameEnumDefaultModelNull;

  _i3.ByIndexEnum byIndexEnumDefaultModel;

  _i3.ByIndexEnum? byIndexEnumDefaultModelNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [EnumDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EnumDefaultModel copyWith({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultModel,
    _i2.ByNameEnum? byNameEnumDefaultModelNull,
    _i3.ByIndexEnum? byIndexEnumDefaultModel,
    _i3.ByIndexEnum? byIndexEnumDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'byNameEnumDefaultModel': byNameEnumDefaultModel.toJson(),
      if (byNameEnumDefaultModelNull != null)
        'byNameEnumDefaultModelNull': byNameEnumDefaultModelNull?.toJson(),
      'byIndexEnumDefaultModel': byIndexEnumDefaultModel.toJson(),
      if (byIndexEnumDefaultModelNull != null)
        'byIndexEnumDefaultModelNull': byIndexEnumDefaultModelNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'byNameEnumDefaultModel': byNameEnumDefaultModel.toJson(),
      if (byNameEnumDefaultModelNull != null)
        'byNameEnumDefaultModelNull': byNameEnumDefaultModelNull?.toJson(),
      'byIndexEnumDefaultModel': byIndexEnumDefaultModel.toJson(),
      if (byIndexEnumDefaultModelNull != null)
        'byIndexEnumDefaultModelNull': byIndexEnumDefaultModelNull?.toJson(),
    };
  }

  static EnumDefaultModelInclude include() {
    return EnumDefaultModelInclude._();
  }

  static EnumDefaultModelIncludeList includeList({
    _i1.WhereExpressionBuilder<EnumDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnumDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnumDefaultModelTable>? orderByList,
    EnumDefaultModelInclude? include,
  }) {
    return EnumDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnumDefaultModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EnumDefaultModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnumDefaultModelImpl extends EnumDefaultModel {
  _EnumDefaultModelImpl({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultModel,
    _i2.ByNameEnum? byNameEnumDefaultModelNull,
    _i3.ByIndexEnum? byIndexEnumDefaultModel,
    _i3.ByIndexEnum? byIndexEnumDefaultModelNull,
  }) : super._(
          id: id,
          byNameEnumDefaultModel: byNameEnumDefaultModel,
          byNameEnumDefaultModelNull: byNameEnumDefaultModelNull,
          byIndexEnumDefaultModel: byIndexEnumDefaultModel,
          byIndexEnumDefaultModelNull: byIndexEnumDefaultModelNull,
        );

  /// Returns a shallow copy of this [EnumDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EnumDefaultModel copyWith({
    Object? id = _Undefined,
    _i2.ByNameEnum? byNameEnumDefaultModel,
    Object? byNameEnumDefaultModelNull = _Undefined,
    _i3.ByIndexEnum? byIndexEnumDefaultModel,
    Object? byIndexEnumDefaultModelNull = _Undefined,
  }) {
    return EnumDefaultModel(
      id: id is int? ? id : this.id,
      byNameEnumDefaultModel:
          byNameEnumDefaultModel ?? this.byNameEnumDefaultModel,
      byNameEnumDefaultModelNull: byNameEnumDefaultModelNull is _i2.ByNameEnum?
          ? byNameEnumDefaultModelNull
          : this.byNameEnumDefaultModelNull,
      byIndexEnumDefaultModel:
          byIndexEnumDefaultModel ?? this.byIndexEnumDefaultModel,
      byIndexEnumDefaultModelNull:
          byIndexEnumDefaultModelNull is _i3.ByIndexEnum?
              ? byIndexEnumDefaultModelNull
              : this.byIndexEnumDefaultModelNull,
    );
  }
}

class EnumDefaultModelTable extends _i1.Table {
  EnumDefaultModelTable({super.tableRelation})
      : super(tableName: 'enum_default_model') {
    byNameEnumDefaultModel = _i1.ColumnEnum(
      'byNameEnumDefaultModel',
      this,
      _i1.EnumSerialization.byName,
    );
    byNameEnumDefaultModelNull = _i1.ColumnEnum(
      'byNameEnumDefaultModelNull',
      this,
      _i1.EnumSerialization.byName,
    );
    byIndexEnumDefaultModel = _i1.ColumnEnum(
      'byIndexEnumDefaultModel',
      this,
      _i1.EnumSerialization.byIndex,
    );
    byIndexEnumDefaultModelNull = _i1.ColumnEnum(
      'byIndexEnumDefaultModelNull',
      this,
      _i1.EnumSerialization.byIndex,
    );
  }

  late final _i1.ColumnEnum<_i2.ByNameEnum> byNameEnumDefaultModel;

  late final _i1.ColumnEnum<_i2.ByNameEnum> byNameEnumDefaultModelNull;

  late final _i1.ColumnEnum<_i3.ByIndexEnum> byIndexEnumDefaultModel;

  late final _i1.ColumnEnum<_i3.ByIndexEnum> byIndexEnumDefaultModelNull;

  @override
  List<_i1.Column> get columns => [
        id,
        byNameEnumDefaultModel,
        byNameEnumDefaultModelNull,
        byIndexEnumDefaultModel,
        byIndexEnumDefaultModelNull,
      ];
}

class EnumDefaultModelInclude extends _i1.IncludeObject {
  EnumDefaultModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => EnumDefaultModel.t;
}

class EnumDefaultModelIncludeList extends _i1.IncludeList {
  EnumDefaultModelIncludeList._({
    _i1.WhereExpressionBuilder<EnumDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EnumDefaultModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => EnumDefaultModel.t;
}

class EnumDefaultModelRepository {
  const EnumDefaultModelRepository._();

  Future<List<EnumDefaultModel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnumDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnumDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnumDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EnumDefaultModel>(
      where: where?.call(EnumDefaultModel.t),
      orderBy: orderBy?.call(EnumDefaultModel.t),
      orderByList: orderByList?.call(EnumDefaultModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<EnumDefaultModel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnumDefaultModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<EnumDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnumDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EnumDefaultModel>(
      where: where?.call(EnumDefaultModel.t),
      orderBy: orderBy?.call(EnumDefaultModel.t),
      orderByList: orderByList?.call(EnumDefaultModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<EnumDefaultModel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EnumDefaultModel>(
      id,
      transaction: transaction,
    );
  }

  Future<List<EnumDefaultModel>> insert(
    _i1.Session session,
    List<EnumDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EnumDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  Future<EnumDefaultModel> insertRow(
    _i1.Session session,
    EnumDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EnumDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  Future<List<EnumDefaultModel>> update(
    _i1.Session session,
    List<EnumDefaultModel> rows, {
    _i1.ColumnSelections<EnumDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EnumDefaultModel>(
      rows,
      columns: columns?.call(EnumDefaultModel.t),
      transaction: transaction,
    );
  }

  Future<EnumDefaultModel> updateRow(
    _i1.Session session,
    EnumDefaultModel row, {
    _i1.ColumnSelections<EnumDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EnumDefaultModel>(
      row,
      columns: columns?.call(EnumDefaultModel.t),
      transaction: transaction,
    );
  }

  Future<List<EnumDefaultModel>> delete(
    _i1.Session session,
    List<EnumDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EnumDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  Future<EnumDefaultModel> deleteRow(
    _i1.Session session,
    EnumDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EnumDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  Future<List<EnumDefaultModel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EnumDefaultModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EnumDefaultModel>(
      where: where(EnumDefaultModel.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnumDefaultModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EnumDefaultModel>(
      where: where?.call(EnumDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

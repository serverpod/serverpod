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

abstract class EnumDefaultMix
    implements _i1.TableRow, _i1.ProtocolSerialization {
  EnumDefaultMix._({
    this.id,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _i2.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  })  : byNameEnumDefaultAndDefaultModel =
            byNameEnumDefaultAndDefaultModel ?? _i2.ByNameEnum.byName2,
        byNameEnumDefaultAndDefaultPersist =
            byNameEnumDefaultAndDefaultPersist ?? _i2.ByNameEnum.byName1,
        byNameEnumDefaultModelAndDefaultPersist =
            byNameEnumDefaultModelAndDefaultPersist ?? _i2.ByNameEnum.byName1;

  factory EnumDefaultMix({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _i2.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  }) = _EnumDefaultMixImpl;

  factory EnumDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnumDefaultMix(
      id: jsonSerialization['id'] as int?,
      byNameEnumDefaultAndDefaultModel: _i2.ByNameEnum.fromJson(
          (jsonSerialization['byNameEnumDefaultAndDefaultModel'] as String)),
      byNameEnumDefaultAndDefaultPersist: _i2.ByNameEnum.fromJson(
          (jsonSerialization['byNameEnumDefaultAndDefaultPersist'] as String)),
      byNameEnumDefaultModelAndDefaultPersist: _i2.ByNameEnum.fromJson(
          (jsonSerialization['byNameEnumDefaultModelAndDefaultPersist']
              as String)),
    );
  }

  static final t = EnumDefaultMixTable();

  static const db = EnumDefaultMixRepository._();

  @override
  int? id;

  _i2.ByNameEnum byNameEnumDefaultAndDefaultModel;

  _i2.ByNameEnum byNameEnumDefaultAndDefaultPersist;

  _i2.ByNameEnum byNameEnumDefaultModelAndDefaultPersist;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [EnumDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EnumDefaultMix copyWith({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _i2.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'byNameEnumDefaultAndDefaultModel':
          byNameEnumDefaultAndDefaultModel.toJson(),
      'byNameEnumDefaultAndDefaultPersist':
          byNameEnumDefaultAndDefaultPersist.toJson(),
      'byNameEnumDefaultModelAndDefaultPersist':
          byNameEnumDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'byNameEnumDefaultAndDefaultModel':
          byNameEnumDefaultAndDefaultModel.toJson(),
      'byNameEnumDefaultAndDefaultPersist':
          byNameEnumDefaultAndDefaultPersist.toJson(),
      'byNameEnumDefaultModelAndDefaultPersist':
          byNameEnumDefaultModelAndDefaultPersist.toJson(),
    };
  }

  static EnumDefaultMixInclude include() {
    return EnumDefaultMixInclude._();
  }

  static EnumDefaultMixIncludeList includeList({
    _i1.WhereExpressionBuilder<EnumDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnumDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnumDefaultMixTable>? orderByList,
    EnumDefaultMixInclude? include,
  }) {
    return EnumDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnumDefaultMix.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EnumDefaultMix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnumDefaultMixImpl extends EnumDefaultMix {
  _EnumDefaultMixImpl({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _i2.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          byNameEnumDefaultAndDefaultModel: byNameEnumDefaultAndDefaultModel,
          byNameEnumDefaultAndDefaultPersist:
              byNameEnumDefaultAndDefaultPersist,
          byNameEnumDefaultModelAndDefaultPersist:
              byNameEnumDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [EnumDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EnumDefaultMix copyWith({
    Object? id = _Undefined,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _i2.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  }) {
    return EnumDefaultMix(
      id: id is int? ? id : this.id,
      byNameEnumDefaultAndDefaultModel: byNameEnumDefaultAndDefaultModel ??
          this.byNameEnumDefaultAndDefaultModel,
      byNameEnumDefaultAndDefaultPersist: byNameEnumDefaultAndDefaultPersist ??
          this.byNameEnumDefaultAndDefaultPersist,
      byNameEnumDefaultModelAndDefaultPersist:
          byNameEnumDefaultModelAndDefaultPersist ??
              this.byNameEnumDefaultModelAndDefaultPersist,
    );
  }
}

class EnumDefaultMixTable extends _i1.Table {
  EnumDefaultMixTable({super.tableRelation})
      : super(tableName: 'enum_default_mix') {
    byNameEnumDefaultAndDefaultModel = _i1.ColumnEnum(
      'byNameEnumDefaultAndDefaultModel',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    byNameEnumDefaultAndDefaultPersist = _i1.ColumnEnum(
      'byNameEnumDefaultAndDefaultPersist',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    byNameEnumDefaultModelAndDefaultPersist = _i1.ColumnEnum(
      'byNameEnumDefaultModelAndDefaultPersist',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
  }

  late final _i1.ColumnEnum<_i2.ByNameEnum> byNameEnumDefaultAndDefaultModel;

  late final _i1.ColumnEnum<_i2.ByNameEnum> byNameEnumDefaultAndDefaultPersist;

  late final _i1.ColumnEnum<_i2.ByNameEnum>
      byNameEnumDefaultModelAndDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        byNameEnumDefaultAndDefaultModel,
        byNameEnumDefaultAndDefaultPersist,
        byNameEnumDefaultModelAndDefaultPersist,
      ];
}

class EnumDefaultMixInclude extends _i1.IncludeObject {
  EnumDefaultMixInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => EnumDefaultMix.t;
}

class EnumDefaultMixIncludeList extends _i1.IncludeList {
  EnumDefaultMixIncludeList._({
    _i1.WhereExpressionBuilder<EnumDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EnumDefaultMix.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => EnumDefaultMix.t;
}

class EnumDefaultMixRepository {
  const EnumDefaultMixRepository._();

  Future<List<EnumDefaultMix>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnumDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnumDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnumDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EnumDefaultMix>(
      where: where?.call(EnumDefaultMix.t),
      orderBy: orderBy?.call(EnumDefaultMix.t),
      orderByList: orderByList?.call(EnumDefaultMix.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<EnumDefaultMix?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnumDefaultMixTable>? where,
    int? offset,
    _i1.OrderByBuilder<EnumDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnumDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EnumDefaultMix>(
      where: where?.call(EnumDefaultMix.t),
      orderBy: orderBy?.call(EnumDefaultMix.t),
      orderByList: orderByList?.call(EnumDefaultMix.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<EnumDefaultMix?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EnumDefaultMix>(
      id,
      transaction: transaction,
    );
  }

  Future<List<EnumDefaultMix>> insert(
    _i1.Session session,
    List<EnumDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EnumDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  Future<EnumDefaultMix> insertRow(
    _i1.Session session,
    EnumDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EnumDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  Future<List<EnumDefaultMix>> update(
    _i1.Session session,
    List<EnumDefaultMix> rows, {
    _i1.ColumnSelections<EnumDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EnumDefaultMix>(
      rows,
      columns: columns?.call(EnumDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<EnumDefaultMix> updateRow(
    _i1.Session session,
    EnumDefaultMix row, {
    _i1.ColumnSelections<EnumDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EnumDefaultMix>(
      row,
      columns: columns?.call(EnumDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<List<EnumDefaultMix>> delete(
    _i1.Session session,
    List<EnumDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EnumDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  Future<EnumDefaultMix> deleteRow(
    _i1.Session session,
    EnumDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EnumDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  Future<List<EnumDefaultMix>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EnumDefaultMixTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EnumDefaultMix>(
      where: where(EnumDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnumDefaultMixTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EnumDefaultMix>(
      where: where?.call(EnumDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

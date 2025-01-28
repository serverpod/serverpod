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

abstract class EnumDefaultPersist
    implements _i1.TableRow, _i1.ProtocolSerialization {
  EnumDefaultPersist._({
    this.id,
    this.byNameEnumDefaultPersist,
    this.byIndexEnumDefaultPersist,
  });

  factory EnumDefaultPersist({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultPersist,
    _i3.ByIndexEnum? byIndexEnumDefaultPersist,
  }) = _EnumDefaultPersistImpl;

  factory EnumDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnumDefaultPersist(
      id: jsonSerialization['id'] as int?,
      byNameEnumDefaultPersist:
          jsonSerialization['byNameEnumDefaultPersist'] == null
              ? null
              : _i2.ByNameEnum.fromJson(
                  (jsonSerialization['byNameEnumDefaultPersist'] as String)),
      byIndexEnumDefaultPersist:
          jsonSerialization['byIndexEnumDefaultPersist'] == null
              ? null
              : _i3.ByIndexEnum.fromJson(
                  (jsonSerialization['byIndexEnumDefaultPersist'] as int)),
    );
  }

  static final t = EnumDefaultPersistTable();

  static const db = EnumDefaultPersistRepository._();

  @override
  int? id;

  _i2.ByNameEnum? byNameEnumDefaultPersist;

  _i3.ByIndexEnum? byIndexEnumDefaultPersist;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [EnumDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EnumDefaultPersist copyWith({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultPersist,
    _i3.ByIndexEnum? byIndexEnumDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (byNameEnumDefaultPersist != null)
        'byNameEnumDefaultPersist': byNameEnumDefaultPersist?.toJson(),
      if (byIndexEnumDefaultPersist != null)
        'byIndexEnumDefaultPersist': byIndexEnumDefaultPersist?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (byNameEnumDefaultPersist != null)
        'byNameEnumDefaultPersist': byNameEnumDefaultPersist?.toJson(),
      if (byIndexEnumDefaultPersist != null)
        'byIndexEnumDefaultPersist': byIndexEnumDefaultPersist?.toJson(),
    };
  }

  static EnumDefaultPersistInclude include() {
    return EnumDefaultPersistInclude._();
  }

  static EnumDefaultPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<EnumDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnumDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnumDefaultPersistTable>? orderByList,
    EnumDefaultPersistInclude? include,
  }) {
    return EnumDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnumDefaultPersist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EnumDefaultPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnumDefaultPersistImpl extends EnumDefaultPersist {
  _EnumDefaultPersistImpl({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultPersist,
    _i3.ByIndexEnum? byIndexEnumDefaultPersist,
  }) : super._(
          id: id,
          byNameEnumDefaultPersist: byNameEnumDefaultPersist,
          byIndexEnumDefaultPersist: byIndexEnumDefaultPersist,
        );

  /// Returns a shallow copy of this [EnumDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EnumDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? byNameEnumDefaultPersist = _Undefined,
    Object? byIndexEnumDefaultPersist = _Undefined,
  }) {
    return EnumDefaultPersist(
      id: id is int? ? id : this.id,
      byNameEnumDefaultPersist: byNameEnumDefaultPersist is _i2.ByNameEnum?
          ? byNameEnumDefaultPersist
          : this.byNameEnumDefaultPersist,
      byIndexEnumDefaultPersist: byIndexEnumDefaultPersist is _i3.ByIndexEnum?
          ? byIndexEnumDefaultPersist
          : this.byIndexEnumDefaultPersist,
    );
  }
}

class EnumDefaultPersistTable extends _i1.Table {
  EnumDefaultPersistTable({super.tableRelation})
      : super(tableName: 'enum_default_persist') {
    byNameEnumDefaultPersist = _i1.ColumnEnum(
      'byNameEnumDefaultPersist',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    byIndexEnumDefaultPersist = _i1.ColumnEnum(
      'byIndexEnumDefaultPersist',
      this,
      _i1.EnumSerialization.byIndex,
      hasDefault: true,
    );
  }

  late final _i1.ColumnEnum<_i2.ByNameEnum> byNameEnumDefaultPersist;

  late final _i1.ColumnEnum<_i3.ByIndexEnum> byIndexEnumDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        byNameEnumDefaultPersist,
        byIndexEnumDefaultPersist,
      ];
}

class EnumDefaultPersistInclude extends _i1.IncludeObject {
  EnumDefaultPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => EnumDefaultPersist.t;
}

class EnumDefaultPersistIncludeList extends _i1.IncludeList {
  EnumDefaultPersistIncludeList._({
    _i1.WhereExpressionBuilder<EnumDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EnumDefaultPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => EnumDefaultPersist.t;
}

class EnumDefaultPersistRepository {
  const EnumDefaultPersistRepository._();

  Future<List<EnumDefaultPersist>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnumDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnumDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnumDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EnumDefaultPersist>(
      where: where?.call(EnumDefaultPersist.t),
      orderBy: orderBy?.call(EnumDefaultPersist.t),
      orderByList: orderByList?.call(EnumDefaultPersist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<EnumDefaultPersist?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnumDefaultPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<EnumDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnumDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EnumDefaultPersist>(
      where: where?.call(EnumDefaultPersist.t),
      orderBy: orderBy?.call(EnumDefaultPersist.t),
      orderByList: orderByList?.call(EnumDefaultPersist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<EnumDefaultPersist?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EnumDefaultPersist>(
      id,
      transaction: transaction,
    );
  }

  Future<List<EnumDefaultPersist>> insert(
    _i1.Session session,
    List<EnumDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EnumDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  Future<EnumDefaultPersist> insertRow(
    _i1.Session session,
    EnumDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EnumDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  Future<List<EnumDefaultPersist>> update(
    _i1.Session session,
    List<EnumDefaultPersist> rows, {
    _i1.ColumnSelections<EnumDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EnumDefaultPersist>(
      rows,
      columns: columns?.call(EnumDefaultPersist.t),
      transaction: transaction,
    );
  }

  Future<EnumDefaultPersist> updateRow(
    _i1.Session session,
    EnumDefaultPersist row, {
    _i1.ColumnSelections<EnumDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EnumDefaultPersist>(
      row,
      columns: columns?.call(EnumDefaultPersist.t),
      transaction: transaction,
    );
  }

  Future<List<EnumDefaultPersist>> delete(
    _i1.Session session,
    List<EnumDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EnumDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  Future<EnumDefaultPersist> deleteRow(
    _i1.Session session,
    EnumDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EnumDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  Future<List<EnumDefaultPersist>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EnumDefaultPersistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EnumDefaultPersist>(
      where: where(EnumDefaultPersist.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnumDefaultPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EnumDefaultPersist>(
      where: where?.call(EnumDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

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

abstract class UuidDefaultMix
    implements _i1.TableRow, _i1.ProtocolSerialization {
  UuidDefaultMix._({
    this.id,
    _i1.UuidValue? uuidDefaultAndDefaultModel,
    _i1.UuidValue? uuidDefaultAndDefaultPersist,
    _i1.UuidValue? uuidDefaultModelAndDefaultPersist,
  })  : uuidDefaultAndDefaultModel = uuidDefaultAndDefaultModel ??
            _i1.UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        uuidDefaultAndDefaultPersist = uuidDefaultAndDefaultPersist ??
            _i1.UuidValue.fromString('6fa459ea-ee8a-3ca4-894e-db77e160355e'),
        uuidDefaultModelAndDefaultPersist = uuidDefaultModelAndDefaultPersist ??
            _i1.UuidValue.fromString('d9428888-122b-11e1-b85c-61cd3cbb3210');

  factory UuidDefaultMix({
    int? id,
    _i1.UuidValue? uuidDefaultAndDefaultModel,
    _i1.UuidValue? uuidDefaultAndDefaultPersist,
    _i1.UuidValue? uuidDefaultModelAndDefaultPersist,
  }) = _UuidDefaultMixImpl;

  factory UuidDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefaultMix(
      id: jsonSerialization['id'] as int?,
      uuidDefaultAndDefaultModel: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultAndDefaultModel']),
      uuidDefaultAndDefaultPersist: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultAndDefaultPersist']),
      uuidDefaultModelAndDefaultPersist: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultModelAndDefaultPersist']),
    );
  }

  static final t = UuidDefaultMixTable();

  static const db = UuidDefaultMixRepository._();

  @override
  int? id;

  _i1.UuidValue uuidDefaultAndDefaultModel;

  _i1.UuidValue uuidDefaultAndDefaultPersist;

  _i1.UuidValue uuidDefaultModelAndDefaultPersist;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [UuidDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UuidDefaultMix copyWith({
    int? id,
    _i1.UuidValue? uuidDefaultAndDefaultModel,
    _i1.UuidValue? uuidDefaultAndDefaultPersist,
    _i1.UuidValue? uuidDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uuidDefaultAndDefaultModel': uuidDefaultAndDefaultModel.toJson(),
      'uuidDefaultAndDefaultPersist': uuidDefaultAndDefaultPersist.toJson(),
      'uuidDefaultModelAndDefaultPersist':
          uuidDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'uuidDefaultAndDefaultModel': uuidDefaultAndDefaultModel.toJson(),
      'uuidDefaultAndDefaultPersist': uuidDefaultAndDefaultPersist.toJson(),
      'uuidDefaultModelAndDefaultPersist':
          uuidDefaultModelAndDefaultPersist.toJson(),
    };
  }

  static UuidDefaultMixInclude include() {
    return UuidDefaultMixInclude._();
  }

  static UuidDefaultMixIncludeList includeList({
    _i1.WhereExpressionBuilder<UuidDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultMixTable>? orderByList,
    UuidDefaultMixInclude? include,
  }) {
    return UuidDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UuidDefaultMix.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UuidDefaultMix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultMixImpl extends UuidDefaultMix {
  _UuidDefaultMixImpl({
    int? id,
    _i1.UuidValue? uuidDefaultAndDefaultModel,
    _i1.UuidValue? uuidDefaultAndDefaultPersist,
    _i1.UuidValue? uuidDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          uuidDefaultAndDefaultModel: uuidDefaultAndDefaultModel,
          uuidDefaultAndDefaultPersist: uuidDefaultAndDefaultPersist,
          uuidDefaultModelAndDefaultPersist: uuidDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [UuidDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UuidDefaultMix copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuidDefaultAndDefaultModel,
    _i1.UuidValue? uuidDefaultAndDefaultPersist,
    _i1.UuidValue? uuidDefaultModelAndDefaultPersist,
  }) {
    return UuidDefaultMix(
      id: id is int? ? id : this.id,
      uuidDefaultAndDefaultModel:
          uuidDefaultAndDefaultModel ?? this.uuidDefaultAndDefaultModel,
      uuidDefaultAndDefaultPersist:
          uuidDefaultAndDefaultPersist ?? this.uuidDefaultAndDefaultPersist,
      uuidDefaultModelAndDefaultPersist: uuidDefaultModelAndDefaultPersist ??
          this.uuidDefaultModelAndDefaultPersist,
    );
  }
}

class UuidDefaultMixTable extends _i1.Table {
  UuidDefaultMixTable({super.tableRelation})
      : super(tableName: 'uuid_default_mix') {
    uuidDefaultAndDefaultModel = _i1.ColumnUuid(
      'uuidDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    uuidDefaultAndDefaultPersist = _i1.ColumnUuid(
      'uuidDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    uuidDefaultModelAndDefaultPersist = _i1.ColumnUuid(
      'uuidDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnUuid uuidDefaultAndDefaultModel;

  late final _i1.ColumnUuid uuidDefaultAndDefaultPersist;

  late final _i1.ColumnUuid uuidDefaultModelAndDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        uuidDefaultAndDefaultModel,
        uuidDefaultAndDefaultPersist,
        uuidDefaultModelAndDefaultPersist,
      ];
}

class UuidDefaultMixInclude extends _i1.IncludeObject {
  UuidDefaultMixInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => UuidDefaultMix.t;
}

class UuidDefaultMixIncludeList extends _i1.IncludeList {
  UuidDefaultMixIncludeList._({
    _i1.WhereExpressionBuilder<UuidDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UuidDefaultMix.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UuidDefaultMix.t;
}

class UuidDefaultMixRepository {
  const UuidDefaultMixRepository._();

  Future<List<UuidDefaultMix>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UuidDefaultMix>(
      where: where?.call(UuidDefaultMix.t),
      orderBy: orderBy?.call(UuidDefaultMix.t),
      orderByList: orderByList?.call(UuidDefaultMix.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<UuidDefaultMix?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultMixTable>? where,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UuidDefaultMix>(
      where: where?.call(UuidDefaultMix.t),
      orderBy: orderBy?.call(UuidDefaultMix.t),
      orderByList: orderByList?.call(UuidDefaultMix.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<UuidDefaultMix?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UuidDefaultMix>(
      id,
      transaction: transaction,
    );
  }

  Future<List<UuidDefaultMix>> insert(
    _i1.Session session,
    List<UuidDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UuidDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  Future<UuidDefaultMix> insertRow(
    _i1.Session session,
    UuidDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UuidDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  Future<List<UuidDefaultMix>> update(
    _i1.Session session,
    List<UuidDefaultMix> rows, {
    _i1.ColumnSelections<UuidDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UuidDefaultMix>(
      rows,
      columns: columns?.call(UuidDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<UuidDefaultMix> updateRow(
    _i1.Session session,
    UuidDefaultMix row, {
    _i1.ColumnSelections<UuidDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UuidDefaultMix>(
      row,
      columns: columns?.call(UuidDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<List<UuidDefaultMix>> delete(
    _i1.Session session,
    List<UuidDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UuidDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  Future<UuidDefaultMix> deleteRow(
    _i1.Session session,
    UuidDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UuidDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  Future<List<UuidDefaultMix>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UuidDefaultMixTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UuidDefaultMix>(
      where: where(UuidDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultMixTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UuidDefaultMix>(
      where: where?.call(UuidDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

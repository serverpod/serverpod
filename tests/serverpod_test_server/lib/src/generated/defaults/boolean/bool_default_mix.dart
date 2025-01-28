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

abstract class BoolDefaultMix
    implements _i1.TableRow, _i1.ProtocolSerialization {
  BoolDefaultMix._({
    this.id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  })  : boolDefaultAndDefaultModel = boolDefaultAndDefaultModel ?? false,
        boolDefaultAndDefaultPersist = boolDefaultAndDefaultPersist ?? true,
        boolDefaultModelAndDefaultPersist =
            boolDefaultModelAndDefaultPersist ?? true;

  factory BoolDefaultMix({
    int? id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  }) = _BoolDefaultMixImpl;

  factory BoolDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoolDefaultMix(
      id: jsonSerialization['id'] as int?,
      boolDefaultAndDefaultModel:
          jsonSerialization['boolDefaultAndDefaultModel'] as bool,
      boolDefaultAndDefaultPersist:
          jsonSerialization['boolDefaultAndDefaultPersist'] as bool,
      boolDefaultModelAndDefaultPersist:
          jsonSerialization['boolDefaultModelAndDefaultPersist'] as bool,
    );
  }

  static final t = BoolDefaultMixTable();

  static const db = BoolDefaultMixRepository._();

  @override
  int? id;

  bool boolDefaultAndDefaultModel;

  bool boolDefaultAndDefaultPersist;

  bool boolDefaultModelAndDefaultPersist;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [BoolDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoolDefaultMix copyWith({
    int? id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'boolDefaultAndDefaultModel': boolDefaultAndDefaultModel,
      'boolDefaultAndDefaultPersist': boolDefaultAndDefaultPersist,
      'boolDefaultModelAndDefaultPersist': boolDefaultModelAndDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'boolDefaultAndDefaultModel': boolDefaultAndDefaultModel,
      'boolDefaultAndDefaultPersist': boolDefaultAndDefaultPersist,
      'boolDefaultModelAndDefaultPersist': boolDefaultModelAndDefaultPersist,
    };
  }

  static BoolDefaultMixInclude include() {
    return BoolDefaultMixInclude._();
  }

  static BoolDefaultMixIncludeList includeList({
    _i1.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    BoolDefaultMixInclude? include,
  }) {
    return BoolDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BoolDefaultMix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoolDefaultMixImpl extends BoolDefaultMix {
  _BoolDefaultMixImpl({
    int? id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          boolDefaultAndDefaultModel: boolDefaultAndDefaultModel,
          boolDefaultAndDefaultPersist: boolDefaultAndDefaultPersist,
          boolDefaultModelAndDefaultPersist: boolDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [BoolDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoolDefaultMix copyWith({
    Object? id = _Undefined,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  }) {
    return BoolDefaultMix(
      id: id is int? ? id : this.id,
      boolDefaultAndDefaultModel:
          boolDefaultAndDefaultModel ?? this.boolDefaultAndDefaultModel,
      boolDefaultAndDefaultPersist:
          boolDefaultAndDefaultPersist ?? this.boolDefaultAndDefaultPersist,
      boolDefaultModelAndDefaultPersist: boolDefaultModelAndDefaultPersist ??
          this.boolDefaultModelAndDefaultPersist,
    );
  }
}

class BoolDefaultMixTable extends _i1.Table {
  BoolDefaultMixTable({super.tableRelation})
      : super(tableName: 'bool_default_mix') {
    boolDefaultAndDefaultModel = _i1.ColumnBool(
      'boolDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    boolDefaultAndDefaultPersist = _i1.ColumnBool(
      'boolDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    boolDefaultModelAndDefaultPersist = _i1.ColumnBool(
      'boolDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnBool boolDefaultAndDefaultModel;

  late final _i1.ColumnBool boolDefaultAndDefaultPersist;

  late final _i1.ColumnBool boolDefaultModelAndDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        boolDefaultAndDefaultModel,
        boolDefaultAndDefaultPersist,
        boolDefaultModelAndDefaultPersist,
      ];
}

class BoolDefaultMixInclude extends _i1.IncludeObject {
  BoolDefaultMixInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => BoolDefaultMix.t;
}

class BoolDefaultMixIncludeList extends _i1.IncludeList {
  BoolDefaultMixIncludeList._({
    _i1.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BoolDefaultMix.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => BoolDefaultMix.t;
}

class BoolDefaultMixRepository {
  const BoolDefaultMixRepository._();

  Future<List<BoolDefaultMix>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BoolDefaultMix>(
      where: where?.call(BoolDefaultMix.t),
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderByList: orderByList?.call(BoolDefaultMix.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<BoolDefaultMix?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BoolDefaultMix>(
      where: where?.call(BoolDefaultMix.t),
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderByList: orderByList?.call(BoolDefaultMix.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<BoolDefaultMix?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BoolDefaultMix>(
      id,
      transaction: transaction,
    );
  }

  Future<List<BoolDefaultMix>> insert(
    _i1.Session session,
    List<BoolDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BoolDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  Future<BoolDefaultMix> insertRow(
    _i1.Session session,
    BoolDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BoolDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  Future<List<BoolDefaultMix>> update(
    _i1.Session session,
    List<BoolDefaultMix> rows, {
    _i1.ColumnSelections<BoolDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BoolDefaultMix>(
      rows,
      columns: columns?.call(BoolDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<BoolDefaultMix> updateRow(
    _i1.Session session,
    BoolDefaultMix row, {
    _i1.ColumnSelections<BoolDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BoolDefaultMix>(
      row,
      columns: columns?.call(BoolDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<List<BoolDefaultMix>> delete(
    _i1.Session session,
    List<BoolDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BoolDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  Future<BoolDefaultMix> deleteRow(
    _i1.Session session,
    BoolDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BoolDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  Future<List<BoolDefaultMix>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BoolDefaultMixTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BoolDefaultMix>(
      where: where(BoolDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BoolDefaultMix>(
      where: where?.call(BoolDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

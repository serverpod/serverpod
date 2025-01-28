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

abstract class DurationDefaultMix
    implements _i1.TableRow, _i1.ProtocolSerialization {
  DurationDefaultMix._({
    this.id,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  })  : durationDefaultAndDefaultModel = durationDefaultAndDefaultModel ??
            Duration(
              days: 2,
              hours: 1,
              minutes: 20,
              seconds: 40,
              milliseconds: 100,
            ),
        durationDefaultAndDefaultPersist = durationDefaultAndDefaultPersist ??
            Duration(
              days: 1,
              hours: 2,
              minutes: 10,
              seconds: 30,
              milliseconds: 100,
            ),
        durationDefaultModelAndDefaultPersist =
            durationDefaultModelAndDefaultPersist ??
                Duration(
                  days: 1,
                  hours: 2,
                  minutes: 10,
                  seconds: 30,
                  milliseconds: 100,
                );

  factory DurationDefaultMix({
    int? id,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  }) = _DurationDefaultMixImpl;

  factory DurationDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return DurationDefaultMix(
      id: jsonSerialization['id'] as int?,
      durationDefaultAndDefaultModel: _i1.DurationJsonExtension.fromJson(
          jsonSerialization['durationDefaultAndDefaultModel']),
      durationDefaultAndDefaultPersist: _i1.DurationJsonExtension.fromJson(
          jsonSerialization['durationDefaultAndDefaultPersist']),
      durationDefaultModelAndDefaultPersist: _i1.DurationJsonExtension.fromJson(
          jsonSerialization['durationDefaultModelAndDefaultPersist']),
    );
  }

  static final t = DurationDefaultMixTable();

  static const db = DurationDefaultMixRepository._();

  @override
  int? id;

  Duration durationDefaultAndDefaultModel;

  Duration durationDefaultAndDefaultPersist;

  Duration durationDefaultModelAndDefaultPersist;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [DurationDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DurationDefaultMix copyWith({
    int? id,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'durationDefaultAndDefaultModel': durationDefaultAndDefaultModel.toJson(),
      'durationDefaultAndDefaultPersist':
          durationDefaultAndDefaultPersist.toJson(),
      'durationDefaultModelAndDefaultPersist':
          durationDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'durationDefaultAndDefaultModel': durationDefaultAndDefaultModel.toJson(),
      'durationDefaultAndDefaultPersist':
          durationDefaultAndDefaultPersist.toJson(),
      'durationDefaultModelAndDefaultPersist':
          durationDefaultModelAndDefaultPersist.toJson(),
    };
  }

  static DurationDefaultMixInclude include() {
    return DurationDefaultMixInclude._();
  }

  static DurationDefaultMixIncludeList includeList({
    _i1.WhereExpressionBuilder<DurationDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DurationDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DurationDefaultMixTable>? orderByList,
    DurationDefaultMixInclude? include,
  }) {
    return DurationDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DurationDefaultMix.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DurationDefaultMix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DurationDefaultMixImpl extends DurationDefaultMix {
  _DurationDefaultMixImpl({
    int? id,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          durationDefaultAndDefaultModel: durationDefaultAndDefaultModel,
          durationDefaultAndDefaultPersist: durationDefaultAndDefaultPersist,
          durationDefaultModelAndDefaultPersist:
              durationDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [DurationDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DurationDefaultMix copyWith({
    Object? id = _Undefined,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  }) {
    return DurationDefaultMix(
      id: id is int? ? id : this.id,
      durationDefaultAndDefaultModel:
          durationDefaultAndDefaultModel ?? this.durationDefaultAndDefaultModel,
      durationDefaultAndDefaultPersist: durationDefaultAndDefaultPersist ??
          this.durationDefaultAndDefaultPersist,
      durationDefaultModelAndDefaultPersist:
          durationDefaultModelAndDefaultPersist ??
              this.durationDefaultModelAndDefaultPersist,
    );
  }
}

class DurationDefaultMixTable extends _i1.Table {
  DurationDefaultMixTable({super.tableRelation})
      : super(tableName: 'duration_default_mix') {
    durationDefaultAndDefaultModel = _i1.ColumnDuration(
      'durationDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    durationDefaultAndDefaultPersist = _i1.ColumnDuration(
      'durationDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    durationDefaultModelAndDefaultPersist = _i1.ColumnDuration(
      'durationDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnDuration durationDefaultAndDefaultModel;

  late final _i1.ColumnDuration durationDefaultAndDefaultPersist;

  late final _i1.ColumnDuration durationDefaultModelAndDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        durationDefaultAndDefaultModel,
        durationDefaultAndDefaultPersist,
        durationDefaultModelAndDefaultPersist,
      ];
}

class DurationDefaultMixInclude extends _i1.IncludeObject {
  DurationDefaultMixInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DurationDefaultMix.t;
}

class DurationDefaultMixIncludeList extends _i1.IncludeList {
  DurationDefaultMixIncludeList._({
    _i1.WhereExpressionBuilder<DurationDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DurationDefaultMix.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DurationDefaultMix.t;
}

class DurationDefaultMixRepository {
  const DurationDefaultMixRepository._();

  Future<List<DurationDefaultMix>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DurationDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DurationDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DurationDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DurationDefaultMix>(
      where: where?.call(DurationDefaultMix.t),
      orderBy: orderBy?.call(DurationDefaultMix.t),
      orderByList: orderByList?.call(DurationDefaultMix.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<DurationDefaultMix?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DurationDefaultMixTable>? where,
    int? offset,
    _i1.OrderByBuilder<DurationDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DurationDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DurationDefaultMix>(
      where: where?.call(DurationDefaultMix.t),
      orderBy: orderBy?.call(DurationDefaultMix.t),
      orderByList: orderByList?.call(DurationDefaultMix.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<DurationDefaultMix?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DurationDefaultMix>(
      id,
      transaction: transaction,
    );
  }

  Future<List<DurationDefaultMix>> insert(
    _i1.Session session,
    List<DurationDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DurationDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  Future<DurationDefaultMix> insertRow(
    _i1.Session session,
    DurationDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DurationDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  Future<List<DurationDefaultMix>> update(
    _i1.Session session,
    List<DurationDefaultMix> rows, {
    _i1.ColumnSelections<DurationDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DurationDefaultMix>(
      rows,
      columns: columns?.call(DurationDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<DurationDefaultMix> updateRow(
    _i1.Session session,
    DurationDefaultMix row, {
    _i1.ColumnSelections<DurationDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DurationDefaultMix>(
      row,
      columns: columns?.call(DurationDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<List<DurationDefaultMix>> delete(
    _i1.Session session,
    List<DurationDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DurationDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  Future<DurationDefaultMix> deleteRow(
    _i1.Session session,
    DurationDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DurationDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  Future<List<DurationDefaultMix>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DurationDefaultMixTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DurationDefaultMix>(
      where: where(DurationDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DurationDefaultMixTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DurationDefaultMix>(
      where: where?.call(DurationDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

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

abstract class DurationDefaultPersist extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  DurationDefaultPersist._({
    int? id,
    this.durationDefaultPersist,
  }) : super(id);

  factory DurationDefaultPersist({
    int? id,
    Duration? durationDefaultPersist,
  }) = _DurationDefaultPersistImpl;

  factory DurationDefaultPersist.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DurationDefaultPersist(
      id: jsonSerialization['id'] as int?,
      durationDefaultPersist:
          jsonSerialization['durationDefaultPersist'] == null
              ? null
              : _i1.DurationJsonExtension.fromJson(
                  jsonSerialization['durationDefaultPersist']),
    );
  }

  static final t = DurationDefaultPersistTable();

  static const db = DurationDefaultPersistRepository._();

  Duration? durationDefaultPersist;

  @override
  _i1.Table get table => t;

  DurationDefaultPersist copyWith({
    int? id,
    Duration? durationDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (durationDefaultPersist != null)
        'durationDefaultPersist': durationDefaultPersist?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (durationDefaultPersist != null)
        'durationDefaultPersist': durationDefaultPersist?.toJson(),
    };
  }

  static DurationDefaultPersistInclude include() {
    return DurationDefaultPersistInclude._();
  }

  static DurationDefaultPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<DurationDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DurationDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DurationDefaultPersistTable>? orderByList,
    DurationDefaultPersistInclude? include,
  }) {
    return DurationDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DurationDefaultPersist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DurationDefaultPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DurationDefaultPersistImpl extends DurationDefaultPersist {
  _DurationDefaultPersistImpl({
    int? id,
    Duration? durationDefaultPersist,
  }) : super._(
          id: id,
          durationDefaultPersist: durationDefaultPersist,
        );

  @override
  DurationDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? durationDefaultPersist = _Undefined,
  }) {
    return DurationDefaultPersist(
      id: id is int? ? id : this.id,
      durationDefaultPersist: durationDefaultPersist is Duration?
          ? durationDefaultPersist
          : this.durationDefaultPersist,
    );
  }
}

class DurationDefaultPersistTable extends _i1.Table {
  DurationDefaultPersistTable({super.tableRelation})
      : super(tableName: 'duration_default_persist') {
    durationDefaultPersist = _i1.ColumnDuration(
      'durationDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnDuration durationDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        durationDefaultPersist,
      ];
}

class DurationDefaultPersistInclude extends _i1.IncludeObject {
  DurationDefaultPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DurationDefaultPersist.t;
}

class DurationDefaultPersistIncludeList extends _i1.IncludeList {
  DurationDefaultPersistIncludeList._({
    _i1.WhereExpressionBuilder<DurationDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DurationDefaultPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DurationDefaultPersist.t;
}

class DurationDefaultPersistRepository {
  const DurationDefaultPersistRepository._();

  Future<List<DurationDefaultPersist>> find(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<DurationDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DurationDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DurationDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.find<DurationDefaultPersist>(
      where: where?.call(DurationDefaultPersist.t),
      orderBy: orderBy?.call(DurationDefaultPersist.t),
      orderByList: orderByList?.call(DurationDefaultPersist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DurationDefaultPersist?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<DurationDefaultPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<DurationDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DurationDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findFirstRow<DurationDefaultPersist>(
      where: where?.call(DurationDefaultPersist.t),
      orderBy: orderBy?.call(DurationDefaultPersist.t),
      orderByList: orderByList?.call(DurationDefaultPersist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DurationDefaultPersist?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findById<DurationDefaultPersist>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DurationDefaultPersist>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<DurationDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<DurationDefaultPersist>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DurationDefaultPersist> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    DurationDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<DurationDefaultPersist>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DurationDefaultPersist>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<DurationDefaultPersist> rows, {
    _i1.ColumnSelections<DurationDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<DurationDefaultPersist>(
      rows,
      columns: columns?.call(DurationDefaultPersist.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DurationDefaultPersist> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    DurationDefaultPersist row, {
    _i1.ColumnSelections<DurationDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<DurationDefaultPersist>(
      row,
      columns: columns?.call(DurationDefaultPersist.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DurationDefaultPersist>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<DurationDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<DurationDefaultPersist>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DurationDefaultPersist> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    DurationDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<DurationDefaultPersist>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DurationDefaultPersist>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<DurationDefaultPersistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<DurationDefaultPersist>(
      where: where(DurationDefaultPersist.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<DurationDefaultPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<DurationDefaultPersist>(
      where: where?.call(DurationDefaultPersist.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

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

abstract class DoubleDefaultPersist extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  DoubleDefaultPersist._({
    int? id,
    this.doubleDefaultPersist,
  }) : super(id);

  factory DoubleDefaultPersist({
    int? id,
    double? doubleDefaultPersist,
  }) = _DoubleDefaultPersistImpl;

  factory DoubleDefaultPersist.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DoubleDefaultPersist(
      id: jsonSerialization['id'] as int?,
      doubleDefaultPersist:
          (jsonSerialization['doubleDefaultPersist'] as num?)?.toDouble(),
    );
  }

  static final t = DoubleDefaultPersistTable();

  static const db = DoubleDefaultPersistRepository._();

  double? doubleDefaultPersist;

  @override
  _i1.Table get table => t;

  DoubleDefaultPersist copyWith({
    int? id,
    double? doubleDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (doubleDefaultPersist != null)
        'doubleDefaultPersist': doubleDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (doubleDefaultPersist != null)
        'doubleDefaultPersist': doubleDefaultPersist,
    };
  }

  static DoubleDefaultPersistInclude include() {
    return DoubleDefaultPersistInclude._();
  }

  static DoubleDefaultPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    DoubleDefaultPersistInclude? include,
  }) {
    return DoubleDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoubleDefaultPersistImpl extends DoubleDefaultPersist {
  _DoubleDefaultPersistImpl({
    int? id,
    double? doubleDefaultPersist,
  }) : super._(
          id: id,
          doubleDefaultPersist: doubleDefaultPersist,
        );

  @override
  DoubleDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? doubleDefaultPersist = _Undefined,
  }) {
    return DoubleDefaultPersist(
      id: id is int? ? id : this.id,
      doubleDefaultPersist: doubleDefaultPersist is double?
          ? doubleDefaultPersist
          : this.doubleDefaultPersist,
    );
  }
}

class DoubleDefaultPersistTable extends _i1.Table {
  DoubleDefaultPersistTable({super.tableRelation})
      : super(tableName: 'double_default_persist') {
    doubleDefaultPersist = _i1.ColumnDouble(
      'doubleDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnDouble doubleDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        doubleDefaultPersist,
      ];
}

class DoubleDefaultPersistInclude extends _i1.IncludeObject {
  DoubleDefaultPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DoubleDefaultPersist.t;
}

class DoubleDefaultPersistIncludeList extends _i1.IncludeList {
  DoubleDefaultPersistIncludeList._({
    _i1.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DoubleDefaultPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DoubleDefaultPersist.t;
}

class DoubleDefaultPersistRepository {
  const DoubleDefaultPersistRepository._();

  Future<List<DoubleDefaultPersist>> find(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.find<DoubleDefaultPersist>(
      where: where?.call(DoubleDefaultPersist.t),
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DoubleDefaultPersist?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findFirstRow<DoubleDefaultPersist>(
      where: where?.call(DoubleDefaultPersist.t),
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DoubleDefaultPersist?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findById<DoubleDefaultPersist>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DoubleDefaultPersist>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<DoubleDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<DoubleDefaultPersist>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DoubleDefaultPersist> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    DoubleDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<DoubleDefaultPersist>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DoubleDefaultPersist>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<DoubleDefaultPersist> rows, {
    _i1.ColumnSelections<DoubleDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<DoubleDefaultPersist>(
      rows,
      columns: columns?.call(DoubleDefaultPersist.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DoubleDefaultPersist> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    DoubleDefaultPersist row, {
    _i1.ColumnSelections<DoubleDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<DoubleDefaultPersist>(
      row,
      columns: columns?.call(DoubleDefaultPersist.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DoubleDefaultPersist>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<DoubleDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<DoubleDefaultPersist>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DoubleDefaultPersist> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    DoubleDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<DoubleDefaultPersist>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DoubleDefaultPersist>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<DoubleDefaultPersistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<DoubleDefaultPersist>(
      where: where(DoubleDefaultPersist.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<DoubleDefaultPersist>(
      where: where?.call(DoubleDefaultPersist.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

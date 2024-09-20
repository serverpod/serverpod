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

abstract class IntDefaultMix extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  IntDefaultMix._({
    int? id,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  })  : intDefaultAndDefaultModel = intDefaultAndDefaultModel ?? 20,
        intDefaultAndDefaultPersist = intDefaultAndDefaultPersist ?? 10,
        intDefaultModelAndDefaultPersist =
            intDefaultModelAndDefaultPersist ?? 10,
        super(id);

  factory IntDefaultMix({
    int? id,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  }) = _IntDefaultMixImpl;

  factory IntDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return IntDefaultMix(
      id: jsonSerialization['id'] as int?,
      intDefaultAndDefaultModel:
          jsonSerialization['intDefaultAndDefaultModel'] as int,
      intDefaultAndDefaultPersist:
          jsonSerialization['intDefaultAndDefaultPersist'] as int,
      intDefaultModelAndDefaultPersist:
          jsonSerialization['intDefaultModelAndDefaultPersist'] as int,
    );
  }

  static final t = IntDefaultMixTable();

  static const db = IntDefaultMixRepository._();

  int intDefaultAndDefaultModel;

  int intDefaultAndDefaultPersist;

  int intDefaultModelAndDefaultPersist;

  @override
  _i1.Table get table => t;

  IntDefaultMix copyWith({
    int? id,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'intDefaultAndDefaultModel': intDefaultAndDefaultModel,
      'intDefaultAndDefaultPersist': intDefaultAndDefaultPersist,
      'intDefaultModelAndDefaultPersist': intDefaultModelAndDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'intDefaultAndDefaultModel': intDefaultAndDefaultModel,
      'intDefaultAndDefaultPersist': intDefaultAndDefaultPersist,
      'intDefaultModelAndDefaultPersist': intDefaultModelAndDefaultPersist,
    };
  }

  static IntDefaultMixInclude include() {
    return IntDefaultMixInclude._();
  }

  static IntDefaultMixIncludeList includeList({
    _i1.WhereExpressionBuilder<IntDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IntDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultMixTable>? orderByList,
    IntDefaultMixInclude? include,
  }) {
    return IntDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntDefaultMix.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(IntDefaultMix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IntDefaultMixImpl extends IntDefaultMix {
  _IntDefaultMixImpl({
    int? id,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          intDefaultAndDefaultModel: intDefaultAndDefaultModel,
          intDefaultAndDefaultPersist: intDefaultAndDefaultPersist,
          intDefaultModelAndDefaultPersist: intDefaultModelAndDefaultPersist,
        );

  @override
  IntDefaultMix copyWith({
    Object? id = _Undefined,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  }) {
    return IntDefaultMix(
      id: id is int? ? id : this.id,
      intDefaultAndDefaultModel:
          intDefaultAndDefaultModel ?? this.intDefaultAndDefaultModel,
      intDefaultAndDefaultPersist:
          intDefaultAndDefaultPersist ?? this.intDefaultAndDefaultPersist,
      intDefaultModelAndDefaultPersist: intDefaultModelAndDefaultPersist ??
          this.intDefaultModelAndDefaultPersist,
    );
  }
}

class IntDefaultMixTable extends _i1.Table {
  IntDefaultMixTable({super.tableRelation})
      : super(tableName: 'int_default_mix') {
    intDefaultAndDefaultModel = _i1.ColumnInt(
      'intDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    intDefaultAndDefaultPersist = _i1.ColumnInt(
      'intDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    intDefaultModelAndDefaultPersist = _i1.ColumnInt(
      'intDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnInt intDefaultAndDefaultModel;

  late final _i1.ColumnInt intDefaultAndDefaultPersist;

  late final _i1.ColumnInt intDefaultModelAndDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        intDefaultAndDefaultModel,
        intDefaultAndDefaultPersist,
        intDefaultModelAndDefaultPersist,
      ];
}

class IntDefaultMixInclude extends _i1.IncludeObject {
  IntDefaultMixInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => IntDefaultMix.t;
}

class IntDefaultMixIncludeList extends _i1.IncludeList {
  IntDefaultMixIncludeList._({
    _i1.WhereExpressionBuilder<IntDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IntDefaultMix.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => IntDefaultMix.t;
}

class IntDefaultMixRepository {
  const IntDefaultMixRepository._();

  Future<List<IntDefaultMix>> find(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<IntDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IntDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.find<IntDefaultMix>(
      where: where?.call(IntDefaultMix.t),
      orderBy: orderBy?.call(IntDefaultMix.t),
      orderByList: orderByList?.call(IntDefaultMix.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<IntDefaultMix?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<IntDefaultMixTable>? where,
    int? offset,
    _i1.OrderByBuilder<IntDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findFirstRow<IntDefaultMix>(
      where: where?.call(IntDefaultMix.t),
      orderBy: orderBy?.call(IntDefaultMix.t),
      orderByList: orderByList?.call(IntDefaultMix.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<IntDefaultMix?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findById<IntDefaultMix>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<IntDefaultMix>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<IntDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<IntDefaultMix>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<IntDefaultMix> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    IntDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<IntDefaultMix>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<IntDefaultMix>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<IntDefaultMix> rows, {
    _i1.ColumnSelections<IntDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<IntDefaultMix>(
      rows,
      columns: columns?.call(IntDefaultMix.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<IntDefaultMix> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    IntDefaultMix row, {
    _i1.ColumnSelections<IntDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<IntDefaultMix>(
      row,
      columns: columns?.call(IntDefaultMix.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<IntDefaultMix>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<IntDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<IntDefaultMix>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<IntDefaultMix> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    IntDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<IntDefaultMix>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<IntDefaultMix>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<IntDefaultMixTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<IntDefaultMix>(
      where: where(IntDefaultMix.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<IntDefaultMixTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<IntDefaultMix>(
      where: where?.call(IntDefaultMix.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

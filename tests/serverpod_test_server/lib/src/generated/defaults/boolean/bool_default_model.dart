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

abstract class BoolDefaultModel extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  BoolDefaultModel._({
    int? id,
    bool? boolDefaultModelTrue,
    bool? boolDefaultModelFalse,
    bool? boolDefaultModelNullFalse,
  })  : boolDefaultModelTrue = boolDefaultModelTrue ?? true,
        boolDefaultModelFalse = boolDefaultModelFalse ?? false,
        boolDefaultModelNullFalse = boolDefaultModelNullFalse ?? false,
        super(id);

  factory BoolDefaultModel({
    int? id,
    bool? boolDefaultModelTrue,
    bool? boolDefaultModelFalse,
    bool? boolDefaultModelNullFalse,
  }) = _BoolDefaultModelImpl;

  factory BoolDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoolDefaultModel(
      id: jsonSerialization['id'] as int?,
      boolDefaultModelTrue: jsonSerialization['boolDefaultModelTrue'] as bool,
      boolDefaultModelFalse: jsonSerialization['boolDefaultModelFalse'] as bool,
      boolDefaultModelNullFalse:
          jsonSerialization['boolDefaultModelNullFalse'] as bool,
    );
  }

  static final t = BoolDefaultModelTable();

  static const db = BoolDefaultModelRepository._();

  bool boolDefaultModelTrue;

  bool boolDefaultModelFalse;

  bool boolDefaultModelNullFalse;

  @override
  _i1.Table get table => t;

  BoolDefaultModel copyWith({
    int? id,
    bool? boolDefaultModelTrue,
    bool? boolDefaultModelFalse,
    bool? boolDefaultModelNullFalse,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'boolDefaultModelTrue': boolDefaultModelTrue,
      'boolDefaultModelFalse': boolDefaultModelFalse,
      'boolDefaultModelNullFalse': boolDefaultModelNullFalse,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'boolDefaultModelTrue': boolDefaultModelTrue,
      'boolDefaultModelFalse': boolDefaultModelFalse,
      'boolDefaultModelNullFalse': boolDefaultModelNullFalse,
    };
  }

  static BoolDefaultModelInclude include() {
    return BoolDefaultModelInclude._();
  }

  static BoolDefaultModelIncludeList includeList({
    _i1.WhereExpressionBuilder<BoolDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultModelTable>? orderByList,
    BoolDefaultModelInclude? include,
  }) {
    return BoolDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoolDefaultModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BoolDefaultModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoolDefaultModelImpl extends BoolDefaultModel {
  _BoolDefaultModelImpl({
    int? id,
    bool? boolDefaultModelTrue,
    bool? boolDefaultModelFalse,
    bool? boolDefaultModelNullFalse,
  }) : super._(
          id: id,
          boolDefaultModelTrue: boolDefaultModelTrue,
          boolDefaultModelFalse: boolDefaultModelFalse,
          boolDefaultModelNullFalse: boolDefaultModelNullFalse,
        );

  @override
  BoolDefaultModel copyWith({
    Object? id = _Undefined,
    bool? boolDefaultModelTrue,
    bool? boolDefaultModelFalse,
    bool? boolDefaultModelNullFalse,
  }) {
    return BoolDefaultModel(
      id: id is int? ? id : this.id,
      boolDefaultModelTrue: boolDefaultModelTrue ?? this.boolDefaultModelTrue,
      boolDefaultModelFalse:
          boolDefaultModelFalse ?? this.boolDefaultModelFalse,
      boolDefaultModelNullFalse:
          boolDefaultModelNullFalse ?? this.boolDefaultModelNullFalse,
    );
  }
}

class BoolDefaultModelTable extends _i1.Table {
  BoolDefaultModelTable({super.tableRelation})
      : super(tableName: 'bool_default_model') {
    boolDefaultModelTrue = _i1.ColumnBool(
      'boolDefaultModelTrue',
      this,
    );
    boolDefaultModelFalse = _i1.ColumnBool(
      'boolDefaultModelFalse',
      this,
    );
    boolDefaultModelNullFalse = _i1.ColumnBool(
      'boolDefaultModelNullFalse',
      this,
    );
  }

  late final _i1.ColumnBool boolDefaultModelTrue;

  late final _i1.ColumnBool boolDefaultModelFalse;

  late final _i1.ColumnBool boolDefaultModelNullFalse;

  @override
  List<_i1.Column> get columns => [
        id,
        boolDefaultModelTrue,
        boolDefaultModelFalse,
        boolDefaultModelNullFalse,
      ];
}

class BoolDefaultModelInclude extends _i1.IncludeObject {
  BoolDefaultModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => BoolDefaultModel.t;
}

class BoolDefaultModelIncludeList extends _i1.IncludeList {
  BoolDefaultModelIncludeList._({
    _i1.WhereExpressionBuilder<BoolDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BoolDefaultModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => BoolDefaultModel.t;
}

class BoolDefaultModelRepository {
  const BoolDefaultModelRepository._();

  Future<List<BoolDefaultModel>> find(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<BoolDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.find<BoolDefaultModel>(
      where: where?.call(BoolDefaultModel.t),
      orderBy: orderBy?.call(BoolDefaultModel.t),
      orderByList: orderByList?.call(BoolDefaultModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<BoolDefaultModel?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<BoolDefaultModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findFirstRow<BoolDefaultModel>(
      where: where?.call(BoolDefaultModel.t),
      orderBy: orderBy?.call(BoolDefaultModel.t),
      orderByList: orderByList?.call(BoolDefaultModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<BoolDefaultModel?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findById<BoolDefaultModel>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<BoolDefaultModel>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<BoolDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<BoolDefaultModel>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<BoolDefaultModel> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    BoolDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<BoolDefaultModel>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<BoolDefaultModel>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<BoolDefaultModel> rows, {
    _i1.ColumnSelections<BoolDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<BoolDefaultModel>(
      rows,
      columns: columns?.call(BoolDefaultModel.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<BoolDefaultModel> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    BoolDefaultModel row, {
    _i1.ColumnSelections<BoolDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<BoolDefaultModel>(
      row,
      columns: columns?.call(BoolDefaultModel.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<BoolDefaultModel>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<BoolDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<BoolDefaultModel>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<BoolDefaultModel> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    BoolDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<BoolDefaultModel>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<BoolDefaultModel>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<BoolDefaultModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<BoolDefaultModel>(
      where: where(BoolDefaultModel.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<BoolDefaultModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<BoolDefaultModel>(
      where: where?.call(BoolDefaultModel.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

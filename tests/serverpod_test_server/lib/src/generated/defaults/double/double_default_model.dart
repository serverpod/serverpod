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

abstract class DoubleDefaultModel
    implements _i1.TableRow, _i1.ProtocolSerialization {
  DoubleDefaultModel._({
    int? id,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  })  : doubleDefaultModel = doubleDefaultModel ?? 10.5,
        doubleDefaultModelNull = doubleDefaultModelNull ?? 20.5 {
    _id = id;
  }

  factory DoubleDefaultModel({
    int? id,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  }) = _DoubleDefaultModelImpl;

  factory DoubleDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoubleDefaultModel(
      id: jsonSerialization['id'] as int?,
      doubleDefaultModel:
          (jsonSerialization['doubleDefaultModel'] as num).toDouble(),
      doubleDefaultModelNull:
          (jsonSerialization['doubleDefaultModelNull'] as num).toDouble(),
    );
  }

  static final t = DoubleDefaultModelTable();

  static const db = DoubleDefaultModelRepository._();

  int? _id;

  double doubleDefaultModel;

  double doubleDefaultModelNull;

  @override
  int? get id {
    return _id;
  }

  @override
  set id(int? value) {
    _id = value;
  }

  @override
  _i1.Table get table => t;

  DoubleDefaultModel copyWith({
    int? id,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'doubleDefaultModel': doubleDefaultModel,
      'doubleDefaultModelNull': doubleDefaultModelNull,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'doubleDefaultModel': doubleDefaultModel,
      'doubleDefaultModelNull': doubleDefaultModelNull,
    };
  }

  static DoubleDefaultModelInclude include() {
    return DoubleDefaultModelInclude._();
  }

  static DoubleDefaultModelIncludeList includeList({
    _i1.WhereExpressionBuilder<DoubleDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultModelTable>? orderByList,
    DoubleDefaultModelInclude? include,
  }) {
    return DoubleDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoubleDefaultModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DoubleDefaultModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoubleDefaultModelImpl extends DoubleDefaultModel {
  _DoubleDefaultModelImpl({
    int? id,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  }) : super._(
          id: id,
          doubleDefaultModel: doubleDefaultModel,
          doubleDefaultModelNull: doubleDefaultModelNull,
        );

  @override
  DoubleDefaultModel copyWith({
    Object? id = _Undefined,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  }) {
    return DoubleDefaultModel(
      id: id is int? ? id : this.id,
      doubleDefaultModel: doubleDefaultModel ?? this.doubleDefaultModel,
      doubleDefaultModelNull:
          doubleDefaultModelNull ?? this.doubleDefaultModelNull,
    );
  }
}

class DoubleDefaultModelTable extends _i1.Table {
  DoubleDefaultModelTable({super.tableRelation})
      : super(tableName: 'double_default_model') {
    doubleDefaultModel = _i1.ColumnDouble(
      'doubleDefaultModel',
      this,
    );
    doubleDefaultModelNull = _i1.ColumnDouble(
      'doubleDefaultModelNull',
      this,
    );
  }

  late final _i1.ColumnDouble doubleDefaultModel;

  late final _i1.ColumnDouble doubleDefaultModelNull;

  @override
  List<_i1.Column> get columns => [
        id,
        doubleDefaultModel,
        doubleDefaultModelNull,
      ];
}

class DoubleDefaultModelInclude extends _i1.IncludeObject {
  DoubleDefaultModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DoubleDefaultModel.t;
}

class DoubleDefaultModelIncludeList extends _i1.IncludeList {
  DoubleDefaultModelIncludeList._({
    _i1.WhereExpressionBuilder<DoubleDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DoubleDefaultModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DoubleDefaultModel.t;
}

class DoubleDefaultModelRepository {
  const DoubleDefaultModelRepository._();

  Future<List<DoubleDefaultModel>> find(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<DoubleDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.find<DoubleDefaultModel>(
      where: where?.call(DoubleDefaultModel.t),
      orderBy: orderBy?.call(DoubleDefaultModel.t),
      orderByList: orderByList?.call(DoubleDefaultModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DoubleDefaultModel?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<DoubleDefaultModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<DoubleDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoubleDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findFirstRow<DoubleDefaultModel>(
      where: where?.call(DoubleDefaultModel.t),
      orderBy: orderBy?.call(DoubleDefaultModel.t),
      orderByList: orderByList?.call(DoubleDefaultModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DoubleDefaultModel?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findById<DoubleDefaultModel>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DoubleDefaultModel>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<DoubleDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<DoubleDefaultModel>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DoubleDefaultModel> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    DoubleDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<DoubleDefaultModel>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DoubleDefaultModel>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<DoubleDefaultModel> rows, {
    _i1.ColumnSelections<DoubleDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<DoubleDefaultModel>(
      rows,
      columns: columns?.call(DoubleDefaultModel.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DoubleDefaultModel> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    DoubleDefaultModel row, {
    _i1.ColumnSelections<DoubleDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<DoubleDefaultModel>(
      row,
      columns: columns?.call(DoubleDefaultModel.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DoubleDefaultModel>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<DoubleDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<DoubleDefaultModel>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DoubleDefaultModel> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    DoubleDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<DoubleDefaultModel>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DoubleDefaultModel>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<DoubleDefaultModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<DoubleDefaultModel>(
      where: where(DoubleDefaultModel.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<DoubleDefaultModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<DoubleDefaultModel>(
      where: where?.call(DoubleDefaultModel.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

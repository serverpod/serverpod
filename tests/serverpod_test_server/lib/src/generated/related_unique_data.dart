/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

abstract class RelatedUniqueData extends _i1.TableRow {
  RelatedUniqueData._({
    int? id,
    required this.uniqueDataId,
    this.uniqueData,
    required this.number,
  }) : super(id);

  factory RelatedUniqueData({
    int? id,
    required int uniqueDataId,
    _i2.UniqueData? uniqueData,
    required int number,
  }) = _RelatedUniqueDataImpl;

  factory RelatedUniqueData.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return RelatedUniqueData(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      uniqueDataId: serializationManager
          .deserialize<int>(jsonSerialization['uniqueDataId']),
      uniqueData: serializationManager
          .deserialize<_i2.UniqueData?>(jsonSerialization['uniqueData']),
      number:
          serializationManager.deserialize<int>(jsonSerialization['number']),
    );
  }

  static final t = RelatedUniqueDataTable();

  static const db = RelatedUniqueDataRepository._();

  int uniqueDataId;

  _i2.UniqueData? uniqueData;

  int number;

  @override
  _i1.Table get table => t;

  RelatedUniqueData copyWith({
    int? id,
    int? uniqueDataId,
    _i2.UniqueData? uniqueData,
    int? number,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uniqueDataId': uniqueDataId,
      'uniqueData': uniqueData,
      'number': number,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'uniqueDataId': uniqueDataId,
      'number': number,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'uniqueDataId': uniqueDataId,
      'uniqueData': uniqueData,
      'number': number,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'uniqueDataId':
        uniqueDataId = value;
        return;
      case 'number':
        number = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<RelatedUniqueData>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    RelatedUniqueDataInclude? include,
  }) async {
    return session.db.find<RelatedUniqueData>(
      where: where != null ? where(RelatedUniqueData.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<RelatedUniqueData?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    RelatedUniqueDataInclude? include,
  }) async {
    return session.db.findSingleRow<RelatedUniqueData>(
      where: where != null ? where(RelatedUniqueData.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<RelatedUniqueData?> findById(
    _i1.Session session,
    int id, {
    RelatedUniqueDataInclude? include,
  }) async {
    return session.db.findById<RelatedUniqueData>(
      id,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RelatedUniqueDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RelatedUniqueData>(
      where: where(RelatedUniqueData.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    RelatedUniqueData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
  static Future<bool> update(
    _i1.Session session,
    RelatedUniqueData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
  static Future<void> insert(
    _i1.Session session,
    RelatedUniqueData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RelatedUniqueData>(
      where: where != null ? where(RelatedUniqueData.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static RelatedUniqueDataInclude include({_i2.UniqueDataInclude? uniqueData}) {
    return RelatedUniqueDataInclude._(uniqueData: uniqueData);
  }

  static RelatedUniqueDataIncludeList includeList({
    _i1.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RelatedUniqueDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelatedUniqueDataTable>? orderByList,
    RelatedUniqueDataInclude? include,
  }) {
    return RelatedUniqueDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RelatedUniqueData.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RelatedUniqueData.t),
      include: include,
    );
  }
}

class _Undefined {}

class _RelatedUniqueDataImpl extends RelatedUniqueData {
  _RelatedUniqueDataImpl({
    int? id,
    required int uniqueDataId,
    _i2.UniqueData? uniqueData,
    required int number,
  }) : super._(
          id: id,
          uniqueDataId: uniqueDataId,
          uniqueData: uniqueData,
          number: number,
        );

  @override
  RelatedUniqueData copyWith({
    Object? id = _Undefined,
    int? uniqueDataId,
    Object? uniqueData = _Undefined,
    int? number,
  }) {
    return RelatedUniqueData(
      id: id is int? ? id : this.id,
      uniqueDataId: uniqueDataId ?? this.uniqueDataId,
      uniqueData: uniqueData is _i2.UniqueData?
          ? uniqueData
          : this.uniqueData?.copyWith(),
      number: number ?? this.number,
    );
  }
}

class RelatedUniqueDataTable extends _i1.Table {
  RelatedUniqueDataTable({super.tableRelation})
      : super(tableName: 'related_unique_data') {
    uniqueDataId = _i1.ColumnInt(
      'uniqueDataId',
      this,
    );
    number = _i1.ColumnInt(
      'number',
      this,
    );
  }

  late final _i1.ColumnInt uniqueDataId;

  _i2.UniqueDataTable? _uniqueData;

  late final _i1.ColumnInt number;

  _i2.UniqueDataTable get uniqueData {
    if (_uniqueData != null) return _uniqueData!;
    _uniqueData = _i1.createRelationTable(
      relationFieldName: 'uniqueData',
      field: RelatedUniqueData.t.uniqueDataId,
      foreignField: _i2.UniqueData.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UniqueDataTable(tableRelation: foreignTableRelation),
    );
    return _uniqueData!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        uniqueDataId,
        number,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'uniqueData') {
      return uniqueData;
    }
    return null;
  }
}

@Deprecated('Use RelatedUniqueDataTable.t instead.')
RelatedUniqueDataTable tRelatedUniqueData = RelatedUniqueDataTable();

class RelatedUniqueDataInclude extends _i1.IncludeObject {
  RelatedUniqueDataInclude._({_i2.UniqueDataInclude? uniqueData}) {
    _uniqueData = uniqueData;
  }

  _i2.UniqueDataInclude? _uniqueData;

  @override
  Map<String, _i1.Include?> get includes => {'uniqueData': _uniqueData};

  @override
  _i1.Table get table => RelatedUniqueData.t;
}

class RelatedUniqueDataIncludeList extends _i1.IncludeList {
  RelatedUniqueDataIncludeList._({
    _i1.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RelatedUniqueData.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => RelatedUniqueData.t;
}

class RelatedUniqueDataRepository {
  const RelatedUniqueDataRepository._();

  final attachRow = const RelatedUniqueDataAttachRowRepository._();

  Future<List<RelatedUniqueData>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RelatedUniqueDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelatedUniqueDataTable>? orderByList,
    _i1.Transaction? transaction,
    RelatedUniqueDataInclude? include,
  }) async {
    return session.dbNext.find<RelatedUniqueData>(
      where: where?.call(RelatedUniqueData.t),
      orderBy: orderBy?.call(RelatedUniqueData.t),
      orderByList: orderByList?.call(RelatedUniqueData.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<RelatedUniqueData?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? offset,
    _i1.OrderByBuilder<RelatedUniqueDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelatedUniqueDataTable>? orderByList,
    _i1.Transaction? transaction,
    RelatedUniqueDataInclude? include,
  }) async {
    return session.dbNext.findFirstRow<RelatedUniqueData>(
      where: where?.call(RelatedUniqueData.t),
      orderBy: orderBy?.call(RelatedUniqueData.t),
      orderByList: orderByList?.call(RelatedUniqueData.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<RelatedUniqueData?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    RelatedUniqueDataInclude? include,
  }) async {
    return session.dbNext.findById<RelatedUniqueData>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<RelatedUniqueData>> insert(
    _i1.Session session,
    List<RelatedUniqueData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<RelatedUniqueData>(
      rows,
      transaction: transaction,
    );
  }

  Future<RelatedUniqueData> insertRow(
    _i1.Session session,
    RelatedUniqueData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<RelatedUniqueData>(
      row,
      transaction: transaction,
    );
  }

  Future<List<RelatedUniqueData>> update(
    _i1.Session session,
    List<RelatedUniqueData> rows, {
    _i1.ColumnSelections<RelatedUniqueDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<RelatedUniqueData>(
      rows,
      columns: columns?.call(RelatedUniqueData.t),
      transaction: transaction,
    );
  }

  Future<RelatedUniqueData> updateRow(
    _i1.Session session,
    RelatedUniqueData row, {
    _i1.ColumnSelections<RelatedUniqueDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<RelatedUniqueData>(
      row,
      columns: columns?.call(RelatedUniqueData.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<RelatedUniqueData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<RelatedUniqueData>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    RelatedUniqueData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<RelatedUniqueData>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RelatedUniqueDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<RelatedUniqueData>(
      where: where(RelatedUniqueData.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<RelatedUniqueData>(
      where: where?.call(RelatedUniqueData.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class RelatedUniqueDataAttachRowRepository {
  const RelatedUniqueDataAttachRowRepository._();

  Future<void> uniqueData(
    _i1.Session session,
    RelatedUniqueData relatedUniqueData,
    _i2.UniqueData uniqueData,
  ) async {
    if (relatedUniqueData.id == null) {
      throw ArgumentError.notNull('relatedUniqueData.id');
    }
    if (uniqueData.id == null) {
      throw ArgumentError.notNull('uniqueData.id');
    }

    var $relatedUniqueData =
        relatedUniqueData.copyWith(uniqueDataId: uniqueData.id);
    await session.dbNext.updateRow<RelatedUniqueData>(
      $relatedUniqueData,
      columns: [RelatedUniqueData.t.uniqueDataId],
    );
  }
}

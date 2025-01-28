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
import '../empty_model/empty_model_relation_item.dart' as _i2;

abstract class RelationEmptyModel
    implements _i1.TableRow, _i1.ProtocolSerialization {
  RelationEmptyModel._({
    this.id,
    this.items,
  });

  factory RelationEmptyModel({
    int? id,
    List<_i2.EmptyModelRelationItem>? items,
  }) = _RelationEmptyModelImpl;

  factory RelationEmptyModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return RelationEmptyModel(
      id: jsonSerialization['id'] as int?,
      items: (jsonSerialization['items'] as List?)
          ?.map((e) =>
              _i2.EmptyModelRelationItem.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = RelationEmptyModelTable();

  static const db = RelationEmptyModelRepository._();

  @override
  int? id;

  List<_i2.EmptyModelRelationItem>? items;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [RelationEmptyModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RelationEmptyModel copyWith({
    int? id,
    List<_i2.EmptyModelRelationItem>? items,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (items != null) 'items': items?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (items != null)
        'items': items?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static RelationEmptyModelInclude include(
      {_i2.EmptyModelRelationItemIncludeList? items}) {
    return RelationEmptyModelInclude._(items: items);
  }

  static RelationEmptyModelIncludeList includeList({
    _i1.WhereExpressionBuilder<RelationEmptyModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RelationEmptyModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelationEmptyModelTable>? orderByList,
    RelationEmptyModelInclude? include,
  }) {
    return RelationEmptyModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RelationEmptyModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RelationEmptyModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RelationEmptyModelImpl extends RelationEmptyModel {
  _RelationEmptyModelImpl({
    int? id,
    List<_i2.EmptyModelRelationItem>? items,
  }) : super._(
          id: id,
          items: items,
        );

  /// Returns a shallow copy of this [RelationEmptyModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RelationEmptyModel copyWith({
    Object? id = _Undefined,
    Object? items = _Undefined,
  }) {
    return RelationEmptyModel(
      id: id is int? ? id : this.id,
      items: items is List<_i2.EmptyModelRelationItem>?
          ? items
          : this.items?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class RelationEmptyModelTable extends _i1.Table {
  RelationEmptyModelTable({super.tableRelation})
      : super(tableName: 'relation_empty_model') {}

  _i2.EmptyModelRelationItemTable? ___items;

  _i1.ManyRelation<_i2.EmptyModelRelationItemTable>? _items;

  _i2.EmptyModelRelationItemTable get __items {
    if (___items != null) return ___items!;
    ___items = _i1.createRelationTable(
      relationFieldName: '__items',
      field: RelationEmptyModel.t.id,
      foreignField: _i2.EmptyModelRelationItem.t
          .$_relationEmptyModelItemsRelationEmptyModelId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.EmptyModelRelationItemTable(tableRelation: foreignTableRelation),
    );
    return ___items!;
  }

  _i1.ManyRelation<_i2.EmptyModelRelationItemTable> get items {
    if (_items != null) return _items!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'items',
      field: RelationEmptyModel.t.id,
      foreignField: _i2.EmptyModelRelationItem.t
          .$_relationEmptyModelItemsRelationEmptyModelId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.EmptyModelRelationItemTable(tableRelation: foreignTableRelation),
    );
    _items = _i1.ManyRelation<_i2.EmptyModelRelationItemTable>(
      tableWithRelations: relationTable,
      table: _i2.EmptyModelRelationItemTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _items!;
  }

  @override
  List<_i1.Column> get columns => [id];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'items') {
      return __items;
    }
    return null;
  }
}

class RelationEmptyModelInclude extends _i1.IncludeObject {
  RelationEmptyModelInclude._({_i2.EmptyModelRelationItemIncludeList? items}) {
    _items = items;
  }

  _i2.EmptyModelRelationItemIncludeList? _items;

  @override
  Map<String, _i1.Include?> get includes => {'items': _items};

  @override
  _i1.Table get table => RelationEmptyModel.t;
}

class RelationEmptyModelIncludeList extends _i1.IncludeList {
  RelationEmptyModelIncludeList._({
    _i1.WhereExpressionBuilder<RelationEmptyModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RelationEmptyModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => RelationEmptyModel.t;
}

class RelationEmptyModelRepository {
  const RelationEmptyModelRepository._();

  final attach = const RelationEmptyModelAttachRepository._();

  final attachRow = const RelationEmptyModelAttachRowRepository._();

  final detach = const RelationEmptyModelDetachRepository._();

  final detachRow = const RelationEmptyModelDetachRowRepository._();

  Future<List<RelationEmptyModel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelationEmptyModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RelationEmptyModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelationEmptyModelTable>? orderByList,
    _i1.Transaction? transaction,
    RelationEmptyModelInclude? include,
  }) async {
    return session.db.find<RelationEmptyModel>(
      where: where?.call(RelationEmptyModel.t),
      orderBy: orderBy?.call(RelationEmptyModel.t),
      orderByList: orderByList?.call(RelationEmptyModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<RelationEmptyModel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelationEmptyModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<RelationEmptyModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelationEmptyModelTable>? orderByList,
    _i1.Transaction? transaction,
    RelationEmptyModelInclude? include,
  }) async {
    return session.db.findFirstRow<RelationEmptyModel>(
      where: where?.call(RelationEmptyModel.t),
      orderBy: orderBy?.call(RelationEmptyModel.t),
      orderByList: orderByList?.call(RelationEmptyModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<RelationEmptyModel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    RelationEmptyModelInclude? include,
  }) async {
    return session.db.findById<RelationEmptyModel>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<RelationEmptyModel>> insert(
    _i1.Session session,
    List<RelationEmptyModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<RelationEmptyModel>(
      rows,
      transaction: transaction,
    );
  }

  Future<RelationEmptyModel> insertRow(
    _i1.Session session,
    RelationEmptyModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RelationEmptyModel>(
      row,
      transaction: transaction,
    );
  }

  Future<List<RelationEmptyModel>> update(
    _i1.Session session,
    List<RelationEmptyModel> rows, {
    _i1.ColumnSelections<RelationEmptyModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RelationEmptyModel>(
      rows,
      columns: columns?.call(RelationEmptyModel.t),
      transaction: transaction,
    );
  }

  Future<RelationEmptyModel> updateRow(
    _i1.Session session,
    RelationEmptyModel row, {
    _i1.ColumnSelections<RelationEmptyModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RelationEmptyModel>(
      row,
      columns: columns?.call(RelationEmptyModel.t),
      transaction: transaction,
    );
  }

  Future<List<RelationEmptyModel>> delete(
    _i1.Session session,
    List<RelationEmptyModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RelationEmptyModel>(
      rows,
      transaction: transaction,
    );
  }

  Future<RelationEmptyModel> deleteRow(
    _i1.Session session,
    RelationEmptyModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RelationEmptyModel>(
      row,
      transaction: transaction,
    );
  }

  Future<List<RelationEmptyModel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RelationEmptyModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RelationEmptyModel>(
      where: where(RelationEmptyModel.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelationEmptyModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RelationEmptyModel>(
      where: where?.call(RelationEmptyModel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class RelationEmptyModelAttachRepository {
  const RelationEmptyModelAttachRepository._();

  Future<void> items(
    _i1.Session session,
    RelationEmptyModel relationEmptyModel,
    List<_i2.EmptyModelRelationItem> emptyModelRelationItem, {
    _i1.Transaction? transaction,
  }) async {
    if (emptyModelRelationItem.any((e) => e.id == null)) {
      throw ArgumentError.notNull('emptyModelRelationItem.id');
    }
    if (relationEmptyModel.id == null) {
      throw ArgumentError.notNull('relationEmptyModel.id');
    }

    var $emptyModelRelationItem = emptyModelRelationItem
        .map((e) => _i2.EmptyModelRelationItemImplicit(
              e,
              $_relationEmptyModelItemsRelationEmptyModelId:
                  relationEmptyModel.id,
            ))
        .toList();
    await session.db.update<_i2.EmptyModelRelationItem>(
      $emptyModelRelationItem,
      columns: [
        _i2.EmptyModelRelationItem.t
            .$_relationEmptyModelItemsRelationEmptyModelId
      ],
      transaction: transaction,
    );
  }
}

class RelationEmptyModelAttachRowRepository {
  const RelationEmptyModelAttachRowRepository._();

  Future<void> items(
    _i1.Session session,
    RelationEmptyModel relationEmptyModel,
    _i2.EmptyModelRelationItem emptyModelRelationItem, {
    _i1.Transaction? transaction,
  }) async {
    if (emptyModelRelationItem.id == null) {
      throw ArgumentError.notNull('emptyModelRelationItem.id');
    }
    if (relationEmptyModel.id == null) {
      throw ArgumentError.notNull('relationEmptyModel.id');
    }

    var $emptyModelRelationItem = _i2.EmptyModelRelationItemImplicit(
      emptyModelRelationItem,
      $_relationEmptyModelItemsRelationEmptyModelId: relationEmptyModel.id,
    );
    await session.db.updateRow<_i2.EmptyModelRelationItem>(
      $emptyModelRelationItem,
      columns: [
        _i2.EmptyModelRelationItem.t
            .$_relationEmptyModelItemsRelationEmptyModelId
      ],
      transaction: transaction,
    );
  }
}

class RelationEmptyModelDetachRepository {
  const RelationEmptyModelDetachRepository._();

  Future<void> items(
    _i1.Session session,
    List<_i2.EmptyModelRelationItem> emptyModelRelationItem, {
    _i1.Transaction? transaction,
  }) async {
    if (emptyModelRelationItem.any((e) => e.id == null)) {
      throw ArgumentError.notNull('emptyModelRelationItem.id');
    }

    var $emptyModelRelationItem = emptyModelRelationItem
        .map((e) => _i2.EmptyModelRelationItemImplicit(
              e,
              $_relationEmptyModelItemsRelationEmptyModelId: null,
            ))
        .toList();
    await session.db.update<_i2.EmptyModelRelationItem>(
      $emptyModelRelationItem,
      columns: [
        _i2.EmptyModelRelationItem.t
            .$_relationEmptyModelItemsRelationEmptyModelId
      ],
      transaction: transaction,
    );
  }
}

class RelationEmptyModelDetachRowRepository {
  const RelationEmptyModelDetachRowRepository._();

  Future<void> items(
    _i1.Session session,
    _i2.EmptyModelRelationItem emptyModelRelationItem, {
    _i1.Transaction? transaction,
  }) async {
    if (emptyModelRelationItem.id == null) {
      throw ArgumentError.notNull('emptyModelRelationItem.id');
    }

    var $emptyModelRelationItem = _i2.EmptyModelRelationItemImplicit(
      emptyModelRelationItem,
      $_relationEmptyModelItemsRelationEmptyModelId: null,
    );
    await session.db.updateRow<_i2.EmptyModelRelationItem>(
      $emptyModelRelationItem,
      columns: [
        _i2.EmptyModelRelationItem.t
            .$_relationEmptyModelItemsRelationEmptyModelId
      ],
      transaction: transaction,
    );
  }
}

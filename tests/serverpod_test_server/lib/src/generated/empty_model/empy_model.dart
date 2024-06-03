/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class EmptyModel extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  EmptyModel._({
    int? id,
    this.items,
  }) : super(id);

  factory EmptyModel({
    int? id,
    List<_i2.EmptyModelRelationItem>? items,
  }) = _EmptyModelImpl;

  factory EmptyModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmptyModel(
      id: jsonSerialization['id'] as int?,
      items: (jsonSerialization['items'] as List?)
          ?.map((e) =>
              _i2.EmptyModelRelationItem.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = EmptyModelTable();

  static const db = EmptyModelRepository._();

  List<_i2.EmptyModelRelationItem>? items;

  @override
  _i1.Table get table => t;

  EmptyModel copyWith({
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

  static EmptyModelInclude include(
      {_i2.EmptyModelRelationItemIncludeList? items}) {
    return EmptyModelInclude._(items: items);
  }

  static EmptyModelIncludeList includeList({
    _i1.WhereExpressionBuilder<EmptyModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmptyModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmptyModelTable>? orderByList,
    EmptyModelInclude? include,
  }) {
    return EmptyModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmptyModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmptyModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmptyModelImpl extends EmptyModel {
  _EmptyModelImpl({
    int? id,
    List<_i2.EmptyModelRelationItem>? items,
  }) : super._(
          id: id,
          items: items,
        );

  @override
  EmptyModel copyWith({
    Object? id = _Undefined,
    Object? items = _Undefined,
  }) {
    return EmptyModel(
      id: id is int? ? id : this.id,
      items: items is List<_i2.EmptyModelRelationItem>?
          ? items
          : this.items?.clone(),
    );
  }
}

class EmptyModelTable extends _i1.Table {
  EmptyModelTable({super.tableRelation}) : super(tableName: 'empty_model') {}

  _i2.EmptyModelRelationItemTable? ___items;

  _i1.ManyRelation<_i2.EmptyModelRelationItemTable>? _items;

  _i2.EmptyModelRelationItemTable get __items {
    if (___items != null) return ___items!;
    ___items = _i1.createRelationTable(
      relationFieldName: '__items',
      field: EmptyModel.t.id,
      foreignField: _i2.EmptyModelRelationItem.t.$_emptyModelItemsEmptyModelId,
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
      field: EmptyModel.t.id,
      foreignField: _i2.EmptyModelRelationItem.t.$_emptyModelItemsEmptyModelId,
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

class EmptyModelInclude extends _i1.IncludeObject {
  EmptyModelInclude._({_i2.EmptyModelRelationItemIncludeList? items}) {
    _items = items;
  }

  _i2.EmptyModelRelationItemIncludeList? _items;

  @override
  Map<String, _i1.Include?> get includes => {'items': _items};

  @override
  _i1.Table get table => EmptyModel.t;
}

class EmptyModelIncludeList extends _i1.IncludeList {
  EmptyModelIncludeList._({
    _i1.WhereExpressionBuilder<EmptyModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmptyModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => EmptyModel.t;
}

class EmptyModelRepository {
  const EmptyModelRepository._();

  final attach = const EmptyModelAttachRepository._();

  final attachRow = const EmptyModelAttachRowRepository._();

  final detach = const EmptyModelDetachRepository._();

  final detachRow = const EmptyModelDetachRowRepository._();

  Future<List<EmptyModel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmptyModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmptyModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmptyModelTable>? orderByList,
    _i1.Transaction? transaction,
    EmptyModelInclude? include,
  }) async {
    return session.db.find<EmptyModel>(
      where: where?.call(EmptyModel.t),
      orderBy: orderBy?.call(EmptyModel.t),
      orderByList: orderByList?.call(EmptyModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<EmptyModel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmptyModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmptyModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmptyModelTable>? orderByList,
    _i1.Transaction? transaction,
    EmptyModelInclude? include,
  }) async {
    return session.db.findFirstRow<EmptyModel>(
      where: where?.call(EmptyModel.t),
      orderBy: orderBy?.call(EmptyModel.t),
      orderByList: orderByList?.call(EmptyModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<EmptyModel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    EmptyModelInclude? include,
  }) async {
    return session.db.findById<EmptyModel>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<EmptyModel>> insert(
    _i1.Session session,
    List<EmptyModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmptyModel>(
      rows,
      transaction: transaction,
    );
  }

  Future<EmptyModel> insertRow(
    _i1.Session session,
    EmptyModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmptyModel>(
      row,
      transaction: transaction,
    );
  }

  Future<List<EmptyModel>> update(
    _i1.Session session,
    List<EmptyModel> rows, {
    _i1.ColumnSelections<EmptyModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmptyModel>(
      rows,
      columns: columns?.call(EmptyModel.t),
      transaction: transaction,
    );
  }

  Future<EmptyModel> updateRow(
    _i1.Session session,
    EmptyModel row, {
    _i1.ColumnSelections<EmptyModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmptyModel>(
      row,
      columns: columns?.call(EmptyModel.t),
      transaction: transaction,
    );
  }

  Future<List<EmptyModel>> delete(
    _i1.Session session,
    List<EmptyModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmptyModel>(
      rows,
      transaction: transaction,
    );
  }

  Future<EmptyModel> deleteRow(
    _i1.Session session,
    EmptyModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmptyModel>(
      row,
      transaction: transaction,
    );
  }

  Future<List<EmptyModel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmptyModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmptyModel>(
      where: where(EmptyModel.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmptyModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmptyModel>(
      where: where?.call(EmptyModel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class EmptyModelAttachRepository {
  const EmptyModelAttachRepository._();

  Future<void> items(
    _i1.Session session,
    EmptyModel emptyModel,
    List<_i2.EmptyModelRelationItem> emptyModelRelationItem,
  ) async {
    if (emptyModelRelationItem.any((e) => e.id == null)) {
      throw ArgumentError.notNull('emptyModelRelationItem.id');
    }
    if (emptyModel.id == null) {
      throw ArgumentError.notNull('emptyModel.id');
    }

    var $emptyModelRelationItem = emptyModelRelationItem
        .map((e) => _i2.EmptyModelRelationItemImplicit(
              e,
              $_emptyModelItemsEmptyModelId: emptyModel.id,
            ))
        .toList();
    await session.db.update<_i2.EmptyModelRelationItem>(
      $emptyModelRelationItem,
      columns: [_i2.EmptyModelRelationItem.t.$_emptyModelItemsEmptyModelId],
    );
  }
}

class EmptyModelAttachRowRepository {
  const EmptyModelAttachRowRepository._();

  Future<void> items(
    _i1.Session session,
    EmptyModel emptyModel,
    _i2.EmptyModelRelationItem emptyModelRelationItem,
  ) async {
    if (emptyModelRelationItem.id == null) {
      throw ArgumentError.notNull('emptyModelRelationItem.id');
    }
    if (emptyModel.id == null) {
      throw ArgumentError.notNull('emptyModel.id');
    }

    var $emptyModelRelationItem = _i2.EmptyModelRelationItemImplicit(
      emptyModelRelationItem,
      $_emptyModelItemsEmptyModelId: emptyModel.id,
    );
    await session.db.updateRow<_i2.EmptyModelRelationItem>(
      $emptyModelRelationItem,
      columns: [_i2.EmptyModelRelationItem.t.$_emptyModelItemsEmptyModelId],
    );
  }
}

class EmptyModelDetachRepository {
  const EmptyModelDetachRepository._();

  Future<void> items(
    _i1.Session session,
    List<_i2.EmptyModelRelationItem> emptyModelRelationItem,
  ) async {
    if (emptyModelRelationItem.any((e) => e.id == null)) {
      throw ArgumentError.notNull('emptyModelRelationItem.id');
    }

    var $emptyModelRelationItem = emptyModelRelationItem
        .map((e) => _i2.EmptyModelRelationItemImplicit(
              e,
              $_emptyModelItemsEmptyModelId: null,
            ))
        .toList();
    await session.db.update<_i2.EmptyModelRelationItem>(
      $emptyModelRelationItem,
      columns: [_i2.EmptyModelRelationItem.t.$_emptyModelItemsEmptyModelId],
    );
  }
}

class EmptyModelDetachRowRepository {
  const EmptyModelDetachRowRepository._();

  Future<void> items(
    _i1.Session session,
    _i2.EmptyModelRelationItem emptyModelRelationItem,
  ) async {
    if (emptyModelRelationItem.id == null) {
      throw ArgumentError.notNull('emptyModelRelationItem.id');
    }

    var $emptyModelRelationItem = _i2.EmptyModelRelationItemImplicit(
      emptyModelRelationItem,
      $_emptyModelItemsEmptyModelId: null,
    );
    await session.db.updateRow<_i2.EmptyModelRelationItem>(
      $emptyModelRelationItem,
      columns: [_i2.EmptyModelRelationItem.t.$_emptyModelItemsEmptyModelId],
    );
  }
}

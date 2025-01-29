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

abstract class EmptyModelRelationItem
    implements _i1.TableRow, _i1.ProtocolSerialization {
  EmptyModelRelationItem._({
    this.id,
    required this.name,
  });

  factory EmptyModelRelationItem({
    int? id,
    required String name,
  }) = _EmptyModelRelationItemImpl;

  factory EmptyModelRelationItem.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmptyModelRelationItem(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
    );
  }

  static final t = EmptyModelRelationItemTable();

  static const db = EmptyModelRelationItemRepository._();

  @override
  int? id;

  String name;

  int? _relationEmptyModelItemsRelationEmptyModelId;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [EmptyModelRelationItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmptyModelRelationItem copyWith({
    int? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (_relationEmptyModelItemsRelationEmptyModelId != null)
        '_relationEmptyModelItemsRelationEmptyModelId':
            _relationEmptyModelItemsRelationEmptyModelId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }

  static EmptyModelRelationItemInclude include() {
    return EmptyModelRelationItemInclude._();
  }

  static EmptyModelRelationItemIncludeList includeList({
    _i1.WhereExpressionBuilder<EmptyModelRelationItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmptyModelRelationItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmptyModelRelationItemTable>? orderByList,
    EmptyModelRelationItemInclude? include,
  }) {
    return EmptyModelRelationItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmptyModelRelationItem.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmptyModelRelationItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmptyModelRelationItemImpl extends EmptyModelRelationItem {
  _EmptyModelRelationItemImpl({
    int? id,
    required String name,
  }) : super._(
          id: id,
          name: name,
        );

  /// Returns a shallow copy of this [EmptyModelRelationItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmptyModelRelationItem copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return EmptyModelRelationItem(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
    );
  }
}

class EmptyModelRelationItemImplicit extends _EmptyModelRelationItemImpl {
  EmptyModelRelationItemImplicit._({
    int? id,
    required String name,
    this.$_relationEmptyModelItemsRelationEmptyModelId,
  }) : super(
          id: id,
          name: name,
        );

  factory EmptyModelRelationItemImplicit(
    EmptyModelRelationItem emptyModelRelationItem, {
    int? $_relationEmptyModelItemsRelationEmptyModelId,
  }) {
    return EmptyModelRelationItemImplicit._(
      id: emptyModelRelationItem.id,
      name: emptyModelRelationItem.name,
      $_relationEmptyModelItemsRelationEmptyModelId:
          $_relationEmptyModelItemsRelationEmptyModelId,
    );
  }

  int? $_relationEmptyModelItemsRelationEmptyModelId;

  @override
  Map<String, dynamic> toJson() {
    var jsonMap = super.toJson();
    jsonMap.addAll({
      '_relationEmptyModelItemsRelationEmptyModelId':
          $_relationEmptyModelItemsRelationEmptyModelId
    });
    return jsonMap;
  }
}

class EmptyModelRelationItemTable extends _i1.Table {
  EmptyModelRelationItemTable({super.tableRelation})
      : super(tableName: 'empty_model_relation_item') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    $_relationEmptyModelItemsRelationEmptyModelId = _i1.ColumnInt(
      '_relationEmptyModelItemsRelationEmptyModelId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt $_relationEmptyModelItemsRelationEmptyModelId;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        $_relationEmptyModelItemsRelationEmptyModelId,
      ];
}

class EmptyModelRelationItemInclude extends _i1.IncludeObject {
  EmptyModelRelationItemInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => EmptyModelRelationItem.t;
}

class EmptyModelRelationItemIncludeList extends _i1.IncludeList {
  EmptyModelRelationItemIncludeList._({
    _i1.WhereExpressionBuilder<EmptyModelRelationItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmptyModelRelationItem.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => EmptyModelRelationItem.t;
}

class EmptyModelRelationItemRepository {
  const EmptyModelRelationItemRepository._();

  /// Returns a list of [EmptyModelRelationItem]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<EmptyModelRelationItem>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmptyModelRelationItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmptyModelRelationItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmptyModelRelationItemTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmptyModelRelationItem>(
      where: where?.call(EmptyModelRelationItem.t),
      orderBy: orderBy?.call(EmptyModelRelationItem.t),
      orderByList: orderByList?.call(EmptyModelRelationItem.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmptyModelRelationItem] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<EmptyModelRelationItem?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmptyModelRelationItemTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmptyModelRelationItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmptyModelRelationItemTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmptyModelRelationItem>(
      where: where?.call(EmptyModelRelationItem.t),
      orderBy: orderBy?.call(EmptyModelRelationItem.t),
      orderByList: orderByList?.call(EmptyModelRelationItem.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmptyModelRelationItem] by its [id] or null if no such row exists.
  Future<EmptyModelRelationItem?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmptyModelRelationItem>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmptyModelRelationItem]s in the list and returns the inserted rows.
  ///
  /// The returned [EmptyModelRelationItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmptyModelRelationItem>> insert(
    _i1.Session session,
    List<EmptyModelRelationItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmptyModelRelationItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmptyModelRelationItem] and returns the inserted row.
  ///
  /// The returned [EmptyModelRelationItem] will have its `id` field set.
  Future<EmptyModelRelationItem> insertRow(
    _i1.Session session,
    EmptyModelRelationItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmptyModelRelationItem>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmptyModelRelationItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmptyModelRelationItem>> update(
    _i1.Session session,
    List<EmptyModelRelationItem> rows, {
    _i1.ColumnSelections<EmptyModelRelationItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmptyModelRelationItem>(
      rows,
      columns: columns?.call(EmptyModelRelationItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmptyModelRelationItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmptyModelRelationItem> updateRow(
    _i1.Session session,
    EmptyModelRelationItem row, {
    _i1.ColumnSelections<EmptyModelRelationItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmptyModelRelationItem>(
      row,
      columns: columns?.call(EmptyModelRelationItem.t),
      transaction: transaction,
    );
  }

  /// Deletes all [EmptyModelRelationItem]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmptyModelRelationItem>> delete(
    _i1.Session session,
    List<EmptyModelRelationItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmptyModelRelationItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmptyModelRelationItem].
  Future<EmptyModelRelationItem> deleteRow(
    _i1.Session session,
    EmptyModelRelationItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmptyModelRelationItem>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmptyModelRelationItem>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmptyModelRelationItemTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmptyModelRelationItem>(
      where: where(EmptyModelRelationItem.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmptyModelRelationItemTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmptyModelRelationItem>(
      where: where?.call(EmptyModelRelationItem.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

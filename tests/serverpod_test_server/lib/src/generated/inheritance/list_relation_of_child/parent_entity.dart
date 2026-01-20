/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../inheritance/list_relation_of_child/child_entity.dart' as _i2;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i3;

abstract class ParentEntity
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ParentEntity._({
    this.id,
    this.children,
  });

  factory ParentEntity({
    int? id,
    List<_i2.ChildEntity>? children,
  }) = _ParentEntityImpl;

  factory ParentEntity.fromJson(Map<String, dynamic> jsonSerialization) {
    return ParentEntity(
      id: jsonSerialization['id'] as int?,
      children: jsonSerialization['children'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.ChildEntity>>(
              jsonSerialization['children'],
            ),
    );
  }

  static final t = ParentEntityTable();

  static const db = ParentEntityRepository._();

  @override
  int? id;

  List<_i2.ChildEntity>? children;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ParentEntity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ParentEntity copyWith({
    int? id,
    List<_i2.ChildEntity>? children,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ParentEntity',
      if (id != null) 'id': id,
      if (children != null)
        'children': children?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ParentEntity',
      if (id != null) 'id': id,
      if (children != null)
        'children': children?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static ParentEntityInclude include({_i2.ChildEntityIncludeList? children}) {
    return ParentEntityInclude._(children: children);
  }

  static ParentEntityIncludeList includeList({
    _i1.WhereExpressionBuilder<ParentEntityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ParentEntityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ParentEntityTable>? orderByList,
    ParentEntityInclude? include,
  }) {
    return ParentEntityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ParentEntity.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ParentEntity.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ParentEntityImpl extends ParentEntity {
  _ParentEntityImpl({
    int? id,
    List<_i2.ChildEntity>? children,
  }) : super._(
         id: id,
         children: children,
       );

  /// Returns a shallow copy of this [ParentEntity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ParentEntity copyWith({
    Object? id = _Undefined,
    Object? children = _Undefined,
  }) {
    return ParentEntity(
      id: id is int? ? id : this.id,
      children: children is List<_i2.ChildEntity>?
          ? children
          : this.children?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class ParentEntityUpdateTable extends _i1.UpdateTable<ParentEntityTable> {
  ParentEntityUpdateTable(super.table);
}

class ParentEntityTable extends _i1.Table<int?> {
  ParentEntityTable({super.tableRelation}) : super(tableName: 'parent_entity') {
    updateTable = ParentEntityUpdateTable(this);
  }

  late final ParentEntityUpdateTable updateTable;

  _i2.ChildEntityTable? ___children;

  _i1.ManyRelation<_i2.ChildEntityTable>? _children;

  _i2.ChildEntityTable get __children {
    if (___children != null) return ___children!;
    ___children = _i1.createRelationTable(
      relationFieldName: '__children',
      field: ParentEntity.t.id,
      foreignField: _i2.ChildEntity.t.$_parentEntityChildrenParentEntityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ChildEntityTable(tableRelation: foreignTableRelation),
    );
    return ___children!;
  }

  _i1.ManyRelation<_i2.ChildEntityTable> get children {
    if (_children != null) return _children!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'children',
      field: ParentEntity.t.id,
      foreignField: _i2.ChildEntity.t.$_parentEntityChildrenParentEntityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ChildEntityTable(tableRelation: foreignTableRelation),
    );
    _children = _i1.ManyRelation<_i2.ChildEntityTable>(
      tableWithRelations: relationTable,
      table: _i2.ChildEntityTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _children!;
  }

  @override
  List<_i1.Column> get columns => [id];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'children') {
      return __children;
    }
    return null;
  }
}

class ParentEntityInclude extends _i1.IncludeObject {
  ParentEntityInclude._({_i2.ChildEntityIncludeList? children}) {
    _children = children;
  }

  _i2.ChildEntityIncludeList? _children;

  @override
  Map<String, _i1.Include?> get includes => {'children': _children};

  @override
  _i1.Table<int?> get table => ParentEntity.t;
}

class ParentEntityIncludeList extends _i1.IncludeList {
  ParentEntityIncludeList._({
    _i1.WhereExpressionBuilder<ParentEntityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ParentEntity.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ParentEntity.t;
}

class ParentEntityRepository {
  const ParentEntityRepository._();

  final attach = const ParentEntityAttachRepository._();

  final attachRow = const ParentEntityAttachRowRepository._();

  final detach = const ParentEntityDetachRepository._();

  final detachRow = const ParentEntityDetachRowRepository._();

  /// Returns a list of [ParentEntity]s matching the given query parameters.
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
  Future<List<ParentEntity>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentEntityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ParentEntityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ParentEntityTable>? orderByList,
    _i1.Transaction? transaction,
    ParentEntityInclude? include,
  }) async {
    return session.db.find<ParentEntity>(
      where: where?.call(ParentEntity.t),
      orderBy: orderBy?.call(ParentEntity.t),
      orderByList: orderByList?.call(ParentEntity.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ParentEntity] matching the given query parameters.
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
  Future<ParentEntity?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentEntityTable>? where,
    int? offset,
    _i1.OrderByBuilder<ParentEntityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ParentEntityTable>? orderByList,
    _i1.Transaction? transaction,
    ParentEntityInclude? include,
  }) async {
    return session.db.findFirstRow<ParentEntity>(
      where: where?.call(ParentEntity.t),
      orderBy: orderBy?.call(ParentEntity.t),
      orderByList: orderByList?.call(ParentEntity.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ParentEntity] by its [id] or null if no such row exists.
  Future<ParentEntity?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ParentEntityInclude? include,
  }) async {
    return session.db.findById<ParentEntity>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ParentEntity]s in the list and returns the inserted rows.
  ///
  /// The returned [ParentEntity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ParentEntity>> insert(
    _i1.Session session,
    List<ParentEntity> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ParentEntity>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ParentEntity] and returns the inserted row.
  ///
  /// The returned [ParentEntity] will have its `id` field set.
  Future<ParentEntity> insertRow(
    _i1.Session session,
    ParentEntity row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ParentEntity>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ParentEntity]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ParentEntity>> update(
    _i1.Session session,
    List<ParentEntity> rows, {
    _i1.ColumnSelections<ParentEntityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ParentEntity>(
      rows,
      columns: columns?.call(ParentEntity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ParentEntity]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ParentEntity> updateRow(
    _i1.Session session,
    ParentEntity row, {
    _i1.ColumnSelections<ParentEntityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ParentEntity>(
      row,
      columns: columns?.call(ParentEntity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ParentEntity] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ParentEntity?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ParentEntityUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ParentEntity>(
      id,
      columnValues: columnValues(ParentEntity.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ParentEntity]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ParentEntity>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ParentEntityUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ParentEntityTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ParentEntityTable>? orderBy,
    _i1.OrderByListBuilder<ParentEntityTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ParentEntity>(
      columnValues: columnValues(ParentEntity.t.updateTable),
      where: where(ParentEntity.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ParentEntity.t),
      orderByList: orderByList?.call(ParentEntity.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ParentEntity]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ParentEntity>> delete(
    _i1.Session session,
    List<ParentEntity> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ParentEntity>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ParentEntity].
  Future<ParentEntity> deleteRow(
    _i1.Session session,
    ParentEntity row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ParentEntity>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ParentEntity>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ParentEntityTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ParentEntity>(
      where: where(ParentEntity.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentEntityTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ParentEntity>(
      where: where?.call(ParentEntity.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ParentEntityAttachRepository {
  const ParentEntityAttachRepository._();

  /// Creates a relation between this [ParentEntity] and the given [ChildEntity]s
  /// by setting each [ChildEntity]'s foreign key `_parentEntityChildrenParentEntityId` to refer to this [ParentEntity].
  Future<void> children(
    _i1.Session session,
    ParentEntity parentEntity,
    List<_i2.ChildEntity> childEntity, {
    _i1.Transaction? transaction,
  }) async {
    if (childEntity.any((e) => e.id == null)) {
      throw ArgumentError.notNull('childEntity.id');
    }
    if (parentEntity.id == null) {
      throw ArgumentError.notNull('parentEntity.id');
    }

    var $childEntity = childEntity
        .map(
          (e) => _i2.ChildEntityImplicit(
            e,
            $_parentEntityChildrenParentEntityId: parentEntity.id,
          ),
        )
        .toList();
    await session.db.update<_i2.ChildEntity>(
      $childEntity,
      columns: [_i2.ChildEntity.t.$_parentEntityChildrenParentEntityId],
      transaction: transaction,
    );
  }
}

class ParentEntityAttachRowRepository {
  const ParentEntityAttachRowRepository._();

  /// Creates a relation between this [ParentEntity] and the given [ChildEntity]
  /// by setting the [ChildEntity]'s foreign key `_parentEntityChildrenParentEntityId` to refer to this [ParentEntity].
  Future<void> children(
    _i1.Session session,
    ParentEntity parentEntity,
    _i2.ChildEntity childEntity, {
    _i1.Transaction? transaction,
  }) async {
    if (childEntity.id == null) {
      throw ArgumentError.notNull('childEntity.id');
    }
    if (parentEntity.id == null) {
      throw ArgumentError.notNull('parentEntity.id');
    }

    var $childEntity = _i2.ChildEntityImplicit(
      childEntity,
      $_parentEntityChildrenParentEntityId: parentEntity.id,
    );
    await session.db.updateRow<_i2.ChildEntity>(
      $childEntity,
      columns: [_i2.ChildEntity.t.$_parentEntityChildrenParentEntityId],
      transaction: transaction,
    );
  }
}

class ParentEntityDetachRepository {
  const ParentEntityDetachRepository._();

  /// Detaches the relation between this [ParentEntity] and the given [ChildEntity]
  /// by setting the [ChildEntity]'s foreign key `_parentEntityChildrenParentEntityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> children(
    _i1.Session session,
    List<_i2.ChildEntity> childEntity, {
    _i1.Transaction? transaction,
  }) async {
    if (childEntity.any((e) => e.id == null)) {
      throw ArgumentError.notNull('childEntity.id');
    }

    var $childEntity = childEntity
        .map(
          (e) => _i2.ChildEntityImplicit(
            e,
            $_parentEntityChildrenParentEntityId: null,
          ),
        )
        .toList();
    await session.db.update<_i2.ChildEntity>(
      $childEntity,
      columns: [_i2.ChildEntity.t.$_parentEntityChildrenParentEntityId],
      transaction: transaction,
    );
  }
}

class ParentEntityDetachRowRepository {
  const ParentEntityDetachRowRepository._();

  /// Detaches the relation between this [ParentEntity] and the given [ChildEntity]
  /// by setting the [ChildEntity]'s foreign key `_parentEntityChildrenParentEntityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> children(
    _i1.Session session,
    _i2.ChildEntity childEntity, {
    _i1.Transaction? transaction,
  }) async {
    if (childEntity.id == null) {
      throw ArgumentError.notNull('childEntity.id');
    }

    var $childEntity = _i2.ChildEntityImplicit(
      childEntity,
      $_parentEntityChildrenParentEntityId: null,
    );
    await session.db.updateRow<_i2.ChildEntity>(
      $childEntity,
      columns: [_i2.ChildEntity.t.$_parentEntityChildrenParentEntityId],
      transaction: transaction,
    );
  }
}

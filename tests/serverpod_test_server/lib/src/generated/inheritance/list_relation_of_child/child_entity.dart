/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../../protocol.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;

abstract class ChildEntity extends _i1.BaseEntity
    implements _i2.TableRow<int?>, _i2.ProtocolSerialization {
  ChildEntity._({
    this.id,
    required super.sharedField,
    required this.localField,
  }) : _parentEntityChildrenParentEntityId = null;

  factory ChildEntity({
    int? id,
    required String sharedField,
    required String localField,
  }) = _ChildEntityImpl;

  factory ChildEntity.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChildEntityImplicit._(
      id: jsonSerialization['id'] as int?,
      sharedField: jsonSerialization['sharedField'] as String,
      localField: jsonSerialization['localField'] as String,
      $_parentEntityChildrenParentEntityId:
          jsonSerialization['_parentEntityChildrenParentEntityId'] as int?,
    );
  }

  static final t = ChildEntityTable();

  static const db = ChildEntityRepository._();

  @override
  int? id;

  String localField;

  final int? _parentEntityChildrenParentEntityId;

  @override
  _i2.Table<int?> get table => t;

  /// Returns a shallow copy of this [ChildEntity]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  ChildEntity copyWith({
    int? id,
    String? sharedField,
    String? localField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChildEntity',
      if (id != null) 'id': id,
      'sharedField': sharedField,
      'localField': localField,
      if (_parentEntityChildrenParentEntityId != null)
        '_parentEntityChildrenParentEntityId':
            _parentEntityChildrenParentEntityId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChildEntity',
      if (id != null) 'id': id,
      'sharedField': sharedField,
      'localField': localField,
    };
  }

  static ChildEntityInclude include() {
    return ChildEntityInclude._();
  }

  static ChildEntityIncludeList includeList({
    _i2.WhereExpressionBuilder<ChildEntityTable>? where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<ChildEntityTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ChildEntityTable>? orderByList,
    ChildEntityInclude? include,
  }) {
    return ChildEntityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildEntity.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ChildEntity.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildEntityImpl extends ChildEntity {
  _ChildEntityImpl({
    int? id,
    required String sharedField,
    required String localField,
  }) : super._(
         id: id,
         sharedField: sharedField,
         localField: localField,
       );

  /// Returns a shallow copy of this [ChildEntity]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ChildEntity copyWith({
    Object? id = _Undefined,
    String? sharedField,
    String? localField,
  }) {
    return ChildEntityImplicit._(
      id: id is int? ? id : this.id,
      sharedField: sharedField ?? this.sharedField,
      localField: localField ?? this.localField,
      $_parentEntityChildrenParentEntityId:
          this._parentEntityChildrenParentEntityId,
    );
  }
}

class ChildEntityImplicit extends _ChildEntityImpl {
  ChildEntityImplicit._({
    int? id,
    required String sharedField,
    required String localField,
    int? $_parentEntityChildrenParentEntityId,
  }) : _parentEntityChildrenParentEntityId =
           $_parentEntityChildrenParentEntityId,
       super(
         id: id,
         sharedField: sharedField,
         localField: localField,
       );

  factory ChildEntityImplicit(
    ChildEntity childEntity, {
    int? $_parentEntityChildrenParentEntityId,
  }) {
    return ChildEntityImplicit._(
      id: childEntity.id,
      sharedField: childEntity.sharedField,
      localField: childEntity.localField,
      $_parentEntityChildrenParentEntityId:
          $_parentEntityChildrenParentEntityId,
    );
  }

  @override
  final int? _parentEntityChildrenParentEntityId;
}

class ChildEntityUpdateTable extends _i2.UpdateTable<ChildEntityTable> {
  ChildEntityUpdateTable(super.table);

  _i2.ColumnValue<String, String> sharedField(String value) => _i2.ColumnValue(
    table.sharedField,
    value,
  );

  _i2.ColumnValue<String, String> localField(String value) => _i2.ColumnValue(
    table.localField,
    value,
  );

  _i2.ColumnValue<int, int> $_parentEntityChildrenParentEntityId(int? value) =>
      _i2.ColumnValue(
        table.$_parentEntityChildrenParentEntityId,
        value,
      );
}

class ChildEntityTable extends _i2.Table<int?> {
  ChildEntityTable({super.tableRelation}) : super(tableName: 'child_entity') {
    updateTable = ChildEntityUpdateTable(this);
    sharedField = _i2.ColumnString(
      'sharedField',
      this,
    );
    localField = _i2.ColumnString(
      'localField',
      this,
    );
    $_parentEntityChildrenParentEntityId = _i2.ColumnInt(
      '_parentEntityChildrenParentEntityId',
      this,
    );
  }

  late final ChildEntityUpdateTable updateTable;

  late final _i2.ColumnString sharedField;

  late final _i2.ColumnString localField;

  late final _i2.ColumnInt $_parentEntityChildrenParentEntityId;

  @override
  List<_i2.Column> get columns => [
    id,
    sharedField,
    localField,
    $_parentEntityChildrenParentEntityId,
  ];

  @override
  List<_i2.Column> get managedColumns => [
    id,
    sharedField,
    localField,
  ];
}

class ChildEntityInclude extends _i2.IncludeObject {
  ChildEntityInclude._();

  @override
  Map<String, _i2.Include?> get includes => {};

  @override
  _i2.Table<int?> get table => ChildEntity.t;
}

class ChildEntityIncludeList extends _i2.IncludeList {
  ChildEntityIncludeList._({
    _i2.WhereExpressionBuilder<ChildEntityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChildEntity.t);
  }

  @override
  Map<String, _i2.Include?> get includes => include?.includes ?? {};

  @override
  _i2.Table<int?> get table => ChildEntity.t;
}

class ChildEntityRepository {
  const ChildEntityRepository._();

  /// Returns a list of [ChildEntity]s matching the given query parameters.
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
  Future<List<ChildEntity>> find(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ChildEntityTable>? where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<ChildEntityTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ChildEntityTable>? orderByList,
    _i2.Transaction? transaction,
    _i2.LockMode? lockMode,
    _i2.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ChildEntity>(
      where: where?.call(ChildEntity.t),
      orderBy: orderBy?.call(ChildEntity.t),
      orderByList: orderByList?.call(ChildEntity.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ChildEntity] matching the given query parameters.
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
  Future<ChildEntity?> findFirstRow(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ChildEntityTable>? where,
    int? offset,
    _i2.OrderByBuilder<ChildEntityTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ChildEntityTable>? orderByList,
    _i2.Transaction? transaction,
    _i2.LockMode? lockMode,
    _i2.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ChildEntity>(
      where: where?.call(ChildEntity.t),
      orderBy: orderBy?.call(ChildEntity.t),
      orderByList: orderByList?.call(ChildEntity.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ChildEntity] by its [id] or null if no such row exists.
  Future<ChildEntity?> findById(
    _i2.Session session,
    int id, {
    _i2.Transaction? transaction,
    _i2.LockMode? lockMode,
    _i2.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ChildEntity>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ChildEntity]s in the list and returns the inserted rows.
  ///
  /// The returned [ChildEntity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ChildEntity>> insert(
    _i2.Session session,
    List<ChildEntity> rows, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.insert<ChildEntity>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ChildEntity] and returns the inserted row.
  ///
  /// The returned [ChildEntity] will have its `id` field set.
  Future<ChildEntity> insertRow(
    _i2.Session session,
    ChildEntity row, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChildEntity>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ChildEntity]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ChildEntity>> update(
    _i2.Session session,
    List<ChildEntity> rows, {
    _i2.ColumnSelections<ChildEntityTable>? columns,
    _i2.Transaction? transaction,
  }) async {
    return session.db.update<ChildEntity>(
      rows,
      columns: columns?.call(ChildEntity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChildEntity]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChildEntity> updateRow(
    _i2.Session session,
    ChildEntity row, {
    _i2.ColumnSelections<ChildEntityTable>? columns,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChildEntity>(
      row,
      columns: columns?.call(ChildEntity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChildEntity] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChildEntity?> updateById(
    _i2.Session session,
    int id, {
    required _i2.ColumnValueListBuilder<ChildEntityUpdateTable> columnValues,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateById<ChildEntity>(
      id,
      columnValues: columnValues(ChildEntity.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChildEntity]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ChildEntity>> updateWhere(
    _i2.Session session, {
    required _i2.ColumnValueListBuilder<ChildEntityUpdateTable> columnValues,
    required _i2.WhereExpressionBuilder<ChildEntityTable> where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<ChildEntityTable>? orderBy,
    _i2.OrderByListBuilder<ChildEntityTable>? orderByList,
    bool orderDescending = false,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ChildEntity>(
      columnValues: columnValues(ChildEntity.t.updateTable),
      where: where(ChildEntity.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildEntity.t),
      orderByList: orderByList?.call(ChildEntity.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ChildEntity]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ChildEntity>> delete(
    _i2.Session session,
    List<ChildEntity> rows, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.delete<ChildEntity>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ChildEntity].
  Future<ChildEntity> deleteRow(
    _i2.Session session,
    ChildEntity row, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChildEntity>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ChildEntity>> deleteWhere(
    _i2.Session session, {
    required _i2.WhereExpressionBuilder<ChildEntityTable> where,
    _i2.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ChildEntity>(
      where: where(ChildEntity.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ChildEntityTable>? where,
    int? limit,
    _i2.Transaction? transaction,
  }) async {
    return session.db.count<ChildEntity>(
      where: where?.call(ChildEntity.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ChildEntity] rows matching the [where] expression.
  Future<void> lockRows(
    _i2.Session session, {
    required _i2.WhereExpressionBuilder<ChildEntityTable> where,
    required _i2.LockMode lockMode,
    required _i2.Transaction transaction,
    _i2.LockBehavior lockBehavior = _i2.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ChildEntity>(
      where: where(ChildEntity.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

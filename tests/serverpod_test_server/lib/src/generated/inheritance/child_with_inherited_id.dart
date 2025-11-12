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
import '../protocol.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;
import '../inheritance/child_with_inherited_id.dart' as _i3;

abstract class ChildWithInheritedId extends _i1.ParentWithChangedId
    implements _i2.TableRow<_i2.UuidValue>, _i2.ProtocolSerialization {
  ChildWithInheritedId._({
    _i2.UuidValue? id,
    required this.name,
    this.parent,
    this.parentId,
  }) : id = id ?? _i2.Uuid().v7obj();

  factory ChildWithInheritedId({
    _i2.UuidValue? id,
    required String name,
    _i3.ChildWithInheritedId? parent,
    _i2.UuidValue? parentId,
  }) = _ChildWithInheritedIdImpl;

  factory ChildWithInheritedId.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ChildWithInheritedId(
      id: _i2.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      parent: jsonSerialization['parent'] == null
          ? null
          : _i3.ChildWithInheritedId.fromJson(
              (jsonSerialization['parent'] as Map<String, dynamic>),
            ),
      parentId: jsonSerialization['parentId'] == null
          ? null
          : _i2.UuidValueJsonExtension.fromJson(jsonSerialization['parentId']),
    );
  }

  static final t = ChildWithInheritedIdTable();

  static const db = ChildWithInheritedIdRepository._();

  @override
  _i2.UuidValue id;

  String name;

  _i3.ChildWithInheritedId? parent;

  _i2.UuidValue? parentId;

  @override
  _i2.Table<_i2.UuidValue> get table => t;

  /// Returns a shallow copy of this [ChildWithInheritedId]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  ChildWithInheritedId copyWith({
    _i2.UuidValue? id,
    String? name,
    _i3.ChildWithInheritedId? parent,
    _i2.UuidValue? parentId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      'name': name,
      if (parent != null) 'parent': parent?.toJson(),
      if (parentId != null) 'parentId': parentId?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ChildWithInheritedIdInclude include({
    _i3.ChildWithInheritedIdInclude? parent,
  }) {
    return ChildWithInheritedIdInclude._(parent: parent);
  }

  static ChildWithInheritedIdIncludeList includeList({
    _i2.WhereExpressionBuilder<ChildWithInheritedIdTable>? where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<ChildWithInheritedIdTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ChildWithInheritedIdTable>? orderByList,
    ChildWithInheritedIdInclude? include,
  }) {
    return ChildWithInheritedIdIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildWithInheritedId.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ChildWithInheritedId.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildWithInheritedIdImpl extends ChildWithInheritedId {
  _ChildWithInheritedIdImpl({
    _i2.UuidValue? id,
    required String name,
    _i3.ChildWithInheritedId? parent,
    _i2.UuidValue? parentId,
  }) : super._(
         id: id,
         name: name,
         parent: parent,
         parentId: parentId,
       );

  /// Returns a shallow copy of this [ChildWithInheritedId]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ChildWithInheritedId copyWith({
    _i2.UuidValue? id,
    String? name,
    Object? parent = _Undefined,
    Object? parentId = _Undefined,
  }) {
    return ChildWithInheritedId(
      id: id ?? this.id,
      name: name ?? this.name,
      parent: parent is _i3.ChildWithInheritedId?
          ? parent
          : this.parent?.copyWith(),
      parentId: parentId is _i2.UuidValue? ? parentId : this.parentId,
    );
  }
}

class ChildWithInheritedIdUpdateTable
    extends _i2.UpdateTable<ChildWithInheritedIdTable> {
  ChildWithInheritedIdUpdateTable(super.table);

  _i2.ColumnValue<String, String> name(String value) => _i2.ColumnValue(
    table.name,
    value,
  );

  _i2.ColumnValue<_i2.UuidValue, _i2.UuidValue> parentId(
    _i2.UuidValue? value,
  ) => _i2.ColumnValue(
    table.parentId,
    value,
  );
}

class ChildWithInheritedIdTable extends _i2.Table<_i2.UuidValue> {
  ChildWithInheritedIdTable({super.tableRelation})
    : super(tableName: 'child_with_inherited_id') {
    updateTable = ChildWithInheritedIdUpdateTable(this);
    name = _i2.ColumnString(
      'name',
      this,
    );
    parentId = _i2.ColumnUuid(
      'parentId',
      this,
    );
  }

  late final ChildWithInheritedIdUpdateTable updateTable;

  late final _i2.ColumnString name;

  _i3.ChildWithInheritedIdTable? _parent;

  late final _i2.ColumnUuid parentId;

  _i3.ChildWithInheritedIdTable get parent {
    if (_parent != null) return _parent!;
    _parent = _i2.createRelationTable(
      relationFieldName: 'parent',
      field: ChildWithInheritedId.t.parentId,
      foreignField: _i3.ChildWithInheritedId.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ChildWithInheritedIdTable(tableRelation: foreignTableRelation),
    );
    return _parent!;
  }

  @override
  List<_i2.Column> get columns => [
    id,
    name,
    parentId,
  ];

  @override
  _i2.Table? getRelationTable(String relationField) {
    if (relationField == 'parent') {
      return parent;
    }
    return null;
  }
}

class ChildWithInheritedIdInclude extends _i2.IncludeObject {
  ChildWithInheritedIdInclude._({_i3.ChildWithInheritedIdInclude? parent}) {
    _parent = parent;
  }

  _i3.ChildWithInheritedIdInclude? _parent;

  @override
  Map<String, _i2.Include?> get includes => {'parent': _parent};

  @override
  _i2.Table<_i2.UuidValue> get table => ChildWithInheritedId.t;
}

class ChildWithInheritedIdIncludeList extends _i2.IncludeList {
  ChildWithInheritedIdIncludeList._({
    _i2.WhereExpressionBuilder<ChildWithInheritedIdTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChildWithInheritedId.t);
  }

  @override
  Map<String, _i2.Include?> get includes => include?.includes ?? {};

  @override
  _i2.Table<_i2.UuidValue> get table => ChildWithInheritedId.t;
}

class ChildWithInheritedIdRepository {
  const ChildWithInheritedIdRepository._();

  final attachRow = const ChildWithInheritedIdAttachRowRepository._();

  final detachRow = const ChildWithInheritedIdDetachRowRepository._();

  /// Returns a list of [ChildWithInheritedId]s matching the given query parameters.
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
  Future<List<ChildWithInheritedId>> find(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ChildWithInheritedIdTable>? where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<ChildWithInheritedIdTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ChildWithInheritedIdTable>? orderByList,
    _i2.Transaction? transaction,
    ChildWithInheritedIdInclude? include,
  }) async {
    return session.db.find<ChildWithInheritedId>(
      where: where?.call(ChildWithInheritedId.t),
      orderBy: orderBy?.call(ChildWithInheritedId.t),
      orderByList: orderByList?.call(ChildWithInheritedId.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ChildWithInheritedId] matching the given query parameters.
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
  Future<ChildWithInheritedId?> findFirstRow(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ChildWithInheritedIdTable>? where,
    int? offset,
    _i2.OrderByBuilder<ChildWithInheritedIdTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ChildWithInheritedIdTable>? orderByList,
    _i2.Transaction? transaction,
    ChildWithInheritedIdInclude? include,
  }) async {
    return session.db.findFirstRow<ChildWithInheritedId>(
      where: where?.call(ChildWithInheritedId.t),
      orderBy: orderBy?.call(ChildWithInheritedId.t),
      orderByList: orderByList?.call(ChildWithInheritedId.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ChildWithInheritedId] by its [id] or null if no such row exists.
  Future<ChildWithInheritedId?> findById(
    _i2.Session session,
    _i2.UuidValue id, {
    _i2.Transaction? transaction,
    ChildWithInheritedIdInclude? include,
  }) async {
    return session.db.findById<ChildWithInheritedId>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ChildWithInheritedId]s in the list and returns the inserted rows.
  ///
  /// The returned [ChildWithInheritedId]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ChildWithInheritedId>> insert(
    _i2.Session session,
    List<ChildWithInheritedId> rows, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.insert<ChildWithInheritedId>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ChildWithInheritedId] and returns the inserted row.
  ///
  /// The returned [ChildWithInheritedId] will have its `id` field set.
  Future<ChildWithInheritedId> insertRow(
    _i2.Session session,
    ChildWithInheritedId row, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChildWithInheritedId>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ChildWithInheritedId]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ChildWithInheritedId>> update(
    _i2.Session session,
    List<ChildWithInheritedId> rows, {
    _i2.ColumnSelections<ChildWithInheritedIdTable>? columns,
    _i2.Transaction? transaction,
  }) async {
    return session.db.update<ChildWithInheritedId>(
      rows,
      columns: columns?.call(ChildWithInheritedId.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChildWithInheritedId]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChildWithInheritedId> updateRow(
    _i2.Session session,
    ChildWithInheritedId row, {
    _i2.ColumnSelections<ChildWithInheritedIdTable>? columns,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChildWithInheritedId>(
      row,
      columns: columns?.call(ChildWithInheritedId.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChildWithInheritedId] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChildWithInheritedId?> updateById(
    _i2.Session session,
    _i2.UuidValue id, {
    required _i2.ColumnValueListBuilder<ChildWithInheritedIdUpdateTable>
    columnValues,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateById<ChildWithInheritedId>(
      id,
      columnValues: columnValues(ChildWithInheritedId.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChildWithInheritedId]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ChildWithInheritedId>> updateWhere(
    _i2.Session session, {
    required _i2.ColumnValueListBuilder<ChildWithInheritedIdUpdateTable>
    columnValues,
    required _i2.WhereExpressionBuilder<ChildWithInheritedIdTable> where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<ChildWithInheritedIdTable>? orderBy,
    _i2.OrderByListBuilder<ChildWithInheritedIdTable>? orderByList,
    bool orderDescending = false,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ChildWithInheritedId>(
      columnValues: columnValues(ChildWithInheritedId.t.updateTable),
      where: where(ChildWithInheritedId.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildWithInheritedId.t),
      orderByList: orderByList?.call(ChildWithInheritedId.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ChildWithInheritedId]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ChildWithInheritedId>> delete(
    _i2.Session session,
    List<ChildWithInheritedId> rows, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.delete<ChildWithInheritedId>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ChildWithInheritedId].
  Future<ChildWithInheritedId> deleteRow(
    _i2.Session session,
    ChildWithInheritedId row, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChildWithInheritedId>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ChildWithInheritedId>> deleteWhere(
    _i2.Session session, {
    required _i2.WhereExpressionBuilder<ChildWithInheritedIdTable> where,
    _i2.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ChildWithInheritedId>(
      where: where(ChildWithInheritedId.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ChildWithInheritedIdTable>? where,
    int? limit,
    _i2.Transaction? transaction,
  }) async {
    return session.db.count<ChildWithInheritedId>(
      where: where?.call(ChildWithInheritedId.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ChildWithInheritedIdAttachRowRepository {
  const ChildWithInheritedIdAttachRowRepository._();

  /// Creates a relation between the given [ChildWithInheritedId] and [ChildWithInheritedId]
  /// by setting the [ChildWithInheritedId]'s foreign key `parentId` to refer to the [ChildWithInheritedId].
  Future<void> parent(
    _i2.Session session,
    ChildWithInheritedId childWithInheritedId,
    _i3.ChildWithInheritedId parent, {
    _i2.Transaction? transaction,
  }) async {
    if (childWithInheritedId.id == null) {
      throw ArgumentError.notNull('childWithInheritedId.id');
    }
    if (parent.id == null) {
      throw ArgumentError.notNull('parent.id');
    }

    var $childWithInheritedId = childWithInheritedId.copyWith(
      parentId: parent.id,
    );
    await session.db.updateRow<ChildWithInheritedId>(
      $childWithInheritedId,
      columns: [ChildWithInheritedId.t.parentId],
      transaction: transaction,
    );
  }
}

class ChildWithInheritedIdDetachRowRepository {
  const ChildWithInheritedIdDetachRowRepository._();

  /// Detaches the relation between this [ChildWithInheritedId] and the [ChildWithInheritedId] set in `parent`
  /// by setting the [ChildWithInheritedId]'s foreign key `parentId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> parent(
    _i2.Session session,
    ChildWithInheritedId childWithInheritedId, {
    _i2.Transaction? transaction,
  }) async {
    if (childWithInheritedId.id == null) {
      throw ArgumentError.notNull('childWithInheritedId.id');
    }

    var $childWithInheritedId = childWithInheritedId.copyWith(parentId: null);
    await session.db.updateRow<ChildWithInheritedId>(
      $childWithInheritedId,
      columns: [ChildWithInheritedId.t.parentId],
      transaction: transaction,
    );
  }
}

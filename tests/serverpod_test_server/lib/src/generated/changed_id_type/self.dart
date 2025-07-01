/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../changed_id_type/self.dart' as _i2;

abstract class ChangedIdTypeSelf
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ChangedIdTypeSelf._({
    _i1.UuidValue? id,
    required this.name,
    this.previous,
    this.nextId,
    this.next,
    this.parentId,
    this.parent,
    this.children,
  }) : id = id ?? _i1.Uuid().v4obj();

  factory ChangedIdTypeSelf({
    _i1.UuidValue? id,
    required String name,
    _i2.ChangedIdTypeSelf? previous,
    _i1.UuidValue? nextId,
    _i2.ChangedIdTypeSelf? next,
    _i1.UuidValue? parentId,
    _i2.ChangedIdTypeSelf? parent,
    List<_i2.ChangedIdTypeSelf>? children,
  }) = _ChangedIdTypeSelfImpl;

  factory ChangedIdTypeSelf.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChangedIdTypeSelf(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      previous: jsonSerialization['previous'] == null
          ? null
          : _i2.ChangedIdTypeSelf.fromJson(
              (jsonSerialization['previous'] as Map<String, dynamic>)),
      nextId: jsonSerialization['nextId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['nextId']),
      next: jsonSerialization['next'] == null
          ? null
          : _i2.ChangedIdTypeSelf.fromJson(
              (jsonSerialization['next'] as Map<String, dynamic>)),
      parentId: jsonSerialization['parentId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['parentId']),
      parent: jsonSerialization['parent'] == null
          ? null
          : _i2.ChangedIdTypeSelf.fromJson(
              (jsonSerialization['parent'] as Map<String, dynamic>)),
      children: (jsonSerialization['children'] as List?)
          ?.map((e) =>
              _i2.ChangedIdTypeSelf.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = ChangedIdTypeSelfTable();

  static const db = ChangedIdTypeSelfRepository._();

  @override
  _i1.UuidValue? id;

  String name;

  _i2.ChangedIdTypeSelf? previous;

  _i1.UuidValue? nextId;

  _i2.ChangedIdTypeSelf? next;

  _i1.UuidValue? parentId;

  _i2.ChangedIdTypeSelf? parent;

  List<_i2.ChangedIdTypeSelf>? children;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ChangedIdTypeSelf]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChangedIdTypeSelf copyWith({
    _i1.UuidValue? id,
    String? name,
    _i2.ChangedIdTypeSelf? previous,
    _i1.UuidValue? nextId,
    _i2.ChangedIdTypeSelf? next,
    _i1.UuidValue? parentId,
    _i2.ChangedIdTypeSelf? parent,
    List<_i2.ChangedIdTypeSelf>? children,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (previous != null) 'previous': previous?.toJson(),
      if (nextId != null) 'nextId': nextId?.toJson(),
      if (next != null) 'next': next?.toJson(),
      if (parentId != null) 'parentId': parentId?.toJson(),
      if (parent != null) 'parent': parent?.toJson(),
      if (children != null)
        'children': children?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (previous != null) 'previous': previous?.toJsonForProtocol(),
      if (nextId != null) 'nextId': nextId?.toJson(),
      if (next != null) 'next': next?.toJsonForProtocol(),
      if (parentId != null) 'parentId': parentId?.toJson(),
      if (parent != null) 'parent': parent?.toJsonForProtocol(),
      if (children != null)
        'children': children?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static ChangedIdTypeSelfInclude include({
    _i2.ChangedIdTypeSelfInclude? previous,
    _i2.ChangedIdTypeSelfInclude? next,
    _i2.ChangedIdTypeSelfInclude? parent,
    _i2.ChangedIdTypeSelfIncludeList? children,
  }) {
    return ChangedIdTypeSelfInclude._(
      previous: previous,
      next: next,
      parent: parent,
      children: children,
    );
  }

  static ChangedIdTypeSelfIncludeList includeList({
    _i1.WhereExpressionBuilder<ChangedIdTypeSelfTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChangedIdTypeSelfTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChangedIdTypeSelfTable>? orderByList,
    ChangedIdTypeSelfInclude? include,
  }) {
    return ChangedIdTypeSelfIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChangedIdTypeSelf.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ChangedIdTypeSelf.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChangedIdTypeSelfImpl extends ChangedIdTypeSelf {
  _ChangedIdTypeSelfImpl({
    _i1.UuidValue? id,
    required String name,
    _i2.ChangedIdTypeSelf? previous,
    _i1.UuidValue? nextId,
    _i2.ChangedIdTypeSelf? next,
    _i1.UuidValue? parentId,
    _i2.ChangedIdTypeSelf? parent,
    List<_i2.ChangedIdTypeSelf>? children,
  }) : super._(
          id: id,
          name: name,
          previous: previous,
          nextId: nextId,
          next: next,
          parentId: parentId,
          parent: parent,
          children: children,
        );

  /// Returns a shallow copy of this [ChangedIdTypeSelf]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChangedIdTypeSelf copyWith({
    Object? id = _Undefined,
    String? name,
    Object? previous = _Undefined,
    Object? nextId = _Undefined,
    Object? next = _Undefined,
    Object? parentId = _Undefined,
    Object? parent = _Undefined,
    Object? children = _Undefined,
  }) {
    return ChangedIdTypeSelf(
      id: id is _i1.UuidValue? ? id : this.id,
      name: name ?? this.name,
      previous: previous is _i2.ChangedIdTypeSelf?
          ? previous
          : this.previous?.copyWith(),
      nextId: nextId is _i1.UuidValue? ? nextId : this.nextId,
      next: next is _i2.ChangedIdTypeSelf? ? next : this.next?.copyWith(),
      parentId: parentId is _i1.UuidValue? ? parentId : this.parentId,
      parent:
          parent is _i2.ChangedIdTypeSelf? ? parent : this.parent?.copyWith(),
      children: children is List<_i2.ChangedIdTypeSelf>?
          ? children
          : this.children?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class ChangedIdTypeSelfTable extends _i1.Table<_i1.UuidValue?> {
  ChangedIdTypeSelfTable({super.tableRelation})
      : super(tableName: 'changed_id_type_self') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    nextId = _i1.ColumnUuid(
      'nextId',
      this,
    );
    parentId = _i1.ColumnUuid(
      'parentId',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.ChangedIdTypeSelfTable? _previous;

  late final _i1.ColumnUuid nextId;

  _i2.ChangedIdTypeSelfTable? _next;

  late final _i1.ColumnUuid parentId;

  _i2.ChangedIdTypeSelfTable? _parent;

  _i2.ChangedIdTypeSelfTable? ___children;

  _i1.ManyRelation<_i2.ChangedIdTypeSelfTable>? _children;

  _i2.ChangedIdTypeSelfTable get previous {
    if (_previous != null) return _previous!;
    _previous = _i1.createRelationTable(
      relationFieldName: 'previous',
      field: ChangedIdTypeSelf.t.id,
      foreignField: _i2.ChangedIdTypeSelf.t.nextId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ChangedIdTypeSelfTable(tableRelation: foreignTableRelation),
    );
    return _previous!;
  }

  _i2.ChangedIdTypeSelfTable get next {
    if (_next != null) return _next!;
    _next = _i1.createRelationTable(
      relationFieldName: 'next',
      field: ChangedIdTypeSelf.t.nextId,
      foreignField: _i2.ChangedIdTypeSelf.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ChangedIdTypeSelfTable(tableRelation: foreignTableRelation),
    );
    return _next!;
  }

  _i2.ChangedIdTypeSelfTable get parent {
    if (_parent != null) return _parent!;
    _parent = _i1.createRelationTable(
      relationFieldName: 'parent',
      field: ChangedIdTypeSelf.t.parentId,
      foreignField: _i2.ChangedIdTypeSelf.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ChangedIdTypeSelfTable(tableRelation: foreignTableRelation),
    );
    return _parent!;
  }

  _i2.ChangedIdTypeSelfTable get __children {
    if (___children != null) return ___children!;
    ___children = _i1.createRelationTable(
      relationFieldName: '__children',
      field: ChangedIdTypeSelf.t.id,
      foreignField: _i2.ChangedIdTypeSelf.t.parentId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ChangedIdTypeSelfTable(tableRelation: foreignTableRelation),
    );
    return ___children!;
  }

  _i1.ManyRelation<_i2.ChangedIdTypeSelfTable> get children {
    if (_children != null) return _children!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'children',
      field: ChangedIdTypeSelf.t.id,
      foreignField: _i2.ChangedIdTypeSelf.t.parentId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ChangedIdTypeSelfTable(tableRelation: foreignTableRelation),
    );
    _children = _i1.ManyRelation<_i2.ChangedIdTypeSelfTable>(
      tableWithRelations: relationTable,
      table: _i2.ChangedIdTypeSelfTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _children!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        nextId,
        parentId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'previous') {
      return previous;
    }
    if (relationField == 'next') {
      return next;
    }
    if (relationField == 'parent') {
      return parent;
    }
    if (relationField == 'children') {
      return __children;
    }
    return null;
  }
}

class ChangedIdTypeSelfInclude extends _i1.IncludeObject {
  ChangedIdTypeSelfInclude._({
    _i2.ChangedIdTypeSelfInclude? previous,
    _i2.ChangedIdTypeSelfInclude? next,
    _i2.ChangedIdTypeSelfInclude? parent,
    _i2.ChangedIdTypeSelfIncludeList? children,
  }) {
    _previous = previous;
    _next = next;
    _parent = parent;
    _children = children;
  }

  _i2.ChangedIdTypeSelfInclude? _previous;

  _i2.ChangedIdTypeSelfInclude? _next;

  _i2.ChangedIdTypeSelfInclude? _parent;

  _i2.ChangedIdTypeSelfIncludeList? _children;

  @override
  Map<String, _i1.Include?> get includes => {
        'previous': _previous,
        'next': _next,
        'parent': _parent,
        'children': _children,
      };

  @override
  _i1.Table<_i1.UuidValue?> get table => ChangedIdTypeSelf.t;
}

class ChangedIdTypeSelfIncludeList extends _i1.IncludeList {
  ChangedIdTypeSelfIncludeList._({
    _i1.WhereExpressionBuilder<ChangedIdTypeSelfTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChangedIdTypeSelf.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ChangedIdTypeSelf.t;
}

class ChangedIdTypeSelfRepository {
  const ChangedIdTypeSelfRepository._();

  final attach = const ChangedIdTypeSelfAttachRepository._();

  final attachRow = const ChangedIdTypeSelfAttachRowRepository._();

  final detach = const ChangedIdTypeSelfDetachRepository._();

  final detachRow = const ChangedIdTypeSelfDetachRowRepository._();

  /// Returns a list of [ChangedIdTypeSelf]s matching the given query parameters.
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
  Future<List<ChangedIdTypeSelf>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChangedIdTypeSelfTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChangedIdTypeSelfTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChangedIdTypeSelfTable>? orderByList,
    _i1.Transaction? transaction,
    ChangedIdTypeSelfInclude? include,
  }) async {
    return session.db.find<ChangedIdTypeSelf>(
      where: where?.call(ChangedIdTypeSelf.t),
      orderBy: orderBy?.call(ChangedIdTypeSelf.t),
      orderByList: orderByList?.call(ChangedIdTypeSelf.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ChangedIdTypeSelf] matching the given query parameters.
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
  Future<ChangedIdTypeSelf?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChangedIdTypeSelfTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChangedIdTypeSelfTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChangedIdTypeSelfTable>? orderByList,
    _i1.Transaction? transaction,
    ChangedIdTypeSelfInclude? include,
  }) async {
    return session.db.findFirstRow<ChangedIdTypeSelf>(
      where: where?.call(ChangedIdTypeSelf.t),
      orderBy: orderBy?.call(ChangedIdTypeSelf.t),
      orderByList: orderByList?.call(ChangedIdTypeSelf.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ChangedIdTypeSelf] by its [id] or null if no such row exists.
  Future<ChangedIdTypeSelf?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    ChangedIdTypeSelfInclude? include,
  }) async {
    return session.db.findById<ChangedIdTypeSelf>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ChangedIdTypeSelf]s in the list and returns the inserted rows.
  ///
  /// The returned [ChangedIdTypeSelf]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ChangedIdTypeSelf>> insert(
    _i1.Session session,
    List<ChangedIdTypeSelf> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ChangedIdTypeSelf>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ChangedIdTypeSelf] and returns the inserted row.
  ///
  /// The returned [ChangedIdTypeSelf] will have its `id` field set.
  Future<ChangedIdTypeSelf> insertRow(
    _i1.Session session,
    ChangedIdTypeSelf row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChangedIdTypeSelf>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ChangedIdTypeSelf]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ChangedIdTypeSelf>> update(
    _i1.Session session,
    List<ChangedIdTypeSelf> rows, {
    _i1.ColumnSelections<ChangedIdTypeSelfTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ChangedIdTypeSelf>(
      rows,
      columns: columns?.call(ChangedIdTypeSelf.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChangedIdTypeSelf]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChangedIdTypeSelf> updateRow(
    _i1.Session session,
    ChangedIdTypeSelf row, {
    _i1.ColumnSelections<ChangedIdTypeSelfTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChangedIdTypeSelf>(
      row,
      columns: columns?.call(ChangedIdTypeSelf.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ChangedIdTypeSelf]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ChangedIdTypeSelf>> delete(
    _i1.Session session,
    List<ChangedIdTypeSelf> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ChangedIdTypeSelf>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ChangedIdTypeSelf].
  Future<ChangedIdTypeSelf> deleteRow(
    _i1.Session session,
    ChangedIdTypeSelf row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChangedIdTypeSelf>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ChangedIdTypeSelf>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChangedIdTypeSelfTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ChangedIdTypeSelf>(
      where: where(ChangedIdTypeSelf.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChangedIdTypeSelfTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ChangedIdTypeSelf>(
      where: where?.call(ChangedIdTypeSelf.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ChangedIdTypeSelfAttachRepository {
  const ChangedIdTypeSelfAttachRepository._();

  /// Creates a relation between this [ChangedIdTypeSelf] and the given [ChangedIdTypeSelf]s
  /// by setting each [ChangedIdTypeSelf]'s foreign key `parentId` to refer to this [ChangedIdTypeSelf].
  Future<void> children(
    _i1.Session session,
    ChangedIdTypeSelf changedIdTypeSelf,
    List<_i2.ChangedIdTypeSelf> nestedChangedIdTypeSelf, {
    _i1.Transaction? transaction,
  }) async {
    if (nestedChangedIdTypeSelf.any((e) => e.id == null)) {
      throw ArgumentError.notNull('nestedChangedIdTypeSelf.id');
    }
    if (changedIdTypeSelf.id == null) {
      throw ArgumentError.notNull('changedIdTypeSelf.id');
    }

    var $nestedChangedIdTypeSelf = nestedChangedIdTypeSelf
        .map((e) => e.copyWith(parentId: changedIdTypeSelf.id))
        .toList();
    await session.db.update<_i2.ChangedIdTypeSelf>(
      $nestedChangedIdTypeSelf,
      columns: [_i2.ChangedIdTypeSelf.t.parentId],
      transaction: transaction,
    );
  }
}

class ChangedIdTypeSelfAttachRowRepository {
  const ChangedIdTypeSelfAttachRowRepository._();

  /// Creates a relation between the given [ChangedIdTypeSelf] and [ChangedIdTypeSelf]
  /// by setting the [ChangedIdTypeSelf]'s foreign key `id` to refer to the [ChangedIdTypeSelf].
  Future<void> previous(
    _i1.Session session,
    ChangedIdTypeSelf changedIdTypeSelf,
    _i2.ChangedIdTypeSelf previous, {
    _i1.Transaction? transaction,
  }) async {
    if (previous.id == null) {
      throw ArgumentError.notNull('previous.id');
    }
    if (changedIdTypeSelf.id == null) {
      throw ArgumentError.notNull('changedIdTypeSelf.id');
    }

    var $previous = previous.copyWith(nextId: changedIdTypeSelf.id);
    await session.db.updateRow<_i2.ChangedIdTypeSelf>(
      $previous,
      columns: [_i2.ChangedIdTypeSelf.t.nextId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ChangedIdTypeSelf] and [ChangedIdTypeSelf]
  /// by setting the [ChangedIdTypeSelf]'s foreign key `nextId` to refer to the [ChangedIdTypeSelf].
  Future<void> next(
    _i1.Session session,
    ChangedIdTypeSelf changedIdTypeSelf,
    _i2.ChangedIdTypeSelf next, {
    _i1.Transaction? transaction,
  }) async {
    if (changedIdTypeSelf.id == null) {
      throw ArgumentError.notNull('changedIdTypeSelf.id');
    }
    if (next.id == null) {
      throw ArgumentError.notNull('next.id');
    }

    var $changedIdTypeSelf = changedIdTypeSelf.copyWith(nextId: next.id);
    await session.db.updateRow<ChangedIdTypeSelf>(
      $changedIdTypeSelf,
      columns: [ChangedIdTypeSelf.t.nextId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ChangedIdTypeSelf] and [ChangedIdTypeSelf]
  /// by setting the [ChangedIdTypeSelf]'s foreign key `parentId` to refer to the [ChangedIdTypeSelf].
  Future<void> parent(
    _i1.Session session,
    ChangedIdTypeSelf changedIdTypeSelf,
    _i2.ChangedIdTypeSelf parent, {
    _i1.Transaction? transaction,
  }) async {
    if (changedIdTypeSelf.id == null) {
      throw ArgumentError.notNull('changedIdTypeSelf.id');
    }
    if (parent.id == null) {
      throw ArgumentError.notNull('parent.id');
    }

    var $changedIdTypeSelf = changedIdTypeSelf.copyWith(parentId: parent.id);
    await session.db.updateRow<ChangedIdTypeSelf>(
      $changedIdTypeSelf,
      columns: [ChangedIdTypeSelf.t.parentId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [ChangedIdTypeSelf] and the given [ChangedIdTypeSelf]
  /// by setting the [ChangedIdTypeSelf]'s foreign key `parentId` to refer to this [ChangedIdTypeSelf].
  Future<void> children(
    _i1.Session session,
    ChangedIdTypeSelf changedIdTypeSelf,
    _i2.ChangedIdTypeSelf nestedChangedIdTypeSelf, {
    _i1.Transaction? transaction,
  }) async {
    if (nestedChangedIdTypeSelf.id == null) {
      throw ArgumentError.notNull('nestedChangedIdTypeSelf.id');
    }
    if (changedIdTypeSelf.id == null) {
      throw ArgumentError.notNull('changedIdTypeSelf.id');
    }

    var $nestedChangedIdTypeSelf =
        nestedChangedIdTypeSelf.copyWith(parentId: changedIdTypeSelf.id);
    await session.db.updateRow<_i2.ChangedIdTypeSelf>(
      $nestedChangedIdTypeSelf,
      columns: [_i2.ChangedIdTypeSelf.t.parentId],
      transaction: transaction,
    );
  }
}

class ChangedIdTypeSelfDetachRepository {
  const ChangedIdTypeSelfDetachRepository._();

  /// Detaches the relation between this [ChangedIdTypeSelf] and the given [ChangedIdTypeSelf]
  /// by setting the [ChangedIdTypeSelf]'s foreign key `parentId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> children(
    _i1.Session session,
    List<_i2.ChangedIdTypeSelf> changedIdTypeSelf, {
    _i1.Transaction? transaction,
  }) async {
    if (changedIdTypeSelf.any((e) => e.id == null)) {
      throw ArgumentError.notNull('changedIdTypeSelf.id');
    }

    var $changedIdTypeSelf =
        changedIdTypeSelf.map((e) => e.copyWith(parentId: null)).toList();
    await session.db.update<_i2.ChangedIdTypeSelf>(
      $changedIdTypeSelf,
      columns: [_i2.ChangedIdTypeSelf.t.parentId],
      transaction: transaction,
    );
  }
}

class ChangedIdTypeSelfDetachRowRepository {
  const ChangedIdTypeSelfDetachRowRepository._();

  /// Detaches the relation between this [ChangedIdTypeSelf] and the [ChangedIdTypeSelf] set in `previous`
  /// by setting the [ChangedIdTypeSelf]'s foreign key `id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> previous(
    _i1.Session session,
    ChangedIdTypeSelf changedidtypeself, {
    _i1.Transaction? transaction,
  }) async {
    var $previous = changedidtypeself.previous;

    if ($previous == null) {
      throw ArgumentError.notNull('changedidtypeself.previous');
    }
    if ($previous.id == null) {
      throw ArgumentError.notNull('changedidtypeself.previous.id');
    }
    if (changedidtypeself.id == null) {
      throw ArgumentError.notNull('changedidtypeself.id');
    }

    var $$previous = $previous.copyWith(nextId: null);
    await session.db.updateRow<_i2.ChangedIdTypeSelf>(
      $$previous,
      columns: [_i2.ChangedIdTypeSelf.t.nextId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [ChangedIdTypeSelf] and the [ChangedIdTypeSelf] set in `next`
  /// by setting the [ChangedIdTypeSelf]'s foreign key `nextId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> next(
    _i1.Session session,
    ChangedIdTypeSelf changedidtypeself, {
    _i1.Transaction? transaction,
  }) async {
    if (changedidtypeself.id == null) {
      throw ArgumentError.notNull('changedidtypeself.id');
    }

    var $changedidtypeself = changedidtypeself.copyWith(nextId: null);
    await session.db.updateRow<ChangedIdTypeSelf>(
      $changedidtypeself,
      columns: [ChangedIdTypeSelf.t.nextId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [ChangedIdTypeSelf] and the [ChangedIdTypeSelf] set in `parent`
  /// by setting the [ChangedIdTypeSelf]'s foreign key `parentId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> parent(
    _i1.Session session,
    ChangedIdTypeSelf changedidtypeself, {
    _i1.Transaction? transaction,
  }) async {
    if (changedidtypeself.id == null) {
      throw ArgumentError.notNull('changedidtypeself.id');
    }

    var $changedidtypeself = changedidtypeself.copyWith(parentId: null);
    await session.db.updateRow<ChangedIdTypeSelf>(
      $changedidtypeself,
      columns: [ChangedIdTypeSelf.t.parentId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [ChangedIdTypeSelf] and the given [ChangedIdTypeSelf]
  /// by setting the [ChangedIdTypeSelf]'s foreign key `parentId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> children(
    _i1.Session session,
    _i2.ChangedIdTypeSelf changedIdTypeSelf, {
    _i1.Transaction? transaction,
  }) async {
    if (changedIdTypeSelf.id == null) {
      throw ArgumentError.notNull('changedIdTypeSelf.id');
    }

    var $changedIdTypeSelf = changedIdTypeSelf.copyWith(parentId: null);
    await session.db.updateRow<_i2.ChangedIdTypeSelf>(
      $changedIdTypeSelf,
      columns: [_i2.ChangedIdTypeSelf.t.parentId],
      transaction: transaction,
    );
  }
}

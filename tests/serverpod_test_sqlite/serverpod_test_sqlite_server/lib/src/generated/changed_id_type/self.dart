/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart'
    as _i08l111i;
import '../changed_id_type/self.dart' as _iqjmn1nu;

abstract class ChangedIdTypeSelf
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ChangedIdTypeSelf._({
    _is.UuidValue? id,
    required this.name,
    this.previous,
    this.nextId,
    this.next,
    this.parentId,
    this.parent,
    this.children,
  }) : id = id ?? const _is.Uuid().v4obj();

  factory ChangedIdTypeSelf({
    _is.UuidValue? id,
    required String name,
    _iqjmn1nu.ChangedIdTypeSelf? previous,
    _is.UuidValue? nextId,
    _iqjmn1nu.ChangedIdTypeSelf? next,
    _is.UuidValue? parentId,
    _iqjmn1nu.ChangedIdTypeSelf? parent,
    List<_iqjmn1nu.ChangedIdTypeSelf>? children,
  }) = _ChangedIdTypeSelfImpl;

  factory ChangedIdTypeSelf.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChangedIdTypeSelf(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      previous: jsonSerialization['previous'] == null
          ? null
          : _i08l111i.Protocol().deserialize<_iqjmn1nu.ChangedIdTypeSelf>(
              jsonSerialization['previous'],
            ),
      nextId: jsonSerialization['nextId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['nextId']),
      next: jsonSerialization['next'] == null
          ? null
          : _i08l111i.Protocol().deserialize<_iqjmn1nu.ChangedIdTypeSelf>(
              jsonSerialization['next'],
            ),
      parentId: jsonSerialization['parentId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['parentId']),
      parent: jsonSerialization['parent'] == null
          ? null
          : _i08l111i.Protocol().deserialize<_iqjmn1nu.ChangedIdTypeSelf>(
              jsonSerialization['parent'],
            ),
      children: jsonSerialization['children'] == null
          ? null
          : _i08l111i.Protocol().deserialize<List<_iqjmn1nu.ChangedIdTypeSelf>>(
              jsonSerialization['children'],
            ),
    );
  }

  static final t = ChangedIdTypeSelfTable();

  static const db = ChangedIdTypeSelfRepository._();

  @override
  _is.UuidValue? id;

  String name;

  _iqjmn1nu.ChangedIdTypeSelf? previous;

  _is.UuidValue? nextId;

  _iqjmn1nu.ChangedIdTypeSelf? next;

  _is.UuidValue? parentId;

  _iqjmn1nu.ChangedIdTypeSelf? parent;

  List<_iqjmn1nu.ChangedIdTypeSelf>? children;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ChangedIdTypeSelf]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ChangedIdTypeSelf copyWith({
    _is.UuidValue? id,
    String? name,
    _iqjmn1nu.ChangedIdTypeSelf? previous,
    _is.UuidValue? nextId,
    _iqjmn1nu.ChangedIdTypeSelf? next,
    _is.UuidValue? parentId,
    _iqjmn1nu.ChangedIdTypeSelf? parent,
    List<_iqjmn1nu.ChangedIdTypeSelf>? children,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChangedIdTypeSelf',
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
      '__className__': 'ChangedIdTypeSelf',
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

  /// Builds a complete [ChangedIdTypeSelfInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ChangedIdTypeSelfInclude include({
    _iqjmn1nu.ChangedIdTypeSelfInclude? previous,
    _iqjmn1nu.ChangedIdTypeSelfInclude? next,
    _iqjmn1nu.ChangedIdTypeSelfInclude? parent,
    _iqjmn1nu.ChangedIdTypeSelfIncludeList? children,
  }) {
    return ChangedIdTypeSelfInclude._(
      previous: previous,
      next: next,
      parent: parent,
      children: children,
    );
  }

  /// Builds a complete [ChangedIdTypeSelfIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ChangedIdTypeSelfIncludeList includeList({
    _is.WhereExpressionBuilder<ChangedIdTypeSelfTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChangedIdTypeSelfTable>? orderBy,
    _is.OrderByListBuilder<ChangedIdTypeSelfTable>? orderByList,
    ChangedIdTypeSelfInclude? include,
  }) {
    return ChangedIdTypeSelfIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChangedIdTypeSelf.t),
      orderByList: orderByList?.call(ChangedIdTypeSelf.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [ChangedIdTypeSelfJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static ChangedIdTypeSelfJsonInclude includeJson({
    _iqjmn1nu.ChangedIdTypeSelfJsonInclude? previous,
    _iqjmn1nu.ChangedIdTypeSelfJsonInclude? next,
    _iqjmn1nu.ChangedIdTypeSelfJsonInclude? parent,
    _iqjmn1nu.ChangedIdTypeSelfJsonIncludeList? children,
    _is.SelectColumnsBuilder<ChangedIdTypeSelfTable>? select,
  }) {
    return _ChangedIdTypeSelfJsonInclude._(
      previous: previous,
      next: next,
      parent: parent,
      children: children,
      selectedColumns: select?.call(ChangedIdTypeSelf.t),
    );
  }

  /// Builds a JSON-compatible [ChangedIdTypeSelfJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static ChangedIdTypeSelfJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<ChangedIdTypeSelfTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChangedIdTypeSelfTable>? orderBy,
    _is.OrderByListBuilder<ChangedIdTypeSelfTable>? orderByList,
    ChangedIdTypeSelfJsonInclude? include,
    _is.SelectColumnsBuilder<ChangedIdTypeSelfTable>? select,
  }) {
    return _ChangedIdTypeSelfJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChangedIdTypeSelf.t),
      orderByList: orderByList?.call(ChangedIdTypeSelf.t),
      include: include,
      selectedColumns: select?.call(ChangedIdTypeSelf.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChangedIdTypeSelfImpl extends ChangedIdTypeSelf {
  _ChangedIdTypeSelfImpl({
    _is.UuidValue? id,
    required String name,
    _iqjmn1nu.ChangedIdTypeSelf? previous,
    _is.UuidValue? nextId,
    _iqjmn1nu.ChangedIdTypeSelf? next,
    _is.UuidValue? parentId,
    _iqjmn1nu.ChangedIdTypeSelf? parent,
    List<_iqjmn1nu.ChangedIdTypeSelf>? children,
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
  @_is.useResult
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
      id: id is _is.UuidValue? ? id : this.id,
      name: name ?? this.name,
      previous: previous is _iqjmn1nu.ChangedIdTypeSelf?
          ? previous
          : this.previous?.copyWith(),
      nextId: nextId is _is.UuidValue? ? nextId : this.nextId,
      next: next is _iqjmn1nu.ChangedIdTypeSelf? ? next : this.next?.copyWith(),
      parentId: parentId is _is.UuidValue? ? parentId : this.parentId,
      parent: parent is _iqjmn1nu.ChangedIdTypeSelf?
          ? parent
          : this.parent?.copyWith(),
      children: children is List<_iqjmn1nu.ChangedIdTypeSelf>?
          ? children
          : this.children?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class ChangedIdTypeSelfUpdateTable
    extends _is.UpdateTable<ChangedIdTypeSelfTable> {
  ChangedIdTypeSelfUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> nextId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.nextId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> parentId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.parentId,
    value,
  );
}

class ChangedIdTypeSelfTable extends _is.Table<_is.UuidValue?> {
  ChangedIdTypeSelfTable({super.tableRelation})
    : super(tableName: 'changed_id_type_self') {
    updateTable = ChangedIdTypeSelfUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    nextId = _is.ColumnUuid(
      'nextId',
      this,
    );
    parentId = _is.ColumnUuid(
      'parentId',
      this,
    );
  }

  late final ChangedIdTypeSelfUpdateTable updateTable;

  late final _is.ColumnString name;

  _iqjmn1nu.ChangedIdTypeSelfTable? _previous;

  late final _is.ColumnUuid nextId;

  _iqjmn1nu.ChangedIdTypeSelfTable? _next;

  late final _is.ColumnUuid parentId;

  _iqjmn1nu.ChangedIdTypeSelfTable? _parent;

  _iqjmn1nu.ChangedIdTypeSelfTable? ___children;

  _is.ManyRelation<_iqjmn1nu.ChangedIdTypeSelfTable>? _children;

  _iqjmn1nu.ChangedIdTypeSelfTable get previous {
    if (_previous != null) return _previous!;
    _previous = _is.createRelationTable(
      relationFieldName: 'previous',
      field: ChangedIdTypeSelf.t.id,
      foreignField: _iqjmn1nu.ChangedIdTypeSelf.t.nextId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iqjmn1nu.ChangedIdTypeSelfTable(tableRelation: foreignTableRelation),
    );
    return _previous!;
  }

  _iqjmn1nu.ChangedIdTypeSelfTable get next {
    if (_next != null) return _next!;
    _next = _is.createRelationTable(
      relationFieldName: 'next',
      field: ChangedIdTypeSelf.t.nextId,
      foreignField: _iqjmn1nu.ChangedIdTypeSelf.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iqjmn1nu.ChangedIdTypeSelfTable(tableRelation: foreignTableRelation),
    );
    return _next!;
  }

  _iqjmn1nu.ChangedIdTypeSelfTable get parent {
    if (_parent != null) return _parent!;
    _parent = _is.createRelationTable(
      relationFieldName: 'parent',
      field: ChangedIdTypeSelf.t.parentId,
      foreignField: _iqjmn1nu.ChangedIdTypeSelf.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iqjmn1nu.ChangedIdTypeSelfTable(tableRelation: foreignTableRelation),
    );
    return _parent!;
  }

  _iqjmn1nu.ChangedIdTypeSelfTable get __children {
    if (___children != null) return ___children!;
    ___children = _is.createRelationTable(
      relationFieldName: '__children',
      field: ChangedIdTypeSelf.t.id,
      foreignField: _iqjmn1nu.ChangedIdTypeSelf.t.parentId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iqjmn1nu.ChangedIdTypeSelfTable(tableRelation: foreignTableRelation),
    );
    return ___children!;
  }

  _is.ManyRelation<_iqjmn1nu.ChangedIdTypeSelfTable> get children {
    if (_children != null) return _children!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'children',
      field: ChangedIdTypeSelf.t.id,
      foreignField: _iqjmn1nu.ChangedIdTypeSelf.t.parentId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iqjmn1nu.ChangedIdTypeSelfTable(tableRelation: foreignTableRelation),
    );
    _children = _is.ManyRelation<_iqjmn1nu.ChangedIdTypeSelfTable>(
      tableWithRelations: relationTable,
      table: _iqjmn1nu.ChangedIdTypeSelfTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _children!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    nextId,
    parentId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
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

abstract interface class ChangedIdTypeSelfJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class ChangedIdTypeSelfJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class ChangedIdTypeSelfInclude extends _is.IncludeObject
    implements ChangedIdTypeSelfJsonInclude, _is.FullModelInclude {
  ChangedIdTypeSelfInclude._({
    _iqjmn1nu.ChangedIdTypeSelfInclude? previous,
    _iqjmn1nu.ChangedIdTypeSelfInclude? next,
    _iqjmn1nu.ChangedIdTypeSelfInclude? parent,
    _iqjmn1nu.ChangedIdTypeSelfIncludeList? children,
  }) {
    _previous = previous;
    _next = next;
    _parent = parent;
    _children = children;
  }

  _iqjmn1nu.ChangedIdTypeSelfInclude? _previous;

  _iqjmn1nu.ChangedIdTypeSelfInclude? _next;

  _iqjmn1nu.ChangedIdTypeSelfInclude? _parent;

  _iqjmn1nu.ChangedIdTypeSelfIncludeList? _children;

  @override
  Map<String, _is.Include?> get includes => {
    'previous': _previous,
    'next': _next,
    'parent': _parent,
    'children': _children,
  };

  @override
  _is.Table<_is.UuidValue?> get table => ChangedIdTypeSelf.t;
}

final class ChangedIdTypeSelfIncludeList extends _is.IncludeList
    implements ChangedIdTypeSelfJsonIncludeList, _is.FullModelInclude {
  ChangedIdTypeSelfIncludeList._({
    _is.WhereExpressionBuilder<ChangedIdTypeSelfTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ChangedIdTypeSelfInclude? super.include,
  }) {
    super.where = where?.call(ChangedIdTypeSelf.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ChangedIdTypeSelf.t;
}

final class _ChangedIdTypeSelfJsonInclude extends _is.IncludeObject
    implements ChangedIdTypeSelfJsonInclude {
  _ChangedIdTypeSelfJsonInclude._({
    _iqjmn1nu.ChangedIdTypeSelfJsonInclude? previous,
    _iqjmn1nu.ChangedIdTypeSelfJsonInclude? next,
    _iqjmn1nu.ChangedIdTypeSelfJsonInclude? parent,
    _iqjmn1nu.ChangedIdTypeSelfJsonIncludeList? children,
    this.selectedColumns,
  }) {
    _previous = previous;
    _next = next;
    _parent = parent;
    _children = children;
  }

  _iqjmn1nu.ChangedIdTypeSelfJsonInclude? _previous;

  _iqjmn1nu.ChangedIdTypeSelfJsonInclude? _next;

  _iqjmn1nu.ChangedIdTypeSelfJsonInclude? _parent;

  _iqjmn1nu.ChangedIdTypeSelfJsonIncludeList? _children;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'previous': _previous,
    'next': _next,
    'parent': _parent,
    'children': _children,
  };

  @override
  _is.Table<_is.UuidValue?> get table => ChangedIdTypeSelf.t;
}

final class _ChangedIdTypeSelfJsonIncludeList extends _is.IncludeList
    implements ChangedIdTypeSelfJsonIncludeList {
  _ChangedIdTypeSelfJsonIncludeList._({
    _is.WhereExpressionBuilder<ChangedIdTypeSelfTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ChangedIdTypeSelfJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ChangedIdTypeSelf.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ChangedIdTypeSelf.t;
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChangedIdTypeSelfTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChangedIdTypeSelfTable>? orderBy,
    _is.OrderByListBuilder<ChangedIdTypeSelfTable>? orderByList,
    _is.Transaction? transaction,
    ChangedIdTypeSelfInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ChangedIdTypeSelf>(
      where: where?.call(ChangedIdTypeSelf.t),
      orderBy: orderBy?.call(ChangedIdTypeSelf.t),
      orderByList: orderByList?.call(ChangedIdTypeSelf.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChangedIdTypeSelfTable>? where,
    int? offset,
    _is.OrderByBuilder<ChangedIdTypeSelfTable>? orderBy,
    _is.OrderByListBuilder<ChangedIdTypeSelfTable>? orderByList,
    _is.Transaction? transaction,
    ChangedIdTypeSelfInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ChangedIdTypeSelf>(
      where: where?.call(ChangedIdTypeSelf.t),
      orderBy: orderBy?.call(ChangedIdTypeSelf.t),
      orderByList: orderByList?.call(ChangedIdTypeSelf.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ChangedIdTypeSelf] by its [id] or null if no such row exists.
  Future<ChangedIdTypeSelf?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    ChangedIdTypeSelfInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ChangedIdTypeSelf>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChangedIdTypeSelfTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChangedIdTypeSelfTable>? orderBy,
    _is.OrderByListBuilder<ChangedIdTypeSelfTable>? orderByList,
    _is.Transaction? transaction,
    ChangedIdTypeSelfJsonInclude? include,
    _is.SelectColumnsBuilder<ChangedIdTypeSelfTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ChangedIdTypeSelf>(
      where: where?.call(ChangedIdTypeSelf.t),
      orderBy: orderBy?.call(ChangedIdTypeSelf.t),
      orderByList: orderByList?.call(ChangedIdTypeSelf.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(ChangedIdTypeSelf.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChangedIdTypeSelfTable>? where,
    int? offset,
    _is.OrderByBuilder<ChangedIdTypeSelfTable>? orderBy,
    _is.OrderByListBuilder<ChangedIdTypeSelfTable>? orderByList,
    _is.Transaction? transaction,
    ChangedIdTypeSelfJsonInclude? include,
    _is.SelectColumnsBuilder<ChangedIdTypeSelfTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ChangedIdTypeSelf>(
      where: where?.call(ChangedIdTypeSelf.t),
      orderBy: orderBy?.call(ChangedIdTypeSelf.t),
      orderByList: orderByList?.call(ChangedIdTypeSelf.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(ChangedIdTypeSelf.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    ChangedIdTypeSelfJsonInclude? include,
    _is.SelectColumnsBuilder<ChangedIdTypeSelfTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ChangedIdTypeSelf>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(ChangedIdTypeSelf.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ChangedIdTypeSelf]s in the list and returns the inserted rows.
  ///
  /// The returned [ChangedIdTypeSelf]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChangedIdTypeSelf>> insert(
    _is.DatabaseSession session,
    List<ChangedIdTypeSelf> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ChangedIdTypeSelf>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ChangedIdTypeSelf] and returns the inserted row.
  ///
  /// The returned [ChangedIdTypeSelf] will have its `id` field set.
  Future<ChangedIdTypeSelf> insertRow(
    _is.DatabaseSession session,
    ChangedIdTypeSelf row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChangedIdTypeSelf>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ChangedIdTypeSelf]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [ChangedIdTypeSelf]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChangedIdTypeSelf>> upsert(
    _is.DatabaseSession session,
    List<ChangedIdTypeSelf> rows, {
    required _is.ColumnSelections<ChangedIdTypeSelfTable> conflictColumns,
    _is.ColumnSelections<ChangedIdTypeSelfTable>? updateColumns,
    _is.WhereExpressionBuilder<ChangedIdTypeSelfTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ChangedIdTypeSelf>(
      rows,
      conflictColumns: conflictColumns(ChangedIdTypeSelf.t),
      updateColumns: updateColumns?.call(ChangedIdTypeSelf.t),
      updateWhere: updateWhere?.call(ChangedIdTypeSelf.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ChangedIdTypeSelf] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [ChangedIdTypeSelf] will have its `id` field set.
  Future<ChangedIdTypeSelf?> upsertRow(
    _is.DatabaseSession session,
    ChangedIdTypeSelf row, {
    required _is.ColumnSelections<ChangedIdTypeSelfTable> conflictColumns,
    _is.ColumnSelections<ChangedIdTypeSelfTable>? updateColumns,
    _is.WhereExpressionBuilder<ChangedIdTypeSelfTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ChangedIdTypeSelf>(
      row,
      conflictColumns: conflictColumns(ChangedIdTypeSelf.t),
      updateColumns: updateColumns?.call(ChangedIdTypeSelf.t),
      updateWhere: updateWhere?.call(ChangedIdTypeSelf.t),
      transaction: transaction,
    );
  }

  /// Updates all [ChangedIdTypeSelf]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChangedIdTypeSelf>> update(
    _is.DatabaseSession session,
    List<ChangedIdTypeSelf> rows, {
    _is.ColumnSelections<ChangedIdTypeSelfTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ChangedIdTypeSelf>(
      rows,
      columns: columns?.call(ChangedIdTypeSelf.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ChangedIdTypeSelf]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChangedIdTypeSelf> updateRow(
    _is.DatabaseSession session,
    ChangedIdTypeSelf row, {
    _is.ColumnSelections<ChangedIdTypeSelfTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChangedIdTypeSelf>(
      row,
      columns: columns?.call(ChangedIdTypeSelf.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChangedIdTypeSelf] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChangedIdTypeSelf?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ChangedIdTypeSelfUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ChangedIdTypeSelf>(
      id,
      columnValues: columnValues(ChangedIdTypeSelf.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChangedIdTypeSelf]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChangedIdTypeSelf>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ChangedIdTypeSelfUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ChangedIdTypeSelfTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChangedIdTypeSelfTable>? orderBy,
    _is.OrderByListBuilder<ChangedIdTypeSelfTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ChangedIdTypeSelf>(
      columnValues: columnValues(ChangedIdTypeSelf.t.updateTable),
      where: where(ChangedIdTypeSelf.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChangedIdTypeSelf.t),
      orderByList: orderByList?.call(ChangedIdTypeSelf.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ChangedIdTypeSelf]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChangedIdTypeSelf>> delete(
    _is.DatabaseSession session,
    List<ChangedIdTypeSelf> rows, {
    _is.OrderByBuilder<ChangedIdTypeSelfTable>? orderBy,
    _is.OrderByListBuilder<ChangedIdTypeSelfTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ChangedIdTypeSelf>(
      rows,
      orderBy: orderBy?.call(ChangedIdTypeSelf.t),
      orderByList: orderByList?.call(ChangedIdTypeSelf.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ChangedIdTypeSelf].
  Future<ChangedIdTypeSelf> deleteRow(
    _is.DatabaseSession session,
    ChangedIdTypeSelf row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChangedIdTypeSelf>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChangedIdTypeSelf>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ChangedIdTypeSelfTable> where,
    _is.OrderByBuilder<ChangedIdTypeSelfTable>? orderBy,
    _is.OrderByListBuilder<ChangedIdTypeSelfTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ChangedIdTypeSelf>(
      where: where(ChangedIdTypeSelf.t),
      orderBy: orderBy?.call(ChangedIdTypeSelf.t),
      orderByList: orderByList?.call(ChangedIdTypeSelf.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChangedIdTypeSelfTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ChangedIdTypeSelf>(
      where: where?.call(ChangedIdTypeSelf.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ChangedIdTypeSelf] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ChangedIdTypeSelfTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ChangedIdTypeSelf>(
      where: where(ChangedIdTypeSelf.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ChangedIdTypeSelfAttachRepository {
  const ChangedIdTypeSelfAttachRepository._();

  /// Creates a relation between this [ChangedIdTypeSelf] and the given [ChangedIdTypeSelf]s
  /// by setting each [ChangedIdTypeSelf]'s foreign key `parentId` to refer to this [ChangedIdTypeSelf].
  Future<void> children(
    _is.DatabaseSession session,
    ChangedIdTypeSelf changedIdTypeSelf,
    List<_iqjmn1nu.ChangedIdTypeSelf> nestedChangedIdTypeSelf, {
    _is.Transaction? transaction,
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
    await session.db.update<_iqjmn1nu.ChangedIdTypeSelf>(
      $nestedChangedIdTypeSelf,
      columns: [_iqjmn1nu.ChangedIdTypeSelf.t.parentId],
      transaction: transaction,
    );
  }
}

class ChangedIdTypeSelfAttachRowRepository {
  const ChangedIdTypeSelfAttachRowRepository._();

  /// Creates a relation between the given [ChangedIdTypeSelf] and [ChangedIdTypeSelf]
  /// by setting the [ChangedIdTypeSelf]'s foreign key `id` to refer to the [ChangedIdTypeSelf].
  Future<void> previous(
    _is.DatabaseSession session,
    ChangedIdTypeSelf changedIdTypeSelf,
    _iqjmn1nu.ChangedIdTypeSelf previous, {
    _is.Transaction? transaction,
  }) async {
    if (previous.id == null) {
      throw ArgumentError.notNull('previous.id');
    }
    if (changedIdTypeSelf.id == null) {
      throw ArgumentError.notNull('changedIdTypeSelf.id');
    }

    var $previous = previous.copyWith(nextId: changedIdTypeSelf.id);
    await session.db.updateRow<_iqjmn1nu.ChangedIdTypeSelf>(
      $previous,
      columns: [_iqjmn1nu.ChangedIdTypeSelf.t.nextId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ChangedIdTypeSelf] and [ChangedIdTypeSelf]
  /// by setting the [ChangedIdTypeSelf]'s foreign key `nextId` to refer to the [ChangedIdTypeSelf].
  Future<void> next(
    _is.DatabaseSession session,
    ChangedIdTypeSelf changedIdTypeSelf,
    _iqjmn1nu.ChangedIdTypeSelf next, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    ChangedIdTypeSelf changedIdTypeSelf,
    _iqjmn1nu.ChangedIdTypeSelf parent, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    ChangedIdTypeSelf changedIdTypeSelf,
    _iqjmn1nu.ChangedIdTypeSelf nestedChangedIdTypeSelf, {
    _is.Transaction? transaction,
  }) async {
    if (nestedChangedIdTypeSelf.id == null) {
      throw ArgumentError.notNull('nestedChangedIdTypeSelf.id');
    }
    if (changedIdTypeSelf.id == null) {
      throw ArgumentError.notNull('changedIdTypeSelf.id');
    }

    var $nestedChangedIdTypeSelf = nestedChangedIdTypeSelf.copyWith(
      parentId: changedIdTypeSelf.id,
    );
    await session.db.updateRow<_iqjmn1nu.ChangedIdTypeSelf>(
      $nestedChangedIdTypeSelf,
      columns: [_iqjmn1nu.ChangedIdTypeSelf.t.parentId],
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
    _is.DatabaseSession session,
    List<_iqjmn1nu.ChangedIdTypeSelf> changedIdTypeSelf, {
    _is.Transaction? transaction,
  }) async {
    if (changedIdTypeSelf.any((e) => e.id == null)) {
      throw ArgumentError.notNull('changedIdTypeSelf.id');
    }

    var $changedIdTypeSelf = changedIdTypeSelf
        .map((e) => e.copyWith(parentId: null))
        .toList();
    await session.db.update<_iqjmn1nu.ChangedIdTypeSelf>(
      $changedIdTypeSelf,
      columns: [_iqjmn1nu.ChangedIdTypeSelf.t.parentId],
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
    _is.DatabaseSession session,
    ChangedIdTypeSelf changedIdTypeSelf, {
    _is.Transaction? transaction,
  }) async {
    var $previous = changedIdTypeSelf.previous;

    if ($previous == null) {
      throw ArgumentError.notNull('changedIdTypeSelf.previous');
    }
    if ($previous.id == null) {
      throw ArgumentError.notNull('changedIdTypeSelf.previous.id');
    }
    if (changedIdTypeSelf.id == null) {
      throw ArgumentError.notNull('changedIdTypeSelf.id');
    }

    var $$previous = $previous.copyWith(nextId: null);
    await session.db.updateRow<_iqjmn1nu.ChangedIdTypeSelf>(
      $$previous,
      columns: [_iqjmn1nu.ChangedIdTypeSelf.t.nextId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [ChangedIdTypeSelf] and the [ChangedIdTypeSelf] set in `next`
  /// by setting the [ChangedIdTypeSelf]'s foreign key `nextId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> next(
    _is.DatabaseSession session,
    ChangedIdTypeSelf changedIdTypeSelf, {
    _is.Transaction? transaction,
  }) async {
    if (changedIdTypeSelf.id == null) {
      throw ArgumentError.notNull('changedIdTypeSelf.id');
    }

    var $changedIdTypeSelf = changedIdTypeSelf.copyWith(nextId: null);
    await session.db.updateRow<ChangedIdTypeSelf>(
      $changedIdTypeSelf,
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
    _is.DatabaseSession session,
    ChangedIdTypeSelf changedIdTypeSelf, {
    _is.Transaction? transaction,
  }) async {
    if (changedIdTypeSelf.id == null) {
      throw ArgumentError.notNull('changedIdTypeSelf.id');
    }

    var $changedIdTypeSelf = changedIdTypeSelf.copyWith(parentId: null);
    await session.db.updateRow<ChangedIdTypeSelf>(
      $changedIdTypeSelf,
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
    _is.DatabaseSession session,
    _iqjmn1nu.ChangedIdTypeSelf changedIdTypeSelf, {
    _is.Transaction? transaction,
  }) async {
    if (changedIdTypeSelf.id == null) {
      throw ArgumentError.notNull('changedIdTypeSelf.id');
    }

    var $changedIdTypeSelf = changedIdTypeSelf.copyWith(parentId: null);
    await session.db.updateRow<_iqjmn1nu.ChangedIdTypeSelf>(
      $changedIdTypeSelf,
      columns: [_iqjmn1nu.ChangedIdTypeSelf.t.parentId],
      transaction: transaction,
    );
  }
}

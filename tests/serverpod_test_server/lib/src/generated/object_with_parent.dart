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

abstract class ObjectWithParent
    implements _i1.TableRow, _i1.ProtocolSerialization {
  ObjectWithParent._({
    this.id,
    required this.other,
  });

  factory ObjectWithParent({
    int? id,
    required int other,
  }) = _ObjectWithParentImpl;

  factory ObjectWithParent.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithParent(
      id: jsonSerialization['id'] as int?,
      other: jsonSerialization['other'] as int,
    );
  }

  static final t = ObjectWithParentTable();

  static const db = ObjectWithParentRepository._();

  @override
  int? id;

  int other;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [ObjectWithParent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithParent copyWith({
    int? id,
    int? other,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'other': other,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'other': other,
    };
  }

  static ObjectWithParentInclude include() {
    return ObjectWithParentInclude._();
  }

  static ObjectWithParentIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    ObjectWithParentInclude? include,
  }) {
    return ObjectWithParentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithParent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithParentImpl extends ObjectWithParent {
  _ObjectWithParentImpl({
    int? id,
    required int other,
  }) : super._(
          id: id,
          other: other,
        );

  /// Returns a shallow copy of this [ObjectWithParent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithParent copyWith({
    Object? id = _Undefined,
    int? other,
  }) {
    return ObjectWithParent(
      id: id is int? ? id : this.id,
      other: other ?? this.other,
    );
  }
}

class ObjectWithParentTable extends _i1.Table {
  ObjectWithParentTable({super.tableRelation})
      : super(tableName: 'object_with_parent') {
    other = _i1.ColumnInt(
      'other',
      this,
    );
  }

  late final _i1.ColumnInt other;

  @override
  List<_i1.Column> get columns => [
        id,
        other,
      ];
}

class ObjectWithParentInclude extends _i1.IncludeObject {
  ObjectWithParentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectWithParent.t;
}

class ObjectWithParentIncludeList extends _i1.IncludeList {
  ObjectWithParentIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithParentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithParent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectWithParent.t;
}

class ObjectWithParentRepository {
  const ObjectWithParentRepository._();

  /// Returns a list of [ObjectWithParent]s matching the given query parameters.
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
  Future<List<ObjectWithParent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithParent>(
      where: where?.call(ObjectWithParent.t),
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderByList: orderByList?.call(ObjectWithParent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ObjectWithParent] matching the given query parameters.
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
  Future<ObjectWithParent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithParent>(
      where: where?.call(ObjectWithParent.t),
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderByList: orderByList?.call(ObjectWithParent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectWithParent] by its [id] or null if no such row exists.
  Future<ObjectWithParent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithParent>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectWithParent]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithParent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectWithParent>> insert(
    _i1.Session session,
    List<ObjectWithParent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithParent>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectWithParent] and returns the inserted row.
  ///
  /// The returned [ObjectWithParent] will have its `id` field set.
  Future<ObjectWithParent> insertRow(
    _i1.Session session,
    ObjectWithParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithParent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithParent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithParent>> update(
    _i1.Session session,
    List<ObjectWithParent> rows, {
    _i1.ColumnSelections<ObjectWithParentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithParent>(
      rows,
      columns: columns?.call(ObjectWithParent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithParent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithParent> updateRow(
    _i1.Session session,
    ObjectWithParent row, {
    _i1.ColumnSelections<ObjectWithParentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithParent>(
      row,
      columns: columns?.call(ObjectWithParent.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithParent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithParent>> delete(
    _i1.Session session,
    List<ObjectWithParent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithParent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithParent].
  Future<ObjectWithParent> deleteRow(
    _i1.Session session,
    ObjectWithParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithParent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithParent>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithParentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithParent>(
      where: where(ObjectWithParent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithParent>(
      where: where?.call(ObjectWithParent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

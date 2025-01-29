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

abstract class ObjectWithSelfParent
    implements _i1.TableRow, _i1.ProtocolSerialization {
  ObjectWithSelfParent._({
    this.id,
    this.other,
  });

  factory ObjectWithSelfParent({
    int? id,
    int? other,
  }) = _ObjectWithSelfParentImpl;

  factory ObjectWithSelfParent.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ObjectWithSelfParent(
      id: jsonSerialization['id'] as int?,
      other: jsonSerialization['other'] as int?,
    );
  }

  static final t = ObjectWithSelfParentTable();

  static const db = ObjectWithSelfParentRepository._();

  @override
  int? id;

  int? other;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [ObjectWithSelfParent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithSelfParent copyWith({
    int? id,
    int? other,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (other != null) 'other': other,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (other != null) 'other': other,
    };
  }

  static ObjectWithSelfParentInclude include() {
    return ObjectWithSelfParentInclude._();
  }

  static ObjectWithSelfParentIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithSelfParentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithSelfParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithSelfParentTable>? orderByList,
    ObjectWithSelfParentInclude? include,
  }) {
    return ObjectWithSelfParentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithSelfParent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithSelfParent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithSelfParentImpl extends ObjectWithSelfParent {
  _ObjectWithSelfParentImpl({
    int? id,
    int? other,
  }) : super._(
          id: id,
          other: other,
        );

  /// Returns a shallow copy of this [ObjectWithSelfParent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithSelfParent copyWith({
    Object? id = _Undefined,
    Object? other = _Undefined,
  }) {
    return ObjectWithSelfParent(
      id: id is int? ? id : this.id,
      other: other is int? ? other : this.other,
    );
  }
}

class ObjectWithSelfParentTable extends _i1.Table {
  ObjectWithSelfParentTable({super.tableRelation})
      : super(tableName: 'object_with_self_parent') {
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

class ObjectWithSelfParentInclude extends _i1.IncludeObject {
  ObjectWithSelfParentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectWithSelfParent.t;
}

class ObjectWithSelfParentIncludeList extends _i1.IncludeList {
  ObjectWithSelfParentIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithSelfParentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithSelfParent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectWithSelfParent.t;
}

class ObjectWithSelfParentRepository {
  const ObjectWithSelfParentRepository._();

  /// Returns a list of [ObjectWithSelfParent]s matching the given query parameters.
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
  Future<List<ObjectWithSelfParent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithSelfParentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithSelfParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithSelfParentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithSelfParent>(
      where: where?.call(ObjectWithSelfParent.t),
      orderBy: orderBy?.call(ObjectWithSelfParent.t),
      orderByList: orderByList?.call(ObjectWithSelfParent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ObjectWithSelfParent] matching the given query parameters.
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
  Future<ObjectWithSelfParent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithSelfParentTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithSelfParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithSelfParentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithSelfParent>(
      where: where?.call(ObjectWithSelfParent.t),
      orderBy: orderBy?.call(ObjectWithSelfParent.t),
      orderByList: orderByList?.call(ObjectWithSelfParent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectWithSelfParent] by its [id] or null if no such row exists.
  Future<ObjectWithSelfParent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithSelfParent>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectWithSelfParent]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithSelfParent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectWithSelfParent>> insert(
    _i1.Session session,
    List<ObjectWithSelfParent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithSelfParent>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectWithSelfParent] and returns the inserted row.
  ///
  /// The returned [ObjectWithSelfParent] will have its `id` field set.
  Future<ObjectWithSelfParent> insertRow(
    _i1.Session session,
    ObjectWithSelfParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithSelfParent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithSelfParent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithSelfParent>> update(
    _i1.Session session,
    List<ObjectWithSelfParent> rows, {
    _i1.ColumnSelections<ObjectWithSelfParentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithSelfParent>(
      rows,
      columns: columns?.call(ObjectWithSelfParent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithSelfParent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithSelfParent> updateRow(
    _i1.Session session,
    ObjectWithSelfParent row, {
    _i1.ColumnSelections<ObjectWithSelfParentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithSelfParent>(
      row,
      columns: columns?.call(ObjectWithSelfParent.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithSelfParent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithSelfParent>> delete(
    _i1.Session session,
    List<ObjectWithSelfParent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithSelfParent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithSelfParent].
  Future<ObjectWithSelfParent> deleteRow(
    _i1.Session session,
    ObjectWithSelfParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithSelfParent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithSelfParent>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithSelfParentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithSelfParent>(
      where: where(ObjectWithSelfParent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithSelfParentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithSelfParent>(
      where: where?.call(ObjectWithSelfParent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

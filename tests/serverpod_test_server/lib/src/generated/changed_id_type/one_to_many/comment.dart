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
import '../../changed_id_type/one_to_many/order.dart' as _i2;

abstract class CommentInt
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CommentInt._({
    this.id,
    required this.description,
    required this.orderId,
    this.order,
  });

  factory CommentInt({
    int? id,
    required String description,
    required _i1.UuidValue orderId,
    _i2.OrderUuid? order,
  }) = _CommentIntImpl;

  factory CommentInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return CommentInt(
      id: jsonSerialization['id'] as int?,
      description: jsonSerialization['description'] as String,
      orderId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['orderId']),
      order: jsonSerialization['order'] == null
          ? null
          : _i2.OrderUuid.fromJson(
              (jsonSerialization['order'] as Map<String, dynamic>)),
    );
  }

  static final t = CommentIntTable();

  static const db = CommentIntRepository._();

  @override
  int? id;

  String description;

  _i1.UuidValue orderId;

  _i2.OrderUuid? order;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CommentInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CommentInt copyWith({
    int? id,
    String? description,
    _i1.UuidValue? orderId,
    _i2.OrderUuid? order,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'description': description,
      'orderId': orderId.toJson(),
      if (order != null) 'order': order?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'description': description,
      'orderId': orderId.toJson(),
      if (order != null) 'order': order?.toJsonForProtocol(),
    };
  }

  static CommentIntInclude include({_i2.OrderUuidInclude? order}) {
    return CommentIntInclude._(order: order);
  }

  static CommentIntIncludeList includeList({
    _i1.WhereExpressionBuilder<CommentIntTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CommentIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CommentIntTable>? orderByList,
    CommentIntInclude? include,
  }) {
    return CommentIntIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CommentInt.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CommentInt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CommentIntImpl extends CommentInt {
  _CommentIntImpl({
    int? id,
    required String description,
    required _i1.UuidValue orderId,
    _i2.OrderUuid? order,
  }) : super._(
          id: id,
          description: description,
          orderId: orderId,
          order: order,
        );

  /// Returns a shallow copy of this [CommentInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CommentInt copyWith({
    Object? id = _Undefined,
    String? description,
    _i1.UuidValue? orderId,
    Object? order = _Undefined,
  }) {
    return CommentInt(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      orderId: orderId ?? this.orderId,
      order: order is _i2.OrderUuid? ? order : this.order?.copyWith(),
    );
  }
}

class CommentIntUpdateTable extends _i1.UpdateTable<CommentIntTable> {
  CommentIntUpdateTable(super.table);

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
        table.description,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> orderId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.orderId,
        value,
      );
}

class CommentIntTable extends _i1.Table<int?> {
  CommentIntTable({super.tableRelation}) : super(tableName: 'comment_int') {
    updateTable = CommentIntUpdateTable(this);
    description = _i1.ColumnString(
      'description',
      this,
    );
    orderId = _i1.ColumnUuid(
      'orderId',
      this,
    );
  }

  late final CommentIntUpdateTable updateTable;

  late final _i1.ColumnString description;

  late final _i1.ColumnUuid orderId;

  _i2.OrderUuidTable? _order;

  _i2.OrderUuidTable get order {
    if (_order != null) return _order!;
    _order = _i1.createRelationTable(
      relationFieldName: 'order',
      field: CommentInt.t.orderId,
      foreignField: _i2.OrderUuid.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.OrderUuidTable(tableRelation: foreignTableRelation),
    );
    return _order!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        description,
        orderId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'order') {
      return order;
    }
    return null;
  }
}

class CommentIntInclude extends _i1.IncludeObject {
  CommentIntInclude._({_i2.OrderUuidInclude? order}) {
    _order = order;
  }

  _i2.OrderUuidInclude? _order;

  @override
  Map<String, _i1.Include?> get includes => {'order': _order};

  @override
  _i1.Table<int?> get table => CommentInt.t;
}

class CommentIntIncludeList extends _i1.IncludeList {
  CommentIntIncludeList._({
    _i1.WhereExpressionBuilder<CommentIntTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CommentInt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CommentInt.t;
}

class CommentIntRepository {
  const CommentIntRepository._();

  final attachRow = const CommentIntAttachRowRepository._();

  /// Returns a list of [CommentInt]s matching the given query parameters.
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
  Future<List<CommentInt>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CommentIntTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CommentIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CommentIntTable>? orderByList,
    _i1.Transaction? transaction,
    CommentIntInclude? include,
  }) async {
    return session.db.find<CommentInt>(
      where: where?.call(CommentInt.t),
      orderBy: orderBy?.call(CommentInt.t),
      orderByList: orderByList?.call(CommentInt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [CommentInt] matching the given query parameters.
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
  Future<CommentInt?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CommentIntTable>? where,
    int? offset,
    _i1.OrderByBuilder<CommentIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CommentIntTable>? orderByList,
    _i1.Transaction? transaction,
    CommentIntInclude? include,
  }) async {
    return session.db.findFirstRow<CommentInt>(
      where: where?.call(CommentInt.t),
      orderBy: orderBy?.call(CommentInt.t),
      orderByList: orderByList?.call(CommentInt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [CommentInt] by its [id] or null if no such row exists.
  Future<CommentInt?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    CommentIntInclude? include,
  }) async {
    return session.db.findById<CommentInt>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [CommentInt]s in the list and returns the inserted rows.
  ///
  /// The returned [CommentInt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CommentInt>> insert(
    _i1.Session session,
    List<CommentInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CommentInt>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CommentInt] and returns the inserted row.
  ///
  /// The returned [CommentInt] will have its `id` field set.
  Future<CommentInt> insertRow(
    _i1.Session session,
    CommentInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CommentInt>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CommentInt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CommentInt>> update(
    _i1.Session session,
    List<CommentInt> rows, {
    _i1.ColumnSelections<CommentIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CommentInt>(
      rows,
      columns: columns?.call(CommentInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CommentInt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CommentInt> updateRow(
    _i1.Session session,
    CommentInt row, {
    _i1.ColumnSelections<CommentIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CommentInt>(
      row,
      columns: columns?.call(CommentInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CommentInt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CommentInt?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CommentIntUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CommentInt>(
      id,
      columnValues: columnValues(CommentInt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CommentInt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CommentInt>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CommentIntUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CommentIntTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CommentIntTable>? orderBy,
    _i1.OrderByListBuilder<CommentIntTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CommentInt>(
      columnValues: columnValues(CommentInt.t.updateTable),
      where: where(CommentInt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CommentInt.t),
      orderByList: orderByList?.call(CommentInt.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CommentInt]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CommentInt>> delete(
    _i1.Session session,
    List<CommentInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CommentInt>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CommentInt].
  Future<CommentInt> deleteRow(
    _i1.Session session,
    CommentInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CommentInt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CommentInt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CommentIntTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CommentInt>(
      where: where(CommentInt.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CommentIntTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CommentInt>(
      where: where?.call(CommentInt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CommentIntAttachRowRepository {
  const CommentIntAttachRowRepository._();

  /// Creates a relation between the given [CommentInt] and [OrderUuid]
  /// by setting the [CommentInt]'s foreign key `orderId` to refer to the [OrderUuid].
  Future<void> order(
    _i1.Session session,
    CommentInt commentInt,
    _i2.OrderUuid order, {
    _i1.Transaction? transaction,
  }) async {
    if (commentInt.id == null) {
      throw ArgumentError.notNull('commentInt.id');
    }
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }

    var $commentInt = commentInt.copyWith(orderId: order.id);
    await session.db.updateRow<CommentInt>(
      $commentInt,
      columns: [CommentInt.t.orderId],
      transaction: transaction,
    );
  }
}

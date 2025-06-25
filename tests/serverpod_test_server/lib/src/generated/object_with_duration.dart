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

abstract class ObjectWithDuration
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithDuration._({
    this.id,
    required this.duration,
  });

  factory ObjectWithDuration({
    int? id,
    required Duration duration,
  }) = _ObjectWithDurationImpl;

  factory ObjectWithDuration.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithDuration(
      id: jsonSerialization['id'] as int?,
      duration:
          _i1.DurationJsonExtension.fromJson(jsonSerialization['duration']),
    );
  }

  static final t = ObjectWithDurationTable();

  static const db = ObjectWithDurationRepository._();

  @override
  int? id;

  Duration duration;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithDuration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithDuration copyWith({
    int? id,
    Duration? duration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'duration': duration.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'duration': duration.toJson(),
    };
  }

  static ObjectWithDurationInclude include() {
    return ObjectWithDurationInclude._();
  }

  static ObjectWithDurationIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithDurationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithDurationTable>? orderByList,
    ObjectWithDurationInclude? include,
  }) {
    return ObjectWithDurationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithDuration.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithDuration.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithDurationImpl extends ObjectWithDuration {
  _ObjectWithDurationImpl({
    int? id,
    required Duration duration,
  }) : super._(
          id: id,
          duration: duration,
        );

  /// Returns a shallow copy of this [ObjectWithDuration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithDuration copyWith({
    Object? id = _Undefined,
    Duration? duration,
  }) {
    return ObjectWithDuration(
      id: id is int? ? id : this.id,
      duration: duration ?? this.duration,
    );
  }
}

class ObjectWithDurationTable extends _i1.Table<int?> {
  ObjectWithDurationTable({super.tableRelation})
      : super(tableName: 'object_with_duration') {
    duration = _i1.ColumnDuration(
      'duration',
      this,
    );
  }

  late final _i1.ColumnDuration duration;

  @override
  List<_i1.Column> get columns => [
        id,
        duration,
      ];
}

class ObjectWithDurationInclude extends _i1.IncludeObject {
  ObjectWithDurationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithDuration.t;
}

class ObjectWithDurationIncludeList extends _i1.IncludeList {
  ObjectWithDurationIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithDuration.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithDuration.t;
}

class ObjectWithDurationRepository {
  const ObjectWithDurationRepository._();

  /// Returns a list of [ObjectWithDuration]s matching the given query parameters.
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
  Future<List<ObjectWithDuration>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithDurationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithDurationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithDuration>(
      where: where?.call(ObjectWithDuration.t),
      orderBy: orderBy?.call(ObjectWithDuration.t),
      orderByList: orderByList?.call(ObjectWithDuration.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ObjectWithDuration] matching the given query parameters.
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
  Future<ObjectWithDuration?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithDurationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithDurationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithDuration>(
      where: where?.call(ObjectWithDuration.t),
      orderBy: orderBy?.call(ObjectWithDuration.t),
      orderByList: orderByList?.call(ObjectWithDuration.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectWithDuration] by its [id] or null if no such row exists.
  Future<ObjectWithDuration?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithDuration>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectWithDuration]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithDuration]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectWithDuration>> insert(
    _i1.Session session,
    List<ObjectWithDuration> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithDuration>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectWithDuration] and returns the inserted row.
  ///
  /// The returned [ObjectWithDuration] will have its `id` field set.
  Future<ObjectWithDuration> insertRow(
    _i1.Session session,
    ObjectWithDuration row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithDuration>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithDuration]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithDuration>> update(
    _i1.Session session,
    List<ObjectWithDuration> rows, {
    _i1.ColumnSelections<ObjectWithDurationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithDuration>(
      rows,
      columns: columns?.call(ObjectWithDuration.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithDuration]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithDuration> updateRow(
    _i1.Session session,
    ObjectWithDuration row, {
    _i1.ColumnSelections<ObjectWithDurationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithDuration>(
      row,
      columns: columns?.call(ObjectWithDuration.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithDuration]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithDuration>> delete(
    _i1.Session session,
    List<ObjectWithDuration> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithDuration>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithDuration].
  Future<ObjectWithDuration> deleteRow(
    _i1.Session session,
    ObjectWithDuration row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithDuration>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithDuration>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithDurationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithDuration>(
      where: where(ObjectWithDuration.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithDuration>(
      where: where?.call(ObjectWithDuration.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

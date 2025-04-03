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

abstract class Session implements _i1.TableRow<int>, _i1.ProtocolSerialization {
  Session._({
    this.id,
    required this.userId,
    required this.created,
  });

  factory Session({
    int? id,
    required int userId,
    required DateTime created,
  }) = _SessionImpl;

  factory Session.fromJson(Map<String, dynamic> jsonSerialization) {
    return Session(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
    );
  }

  static final t = SessionTable();

  static const db = SessionRepository._();

  @override
  int? id;

  int userId;

  /// The time when this sesion was created.
  DateTime created;

  @override
  _i1.Table<int> get table => t;

  /// Returns a shallow copy of this [Session]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Session copyWith({
    int? id,
    int? userId,
    DateTime? created,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'created': created.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'created': created.toJson(),
    };
  }

  static SessionInclude include() {
    return SessionInclude._();
  }

  static SessionIncludeList includeList({
    _i1.WhereExpressionBuilder<SessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionTable>? orderByList,
    SessionInclude? include,
  }) {
    return SessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Session.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Session.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionImpl extends Session {
  _SessionImpl({
    int? id,
    required int userId,
    required DateTime created,
  }) : super._(
          id: id,
          userId: userId,
          created: created,
        );

  /// Returns a shallow copy of this [Session]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Session copyWith({
    Object? id = _Undefined,
    int? userId,
    DateTime? created,
  }) {
    return Session(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      created: created ?? this.created,
    );
  }
}

class SessionTable extends _i1.Table<int> {
  SessionTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_session') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
    );
  }

  late final _i1.ColumnInt userId;

  /// The time when this sesion was created.
  late final _i1.ColumnDateTime created;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        created,
      ];
}

class SessionInclude extends _i1.IncludeObject {
  SessionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int> get table => Session.t;
}

class SessionIncludeList extends _i1.IncludeList {
  SessionIncludeList._({
    _i1.WhereExpressionBuilder<SessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Session.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int> get table => Session.t;
}

class SessionRepository {
  const SessionRepository._();

  /// Returns a list of [Session]s matching the given query parameters.
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
  Future<List<Session>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Session>(
      where: where?.call(Session.t),
      orderBy: orderBy?.call(Session.t),
      orderByList: orderByList?.call(Session.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Session] matching the given query parameters.
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
  Future<Session?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SessionTable>? where,
    int? offset,
    _i1.OrderByBuilder<SessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Session>(
      where: where?.call(Session.t),
      orderBy: orderBy?.call(Session.t),
      orderByList: orderByList?.call(Session.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Session] by its [id] or null if no such row exists.
  Future<Session?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Session>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Session]s in the list and returns the inserted rows.
  ///
  /// The returned [Session]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Session>> insert(
    _i1.Session session,
    List<Session> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Session>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Session] and returns the inserted row.
  ///
  /// The returned [Session] will have its `id` field set.
  Future<Session> insertRow(
    _i1.Session session,
    Session row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Session>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Session]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Session>> update(
    _i1.Session session,
    List<Session> rows, {
    _i1.ColumnSelections<SessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Session>(
      rows,
      columns: columns?.call(Session.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Session]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Session> updateRow(
    _i1.Session session,
    Session row, {
    _i1.ColumnSelections<SessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Session>(
      row,
      columns: columns?.call(Session.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Session]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Session>> delete(
    _i1.Session session,
    List<Session> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Session>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Session].
  Future<Session> deleteRow(
    _i1.Session session,
    Session row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Session>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Session>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SessionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Session>(
      where: where(Session.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SessionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Session>(
      where: where?.call(Session.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

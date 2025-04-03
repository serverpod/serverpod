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
import 'package:uuid/uuid.dart' as _i2;

abstract class ActiveSession
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  ActiveSession._({
    _i1.UuidValue? id,
    required this.userId,
    required this.created,
    required this.sessionKey,
  }) : id = id ?? _i2.Uuid().v4obj();

  factory ActiveSession({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required DateTime created,
    required String sessionKey,
  }) = _ActiveSessionImpl;

  factory ActiveSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActiveSession(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      sessionKey: jsonSerialization['sessionKey'] as String,
    );
  }

  static final t = ActiveSessionTable();

  static const db = ActiveSessionRepository._();

  @override
  _i1.UuidValue? id;

  /// The id of the [AuthUser] this session belongs to
  _i1.UuidValue userId;

  /// The time when this sesion was created.
  DateTime created;

  String sessionKey;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [ActiveSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ActiveSession copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    DateTime? created,
    String? sessionKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'created': created.toJson(),
      'sessionKey': sessionKey,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'created': created.toJson(),
      'sessionKey': sessionKey,
    };
  }

  static ActiveSessionInclude include() {
    return ActiveSessionInclude._();
  }

  static ActiveSessionIncludeList includeList({
    _i1.WhereExpressionBuilder<ActiveSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActiveSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActiveSessionTable>? orderByList,
    ActiveSessionInclude? include,
  }) {
    return ActiveSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActiveSession.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ActiveSession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActiveSessionImpl extends ActiveSession {
  _ActiveSessionImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required DateTime created,
    required String sessionKey,
  }) : super._(
          id: id,
          userId: userId,
          created: created,
          sessionKey: sessionKey,
        );

  /// Returns a shallow copy of this [ActiveSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ActiveSession copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    DateTime? created,
    String? sessionKey,
  }) {
    return ActiveSession(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      created: created ?? this.created,
      sessionKey: sessionKey ?? this.sessionKey,
    );
  }
}

class ActiveSessionTable extends _i1.Table<_i1.UuidValue> {
  ActiveSessionTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_session') {
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
    );
    sessionKey = _i1.ColumnString(
      'sessionKey',
      this,
    );
  }

  /// The id of the [AuthUser] this session belongs to
  late final _i1.ColumnUuid userId;

  /// The time when this sesion was created.
  late final _i1.ColumnDateTime created;

  late final _i1.ColumnString sessionKey;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        created,
        sessionKey,
      ];
}

class ActiveSessionInclude extends _i1.IncludeObject {
  ActiveSessionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue> get table => ActiveSession.t;
}

class ActiveSessionIncludeList extends _i1.IncludeList {
  ActiveSessionIncludeList._({
    _i1.WhereExpressionBuilder<ActiveSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ActiveSession.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => ActiveSession.t;
}

class ActiveSessionRepository {
  const ActiveSessionRepository._();

  /// Returns a list of [ActiveSession]s matching the given query parameters.
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
  Future<List<ActiveSession>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActiveSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActiveSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActiveSessionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ActiveSession>(
      where: where?.call(ActiveSession.t),
      orderBy: orderBy?.call(ActiveSession.t),
      orderByList: orderByList?.call(ActiveSession.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ActiveSession] matching the given query parameters.
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
  Future<ActiveSession?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActiveSessionTable>? where,
    int? offset,
    _i1.OrderByBuilder<ActiveSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActiveSessionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ActiveSession>(
      where: where?.call(ActiveSession.t),
      orderBy: orderBy?.call(ActiveSession.t),
      orderByList: orderByList?.call(ActiveSession.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ActiveSession] by its [id] or null if no such row exists.
  Future<ActiveSession?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ActiveSession>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ActiveSession]s in the list and returns the inserted rows.
  ///
  /// The returned [ActiveSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ActiveSession>> insert(
    _i1.Session session,
    List<ActiveSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ActiveSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ActiveSession] and returns the inserted row.
  ///
  /// The returned [ActiveSession] will have its `id` field set.
  Future<ActiveSession> insertRow(
    _i1.Session session,
    ActiveSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ActiveSession>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ActiveSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ActiveSession>> update(
    _i1.Session session,
    List<ActiveSession> rows, {
    _i1.ColumnSelections<ActiveSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ActiveSession>(
      rows,
      columns: columns?.call(ActiveSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ActiveSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ActiveSession> updateRow(
    _i1.Session session,
    ActiveSession row, {
    _i1.ColumnSelections<ActiveSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ActiveSession>(
      row,
      columns: columns?.call(ActiveSession.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ActiveSession]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ActiveSession>> delete(
    _i1.Session session,
    List<ActiveSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ActiveSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ActiveSession].
  Future<ActiveSession> deleteRow(
    _i1.Session session,
    ActiveSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ActiveSession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ActiveSession>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ActiveSessionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ActiveSession>(
      where: where(ActiveSession.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActiveSessionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ActiveSession>(
      where: where?.call(ActiveSession.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

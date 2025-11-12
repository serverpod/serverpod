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
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i2;

abstract class LegacyExternalUserIdentifier
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  LegacyExternalUserIdentifier._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.userIdentifier,
  });

  factory LegacyExternalUserIdentifier({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String userIdentifier,
  }) = _LegacyExternalUserIdentifierImpl;

  factory LegacyExternalUserIdentifier.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return LegacyExternalUserIdentifier(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i2.AuthUser.fromJson(
              (jsonSerialization['authUser'] as Map<String, dynamic>)),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
    );
  }

  static final t = LegacyExternalUserIdentifierTable();

  static const db = LegacyExternalUserIdentifierRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this session belongs to
  _i2.AuthUser? authUser;

  /// The user identifier as imported from `serverpod_auth`.
  ///
  /// This could be an external user ID for e.g. "Sign in with Apple", or an
  /// email address (in the Google Sign-In case).
  String userIdentifier;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [LegacyExternalUserIdentifier]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LegacyExternalUserIdentifier copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    String? userIdentifier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'userIdentifier': userIdentifier,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static LegacyExternalUserIdentifierInclude include(
      {_i2.AuthUserInclude? authUser}) {
    return LegacyExternalUserIdentifierInclude._(authUser: authUser);
  }

  static LegacyExternalUserIdentifierIncludeList includeList({
    _i1.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegacyExternalUserIdentifierTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegacyExternalUserIdentifierTable>? orderByList,
    LegacyExternalUserIdentifierInclude? include,
  }) {
    return LegacyExternalUserIdentifierIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegacyExternalUserIdentifier.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LegacyExternalUserIdentifier.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LegacyExternalUserIdentifierImpl extends LegacyExternalUserIdentifier {
  _LegacyExternalUserIdentifierImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String userIdentifier,
  }) : super._(
          id: id,
          authUserId: authUserId,
          authUser: authUser,
          userIdentifier: userIdentifier,
        );

  /// Returns a shallow copy of this [LegacyExternalUserIdentifier]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LegacyExternalUserIdentifier copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? userIdentifier,
  }) {
    return LegacyExternalUserIdentifier(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser:
          authUser is _i2.AuthUser? ? authUser : this.authUser?.copyWith(),
      userIdentifier: userIdentifier ?? this.userIdentifier,
    );
  }
}

class LegacyExternalUserIdentifierUpdateTable
    extends _i1.UpdateTable<LegacyExternalUserIdentifierTable> {
  LegacyExternalUserIdentifierUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
          _i1.UuidValue value) =>
      _i1.ColumnValue(
        table.authUserId,
        value,
      );

  _i1.ColumnValue<String, String> userIdentifier(String value) =>
      _i1.ColumnValue(
        table.userIdentifier,
        value,
      );
}

class LegacyExternalUserIdentifierTable extends _i1.Table<_i1.UuidValue?> {
  LegacyExternalUserIdentifierTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_bridge_external_user_id') {
    updateTable = LegacyExternalUserIdentifierUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    userIdentifier = _i1.ColumnString(
      'userIdentifier',
      this,
    );
  }

  late final LegacyExternalUserIdentifierUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this session belongs to
  _i2.AuthUserTable? _authUser;

  /// The user identifier as imported from `serverpod_auth`.
  ///
  /// This could be an external user ID for e.g. "Sign in with Apple", or an
  /// email address (in the Google Sign-In case).
  late final _i1.ColumnString userIdentifier;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: LegacyExternalUserIdentifier.t.authUserId,
      foreignField: _i2.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        authUserId,
        userIdentifier,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class LegacyExternalUserIdentifierInclude extends _i1.IncludeObject {
  LegacyExternalUserIdentifierInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => LegacyExternalUserIdentifier.t;
}

class LegacyExternalUserIdentifierIncludeList extends _i1.IncludeList {
  LegacyExternalUserIdentifierIncludeList._({
    _i1.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LegacyExternalUserIdentifier.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => LegacyExternalUserIdentifier.t;
}

class LegacyExternalUserIdentifierRepository {
  const LegacyExternalUserIdentifierRepository._();

  final attachRow = const LegacyExternalUserIdentifierAttachRowRepository._();

  /// Returns a list of [LegacyExternalUserIdentifier]s matching the given query parameters.
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
  Future<List<LegacyExternalUserIdentifier>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegacyExternalUserIdentifierTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegacyExternalUserIdentifierTable>? orderByList,
    _i1.Transaction? transaction,
    LegacyExternalUserIdentifierInclude? include,
  }) async {
    return session.db.find<LegacyExternalUserIdentifier>(
      where: where?.call(LegacyExternalUserIdentifier.t),
      orderBy: orderBy?.call(LegacyExternalUserIdentifier.t),
      orderByList: orderByList?.call(LegacyExternalUserIdentifier.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [LegacyExternalUserIdentifier] matching the given query parameters.
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
  Future<LegacyExternalUserIdentifier?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>? where,
    int? offset,
    _i1.OrderByBuilder<LegacyExternalUserIdentifierTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegacyExternalUserIdentifierTable>? orderByList,
    _i1.Transaction? transaction,
    LegacyExternalUserIdentifierInclude? include,
  }) async {
    return session.db.findFirstRow<LegacyExternalUserIdentifier>(
      where: where?.call(LegacyExternalUserIdentifier.t),
      orderBy: orderBy?.call(LegacyExternalUserIdentifier.t),
      orderByList: orderByList?.call(LegacyExternalUserIdentifier.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [LegacyExternalUserIdentifier] by its [id] or null if no such row exists.
  Future<LegacyExternalUserIdentifier?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    LegacyExternalUserIdentifierInclude? include,
  }) async {
    return session.db.findById<LegacyExternalUserIdentifier>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [LegacyExternalUserIdentifier]s in the list and returns the inserted rows.
  ///
  /// The returned [LegacyExternalUserIdentifier]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<LegacyExternalUserIdentifier>> insert(
    _i1.Session session,
    List<LegacyExternalUserIdentifier> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<LegacyExternalUserIdentifier>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [LegacyExternalUserIdentifier] and returns the inserted row.
  ///
  /// The returned [LegacyExternalUserIdentifier] will have its `id` field set.
  Future<LegacyExternalUserIdentifier> insertRow(
    _i1.Session session,
    LegacyExternalUserIdentifier row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LegacyExternalUserIdentifier>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LegacyExternalUserIdentifier]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LegacyExternalUserIdentifier>> update(
    _i1.Session session,
    List<LegacyExternalUserIdentifier> rows, {
    _i1.ColumnSelections<LegacyExternalUserIdentifierTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LegacyExternalUserIdentifier>(
      rows,
      columns: columns?.call(LegacyExternalUserIdentifier.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegacyExternalUserIdentifier]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LegacyExternalUserIdentifier> updateRow(
    _i1.Session session,
    LegacyExternalUserIdentifier row, {
    _i1.ColumnSelections<LegacyExternalUserIdentifierTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LegacyExternalUserIdentifier>(
      row,
      columns: columns?.call(LegacyExternalUserIdentifier.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegacyExternalUserIdentifier] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LegacyExternalUserIdentifier?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<LegacyExternalUserIdentifierUpdateTable>
        columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<LegacyExternalUserIdentifier>(
      id,
      columnValues: columnValues(LegacyExternalUserIdentifier.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LegacyExternalUserIdentifier]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<LegacyExternalUserIdentifier>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<LegacyExternalUserIdentifierUpdateTable>
        columnValues,
    required _i1.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>
        where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegacyExternalUserIdentifierTable>? orderBy,
    _i1.OrderByListBuilder<LegacyExternalUserIdentifierTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<LegacyExternalUserIdentifier>(
      columnValues: columnValues(LegacyExternalUserIdentifier.t.updateTable),
      where: where(LegacyExternalUserIdentifier.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegacyExternalUserIdentifier.t),
      orderByList: orderByList?.call(LegacyExternalUserIdentifier.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [LegacyExternalUserIdentifier]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LegacyExternalUserIdentifier>> delete(
    _i1.Session session,
    List<LegacyExternalUserIdentifier> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LegacyExternalUserIdentifier>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LegacyExternalUserIdentifier].
  Future<LegacyExternalUserIdentifier> deleteRow(
    _i1.Session session,
    LegacyExternalUserIdentifier row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LegacyExternalUserIdentifier>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LegacyExternalUserIdentifier>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LegacyExternalUserIdentifier>(
      where: where(LegacyExternalUserIdentifier.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LegacyExternalUserIdentifier>(
      where: where?.call(LegacyExternalUserIdentifier.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class LegacyExternalUserIdentifierAttachRowRepository {
  const LegacyExternalUserIdentifierAttachRowRepository._();

  /// Creates a relation between the given [LegacyExternalUserIdentifier] and [AuthUser]
  /// by setting the [LegacyExternalUserIdentifier]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    LegacyExternalUserIdentifier legacyExternalUserIdentifier,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (legacyExternalUserIdentifier.id == null) {
      throw ArgumentError.notNull('legacyExternalUserIdentifier.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $legacyExternalUserIdentifier =
        legacyExternalUserIdentifier.copyWith(authUserId: authUser.id);
    await session.db.updateRow<LegacyExternalUserIdentifier>(
      $legacyExternalUserIdentifier,
      columns: [LegacyExternalUserIdentifier.t.authUserId],
      transaction: transaction,
    );
  }
}

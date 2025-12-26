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
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart' as _i3;

/// A shell account. Persists as long as the user remains logged in,
/// but can never restore this session if the user logs out or loses access
/// to their device.
abstract class AnonymousAccount
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  AnonymousAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AnonymousAccount({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
  }) = _AnonymousAccountImpl;

  factory AnonymousAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return AnonymousAccount(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.AuthUser>(
              jsonSerialization['authUser'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AnonymousAccountTable();

  static const db = AnonymousAccountRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUser? authUser;

  /// The time when this authentication was created.
  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AnonymousAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AnonymousAccount copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.AnonymousAccount',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AnonymousAccountInclude include({_i2.AuthUserInclude? authUser}) {
    return AnonymousAccountInclude._(authUser: authUser);
  }

  static AnonymousAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<AnonymousAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnonymousAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnonymousAccountTable>? orderByList,
    AnonymousAccountInclude? include,
  }) {
    return AnonymousAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AnonymousAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AnonymousAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnonymousAccountImpl extends AnonymousAccount {
  _AnonymousAccountImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AnonymousAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AnonymousAccount copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? createdAt,
  }) {
    return AnonymousAccount(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AnonymousAccountUpdateTable
    extends _i1.UpdateTable<AnonymousAccountTable> {
  AnonymousAccountUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AnonymousAccountTable extends _i1.Table<_i1.UuidValue?> {
  AnonymousAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_anonymous_account') {
    updateTable = AnonymousAccountUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AnonymousAccountUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUserTable? _authUser;

  /// The time when this authentication was created.
  late final _i1.ColumnDateTime createdAt;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: AnonymousAccount.t.authUserId,
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
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class AnonymousAccountInclude extends _i1.IncludeObject {
  AnonymousAccountInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => AnonymousAccount.t;
}

class AnonymousAccountIncludeList extends _i1.IncludeList {
  AnonymousAccountIncludeList._({
    _i1.WhereExpressionBuilder<AnonymousAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AnonymousAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AnonymousAccount.t;
}

class AnonymousAccountRepository {
  const AnonymousAccountRepository._();

  final attachRow = const AnonymousAccountAttachRowRepository._();

  /// Returns a list of [AnonymousAccount]s matching the given query parameters.
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
  Future<List<AnonymousAccount>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnonymousAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnonymousAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnonymousAccountTable>? orderByList,
    _i1.Transaction? transaction,
    AnonymousAccountInclude? include,
  }) async {
    return session.db.find<AnonymousAccount>(
      where: where?.call(AnonymousAccount.t),
      orderBy: orderBy?.call(AnonymousAccount.t),
      orderByList: orderByList?.call(AnonymousAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AnonymousAccount] matching the given query parameters.
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
  Future<AnonymousAccount?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnonymousAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<AnonymousAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnonymousAccountTable>? orderByList,
    _i1.Transaction? transaction,
    AnonymousAccountInclude? include,
  }) async {
    return session.db.findFirstRow<AnonymousAccount>(
      where: where?.call(AnonymousAccount.t),
      orderBy: orderBy?.call(AnonymousAccount.t),
      orderByList: orderByList?.call(AnonymousAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AnonymousAccount] by its [id] or null if no such row exists.
  Future<AnonymousAccount?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    AnonymousAccountInclude? include,
  }) async {
    return session.db.findById<AnonymousAccount>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AnonymousAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [AnonymousAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AnonymousAccount>> insert(
    _i1.Session session,
    List<AnonymousAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AnonymousAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AnonymousAccount] and returns the inserted row.
  ///
  /// The returned [AnonymousAccount] will have its `id` field set.
  Future<AnonymousAccount> insertRow(
    _i1.Session session,
    AnonymousAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AnonymousAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AnonymousAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AnonymousAccount>> update(
    _i1.Session session,
    List<AnonymousAccount> rows, {
    _i1.ColumnSelections<AnonymousAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AnonymousAccount>(
      rows,
      columns: columns?.call(AnonymousAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AnonymousAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AnonymousAccount> updateRow(
    _i1.Session session,
    AnonymousAccount row, {
    _i1.ColumnSelections<AnonymousAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AnonymousAccount>(
      row,
      columns: columns?.call(AnonymousAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AnonymousAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AnonymousAccount?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<AnonymousAccountUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AnonymousAccount>(
      id,
      columnValues: columnValues(AnonymousAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AnonymousAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AnonymousAccount>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AnonymousAccountUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AnonymousAccountTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnonymousAccountTable>? orderBy,
    _i1.OrderByListBuilder<AnonymousAccountTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AnonymousAccount>(
      columnValues: columnValues(AnonymousAccount.t.updateTable),
      where: where(AnonymousAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AnonymousAccount.t),
      orderByList: orderByList?.call(AnonymousAccount.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AnonymousAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AnonymousAccount>> delete(
    _i1.Session session,
    List<AnonymousAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AnonymousAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AnonymousAccount].
  Future<AnonymousAccount> deleteRow(
    _i1.Session session,
    AnonymousAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AnonymousAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AnonymousAccount>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AnonymousAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AnonymousAccount>(
      where: where(AnonymousAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnonymousAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AnonymousAccount>(
      where: where?.call(AnonymousAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AnonymousAccountAttachRowRepository {
  const AnonymousAccountAttachRowRepository._();

  /// Creates a relation between the given [AnonymousAccount] and [AuthUser]
  /// by setting the [AnonymousAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    AnonymousAccount anonymousAccount,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (anonymousAccount.id == null) {
      throw ArgumentError.notNull('anonymousAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $anonymousAccount = anonymousAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<AnonymousAccount>(
      $anonymousAccount,
      columns: [AnonymousAccount.t.authUserId],
      transaction: transaction,
    );
  }
}

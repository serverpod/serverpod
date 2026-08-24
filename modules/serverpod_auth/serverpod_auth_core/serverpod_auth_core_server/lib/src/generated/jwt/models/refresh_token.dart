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
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/src/generated/protocol.dart'
    as _i8reeoob;
import '../../auth_user/models/auth_user.dart' as _ivyervu7;

/// Refresh token for JWT-based authentication.
abstract class RefreshToken
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  RefreshToken._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.scopeNames,
    this.extraClaims,
    required this.method,
    required this.fixedSecret,
    required this.rotatingSecretHash,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
  }) : lastUpdatedAt = lastUpdatedAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now();

  factory RefreshToken({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _ivyervu7.AuthUser? authUser,
    required Set<String> scopeNames,
    String? extraClaims,
    required String method,
    required _idt.ByteData fixedSecret,
    required String rotatingSecretHash,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
  }) = _RefreshTokenImpl;

  factory RefreshToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return RefreshToken(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i8reeoob.Protocol().deserialize<_ivyervu7.AuthUser>(
              jsonSerialization['authUser'],
            ),
      scopeNames: _i8reeoob.Protocol().deserialize<Set<String>>(
        jsonSerialization['scopeNames'],
      ),
      extraClaims: jsonSerialization['extraClaims'] as String?,
      method: jsonSerialization['method'] as String,
      fixedSecret: _is.ByteDataJsonExtension.fromJson(
        jsonSerialization['fixedSecret'],
      ),
      rotatingSecretHash: jsonSerialization['rotatingSecretHash'] as String,
      lastUpdatedAt: jsonSerialization['lastUpdatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastUpdatedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = RefreshTokenTable();

  static const db = RefreshTokenRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue authUserId;

  /// The [AuthUser] this refresh token belongs to.
  _ivyervu7.AuthUser? authUser;

  /// The scopes given to this session.
  ///
  /// These will also be added to each access token (JWT) created from this refresh token as a claim named "dev.serverpod.scopeNames".
  Set<String> scopeNames;

  /// Extra claims to be added to each access token created for this refresh token.
  ///
  /// This is a `Map<String, dynamic>` where each entry's key is used as a claim name.
  /// The values must be JSON-encodable.
  ///
  /// Users must ensure that the claims don't conflict with [registered claims](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1)
  /// or the above-mentioned claim for [scopeNames].
  ///
  /// This is only stored as a serialized String in the database due to schema limitations.
  String? extraClaims;

  /// The method through which this token was created.
  ///
  /// This can be either an email or social login, a personal access token, service account etc.
  String method;

  /// The fixed part of the secret.
  ///
  /// Any incoming rotation request referencing refresh token by ID and having the correct fixed part,
  /// but not the correct `secret`, will cause the refresh token to be invalidated (as the refresh token
  /// may have been leaked at that point).
  /// Since the refresh token's `id` is also part of the JWT access tokens for reference, we have to have this second
  /// part in here, ensuring that no one with just a (potentially expired) JWT can invalidate the refresh token.
  ///
  /// Per default uses 16 bytes of random data.
  _idt.ByteData fixedSecret;

  /// The most recent rotating secret associated with this refresh token.
  ///
  /// This is changed on every rotation of the refresh token,
  /// whenever a new access token is created.
  ///
  /// Per default uses 64 bytes of random data, and its hash is stored in PHC format:
  /// $argon2id$v=19$m={memory},t={iterations},p={lanes}${base64Salt}$${base64Hash}
  String rotatingSecretHash;

  /// The time when the [rotatingSecretHash] was last updated.
  DateTime lastUpdatedAt;

  /// The time when the first refresh token was created.
  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [RefreshToken]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RefreshToken copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    _ivyervu7.AuthUser? authUser,
    Set<String>? scopeNames,
    String? extraClaims,
    String? method,
    _idt.ByteData? fixedSecret,
    String? rotatingSecretHash,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.RefreshToken',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'scopeNames': scopeNames.toJson(),
      if (extraClaims != null) 'extraClaims': extraClaims,
      'method': method,
      'fixedSecret': fixedSecret.toJson(),
      'rotatingSecretHash': rotatingSecretHash,
      'lastUpdatedAt': lastUpdatedAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static RefreshTokenInclude include({
    _ivyervu7.AuthUserInclude? authUser,
    _is.SelectColumnsBuilder<RefreshTokenTable>? select,
  }) {
    return RefreshTokenInclude.internal_(
      authUser: authUser,
      selectedColumns: select?.call(RefreshToken.t),
    );
  }

  static RefreshTokenIncludeList includeList({
    _is.WhereExpressionBuilder<RefreshTokenTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RefreshTokenTable>? orderBy,
    _is.OrderByListBuilder<RefreshTokenTable>? orderByList,
    RefreshTokenInclude? include,
    _is.SelectColumnsBuilder<RefreshTokenTable>? select,
  }) {
    return RefreshTokenIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RefreshToken.t),
      orderByList: orderByList?.call(RefreshToken.t),
      include: include,
      selectedColumns: select?.call(RefreshToken.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RefreshTokenImpl extends RefreshToken {
  _RefreshTokenImpl({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _ivyervu7.AuthUser? authUser,
    required Set<String> scopeNames,
    String? extraClaims,
    required String method,
    required _idt.ByteData fixedSecret,
    required String rotatingSecretHash,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         scopeNames: scopeNames,
         extraClaims: extraClaims,
         method: method,
         fixedSecret: fixedSecret,
         rotatingSecretHash: rotatingSecretHash,
         lastUpdatedAt: lastUpdatedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RefreshToken]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RefreshToken copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Set<String>? scopeNames,
    Object? extraClaims = _Undefined,
    String? method,
    _idt.ByteData? fixedSecret,
    String? rotatingSecretHash,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
  }) {
    return RefreshToken(
      id: id is _is.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _ivyervu7.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      extraClaims: extraClaims is String? ? extraClaims : this.extraClaims,
      method: method ?? this.method,
      fixedSecret: fixedSecret ?? this.fixedSecret.clone(),
      rotatingSecretHash: rotatingSecretHash ?? this.rotatingSecretHash,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RefreshTokenUpdateTable extends _is.UpdateTable<RefreshTokenTable> {
  RefreshTokenUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<Set<String>, Set<String>> scopeNames(Set<String> value) =>
      _is.ColumnValue(
        table.scopeNames,
        value,
      );

  _is.ColumnValue<String, String> extraClaims(String? value) => _is.ColumnValue(
    table.extraClaims,
    value,
  );

  _is.ColumnValue<String, String> method(String value) => _is.ColumnValue(
    table.method,
    value,
  );

  _is.ColumnValue<_idt.ByteData, _idt.ByteData> fixedSecret(
    _idt.ByteData value,
  ) => _is.ColumnValue(
    table.fixedSecret,
    value,
  );

  _is.ColumnValue<String, String> rotatingSecretHash(String value) =>
      _is.ColumnValue(
        table.rotatingSecretHash,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastUpdatedAt(DateTime value) =>
      _is.ColumnValue(
        table.lastUpdatedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class RefreshTokenTable extends _is.Table<_is.UuidValue?> {
  RefreshTokenTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_core_jwt_refresh_token') {
    updateTable = RefreshTokenUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    scopeNames = _is.ColumnSerializable<Set<String>>(
      'scopeNames',
      this,
    );
    extraClaims = _is.ColumnString(
      'extraClaims',
      this,
    );
    method = _is.ColumnString(
      'method',
      this,
    );
    fixedSecret = _is.ColumnByteData(
      'fixedSecret',
      this,
    );
    rotatingSecretHash = _is.ColumnString(
      'rotatingSecretHash',
      this,
    );
    lastUpdatedAt = _is.ColumnDateTime(
      'lastUpdatedAt',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final RefreshTokenUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The [AuthUser] this refresh token belongs to.
  _ivyervu7.AuthUserTable? _authUser;

  /// The scopes given to this session.
  ///
  /// These will also be added to each access token (JWT) created from this refresh token as a claim named "dev.serverpod.scopeNames".
  late final _is.ColumnSerializable<Set<String>> scopeNames;

  /// Extra claims to be added to each access token created for this refresh token.
  ///
  /// This is a `Map<String, dynamic>` where each entry's key is used as a claim name.
  /// The values must be JSON-encodable.
  ///
  /// Users must ensure that the claims don't conflict with [registered claims](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1)
  /// or the above-mentioned claim for [scopeNames].
  ///
  /// This is only stored as a serialized String in the database due to schema limitations.
  late final _is.ColumnString extraClaims;

  /// The method through which this token was created.
  ///
  /// This can be either an email or social login, a personal access token, service account etc.
  late final _is.ColumnString method;

  /// The fixed part of the secret.
  ///
  /// Any incoming rotation request referencing refresh token by ID and having the correct fixed part,
  /// but not the correct `secret`, will cause the refresh token to be invalidated (as the refresh token
  /// may have been leaked at that point).
  /// Since the refresh token's `id` is also part of the JWT access tokens for reference, we have to have this second
  /// part in here, ensuring that no one with just a (potentially expired) JWT can invalidate the refresh token.
  ///
  /// Per default uses 16 bytes of random data.
  late final _is.ColumnByteData fixedSecret;

  /// The most recent rotating secret associated with this refresh token.
  ///
  /// This is changed on every rotation of the refresh token,
  /// whenever a new access token is created.
  ///
  /// Per default uses 64 bytes of random data, and its hash is stored in PHC format:
  /// $argon2id$v=19$m={memory},t={iterations},p={lanes}${base64Salt}$${base64Hash}
  late final _is.ColumnString rotatingSecretHash;

  /// The time when the [rotatingSecretHash] was last updated.
  late final _is.ColumnDateTime lastUpdatedAt;

  /// The time when the first refresh token was created.
  late final _is.ColumnDateTime createdAt;

  _ivyervu7.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: RefreshToken.t.authUserId,
      foreignField: _ivyervu7.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ivyervu7.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    scopeNames,
    extraClaims,
    method,
    fixedSecret,
    rotatingSecretHash,
    lastUpdatedAt,
    createdAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class RefreshTokenInclude extends _is.IncludeObject {
  RefreshTokenInclude.internal_({
    _ivyervu7.AuthUserInclude? authUser,
    this.selectedColumns,
  }) {
    _authUser = authUser;
  }

  _ivyervu7.AuthUserInclude? _authUser;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<_is.UuidValue?> get table => RefreshToken.t;
}

class RefreshTokenIncludeList extends _is.IncludeList {
  RefreshTokenIncludeList.internal_({
    _is.WhereExpressionBuilder<RefreshTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(RefreshToken.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => RefreshToken.t;
}

class RefreshTokenRepository {
  const RefreshTokenRepository._();

  final attachRow = const RefreshTokenAttachRowRepository._();

  /// Returns a list of [RefreshToken]s matching the given query parameters.
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
  Future<List<RefreshToken>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RefreshTokenTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RefreshTokenTable>? orderBy,
    _is.OrderByListBuilder<RefreshTokenTable>? orderByList,
    _is.Transaction? transaction,
    RefreshTokenInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RefreshToken>(
      where: where?.call(RefreshToken.t),
      orderBy: orderBy?.call(RefreshToken.t),
      orderByList: orderByList?.call(RefreshToken.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RefreshToken] matching the given query parameters.
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
  Future<RefreshToken?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RefreshTokenTable>? where,
    int? offset,
    _is.OrderByBuilder<RefreshTokenTable>? orderBy,
    _is.OrderByListBuilder<RefreshTokenTable>? orderByList,
    _is.Transaction? transaction,
    RefreshTokenInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RefreshToken>(
      where: where?.call(RefreshToken.t),
      orderBy: orderBy?.call(RefreshToken.t),
      orderByList: orderByList?.call(RefreshToken.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RefreshToken] by its [id] or null if no such row exists.
  Future<RefreshToken?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    RefreshTokenInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RefreshToken>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RefreshToken]s in the list and returns the inserted rows.
  ///
  /// The returned [RefreshToken]s will have their `id` fields set.
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
  Future<List<RefreshToken>> insert(
    _is.DatabaseSession session,
    List<RefreshToken> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RefreshToken>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RefreshToken] and returns the inserted row.
  ///
  /// The returned [RefreshToken] will have its `id` field set.
  Future<RefreshToken> insertRow(
    _is.DatabaseSession session,
    RefreshToken row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RefreshToken>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RefreshToken]s in the list and returns the resulting rows.
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
  /// The returned [RefreshToken]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RefreshToken>> upsert(
    _is.DatabaseSession session,
    List<RefreshToken> rows, {
    required _is.ColumnSelections<RefreshTokenTable> conflictColumns,
    _is.ColumnSelections<RefreshTokenTable>? updateColumns,
    _is.WhereExpressionBuilder<RefreshTokenTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RefreshToken>(
      rows,
      conflictColumns: conflictColumns(RefreshToken.t),
      updateColumns: updateColumns?.call(RefreshToken.t),
      updateWhere: updateWhere?.call(RefreshToken.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RefreshToken] and returns the resulting row.
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
  /// The returned [RefreshToken] will have its `id` field set.
  Future<RefreshToken?> upsertRow(
    _is.DatabaseSession session,
    RefreshToken row, {
    required _is.ColumnSelections<RefreshTokenTable> conflictColumns,
    _is.ColumnSelections<RefreshTokenTable>? updateColumns,
    _is.WhereExpressionBuilder<RefreshTokenTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RefreshToken>(
      row,
      conflictColumns: conflictColumns(RefreshToken.t),
      updateColumns: updateColumns?.call(RefreshToken.t),
      updateWhere: updateWhere?.call(RefreshToken.t),
      transaction: transaction,
    );
  }

  /// Updates all [RefreshToken]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RefreshToken>> update(
    _is.DatabaseSession session,
    List<RefreshToken> rows, {
    _is.ColumnSelections<RefreshTokenTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RefreshToken>(
      rows,
      columns: columns?.call(RefreshToken.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RefreshToken]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RefreshToken> updateRow(
    _is.DatabaseSession session,
    RefreshToken row, {
    _is.ColumnSelections<RefreshTokenTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RefreshToken>(
      row,
      columns: columns?.call(RefreshToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RefreshToken] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RefreshToken?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<RefreshTokenUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RefreshToken>(
      id,
      columnValues: columnValues(RefreshToken.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RefreshToken]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RefreshToken>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RefreshTokenUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RefreshTokenTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RefreshTokenTable>? orderBy,
    _is.OrderByListBuilder<RefreshTokenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RefreshToken>(
      columnValues: columnValues(RefreshToken.t.updateTable),
      where: where(RefreshToken.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RefreshToken.t),
      orderByList: orderByList?.call(RefreshToken.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RefreshToken]s in the list and returns the deleted rows.
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
  Future<List<RefreshToken>> delete(
    _is.DatabaseSession session,
    List<RefreshToken> rows, {
    _is.OrderByBuilder<RefreshTokenTable>? orderBy,
    _is.OrderByListBuilder<RefreshTokenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RefreshToken>(
      rows,
      orderBy: orderBy?.call(RefreshToken.t),
      orderByList: orderByList?.call(RefreshToken.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RefreshToken].
  Future<RefreshToken> deleteRow(
    _is.DatabaseSession session,
    RefreshToken row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RefreshToken>(
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
  Future<List<RefreshToken>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RefreshTokenTable> where,
    _is.OrderByBuilder<RefreshTokenTable>? orderBy,
    _is.OrderByListBuilder<RefreshTokenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RefreshToken>(
      where: where(RefreshToken.t),
      orderBy: orderBy?.call(RefreshToken.t),
      orderByList: orderByList?.call(RefreshToken.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RefreshTokenTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RefreshToken>(
      where: where?.call(RefreshToken.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RefreshToken] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RefreshTokenTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RefreshToken>(
      where: where(RefreshToken.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class RefreshTokenAttachRowRepository {
  const RefreshTokenAttachRowRepository._();

  /// Creates a relation between the given [RefreshToken] and [AuthUser]
  /// by setting the [RefreshToken]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    RefreshToken refreshToken,
    _ivyervu7.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (refreshToken.id == null) {
      throw ArgumentError.notNull('refreshToken.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $refreshToken = refreshToken.copyWith(authUserId: authUser.id);
    await session.db.updateRow<RefreshToken>(
      $refreshToken,
      columns: [RefreshToken.t.authUserId],
      transaction: transaction,
    );
  }
}

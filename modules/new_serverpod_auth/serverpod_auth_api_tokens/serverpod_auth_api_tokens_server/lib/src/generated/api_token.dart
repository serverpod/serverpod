/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart'
    as _i2;
import 'dart:typed_data' as _i3;

abstract class ApiToken
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ApiToken._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.scopeNames,
    DateTime? created,
    DateTime? lastUsed,
    this.expiresAt,
    this.expireAfterUnusedFor,
    required this.apiTokenHash,
    required this.apiTokenSalt,
    String? kind,
  })  : created = created ?? DateTime.now(),
        lastUsed = lastUsed ?? DateTime.now(),
        kind = kind ?? '';

  factory ApiToken({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required Set<String> scopeNames,
    DateTime? created,
    DateTime? lastUsed,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    required _i3.ByteData apiTokenHash,
    required _i3.ByteData apiTokenSalt,
    String? kind,
  }) = _ApiTokenImpl;

  factory ApiToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiToken(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i2.AuthUser.fromJson(
              (jsonSerialization['authUser'] as Map<String, dynamic>)),
      scopeNames: _i1.SetJsonExtension.fromJson(
          (jsonSerialization['scopeNames'] as List),
          itemFromJson: (e) => e as String)!,
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      lastUsed:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastUsed']),
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      expireAfterUnusedFor: jsonSerialization['expireAfterUnusedFor'] == null
          ? null
          : _i1.DurationJsonExtension.fromJson(
              jsonSerialization['expireAfterUnusedFor']),
      apiTokenHash:
          _i1.ByteDataJsonExtension.fromJson(jsonSerialization['apiTokenHash']),
      apiTokenSalt:
          _i1.ByteDataJsonExtension.fromJson(jsonSerialization['apiTokenSalt']),
      kind: jsonSerialization['kind'] as String,
    );
  }

  static final t = ApiTokenTable();

  static const db = ApiTokenRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this API token belongs to
  _i2.AuthUser? authUser;

  /// The scopes this API token provides access to.
  ///
  /// These are not connected to the [authUser], and can for example represent a subset of their permissions.
  Set<String> scopeNames;

  /// The time when this API token was created.
  DateTime created;

  /// The time when this access token was last used.
  ///
  /// Operates only with minute resolution, to avoid excessive writes to the database.
  DateTime lastUsed;

  /// The time after which this token can not be used anymore.
  ///
  /// If `null`, the token can be used indefinitely.
  DateTime? expiresAt;

  /// The maximum duration this token can go unused.
  ///
  /// If set, and the token is used after [lastUsed] + [expireAfterUnusedFor], then it will be rejected.
  ///
  /// If `null`, the token is valid until [expiresAt].
  Duration? expireAfterUnusedFor;

  /// Hashed version of the API token.
  ///
  /// Per default a token uses 64 bytes of random data, and its hash is stored peppered and salted.
  _i3.ByteData apiTokenHash;

  /// The salt used for computing the [apiTokenHash].
  ///
  /// Per default uses 16 bytes of random data.
  _i3.ByteData apiTokenSalt;

  /// The kind of API token this represents.
  ///
  /// This does not impact the behavior of the token, but can be useful for debugging.
  /// For example this could be used to differentiate between anonymous accounts, personal access tokens, or service accounts.
  String kind;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ApiToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ApiToken copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    Set<String>? scopeNames,
    DateTime? created,
    DateTime? lastUsed,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    _i3.ByteData? apiTokenHash,
    _i3.ByteData? apiTokenSalt,
    String? kind,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'scopeNames': scopeNames.toJson(),
      'created': created.toJson(),
      'lastUsed': lastUsed.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (expireAfterUnusedFor != null)
        'expireAfterUnusedFor': expireAfterUnusedFor?.toJson(),
      'apiTokenHash': apiTokenHash.toJson(),
      'apiTokenSalt': apiTokenSalt.toJson(),
      'kind': kind,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id?.toJson()};
  }

  static ApiTokenInclude include({_i2.AuthUserInclude? authUser}) {
    return ApiTokenInclude._(authUser: authUser);
  }

  static ApiTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<ApiTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ApiTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ApiTokenTable>? orderByList,
    ApiTokenInclude? include,
  }) {
    return ApiTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ApiToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ApiToken.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApiTokenImpl extends ApiToken {
  _ApiTokenImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required Set<String> scopeNames,
    DateTime? created,
    DateTime? lastUsed,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    required _i3.ByteData apiTokenHash,
    required _i3.ByteData apiTokenSalt,
    String? kind,
  }) : super._(
          id: id,
          authUserId: authUserId,
          authUser: authUser,
          scopeNames: scopeNames,
          created: created,
          lastUsed: lastUsed,
          expiresAt: expiresAt,
          expireAfterUnusedFor: expireAfterUnusedFor,
          apiTokenHash: apiTokenHash,
          apiTokenSalt: apiTokenSalt,
          kind: kind,
        );

  /// Returns a shallow copy of this [ApiToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ApiToken copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Set<String>? scopeNames,
    DateTime? created,
    DateTime? lastUsed,
    Object? expiresAt = _Undefined,
    Object? expireAfterUnusedFor = _Undefined,
    _i3.ByteData? apiTokenHash,
    _i3.ByteData? apiTokenSalt,
    String? kind,
  }) {
    return ApiToken(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser:
          authUser is _i2.AuthUser? ? authUser : this.authUser?.copyWith(),
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      created: created ?? this.created,
      lastUsed: lastUsed ?? this.lastUsed,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      expireAfterUnusedFor: expireAfterUnusedFor is Duration?
          ? expireAfterUnusedFor
          : this.expireAfterUnusedFor,
      apiTokenHash: apiTokenHash ?? this.apiTokenHash.clone(),
      apiTokenSalt: apiTokenSalt ?? this.apiTokenSalt.clone(),
      kind: kind ?? this.kind,
    );
  }
}

class ApiTokenTable extends _i1.Table<_i1.UuidValue?> {
  ApiTokenTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_api_token') {
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    scopeNames = _i1.ColumnSerializable(
      'scopeNames',
      this,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
      hasDefault: true,
    );
    lastUsed = _i1.ColumnDateTime(
      'lastUsed',
      this,
      hasDefault: true,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    expireAfterUnusedFor = _i1.ColumnDuration(
      'expireAfterUnusedFor',
      this,
    );
    apiTokenHash = _i1.ColumnByteData(
      'apiTokenHash',
      this,
    );
    apiTokenSalt = _i1.ColumnByteData(
      'apiTokenSalt',
      this,
    );
    kind = _i1.ColumnString(
      'kind',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this API token belongs to
  _i2.AuthUserTable? _authUser;

  /// The scopes this API token provides access to.
  ///
  /// These are not connected to the [authUser], and can for example represent a subset of their permissions.
  late final _i1.ColumnSerializable scopeNames;

  /// The time when this API token was created.
  late final _i1.ColumnDateTime created;

  /// The time when this access token was last used.
  ///
  /// Operates only with minute resolution, to avoid excessive writes to the database.
  late final _i1.ColumnDateTime lastUsed;

  /// The time after which this token can not be used anymore.
  ///
  /// If `null`, the token can be used indefinitely.
  late final _i1.ColumnDateTime expiresAt;

  /// The maximum duration this token can go unused.
  ///
  /// If set, and the token is used after [lastUsed] + [expireAfterUnusedFor], then it will be rejected.
  ///
  /// If `null`, the token is valid until [expiresAt].
  late final _i1.ColumnDuration expireAfterUnusedFor;

  /// Hashed version of the API token.
  ///
  /// Per default a token uses 64 bytes of random data, and its hash is stored peppered and salted.
  late final _i1.ColumnByteData apiTokenHash;

  /// The salt used for computing the [apiTokenHash].
  ///
  /// Per default uses 16 bytes of random data.
  late final _i1.ColumnByteData apiTokenSalt;

  /// The kind of API token this represents.
  ///
  /// This does not impact the behavior of the token, but can be useful for debugging.
  /// For example this could be used to differentiate between anonymous accounts, personal access tokens, or service accounts.
  late final _i1.ColumnString kind;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: ApiToken.t.authUserId,
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
        scopeNames,
        created,
        lastUsed,
        expiresAt,
        expireAfterUnusedFor,
        apiTokenHash,
        apiTokenSalt,
        kind,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class ApiTokenInclude extends _i1.IncludeObject {
  ApiTokenInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => ApiToken.t;
}

class ApiTokenIncludeList extends _i1.IncludeList {
  ApiTokenIncludeList._({
    _i1.WhereExpressionBuilder<ApiTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ApiToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ApiToken.t;
}

class ApiTokenRepository {
  const ApiTokenRepository._();

  final attachRow = const ApiTokenAttachRowRepository._();

  /// Returns a list of [ApiToken]s matching the given query parameters.
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
  Future<List<ApiToken>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ApiTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ApiTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ApiTokenTable>? orderByList,
    _i1.Transaction? transaction,
    ApiTokenInclude? include,
  }) async {
    return session.db.find<ApiToken>(
      where: where?.call(ApiToken.t),
      orderBy: orderBy?.call(ApiToken.t),
      orderByList: orderByList?.call(ApiToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ApiToken] matching the given query parameters.
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
  Future<ApiToken?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ApiTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<ApiTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ApiTokenTable>? orderByList,
    _i1.Transaction? transaction,
    ApiTokenInclude? include,
  }) async {
    return session.db.findFirstRow<ApiToken>(
      where: where?.call(ApiToken.t),
      orderBy: orderBy?.call(ApiToken.t),
      orderByList: orderByList?.call(ApiToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ApiToken] by its [id] or null if no such row exists.
  Future<ApiToken?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    ApiTokenInclude? include,
  }) async {
    return session.db.findById<ApiToken>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ApiToken]s in the list and returns the inserted rows.
  ///
  /// The returned [ApiToken]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ApiToken>> insert(
    _i1.Session session,
    List<ApiToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ApiToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ApiToken] and returns the inserted row.
  ///
  /// The returned [ApiToken] will have its `id` field set.
  Future<ApiToken> insertRow(
    _i1.Session session,
    ApiToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ApiToken>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ApiToken]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ApiToken>> update(
    _i1.Session session,
    List<ApiToken> rows, {
    _i1.ColumnSelections<ApiTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ApiToken>(
      rows,
      columns: columns?.call(ApiToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ApiToken]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ApiToken> updateRow(
    _i1.Session session,
    ApiToken row, {
    _i1.ColumnSelections<ApiTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ApiToken>(
      row,
      columns: columns?.call(ApiToken.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ApiToken]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ApiToken>> delete(
    _i1.Session session,
    List<ApiToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ApiToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ApiToken].
  Future<ApiToken> deleteRow(
    _i1.Session session,
    ApiToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ApiToken>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ApiToken>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ApiTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ApiToken>(
      where: where(ApiToken.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ApiTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ApiToken>(
      where: where?.call(ApiToken.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ApiTokenAttachRowRepository {
  const ApiTokenAttachRowRepository._();

  /// Creates a relation between the given [ApiToken] and [AuthUser]
  /// by setting the [ApiToken]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    ApiToken apiToken,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (apiToken.id == null) {
      throw ArgumentError.notNull('apiToken.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $apiToken = apiToken.copyWith(authUserId: authUser.id);
    await session.db.updateRow<ApiToken>(
      $apiToken,
      columns: [ApiToken.t.authUserId],
      transaction: transaction,
    );
  }
}

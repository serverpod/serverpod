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

abstract class RefreshToken
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  RefreshToken._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.scopeNames,
    this.extraClaims,
    required this.fixedSecret,
    required this.rotatingSecretHash,
    required this.rotatingSecretSalt,
    DateTime? lastUpdated,
    DateTime? created,
  })  : lastUpdated = lastUpdated ?? DateTime.now(),
        created = created ?? DateTime.now();

  factory RefreshToken({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required Set<String> scopeNames,
    String? extraClaims,
    required _i3.ByteData fixedSecret,
    required _i3.ByteData rotatingSecretHash,
    required _i3.ByteData rotatingSecretSalt,
    DateTime? lastUpdated,
    DateTime? created,
  }) = _RefreshTokenImpl;

  factory RefreshToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return RefreshToken(
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
      extraClaims: jsonSerialization['extraClaims'] as String?,
      fixedSecret:
          _i1.ByteDataJsonExtension.fromJson(jsonSerialization['fixedSecret']),
      rotatingSecretHash: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['rotatingSecretHash']),
      rotatingSecretSalt: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['rotatingSecretSalt']),
      lastUpdated:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastUpdated']),
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
    );
  }

  static final t = RefreshTokenTable();

  static const db = RefreshTokenRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this refresh token belongs to.
  _i2.AuthUser? authUser;

  /// The scopes given to this session.
  ///
  /// These will also be added to each access token (JWT) created from this refresh token as a claim named "dev.serverpod.scopeNames".
  Set<String> scopeNames;

  /// Extra claims to be added to each access token created for this refresh token.
  ///
  /// This is a `Map<String, dynamic>` where each entry's key is used as a claim name.
  /// The values must be JSON-encodable.
  ///
  /// Users must ensure that the claims don't conflict with [registerd claims](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1)
  /// or the above-mentioned claim for [scopeNames].
  ///
  /// This is only stored as a serialized String in the database due to schema limitations.
  String? extraClaims;

  /// The fixed part of the secret.
  ///
  /// Any incoming rotation request referencing refresh token by ID and having the correct fixed part,
  /// but not the correct `secret`, will cause the refresh token to be invalidated (as the refresh token
  /// may have been leaked at that point).
  /// Since the refresh token's `id` is also part of the JWT access tokens for reference, we have to have this second
  /// part in here, ensuring that no one with just a (potentially expired) JWT can invalidate the refresh token.
  ///
  /// Per default uses 16 bytes of random data.
  _i3.ByteData fixedSecret;

  /// The most recent rotating secret associated with this refresh token.
  ///
  /// This is changed on every rotation of the refresh token,
  /// whenever a new access token is created.
  ///
  /// Per default uses 64 bytes of random data, and its hash is stored peppered and salted.
  _i3.ByteData rotatingSecretHash;

  /// The salt used for computing the [rotatingSecretHash].
  ///
  /// Per default uses 16 bytes of random data.
  _i3.ByteData rotatingSecretSalt;

  /// The time when the [rotatingSecretHash] / [rotatingSecretSalt] pair was last updated.
  DateTime lastUpdated;

  /// The time when the first refresh token was created.
  DateTime created;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [RefreshToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RefreshToken copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    Set<String>? scopeNames,
    String? extraClaims,
    _i3.ByteData? fixedSecret,
    _i3.ByteData? rotatingSecretHash,
    _i3.ByteData? rotatingSecretSalt,
    DateTime? lastUpdated,
    DateTime? created,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'scopeNames': scopeNames.toJson(),
      if (extraClaims != null) 'extraClaims': extraClaims,
      'fixedSecret': fixedSecret.toJson(),
      'rotatingSecretHash': rotatingSecretHash.toJson(),
      'rotatingSecretSalt': rotatingSecretSalt.toJson(),
      'lastUpdated': lastUpdated.toJson(),
      'created': created.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id?.toJson()};
  }

  static RefreshTokenInclude include({_i2.AuthUserInclude? authUser}) {
    return RefreshTokenInclude._(authUser: authUser);
  }

  static RefreshTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<RefreshTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RefreshTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefreshTokenTable>? orderByList,
    RefreshTokenInclude? include,
  }) {
    return RefreshTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RefreshToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RefreshToken.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RefreshTokenImpl extends RefreshToken {
  _RefreshTokenImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required Set<String> scopeNames,
    String? extraClaims,
    required _i3.ByteData fixedSecret,
    required _i3.ByteData rotatingSecretHash,
    required _i3.ByteData rotatingSecretSalt,
    DateTime? lastUpdated,
    DateTime? created,
  }) : super._(
          id: id,
          authUserId: authUserId,
          authUser: authUser,
          scopeNames: scopeNames,
          extraClaims: extraClaims,
          fixedSecret: fixedSecret,
          rotatingSecretHash: rotatingSecretHash,
          rotatingSecretSalt: rotatingSecretSalt,
          lastUpdated: lastUpdated,
          created: created,
        );

  /// Returns a shallow copy of this [RefreshToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RefreshToken copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Set<String>? scopeNames,
    Object? extraClaims = _Undefined,
    _i3.ByteData? fixedSecret,
    _i3.ByteData? rotatingSecretHash,
    _i3.ByteData? rotatingSecretSalt,
    DateTime? lastUpdated,
    DateTime? created,
  }) {
    return RefreshToken(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser:
          authUser is _i2.AuthUser? ? authUser : this.authUser?.copyWith(),
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      extraClaims: extraClaims is String? ? extraClaims : this.extraClaims,
      fixedSecret: fixedSecret ?? this.fixedSecret.clone(),
      rotatingSecretHash: rotatingSecretHash ?? this.rotatingSecretHash.clone(),
      rotatingSecretSalt: rotatingSecretSalt ?? this.rotatingSecretSalt.clone(),
      lastUpdated: lastUpdated ?? this.lastUpdated,
      created: created ?? this.created,
    );
  }
}

class RefreshTokenTable extends _i1.Table<_i1.UuidValue?> {
  RefreshTokenTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_jwt_refresh_token') {
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    scopeNames = _i1.ColumnSerializable(
      'scopeNames',
      this,
    );
    extraClaims = _i1.ColumnString(
      'extraClaims',
      this,
    );
    fixedSecret = _i1.ColumnByteData(
      'fixedSecret',
      this,
    );
    rotatingSecretHash = _i1.ColumnByteData(
      'rotatingSecretHash',
      this,
    );
    rotatingSecretSalt = _i1.ColumnByteData(
      'rotatingSecretSalt',
      this,
    );
    lastUpdated = _i1.ColumnDateTime(
      'lastUpdated',
      this,
      hasDefault: true,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this refresh token belongs to.
  _i2.AuthUserTable? _authUser;

  /// The scopes given to this session.
  ///
  /// These will also be added to each access token (JWT) created from this refresh token as a claim named "dev.serverpod.scopeNames".
  late final _i1.ColumnSerializable scopeNames;

  /// Extra claims to be added to each access token created for this refresh token.
  ///
  /// This is a `Map<String, dynamic>` where each entry's key is used as a claim name.
  /// The values must be JSON-encodable.
  ///
  /// Users must ensure that the claims don't conflict with [registerd claims](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1)
  /// or the above-mentioned claim for [scopeNames].
  ///
  /// This is only stored as a serialized String in the database due to schema limitations.
  late final _i1.ColumnString extraClaims;

  /// The fixed part of the secret.
  ///
  /// Any incoming rotation request referencing refresh token by ID and having the correct fixed part,
  /// but not the correct `secret`, will cause the refresh token to be invalidated (as the refresh token
  /// may have been leaked at that point).
  /// Since the refresh token's `id` is also part of the JWT access tokens for reference, we have to have this second
  /// part in here, ensuring that no one with just a (potentially expired) JWT can invalidate the refresh token.
  ///
  /// Per default uses 16 bytes of random data.
  late final _i1.ColumnByteData fixedSecret;

  /// The most recent rotating secret associated with this refresh token.
  ///
  /// This is changed on every rotation of the refresh token,
  /// whenever a new access token is created.
  ///
  /// Per default uses 64 bytes of random data, and its hash is stored peppered and salted.
  late final _i1.ColumnByteData rotatingSecretHash;

  /// The salt used for computing the [rotatingSecretHash].
  ///
  /// Per default uses 16 bytes of random data.
  late final _i1.ColumnByteData rotatingSecretSalt;

  /// The time when the [rotatingSecretHash] / [rotatingSecretSalt] pair was last updated.
  late final _i1.ColumnDateTime lastUpdated;

  /// The time when the first refresh token was created.
  late final _i1.ColumnDateTime created;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: RefreshToken.t.authUserId,
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
        extraClaims,
        fixedSecret,
        rotatingSecretHash,
        rotatingSecretSalt,
        lastUpdated,
        created,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class RefreshTokenInclude extends _i1.IncludeObject {
  RefreshTokenInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => RefreshToken.t;
}

class RefreshTokenIncludeList extends _i1.IncludeList {
  RefreshTokenIncludeList._({
    _i1.WhereExpressionBuilder<RefreshTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RefreshToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => RefreshToken.t;
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RefreshTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RefreshTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefreshTokenTable>? orderByList,
    _i1.Transaction? transaction,
    RefreshTokenInclude? include,
  }) async {
    return session.db.find<RefreshToken>(
      where: where?.call(RefreshToken.t),
      orderBy: orderBy?.call(RefreshToken.t),
      orderByList: orderByList?.call(RefreshToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RefreshTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<RefreshTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefreshTokenTable>? orderByList,
    _i1.Transaction? transaction,
    RefreshTokenInclude? include,
  }) async {
    return session.db.findFirstRow<RefreshToken>(
      where: where?.call(RefreshToken.t),
      orderBy: orderBy?.call(RefreshToken.t),
      orderByList: orderByList?.call(RefreshToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [RefreshToken] by its [id] or null if no such row exists.
  Future<RefreshToken?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    RefreshTokenInclude? include,
  }) async {
    return session.db.findById<RefreshToken>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [RefreshToken]s in the list and returns the inserted rows.
  ///
  /// The returned [RefreshToken]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<RefreshToken>> insert(
    _i1.Session session,
    List<RefreshToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<RefreshToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [RefreshToken] and returns the inserted row.
  ///
  /// The returned [RefreshToken] will have its `id` field set.
  Future<RefreshToken> insertRow(
    _i1.Session session,
    RefreshToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RefreshToken>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RefreshToken]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RefreshToken>> update(
    _i1.Session session,
    List<RefreshToken> rows, {
    _i1.ColumnSelections<RefreshTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RefreshToken>(
      rows,
      columns: columns?.call(RefreshToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RefreshToken]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RefreshToken> updateRow(
    _i1.Session session,
    RefreshToken row, {
    _i1.ColumnSelections<RefreshTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RefreshToken>(
      row,
      columns: columns?.call(RefreshToken.t),
      transaction: transaction,
    );
  }

  /// Deletes all [RefreshToken]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RefreshToken>> delete(
    _i1.Session session,
    List<RefreshToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RefreshToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RefreshToken].
  Future<RefreshToken> deleteRow(
    _i1.Session session,
    RefreshToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RefreshToken>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RefreshToken>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RefreshTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RefreshToken>(
      where: where(RefreshToken.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RefreshTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RefreshToken>(
      where: where?.call(RefreshToken.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class RefreshTokenAttachRowRepository {
  const RefreshTokenAttachRowRepository._();

  /// Creates a relation between the given [RefreshToken] and [AuthUser]
  /// by setting the [RefreshToken]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    RefreshToken refreshToken,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
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

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
import 'dart:typed_data' as _i3;

/// A fully configured passkey to be used for logins.
abstract class PasskeyAccount
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  PasskeyAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? createdAt,
    required this.keyId,
    required this.keyIdBase64,
    required this.clientDataJSON,
    required this.attestationObject,
    required this.originalChallenge,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PasskeyAccount({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
    required _i3.ByteData keyId,
    required String keyIdBase64,
    required _i3.ByteData clientDataJSON,
    required _i3.ByteData attestationObject,
    required _i3.ByteData originalChallenge,
  }) = _PasskeyAccountImpl;

  factory PasskeyAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return PasskeyAccount(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i2.AuthUser.fromJson(
              (jsonSerialization['authUser'] as Map<String, dynamic>)),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      keyId: _i1.ByteDataJsonExtension.fromJson(jsonSerialization['keyId']),
      keyIdBase64: jsonSerialization['keyIdBase64'] as String,
      clientDataJSON: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['clientDataJSON']),
      attestationObject: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['attestationObject']),
      originalChallenge: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['originalChallenge']),
    );
  }

  static final t = PasskeyAccountTable();

  static const db = PasskeyAccountRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUser? authUser;

  /// The time when this authentication was created.
  DateTime createdAt;

  /// The ID of the [publicKey].
  _i3.ByteData keyId;

  /// Base64 variant of the key ID (to enable DB lookups).
  String keyIdBase64;

  /// The authenticator's JSON client data sent during the registration.
  _i3.ByteData clientDataJSON;

  /// The attestation object used during the registration.
  _i3.ByteData attestationObject;

  /// The challenge used during registration.
  _i3.ByteData originalChallenge;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PasskeyAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PasskeyAccount copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
    _i3.ByteData? keyId,
    String? keyIdBase64,
    _i3.ByteData? clientDataJSON,
    _i3.ByteData? attestationObject,
    _i3.ByteData? originalChallenge,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'createdAt': createdAt.toJson(),
      'keyId': keyId.toJson(),
      'keyIdBase64': keyIdBase64,
      'clientDataJSON': clientDataJSON.toJson(),
      'attestationObject': attestationObject.toJson(),
      'originalChallenge': originalChallenge.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PasskeyAccountInclude include({_i2.AuthUserInclude? authUser}) {
    return PasskeyAccountInclude._(authUser: authUser);
  }

  static PasskeyAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<PasskeyAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PasskeyAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PasskeyAccountTable>? orderByList,
    PasskeyAccountInclude? include,
  }) {
    return PasskeyAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PasskeyAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PasskeyAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PasskeyAccountImpl extends PasskeyAccount {
  _PasskeyAccountImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
    required _i3.ByteData keyId,
    required String keyIdBase64,
    required _i3.ByteData clientDataJSON,
    required _i3.ByteData attestationObject,
    required _i3.ByteData originalChallenge,
  }) : super._(
          id: id,
          authUserId: authUserId,
          authUser: authUser,
          createdAt: createdAt,
          keyId: keyId,
          keyIdBase64: keyIdBase64,
          clientDataJSON: clientDataJSON,
          attestationObject: attestationObject,
          originalChallenge: originalChallenge,
        );

  /// Returns a shallow copy of this [PasskeyAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PasskeyAccount copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? createdAt,
    _i3.ByteData? keyId,
    String? keyIdBase64,
    _i3.ByteData? clientDataJSON,
    _i3.ByteData? attestationObject,
    _i3.ByteData? originalChallenge,
  }) {
    return PasskeyAccount(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser:
          authUser is _i2.AuthUser? ? authUser : this.authUser?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      keyId: keyId ?? this.keyId.clone(),
      keyIdBase64: keyIdBase64 ?? this.keyIdBase64,
      clientDataJSON: clientDataJSON ?? this.clientDataJSON.clone(),
      attestationObject: attestationObject ?? this.attestationObject.clone(),
      originalChallenge: originalChallenge ?? this.originalChallenge.clone(),
    );
  }
}

class PasskeyAccountUpdateTable extends _i1.UpdateTable<PasskeyAccountTable> {
  PasskeyAccountUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
          _i1.UuidValue value) =>
      _i1.ColumnValue(
        table.authUserId,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<_i3.ByteData, _i3.ByteData> keyId(_i3.ByteData value) =>
      _i1.ColumnValue(
        table.keyId,
        value,
      );

  _i1.ColumnValue<String, String> keyIdBase64(String value) => _i1.ColumnValue(
        table.keyIdBase64,
        value,
      );

  _i1.ColumnValue<_i3.ByteData, _i3.ByteData> clientDataJSON(
          _i3.ByteData value) =>
      _i1.ColumnValue(
        table.clientDataJSON,
        value,
      );

  _i1.ColumnValue<_i3.ByteData, _i3.ByteData> attestationObject(
          _i3.ByteData value) =>
      _i1.ColumnValue(
        table.attestationObject,
        value,
      );

  _i1.ColumnValue<_i3.ByteData, _i3.ByteData> originalChallenge(
          _i3.ByteData value) =>
      _i1.ColumnValue(
        table.originalChallenge,
        value,
      );
}

class PasskeyAccountTable extends _i1.Table<_i1.UuidValue?> {
  PasskeyAccountTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_idp_passkey_account') {
    updateTable = PasskeyAccountUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    keyId = _i1.ColumnByteData(
      'keyId',
      this,
    );
    keyIdBase64 = _i1.ColumnString(
      'keyIdBase64',
      this,
    );
    clientDataJSON = _i1.ColumnByteData(
      'clientDataJSON',
      this,
    );
    attestationObject = _i1.ColumnByteData(
      'attestationObject',
      this,
    );
    originalChallenge = _i1.ColumnByteData(
      'originalChallenge',
      this,
    );
  }

  late final PasskeyAccountUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUserTable? _authUser;

  /// The time when this authentication was created.
  late final _i1.ColumnDateTime createdAt;

  /// The ID of the [publicKey].
  late final _i1.ColumnByteData keyId;

  /// Base64 variant of the key ID (to enable DB lookups).
  late final _i1.ColumnString keyIdBase64;

  /// The authenticator's JSON client data sent during the registration.
  late final _i1.ColumnByteData clientDataJSON;

  /// The attestation object used during the registration.
  late final _i1.ColumnByteData attestationObject;

  /// The challenge used during registration.
  late final _i1.ColumnByteData originalChallenge;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: PasskeyAccount.t.authUserId,
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
        keyId,
        keyIdBase64,
        clientDataJSON,
        attestationObject,
        originalChallenge,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class PasskeyAccountInclude extends _i1.IncludeObject {
  PasskeyAccountInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => PasskeyAccount.t;
}

class PasskeyAccountIncludeList extends _i1.IncludeList {
  PasskeyAccountIncludeList._({
    _i1.WhereExpressionBuilder<PasskeyAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PasskeyAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => PasskeyAccount.t;
}

class PasskeyAccountRepository {
  const PasskeyAccountRepository._();

  final attachRow = const PasskeyAccountAttachRowRepository._();

  /// Returns a list of [PasskeyAccount]s matching the given query parameters.
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
  Future<List<PasskeyAccount>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PasskeyAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PasskeyAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PasskeyAccountTable>? orderByList,
    _i1.Transaction? transaction,
    PasskeyAccountInclude? include,
  }) async {
    return session.db.find<PasskeyAccount>(
      where: where?.call(PasskeyAccount.t),
      orderBy: orderBy?.call(PasskeyAccount.t),
      orderByList: orderByList?.call(PasskeyAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [PasskeyAccount] matching the given query parameters.
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
  Future<PasskeyAccount?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PasskeyAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<PasskeyAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PasskeyAccountTable>? orderByList,
    _i1.Transaction? transaction,
    PasskeyAccountInclude? include,
  }) async {
    return session.db.findFirstRow<PasskeyAccount>(
      where: where?.call(PasskeyAccount.t),
      orderBy: orderBy?.call(PasskeyAccount.t),
      orderByList: orderByList?.call(PasskeyAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [PasskeyAccount] by its [id] or null if no such row exists.
  Future<PasskeyAccount?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    PasskeyAccountInclude? include,
  }) async {
    return session.db.findById<PasskeyAccount>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [PasskeyAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [PasskeyAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PasskeyAccount>> insert(
    _i1.Session session,
    List<PasskeyAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PasskeyAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PasskeyAccount] and returns the inserted row.
  ///
  /// The returned [PasskeyAccount] will have its `id` field set.
  Future<PasskeyAccount> insertRow(
    _i1.Session session,
    PasskeyAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PasskeyAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PasskeyAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PasskeyAccount>> update(
    _i1.Session session,
    List<PasskeyAccount> rows, {
    _i1.ColumnSelections<PasskeyAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PasskeyAccount>(
      rows,
      columns: columns?.call(PasskeyAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PasskeyAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PasskeyAccount> updateRow(
    _i1.Session session,
    PasskeyAccount row, {
    _i1.ColumnSelections<PasskeyAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PasskeyAccount>(
      row,
      columns: columns?.call(PasskeyAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PasskeyAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PasskeyAccount?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<PasskeyAccountUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PasskeyAccount>(
      id,
      columnValues: columnValues(PasskeyAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PasskeyAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PasskeyAccount>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PasskeyAccountUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PasskeyAccountTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PasskeyAccountTable>? orderBy,
    _i1.OrderByListBuilder<PasskeyAccountTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PasskeyAccount>(
      columnValues: columnValues(PasskeyAccount.t.updateTable),
      where: where(PasskeyAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PasskeyAccount.t),
      orderByList: orderByList?.call(PasskeyAccount.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PasskeyAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PasskeyAccount>> delete(
    _i1.Session session,
    List<PasskeyAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PasskeyAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PasskeyAccount].
  Future<PasskeyAccount> deleteRow(
    _i1.Session session,
    PasskeyAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PasskeyAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PasskeyAccount>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PasskeyAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PasskeyAccount>(
      where: where(PasskeyAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PasskeyAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PasskeyAccount>(
      where: where?.call(PasskeyAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class PasskeyAccountAttachRowRepository {
  const PasskeyAccountAttachRowRepository._();

  /// Creates a relation between the given [PasskeyAccount] and [AuthUser]
  /// by setting the [PasskeyAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    PasskeyAccount passkeyAccount,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (passkeyAccount.id == null) {
      throw ArgumentError.notNull('passkeyAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $passkeyAccount = passkeyAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<PasskeyAccount>(
      $passkeyAccount,
      columns: [PasskeyAccount.t.authUserId],
      transaction: transaction,
    );
  }
}

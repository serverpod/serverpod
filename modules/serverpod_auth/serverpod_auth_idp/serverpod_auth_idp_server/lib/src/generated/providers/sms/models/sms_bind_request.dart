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
import '../../../common/secret_challenge/models/secret_challenge.dart' as _i3;
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart' as _i4;

/// Pending SMS phone bind request.
abstract class SmsBindRequest
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  SmsBindRequest._({
    this.id,
    DateTime? createdAt,
    required this.authUserId,
    this.authUser,
    required this.phoneHash,
    required this.challengeId,
    this.challenge,
    this.bindChallengeId,
    this.bindChallenge,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SmsBindRequest({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String phoneHash,
    required _i1.UuidValue challengeId,
    _i3.SecretChallenge? challenge,
    _i1.UuidValue? bindChallengeId,
    _i3.SecretChallenge? bindChallenge,
  }) = _SmsBindRequestImpl;

  factory SmsBindRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return SmsBindRequest(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.AuthUser>(
              jsonSerialization['authUser'],
            ),
      phoneHash: jsonSerialization['phoneHash'] as String,
      challengeId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['challengeId'],
      ),
      challenge: jsonSerialization['challenge'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.SecretChallenge>(
              jsonSerialization['challenge'],
            ),
      bindChallengeId: jsonSerialization['bindChallengeId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['bindChallengeId'],
            ),
      bindChallenge: jsonSerialization['bindChallenge'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.SecretChallenge>(
              jsonSerialization['bindChallenge'],
            ),
    );
  }

  static final t = SmsBindRequestTable();

  static const db = SmsBindRequestRepository._();

  @override
  _i1.UuidValue? id;

  /// The time when this request was created.
  DateTime createdAt;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this bind request belongs to
  _i2.AuthUser? authUser;

  /// The hash of the phone number.
  String phoneHash;

  _i1.UuidValue challengeId;

  /// The associated challenge for this request
  _i3.SecretChallenge? challenge;

  _i1.UuidValue? bindChallengeId;

  /// Used to complete the phone binding.
  /// This will be set after the verification challenge has been validated.
  _i3.SecretChallenge? bindChallenge;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SmsBindRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SmsBindRequest copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    String? phoneHash,
    _i1.UuidValue? challengeId,
    _i3.SecretChallenge? challenge,
    _i1.UuidValue? bindChallengeId,
    _i3.SecretChallenge? bindChallenge,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.SmsBindRequest',
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'phoneHash': phoneHash,
      'challengeId': challengeId.toJson(),
      if (challenge != null) 'challenge': challenge?.toJson(),
      if (bindChallengeId != null) 'bindChallengeId': bindChallengeId?.toJson(),
      if (bindChallenge != null) 'bindChallenge': bindChallenge?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SmsBindRequestInclude include({
    _i2.AuthUserInclude? authUser,
    _i3.SecretChallengeInclude? challenge,
    _i3.SecretChallengeInclude? bindChallenge,
  }) {
    return SmsBindRequestInclude._(
      authUser: authUser,
      challenge: challenge,
      bindChallenge: bindChallenge,
    );
  }

  static SmsBindRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<SmsBindRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsBindRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsBindRequestTable>? orderByList,
    SmsBindRequestInclude? include,
  }) {
    return SmsBindRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmsBindRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SmsBindRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SmsBindRequestImpl extends SmsBindRequest {
  _SmsBindRequestImpl({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String phoneHash,
    required _i1.UuidValue challengeId,
    _i3.SecretChallenge? challenge,
    _i1.UuidValue? bindChallengeId,
    _i3.SecretChallenge? bindChallenge,
  }) : super._(
         id: id,
         createdAt: createdAt,
         authUserId: authUserId,
         authUser: authUser,
         phoneHash: phoneHash,
         challengeId: challengeId,
         challenge: challenge,
         bindChallengeId: bindChallengeId,
         bindChallenge: bindChallenge,
       );

  /// Returns a shallow copy of this [SmsBindRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SmsBindRequest copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? phoneHash,
    _i1.UuidValue? challengeId,
    Object? challenge = _Undefined,
    Object? bindChallengeId = _Undefined,
    Object? bindChallenge = _Undefined,
  }) {
    return SmsBindRequest(
      id: id is _i1.UuidValue? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      phoneHash: phoneHash ?? this.phoneHash,
      challengeId: challengeId ?? this.challengeId,
      challenge: challenge is _i3.SecretChallenge?
          ? challenge
          : this.challenge?.copyWith(),
      bindChallengeId: bindChallengeId is _i1.UuidValue?
          ? bindChallengeId
          : this.bindChallengeId,
      bindChallenge: bindChallenge is _i3.SecretChallenge?
          ? bindChallenge
          : this.bindChallenge?.copyWith(),
    );
  }
}

class SmsBindRequestUpdateTable extends _i1.UpdateTable<SmsBindRequestTable> {
  SmsBindRequestUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<String, String> phoneHash(String value) => _i1.ColumnValue(
    table.phoneHash,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> challengeId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.challengeId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> bindChallengeId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.bindChallengeId,
    value,
  );
}

class SmsBindRequestTable extends _i1.Table<_i1.UuidValue?> {
  SmsBindRequestTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_sms_bind_request') {
    updateTable = SmsBindRequestUpdateTable(this);
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    phoneHash = _i1.ColumnString(
      'phoneHash',
      this,
    );
    challengeId = _i1.ColumnUuid(
      'challengeId',
      this,
    );
    bindChallengeId = _i1.ColumnUuid(
      'bindChallengeId',
      this,
    );
  }

  late final SmsBindRequestUpdateTable updateTable;

  /// The time when this request was created.
  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this bind request belongs to
  _i2.AuthUserTable? _authUser;

  /// The hash of the phone number.
  late final _i1.ColumnString phoneHash;

  late final _i1.ColumnUuid challengeId;

  /// The associated challenge for this request
  _i3.SecretChallengeTable? _challenge;

  late final _i1.ColumnUuid bindChallengeId;

  /// Used to complete the phone binding.
  /// This will be set after the verification challenge has been validated.
  _i3.SecretChallengeTable? _bindChallenge;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: SmsBindRequest.t.authUserId,
      foreignField: _i2.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  _i3.SecretChallengeTable get challenge {
    if (_challenge != null) return _challenge!;
    _challenge = _i1.createRelationTable(
      relationFieldName: 'challenge',
      field: SmsBindRequest.t.challengeId,
      foreignField: _i3.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _challenge!;
  }

  _i3.SecretChallengeTable get bindChallenge {
    if (_bindChallenge != null) return _bindChallenge!;
    _bindChallenge = _i1.createRelationTable(
      relationFieldName: 'bindChallenge',
      field: SmsBindRequest.t.bindChallengeId,
      foreignField: _i3.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _bindChallenge!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    createdAt,
    authUserId,
    phoneHash,
    challengeId,
    bindChallengeId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    if (relationField == 'challenge') {
      return challenge;
    }
    if (relationField == 'bindChallenge') {
      return bindChallenge;
    }
    return null;
  }
}

class SmsBindRequestInclude extends _i1.IncludeObject {
  SmsBindRequestInclude._({
    _i2.AuthUserInclude? authUser,
    _i3.SecretChallengeInclude? challenge,
    _i3.SecretChallengeInclude? bindChallenge,
  }) {
    _authUser = authUser;
    _challenge = challenge;
    _bindChallenge = bindChallenge;
  }

  _i2.AuthUserInclude? _authUser;

  _i3.SecretChallengeInclude? _challenge;

  _i3.SecretChallengeInclude? _bindChallenge;

  @override
  Map<String, _i1.Include?> get includes => {
    'authUser': _authUser,
    'challenge': _challenge,
    'bindChallenge': _bindChallenge,
  };

  @override
  _i1.Table<_i1.UuidValue?> get table => SmsBindRequest.t;
}

class SmsBindRequestIncludeList extends _i1.IncludeList {
  SmsBindRequestIncludeList._({
    _i1.WhereExpressionBuilder<SmsBindRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SmsBindRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => SmsBindRequest.t;
}

class SmsBindRequestRepository {
  const SmsBindRequestRepository._();

  final attachRow = const SmsBindRequestAttachRowRepository._();

  final detachRow = const SmsBindRequestDetachRowRepository._();

  /// Returns a list of [SmsBindRequest]s matching the given query parameters.
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
  Future<List<SmsBindRequest>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsBindRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsBindRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsBindRequestTable>? orderByList,
    _i1.Transaction? transaction,
    SmsBindRequestInclude? include,
  }) async {
    return session.db.find<SmsBindRequest>(
      where: where?.call(SmsBindRequest.t),
      orderBy: orderBy?.call(SmsBindRequest.t),
      orderByList: orderByList?.call(SmsBindRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [SmsBindRequest] matching the given query parameters.
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
  Future<SmsBindRequest?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsBindRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<SmsBindRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsBindRequestTable>? orderByList,
    _i1.Transaction? transaction,
    SmsBindRequestInclude? include,
  }) async {
    return session.db.findFirstRow<SmsBindRequest>(
      where: where?.call(SmsBindRequest.t),
      orderBy: orderBy?.call(SmsBindRequest.t),
      orderByList: orderByList?.call(SmsBindRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [SmsBindRequest] by its [id] or null if no such row exists.
  Future<SmsBindRequest?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    SmsBindRequestInclude? include,
  }) async {
    return session.db.findById<SmsBindRequest>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [SmsBindRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [SmsBindRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SmsBindRequest>> insert(
    _i1.Session session,
    List<SmsBindRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SmsBindRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SmsBindRequest] and returns the inserted row.
  ///
  /// The returned [SmsBindRequest] will have its `id` field set.
  Future<SmsBindRequest> insertRow(
    _i1.Session session,
    SmsBindRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SmsBindRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SmsBindRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SmsBindRequest>> update(
    _i1.Session session,
    List<SmsBindRequest> rows, {
    _i1.ColumnSelections<SmsBindRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SmsBindRequest>(
      rows,
      columns: columns?.call(SmsBindRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SmsBindRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SmsBindRequest> updateRow(
    _i1.Session session,
    SmsBindRequest row, {
    _i1.ColumnSelections<SmsBindRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SmsBindRequest>(
      row,
      columns: columns?.call(SmsBindRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SmsBindRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SmsBindRequest?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<SmsBindRequestUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SmsBindRequest>(
      id,
      columnValues: columnValues(SmsBindRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SmsBindRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SmsBindRequest>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SmsBindRequestUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SmsBindRequestTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsBindRequestTable>? orderBy,
    _i1.OrderByListBuilder<SmsBindRequestTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SmsBindRequest>(
      columnValues: columnValues(SmsBindRequest.t.updateTable),
      where: where(SmsBindRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmsBindRequest.t),
      orderByList: orderByList?.call(SmsBindRequest.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SmsBindRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SmsBindRequest>> delete(
    _i1.Session session,
    List<SmsBindRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SmsBindRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SmsBindRequest].
  Future<SmsBindRequest> deleteRow(
    _i1.Session session,
    SmsBindRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SmsBindRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SmsBindRequest>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SmsBindRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SmsBindRequest>(
      where: where(SmsBindRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsBindRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SmsBindRequest>(
      where: where?.call(SmsBindRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class SmsBindRequestAttachRowRepository {
  const SmsBindRequestAttachRowRepository._();

  /// Creates a relation between the given [SmsBindRequest] and [AuthUser]
  /// by setting the [SmsBindRequest]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    SmsBindRequest smsBindRequest,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (smsBindRequest.id == null) {
      throw ArgumentError.notNull('smsBindRequest.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $smsBindRequest = smsBindRequest.copyWith(authUserId: authUser.id);
    await session.db.updateRow<SmsBindRequest>(
      $smsBindRequest,
      columns: [SmsBindRequest.t.authUserId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [SmsBindRequest] and [SecretChallenge]
  /// by setting the [SmsBindRequest]'s foreign key `challengeId` to refer to the [SecretChallenge].
  Future<void> challenge(
    _i1.Session session,
    SmsBindRequest smsBindRequest,
    _i3.SecretChallenge challenge, {
    _i1.Transaction? transaction,
  }) async {
    if (smsBindRequest.id == null) {
      throw ArgumentError.notNull('smsBindRequest.id');
    }
    if (challenge.id == null) {
      throw ArgumentError.notNull('challenge.id');
    }

    var $smsBindRequest = smsBindRequest.copyWith(challengeId: challenge.id);
    await session.db.updateRow<SmsBindRequest>(
      $smsBindRequest,
      columns: [SmsBindRequest.t.challengeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [SmsBindRequest] and [SecretChallenge]
  /// by setting the [SmsBindRequest]'s foreign key `bindChallengeId` to refer to the [SecretChallenge].
  Future<void> bindChallenge(
    _i1.Session session,
    SmsBindRequest smsBindRequest,
    _i3.SecretChallenge bindChallenge, {
    _i1.Transaction? transaction,
  }) async {
    if (smsBindRequest.id == null) {
      throw ArgumentError.notNull('smsBindRequest.id');
    }
    if (bindChallenge.id == null) {
      throw ArgumentError.notNull('bindChallenge.id');
    }

    var $smsBindRequest = smsBindRequest.copyWith(
      bindChallengeId: bindChallenge.id,
    );
    await session.db.updateRow<SmsBindRequest>(
      $smsBindRequest,
      columns: [SmsBindRequest.t.bindChallengeId],
      transaction: transaction,
    );
  }
}

class SmsBindRequestDetachRowRepository {
  const SmsBindRequestDetachRowRepository._();

  /// Detaches the relation between this [SmsBindRequest] and the [SecretChallenge] set in `bindChallenge`
  /// by setting the [SmsBindRequest]'s foreign key `bindChallengeId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> bindChallenge(
    _i1.Session session,
    SmsBindRequest smsBindRequest, {
    _i1.Transaction? transaction,
  }) async {
    if (smsBindRequest.id == null) {
      throw ArgumentError.notNull('smsBindRequest.id');
    }

    var $smsBindRequest = smsBindRequest.copyWith(bindChallengeId: null);
    await session.db.updateRow<SmsBindRequest>(
      $smsBindRequest,
      columns: [SmsBindRequest.t.bindChallengeId],
      transaction: transaction,
    );
  }
}

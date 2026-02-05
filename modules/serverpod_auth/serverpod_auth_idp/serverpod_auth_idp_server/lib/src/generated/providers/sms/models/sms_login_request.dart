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
import '../../../common/secret_challenge/models/secret_challenge.dart' as _i2;
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart' as _i3;

/// Pending SMS login request.
abstract class SmsLoginRequest
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  SmsLoginRequest._({
    this.id,
    DateTime? createdAt,
    required this.phoneHash,
    required this.challengeId,
    this.challenge,
    this.loginChallengeId,
    this.loginChallenge,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SmsLoginRequest({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required String phoneHash,
    required _i1.UuidValue challengeId,
    _i2.SecretChallenge? challenge,
    _i1.UuidValue? loginChallengeId,
    _i2.SecretChallenge? loginChallenge,
  }) = _SmsLoginRequestImpl;

  factory SmsLoginRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return SmsLoginRequest(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      phoneHash: jsonSerialization['phoneHash'] as String,
      challengeId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['challengeId'],
      ),
      challenge: jsonSerialization['challenge'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.SecretChallenge>(
              jsonSerialization['challenge'],
            ),
      loginChallengeId: jsonSerialization['loginChallengeId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['loginChallengeId'],
            ),
      loginChallenge: jsonSerialization['loginChallenge'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.SecretChallenge>(
              jsonSerialization['loginChallenge'],
            ),
    );
  }

  static final t = SmsLoginRequestTable();

  static const db = SmsLoginRequestRepository._();

  @override
  _i1.UuidValue? id;

  /// The time when this request was created.
  DateTime createdAt;

  /// The hash of the phone number.
  String phoneHash;

  _i1.UuidValue challengeId;

  /// The associated challenge for this request
  _i2.SecretChallenge? challenge;

  _i1.UuidValue? loginChallengeId;

  /// Used to complete the login.
  /// This will be set after the verification challenge has been validated.
  _i2.SecretChallenge? loginChallenge;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SmsLoginRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SmsLoginRequest copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    String? phoneHash,
    _i1.UuidValue? challengeId,
    _i2.SecretChallenge? challenge,
    _i1.UuidValue? loginChallengeId,
    _i2.SecretChallenge? loginChallenge,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.SmsLoginRequest',
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'phoneHash': phoneHash,
      'challengeId': challengeId.toJson(),
      if (challenge != null) 'challenge': challenge?.toJson(),
      if (loginChallengeId != null)
        'loginChallengeId': loginChallengeId?.toJson(),
      if (loginChallenge != null) 'loginChallenge': loginChallenge?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SmsLoginRequestInclude include({
    _i2.SecretChallengeInclude? challenge,
    _i2.SecretChallengeInclude? loginChallenge,
  }) {
    return SmsLoginRequestInclude._(
      challenge: challenge,
      loginChallenge: loginChallenge,
    );
  }

  static SmsLoginRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<SmsLoginRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsLoginRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsLoginRequestTable>? orderByList,
    SmsLoginRequestInclude? include,
  }) {
    return SmsLoginRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmsLoginRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SmsLoginRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SmsLoginRequestImpl extends SmsLoginRequest {
  _SmsLoginRequestImpl({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required String phoneHash,
    required _i1.UuidValue challengeId,
    _i2.SecretChallenge? challenge,
    _i1.UuidValue? loginChallengeId,
    _i2.SecretChallenge? loginChallenge,
  }) : super._(
         id: id,
         createdAt: createdAt,
         phoneHash: phoneHash,
         challengeId: challengeId,
         challenge: challenge,
         loginChallengeId: loginChallengeId,
         loginChallenge: loginChallenge,
       );

  /// Returns a shallow copy of this [SmsLoginRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SmsLoginRequest copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    String? phoneHash,
    _i1.UuidValue? challengeId,
    Object? challenge = _Undefined,
    Object? loginChallengeId = _Undefined,
    Object? loginChallenge = _Undefined,
  }) {
    return SmsLoginRequest(
      id: id is _i1.UuidValue? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      phoneHash: phoneHash ?? this.phoneHash,
      challengeId: challengeId ?? this.challengeId,
      challenge: challenge is _i2.SecretChallenge?
          ? challenge
          : this.challenge?.copyWith(),
      loginChallengeId: loginChallengeId is _i1.UuidValue?
          ? loginChallengeId
          : this.loginChallengeId,
      loginChallenge: loginChallenge is _i2.SecretChallenge?
          ? loginChallenge
          : this.loginChallenge?.copyWith(),
    );
  }
}

class SmsLoginRequestUpdateTable extends _i1.UpdateTable<SmsLoginRequestTable> {
  SmsLoginRequestUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
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

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> loginChallengeId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.loginChallengeId,
    value,
  );
}

class SmsLoginRequestTable extends _i1.Table<_i1.UuidValue?> {
  SmsLoginRequestTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_sms_login_request') {
    updateTable = SmsLoginRequestUpdateTable(this);
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    phoneHash = _i1.ColumnString(
      'phoneHash',
      this,
    );
    challengeId = _i1.ColumnUuid(
      'challengeId',
      this,
    );
    loginChallengeId = _i1.ColumnUuid(
      'loginChallengeId',
      this,
    );
  }

  late final SmsLoginRequestUpdateTable updateTable;

  /// The time when this request was created.
  late final _i1.ColumnDateTime createdAt;

  /// The hash of the phone number.
  late final _i1.ColumnString phoneHash;

  late final _i1.ColumnUuid challengeId;

  /// The associated challenge for this request
  _i2.SecretChallengeTable? _challenge;

  late final _i1.ColumnUuid loginChallengeId;

  /// Used to complete the login.
  /// This will be set after the verification challenge has been validated.
  _i2.SecretChallengeTable? _loginChallenge;

  _i2.SecretChallengeTable get challenge {
    if (_challenge != null) return _challenge!;
    _challenge = _i1.createRelationTable(
      relationFieldName: 'challenge',
      field: SmsLoginRequest.t.challengeId,
      foreignField: _i2.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _challenge!;
  }

  _i2.SecretChallengeTable get loginChallenge {
    if (_loginChallenge != null) return _loginChallenge!;
    _loginChallenge = _i1.createRelationTable(
      relationFieldName: 'loginChallenge',
      field: SmsLoginRequest.t.loginChallengeId,
      foreignField: _i2.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _loginChallenge!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    createdAt,
    phoneHash,
    challengeId,
    loginChallengeId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'challenge') {
      return challenge;
    }
    if (relationField == 'loginChallenge') {
      return loginChallenge;
    }
    return null;
  }
}

class SmsLoginRequestInclude extends _i1.IncludeObject {
  SmsLoginRequestInclude._({
    _i2.SecretChallengeInclude? challenge,
    _i2.SecretChallengeInclude? loginChallenge,
  }) {
    _challenge = challenge;
    _loginChallenge = loginChallenge;
  }

  _i2.SecretChallengeInclude? _challenge;

  _i2.SecretChallengeInclude? _loginChallenge;

  @override
  Map<String, _i1.Include?> get includes => {
    'challenge': _challenge,
    'loginChallenge': _loginChallenge,
  };

  @override
  _i1.Table<_i1.UuidValue?> get table => SmsLoginRequest.t;
}

class SmsLoginRequestIncludeList extends _i1.IncludeList {
  SmsLoginRequestIncludeList._({
    _i1.WhereExpressionBuilder<SmsLoginRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SmsLoginRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => SmsLoginRequest.t;
}

class SmsLoginRequestRepository {
  const SmsLoginRequestRepository._();

  final attachRow = const SmsLoginRequestAttachRowRepository._();

  final detachRow = const SmsLoginRequestDetachRowRepository._();

  /// Returns a list of [SmsLoginRequest]s matching the given query parameters.
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
  Future<List<SmsLoginRequest>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsLoginRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsLoginRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsLoginRequestTable>? orderByList,
    _i1.Transaction? transaction,
    SmsLoginRequestInclude? include,
  }) async {
    return session.db.find<SmsLoginRequest>(
      where: where?.call(SmsLoginRequest.t),
      orderBy: orderBy?.call(SmsLoginRequest.t),
      orderByList: orderByList?.call(SmsLoginRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [SmsLoginRequest] matching the given query parameters.
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
  Future<SmsLoginRequest?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsLoginRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<SmsLoginRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsLoginRequestTable>? orderByList,
    _i1.Transaction? transaction,
    SmsLoginRequestInclude? include,
  }) async {
    return session.db.findFirstRow<SmsLoginRequest>(
      where: where?.call(SmsLoginRequest.t),
      orderBy: orderBy?.call(SmsLoginRequest.t),
      orderByList: orderByList?.call(SmsLoginRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [SmsLoginRequest] by its [id] or null if no such row exists.
  Future<SmsLoginRequest?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    SmsLoginRequestInclude? include,
  }) async {
    return session.db.findById<SmsLoginRequest>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [SmsLoginRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [SmsLoginRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SmsLoginRequest>> insert(
    _i1.Session session,
    List<SmsLoginRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SmsLoginRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SmsLoginRequest] and returns the inserted row.
  ///
  /// The returned [SmsLoginRequest] will have its `id` field set.
  Future<SmsLoginRequest> insertRow(
    _i1.Session session,
    SmsLoginRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SmsLoginRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SmsLoginRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SmsLoginRequest>> update(
    _i1.Session session,
    List<SmsLoginRequest> rows, {
    _i1.ColumnSelections<SmsLoginRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SmsLoginRequest>(
      rows,
      columns: columns?.call(SmsLoginRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SmsLoginRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SmsLoginRequest> updateRow(
    _i1.Session session,
    SmsLoginRequest row, {
    _i1.ColumnSelections<SmsLoginRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SmsLoginRequest>(
      row,
      columns: columns?.call(SmsLoginRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SmsLoginRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SmsLoginRequest?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<SmsLoginRequestUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SmsLoginRequest>(
      id,
      columnValues: columnValues(SmsLoginRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SmsLoginRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SmsLoginRequest>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SmsLoginRequestUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SmsLoginRequestTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsLoginRequestTable>? orderBy,
    _i1.OrderByListBuilder<SmsLoginRequestTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SmsLoginRequest>(
      columnValues: columnValues(SmsLoginRequest.t.updateTable),
      where: where(SmsLoginRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmsLoginRequest.t),
      orderByList: orderByList?.call(SmsLoginRequest.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SmsLoginRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SmsLoginRequest>> delete(
    _i1.Session session,
    List<SmsLoginRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SmsLoginRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SmsLoginRequest].
  Future<SmsLoginRequest> deleteRow(
    _i1.Session session,
    SmsLoginRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SmsLoginRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SmsLoginRequest>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SmsLoginRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SmsLoginRequest>(
      where: where(SmsLoginRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsLoginRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SmsLoginRequest>(
      where: where?.call(SmsLoginRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class SmsLoginRequestAttachRowRepository {
  const SmsLoginRequestAttachRowRepository._();

  /// Creates a relation between the given [SmsLoginRequest] and [SecretChallenge]
  /// by setting the [SmsLoginRequest]'s foreign key `challengeId` to refer to the [SecretChallenge].
  Future<void> challenge(
    _i1.Session session,
    SmsLoginRequest smsLoginRequest,
    _i2.SecretChallenge challenge, {
    _i1.Transaction? transaction,
  }) async {
    if (smsLoginRequest.id == null) {
      throw ArgumentError.notNull('smsLoginRequest.id');
    }
    if (challenge.id == null) {
      throw ArgumentError.notNull('challenge.id');
    }

    var $smsLoginRequest = smsLoginRequest.copyWith(challengeId: challenge.id);
    await session.db.updateRow<SmsLoginRequest>(
      $smsLoginRequest,
      columns: [SmsLoginRequest.t.challengeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [SmsLoginRequest] and [SecretChallenge]
  /// by setting the [SmsLoginRequest]'s foreign key `loginChallengeId` to refer to the [SecretChallenge].
  Future<void> loginChallenge(
    _i1.Session session,
    SmsLoginRequest smsLoginRequest,
    _i2.SecretChallenge loginChallenge, {
    _i1.Transaction? transaction,
  }) async {
    if (smsLoginRequest.id == null) {
      throw ArgumentError.notNull('smsLoginRequest.id');
    }
    if (loginChallenge.id == null) {
      throw ArgumentError.notNull('loginChallenge.id');
    }

    var $smsLoginRequest = smsLoginRequest.copyWith(
      loginChallengeId: loginChallenge.id,
    );
    await session.db.updateRow<SmsLoginRequest>(
      $smsLoginRequest,
      columns: [SmsLoginRequest.t.loginChallengeId],
      transaction: transaction,
    );
  }
}

class SmsLoginRequestDetachRowRepository {
  const SmsLoginRequestDetachRowRepository._();

  /// Detaches the relation between this [SmsLoginRequest] and the [SecretChallenge] set in `loginChallenge`
  /// by setting the [SmsLoginRequest]'s foreign key `loginChallengeId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> loginChallenge(
    _i1.Session session,
    SmsLoginRequest smsLoginRequest, {
    _i1.Transaction? transaction,
  }) async {
    if (smsLoginRequest.id == null) {
      throw ArgumentError.notNull('smsLoginRequest.id');
    }

    var $smsLoginRequest = smsLoginRequest.copyWith(loginChallengeId: null);
    await session.db.updateRow<SmsLoginRequest>(
      $smsLoginRequest,
      columns: [SmsLoginRequest.t.loginChallengeId],
      transaction: transaction,
    );
  }
}

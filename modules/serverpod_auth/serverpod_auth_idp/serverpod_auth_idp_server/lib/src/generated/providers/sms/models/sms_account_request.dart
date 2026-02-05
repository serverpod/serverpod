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

/// Pending SMS account registration request.
abstract class SmsAccountRequest
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  SmsAccountRequest._({
    this.id,
    DateTime? createdAt,
    required this.phoneHash,
    required this.challengeId,
    this.challenge,
    this.createAccountChallengeId,
    this.createAccountChallenge,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SmsAccountRequest({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required String phoneHash,
    required _i1.UuidValue challengeId,
    _i2.SecretChallenge? challenge,
    _i1.UuidValue? createAccountChallengeId,
    _i2.SecretChallenge? createAccountChallenge,
  }) = _SmsAccountRequestImpl;

  factory SmsAccountRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return SmsAccountRequest(
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
      createAccountChallengeId:
          jsonSerialization['createAccountChallengeId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['createAccountChallengeId'],
            ),
      createAccountChallenge:
          jsonSerialization['createAccountChallenge'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.SecretChallenge>(
              jsonSerialization['createAccountChallenge'],
            ),
    );
  }

  static final t = SmsAccountRequestTable();

  static const db = SmsAccountRequestRepository._();

  @override
  _i1.UuidValue? id;

  /// The time when this request was created.
  DateTime createdAt;

  /// The hash of the phone number.
  ///
  /// Used for lookup without storing the actual phone number.
  String phoneHash;

  _i1.UuidValue challengeId;

  /// The associated challenge for this request
  _i2.SecretChallenge? challenge;

  _i1.UuidValue? createAccountChallengeId;

  /// Used to complete the account creation.
  /// This will be set after the verification challenge has been validated.
  _i2.SecretChallenge? createAccountChallenge;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SmsAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SmsAccountRequest copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    String? phoneHash,
    _i1.UuidValue? challengeId,
    _i2.SecretChallenge? challenge,
    _i1.UuidValue? createAccountChallengeId,
    _i2.SecretChallenge? createAccountChallenge,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.SmsAccountRequest',
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'phoneHash': phoneHash,
      'challengeId': challengeId.toJson(),
      if (challenge != null) 'challenge': challenge?.toJson(),
      if (createAccountChallengeId != null)
        'createAccountChallengeId': createAccountChallengeId?.toJson(),
      if (createAccountChallenge != null)
        'createAccountChallenge': createAccountChallenge?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SmsAccountRequestInclude include({
    _i2.SecretChallengeInclude? challenge,
    _i2.SecretChallengeInclude? createAccountChallenge,
  }) {
    return SmsAccountRequestInclude._(
      challenge: challenge,
      createAccountChallenge: createAccountChallenge,
    );
  }

  static SmsAccountRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<SmsAccountRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsAccountRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsAccountRequestTable>? orderByList,
    SmsAccountRequestInclude? include,
  }) {
    return SmsAccountRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmsAccountRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SmsAccountRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SmsAccountRequestImpl extends SmsAccountRequest {
  _SmsAccountRequestImpl({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required String phoneHash,
    required _i1.UuidValue challengeId,
    _i2.SecretChallenge? challenge,
    _i1.UuidValue? createAccountChallengeId,
    _i2.SecretChallenge? createAccountChallenge,
  }) : super._(
         id: id,
         createdAt: createdAt,
         phoneHash: phoneHash,
         challengeId: challengeId,
         challenge: challenge,
         createAccountChallengeId: createAccountChallengeId,
         createAccountChallenge: createAccountChallenge,
       );

  /// Returns a shallow copy of this [SmsAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SmsAccountRequest copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    String? phoneHash,
    _i1.UuidValue? challengeId,
    Object? challenge = _Undefined,
    Object? createAccountChallengeId = _Undefined,
    Object? createAccountChallenge = _Undefined,
  }) {
    return SmsAccountRequest(
      id: id is _i1.UuidValue? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      phoneHash: phoneHash ?? this.phoneHash,
      challengeId: challengeId ?? this.challengeId,
      challenge: challenge is _i2.SecretChallenge?
          ? challenge
          : this.challenge?.copyWith(),
      createAccountChallengeId: createAccountChallengeId is _i1.UuidValue?
          ? createAccountChallengeId
          : this.createAccountChallengeId,
      createAccountChallenge: createAccountChallenge is _i2.SecretChallenge?
          ? createAccountChallenge
          : this.createAccountChallenge?.copyWith(),
    );
  }
}

class SmsAccountRequestUpdateTable
    extends _i1.UpdateTable<SmsAccountRequestTable> {
  SmsAccountRequestUpdateTable(super.table);

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

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> createAccountChallengeId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.createAccountChallengeId,
    value,
  );
}

class SmsAccountRequestTable extends _i1.Table<_i1.UuidValue?> {
  SmsAccountRequestTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_sms_account_request') {
    updateTable = SmsAccountRequestUpdateTable(this);
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
    createAccountChallengeId = _i1.ColumnUuid(
      'createAccountChallengeId',
      this,
    );
  }

  late final SmsAccountRequestUpdateTable updateTable;

  /// The time when this request was created.
  late final _i1.ColumnDateTime createdAt;

  /// The hash of the phone number.
  ///
  /// Used for lookup without storing the actual phone number.
  late final _i1.ColumnString phoneHash;

  late final _i1.ColumnUuid challengeId;

  /// The associated challenge for this request
  _i2.SecretChallengeTable? _challenge;

  late final _i1.ColumnUuid createAccountChallengeId;

  /// Used to complete the account creation.
  /// This will be set after the verification challenge has been validated.
  _i2.SecretChallengeTable? _createAccountChallenge;

  _i2.SecretChallengeTable get challenge {
    if (_challenge != null) return _challenge!;
    _challenge = _i1.createRelationTable(
      relationFieldName: 'challenge',
      field: SmsAccountRequest.t.challengeId,
      foreignField: _i2.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _challenge!;
  }

  _i2.SecretChallengeTable get createAccountChallenge {
    if (_createAccountChallenge != null) return _createAccountChallenge!;
    _createAccountChallenge = _i1.createRelationTable(
      relationFieldName: 'createAccountChallenge',
      field: SmsAccountRequest.t.createAccountChallengeId,
      foreignField: _i2.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _createAccountChallenge!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    createdAt,
    phoneHash,
    challengeId,
    createAccountChallengeId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'challenge') {
      return challenge;
    }
    if (relationField == 'createAccountChallenge') {
      return createAccountChallenge;
    }
    return null;
  }
}

class SmsAccountRequestInclude extends _i1.IncludeObject {
  SmsAccountRequestInclude._({
    _i2.SecretChallengeInclude? challenge,
    _i2.SecretChallengeInclude? createAccountChallenge,
  }) {
    _challenge = challenge;
    _createAccountChallenge = createAccountChallenge;
  }

  _i2.SecretChallengeInclude? _challenge;

  _i2.SecretChallengeInclude? _createAccountChallenge;

  @override
  Map<String, _i1.Include?> get includes => {
    'challenge': _challenge,
    'createAccountChallenge': _createAccountChallenge,
  };

  @override
  _i1.Table<_i1.UuidValue?> get table => SmsAccountRequest.t;
}

class SmsAccountRequestIncludeList extends _i1.IncludeList {
  SmsAccountRequestIncludeList._({
    _i1.WhereExpressionBuilder<SmsAccountRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SmsAccountRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => SmsAccountRequest.t;
}

class SmsAccountRequestRepository {
  const SmsAccountRequestRepository._();

  final attachRow = const SmsAccountRequestAttachRowRepository._();

  final detachRow = const SmsAccountRequestDetachRowRepository._();

  /// Returns a list of [SmsAccountRequest]s matching the given query parameters.
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
  Future<List<SmsAccountRequest>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsAccountRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsAccountRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsAccountRequestTable>? orderByList,
    _i1.Transaction? transaction,
    SmsAccountRequestInclude? include,
  }) async {
    return session.db.find<SmsAccountRequest>(
      where: where?.call(SmsAccountRequest.t),
      orderBy: orderBy?.call(SmsAccountRequest.t),
      orderByList: orderByList?.call(SmsAccountRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [SmsAccountRequest] matching the given query parameters.
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
  Future<SmsAccountRequest?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsAccountRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<SmsAccountRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsAccountRequestTable>? orderByList,
    _i1.Transaction? transaction,
    SmsAccountRequestInclude? include,
  }) async {
    return session.db.findFirstRow<SmsAccountRequest>(
      where: where?.call(SmsAccountRequest.t),
      orderBy: orderBy?.call(SmsAccountRequest.t),
      orderByList: orderByList?.call(SmsAccountRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [SmsAccountRequest] by its [id] or null if no such row exists.
  Future<SmsAccountRequest?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    SmsAccountRequestInclude? include,
  }) async {
    return session.db.findById<SmsAccountRequest>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [SmsAccountRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [SmsAccountRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SmsAccountRequest>> insert(
    _i1.Session session,
    List<SmsAccountRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SmsAccountRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SmsAccountRequest] and returns the inserted row.
  ///
  /// The returned [SmsAccountRequest] will have its `id` field set.
  Future<SmsAccountRequest> insertRow(
    _i1.Session session,
    SmsAccountRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SmsAccountRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SmsAccountRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SmsAccountRequest>> update(
    _i1.Session session,
    List<SmsAccountRequest> rows, {
    _i1.ColumnSelections<SmsAccountRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SmsAccountRequest>(
      rows,
      columns: columns?.call(SmsAccountRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SmsAccountRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SmsAccountRequest> updateRow(
    _i1.Session session,
    SmsAccountRequest row, {
    _i1.ColumnSelections<SmsAccountRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SmsAccountRequest>(
      row,
      columns: columns?.call(SmsAccountRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SmsAccountRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SmsAccountRequest?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<SmsAccountRequestUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SmsAccountRequest>(
      id,
      columnValues: columnValues(SmsAccountRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SmsAccountRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SmsAccountRequest>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SmsAccountRequestUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SmsAccountRequestTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsAccountRequestTable>? orderBy,
    _i1.OrderByListBuilder<SmsAccountRequestTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SmsAccountRequest>(
      columnValues: columnValues(SmsAccountRequest.t.updateTable),
      where: where(SmsAccountRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmsAccountRequest.t),
      orderByList: orderByList?.call(SmsAccountRequest.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SmsAccountRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SmsAccountRequest>> delete(
    _i1.Session session,
    List<SmsAccountRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SmsAccountRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SmsAccountRequest].
  Future<SmsAccountRequest> deleteRow(
    _i1.Session session,
    SmsAccountRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SmsAccountRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SmsAccountRequest>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SmsAccountRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SmsAccountRequest>(
      where: where(SmsAccountRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsAccountRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SmsAccountRequest>(
      where: where?.call(SmsAccountRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class SmsAccountRequestAttachRowRepository {
  const SmsAccountRequestAttachRowRepository._();

  /// Creates a relation between the given [SmsAccountRequest] and [SecretChallenge]
  /// by setting the [SmsAccountRequest]'s foreign key `challengeId` to refer to the [SecretChallenge].
  Future<void> challenge(
    _i1.Session session,
    SmsAccountRequest smsAccountRequest,
    _i2.SecretChallenge challenge, {
    _i1.Transaction? transaction,
  }) async {
    if (smsAccountRequest.id == null) {
      throw ArgumentError.notNull('smsAccountRequest.id');
    }
    if (challenge.id == null) {
      throw ArgumentError.notNull('challenge.id');
    }

    var $smsAccountRequest = smsAccountRequest.copyWith(
      challengeId: challenge.id,
    );
    await session.db.updateRow<SmsAccountRequest>(
      $smsAccountRequest,
      columns: [SmsAccountRequest.t.challengeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [SmsAccountRequest] and [SecretChallenge]
  /// by setting the [SmsAccountRequest]'s foreign key `createAccountChallengeId` to refer to the [SecretChallenge].
  Future<void> createAccountChallenge(
    _i1.Session session,
    SmsAccountRequest smsAccountRequest,
    _i2.SecretChallenge createAccountChallenge, {
    _i1.Transaction? transaction,
  }) async {
    if (smsAccountRequest.id == null) {
      throw ArgumentError.notNull('smsAccountRequest.id');
    }
    if (createAccountChallenge.id == null) {
      throw ArgumentError.notNull('createAccountChallenge.id');
    }

    var $smsAccountRequest = smsAccountRequest.copyWith(
      createAccountChallengeId: createAccountChallenge.id,
    );
    await session.db.updateRow<SmsAccountRequest>(
      $smsAccountRequest,
      columns: [SmsAccountRequest.t.createAccountChallengeId],
      transaction: transaction,
    );
  }
}

class SmsAccountRequestDetachRowRepository {
  const SmsAccountRequestDetachRowRepository._();

  /// Detaches the relation between this [SmsAccountRequest] and the [SecretChallenge] set in `createAccountChallenge`
  /// by setting the [SmsAccountRequest]'s foreign key `createAccountChallengeId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> createAccountChallenge(
    _i1.Session session,
    SmsAccountRequest smsAccountRequest, {
    _i1.Transaction? transaction,
  }) async {
    if (smsAccountRequest.id == null) {
      throw ArgumentError.notNull('smsAccountRequest.id');
    }

    var $smsAccountRequest = smsAccountRequest.copyWith(
      createAccountChallengeId: null,
    );
    await session.db.updateRow<SmsAccountRequest>(
      $smsAccountRequest,
      columns: [SmsAccountRequest.t.createAccountChallengeId],
      transaction: transaction,
    );
  }
}

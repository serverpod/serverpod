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
import '../../../../common/models/secret_challenge.dart' as _i2;

/// Pending email account registration.
///
/// There is no user ID stored with the request.
/// If an existing user should be assigned to this specific request,
/// store that with the request's `id` and link them up during registration.
abstract class EmailAccountRequest
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  EmailAccountRequest._({
    this.id,
    DateTime? createdAt,
    required this.email,
    required this.challengeId,
    this.challenge,
    this.createAccountChallengeId,
    this.createAccountChallenge,
  }) : createdAt = createdAt ?? DateTime.now();

  factory EmailAccountRequest({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required String email,
    required _i1.UuidValue challengeId,
    _i2.SecretChallenge? challenge,
    _i1.UuidValue? createAccountChallengeId,
    _i2.SecretChallenge? createAccountChallenge,
  }) = _EmailAccountRequestImpl;

  factory EmailAccountRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailAccountRequest(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      email: jsonSerialization['email'] as String,
      challengeId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['challengeId'],
      ),
      challenge: jsonSerialization['challenge'] == null
          ? null
          : _i2.SecretChallenge.fromJson(
              (jsonSerialization['challenge'] as Map<String, dynamic>),
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
          : _i2.SecretChallenge.fromJson(
              (jsonSerialization['createAccountChallenge']
                  as Map<String, dynamic>),
            ),
    );
  }

  static final t = EmailAccountRequestTable();

  static const db = EmailAccountRequestRepository._();

  @override
  _i1.UuidValue? id;

  /// The time when this authentication was created.
  DateTime createdAt;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  String email;

  _i1.UuidValue challengeId;

  /// The associated challenge for this request
  _i2.SecretChallenge? challenge;

  _i1.UuidValue? createAccountChallengeId;

  /// Used to complete the account creation.
  /// This will be set after the account creation challenge has been validated.
  _i2.SecretChallenge? createAccountChallenge;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountRequest copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    String? email,
    _i1.UuidValue? challengeId,
    _i2.SecretChallenge? challenge,
    _i1.UuidValue? createAccountChallengeId,
    _i2.SecretChallenge? createAccountChallenge,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'email': email,
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

  static EmailAccountRequestInclude include({
    _i2.SecretChallengeInclude? challenge,
    _i2.SecretChallengeInclude? createAccountChallenge,
  }) {
    return EmailAccountRequestInclude._(
      challenge: challenge,
      createAccountChallenge: createAccountChallenge,
    );
  }

  static EmailAccountRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailAccountRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountRequestTable>? orderByList,
    EmailAccountRequestInclude? include,
  }) {
    return EmailAccountRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailAccountRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountRequestImpl extends EmailAccountRequest {
  _EmailAccountRequestImpl({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required String email,
    required _i1.UuidValue challengeId,
    _i2.SecretChallenge? challenge,
    _i1.UuidValue? createAccountChallengeId,
    _i2.SecretChallenge? createAccountChallenge,
  }) : super._(
         id: id,
         createdAt: createdAt,
         email: email,
         challengeId: challengeId,
         challenge: challenge,
         createAccountChallengeId: createAccountChallengeId,
         createAccountChallenge: createAccountChallenge,
       );

  /// Returns a shallow copy of this [EmailAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountRequest copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    String? email,
    _i1.UuidValue? challengeId,
    Object? challenge = _Undefined,
    Object? createAccountChallengeId = _Undefined,
    Object? createAccountChallenge = _Undefined,
  }) {
    return EmailAccountRequest(
      id: id is _i1.UuidValue? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
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

class EmailAccountRequestUpdateTable
    extends _i1.UpdateTable<EmailAccountRequestTable> {
  EmailAccountRequestUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
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

class EmailAccountRequestTable extends _i1.Table<_i1.UuidValue?> {
  EmailAccountRequestTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_email_account_request') {
    updateTable = EmailAccountRequestUpdateTable(this);
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    email = _i1.ColumnString(
      'email',
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

  late final EmailAccountRequestUpdateTable updateTable;

  /// The time when this authentication was created.
  late final _i1.ColumnDateTime createdAt;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  late final _i1.ColumnString email;

  late final _i1.ColumnUuid challengeId;

  /// The associated challenge for this request
  _i2.SecretChallengeTable? _challenge;

  late final _i1.ColumnUuid createAccountChallengeId;

  /// Used to complete the account creation.
  /// This will be set after the account creation challenge has been validated.
  _i2.SecretChallengeTable? _createAccountChallenge;

  _i2.SecretChallengeTable get challenge {
    if (_challenge != null) return _challenge!;
    _challenge = _i1.createRelationTable(
      relationFieldName: 'challenge',
      field: EmailAccountRequest.t.challengeId,
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
      field: EmailAccountRequest.t.createAccountChallengeId,
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
    email,
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

class EmailAccountRequestInclude extends _i1.IncludeObject {
  EmailAccountRequestInclude._({
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
  _i1.Table<_i1.UuidValue?> get table => EmailAccountRequest.t;
}

class EmailAccountRequestIncludeList extends _i1.IncludeList {
  EmailAccountRequestIncludeList._({
    _i1.WhereExpressionBuilder<EmailAccountRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAccountRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailAccountRequest.t;
}

class EmailAccountRequestRepository {
  const EmailAccountRequestRepository._();

  final attachRow = const EmailAccountRequestAttachRowRepository._();

  final detachRow = const EmailAccountRequestDetachRowRepository._();

  /// Returns a list of [EmailAccountRequest]s matching the given query parameters.
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
  Future<List<EmailAccountRequest>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountRequestTable>? orderByList,
    _i1.Transaction? transaction,
    EmailAccountRequestInclude? include,
  }) async {
    return session.db.find<EmailAccountRequest>(
      where: where?.call(EmailAccountRequest.t),
      orderBy: orderBy?.call(EmailAccountRequest.t),
      orderByList: orderByList?.call(EmailAccountRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [EmailAccountRequest] matching the given query parameters.
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
  Future<EmailAccountRequest?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailAccountRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountRequestTable>? orderByList,
    _i1.Transaction? transaction,
    EmailAccountRequestInclude? include,
  }) async {
    return session.db.findFirstRow<EmailAccountRequest>(
      where: where?.call(EmailAccountRequest.t),
      orderBy: orderBy?.call(EmailAccountRequest.t),
      orderByList: orderByList?.call(EmailAccountRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [EmailAccountRequest] by its [id] or null if no such row exists.
  Future<EmailAccountRequest?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    EmailAccountRequestInclude? include,
  }) async {
    return session.db.findById<EmailAccountRequest>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [EmailAccountRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccountRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailAccountRequest>> insert(
    _i1.Session session,
    List<EmailAccountRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailAccountRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailAccountRequest] and returns the inserted row.
  ///
  /// The returned [EmailAccountRequest] will have its `id` field set.
  Future<EmailAccountRequest> insertRow(
    _i1.Session session,
    EmailAccountRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccountRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailAccountRequest>> update(
    _i1.Session session,
    List<EmailAccountRequest> rows, {
    _i1.ColumnSelections<EmailAccountRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailAccountRequest>(
      rows,
      columns: columns?.call(EmailAccountRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccountRequest> updateRow(
    _i1.Session session,
    EmailAccountRequest row, {
    _i1.ColumnSelections<EmailAccountRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAccountRequest>(
      row,
      columns: columns?.call(EmailAccountRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailAccountRequest?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<EmailAccountRequestUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailAccountRequest>(
      id,
      columnValues: columnValues(EmailAccountRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<EmailAccountRequest>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<EmailAccountRequestUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<EmailAccountRequestTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountRequestTable>? orderBy,
    _i1.OrderByListBuilder<EmailAccountRequestTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<EmailAccountRequest>(
      columnValues: columnValues(EmailAccountRequest.t.updateTable),
      where: where(EmailAccountRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountRequest.t),
      orderByList: orderByList?.call(EmailAccountRequest.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [EmailAccountRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailAccountRequest>> delete(
    _i1.Session session,
    List<EmailAccountRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailAccountRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailAccountRequest].
  Future<EmailAccountRequest> deleteRow(
    _i1.Session session,
    EmailAccountRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccountRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailAccountRequest>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailAccountRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailAccountRequest>(
      where: where(EmailAccountRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccountRequest>(
      where: where?.call(EmailAccountRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class EmailAccountRequestAttachRowRepository {
  const EmailAccountRequestAttachRowRepository._();

  /// Creates a relation between the given [EmailAccountRequest] and [SecretChallenge]
  /// by setting the [EmailAccountRequest]'s foreign key `challengeId` to refer to the [SecretChallenge].
  Future<void> challenge(
    _i1.Session session,
    EmailAccountRequest emailAccountRequest,
    _i2.SecretChallenge challenge, {
    _i1.Transaction? transaction,
  }) async {
    if (emailAccountRequest.id == null) {
      throw ArgumentError.notNull('emailAccountRequest.id');
    }
    if (challenge.id == null) {
      throw ArgumentError.notNull('challenge.id');
    }

    var $emailAccountRequest = emailAccountRequest.copyWith(
      challengeId: challenge.id,
    );
    await session.db.updateRow<EmailAccountRequest>(
      $emailAccountRequest,
      columns: [EmailAccountRequest.t.challengeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [EmailAccountRequest] and [SecretChallenge]
  /// by setting the [EmailAccountRequest]'s foreign key `createAccountChallengeId` to refer to the [SecretChallenge].
  Future<void> createAccountChallenge(
    _i1.Session session,
    EmailAccountRequest emailAccountRequest,
    _i2.SecretChallenge createAccountChallenge, {
    _i1.Transaction? transaction,
  }) async {
    if (emailAccountRequest.id == null) {
      throw ArgumentError.notNull('emailAccountRequest.id');
    }
    if (createAccountChallenge.id == null) {
      throw ArgumentError.notNull('createAccountChallenge.id');
    }

    var $emailAccountRequest = emailAccountRequest.copyWith(
      createAccountChallengeId: createAccountChallenge.id,
    );
    await session.db.updateRow<EmailAccountRequest>(
      $emailAccountRequest,
      columns: [EmailAccountRequest.t.createAccountChallengeId],
      transaction: transaction,
    );
  }
}

class EmailAccountRequestDetachRowRepository {
  const EmailAccountRequestDetachRowRepository._();

  /// Detaches the relation between this [EmailAccountRequest] and the [SecretChallenge] set in `createAccountChallenge`
  /// by setting the [EmailAccountRequest]'s foreign key `createAccountChallengeId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> createAccountChallenge(
    _i1.Session session,
    EmailAccountRequest emailAccountRequest, {
    _i1.Transaction? transaction,
  }) async {
    if (emailAccountRequest.id == null) {
      throw ArgumentError.notNull('emailAccountRequest.id');
    }

    var $emailAccountRequest = emailAccountRequest.copyWith(
      createAccountChallengeId: null,
    );
    await session.db.updateRow<EmailAccountRequest>(
      $emailAccountRequest,
      columns: [EmailAccountRequest.t.createAccountChallengeId],
      transaction: transaction,
    );
  }
}

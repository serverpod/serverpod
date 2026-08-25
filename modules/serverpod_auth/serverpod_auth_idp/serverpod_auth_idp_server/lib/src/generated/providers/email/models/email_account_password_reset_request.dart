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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart'
    as _i99s0abf;
import '../../../common/secret_challenge/models/secret_challenge.dart'
    as _i7k1fa50;
import '../../../providers/email/models/email_account.dart' as _imety4f2;

/// Pending email account password reset.
abstract class EmailAccountPasswordResetRequest
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  EmailAccountPasswordResetRequest._({
    this.id,
    required this.emailAccountId,
    this.emailAccount,
    DateTime? createdAt,
    required this.challengeId,
    this.challenge,
    this.setPasswordChallengeId,
    this.setPasswordChallenge,
  }) : createdAt = createdAt ?? DateTime.now();

  factory EmailAccountPasswordResetRequest({
    _is.UuidValue? id,
    required _is.UuidValue emailAccountId,
    _imety4f2.EmailAccount? emailAccount,
    DateTime? createdAt,
    required _is.UuidValue challengeId,
    _i7k1fa50.SecretChallenge? challenge,
    _is.UuidValue? setPasswordChallengeId,
    _i7k1fa50.SecretChallenge? setPasswordChallenge,
  }) = _EmailAccountPasswordResetRequestImpl;

  factory EmailAccountPasswordResetRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailAccountPasswordResetRequest(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      emailAccountId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['emailAccountId'],
      ),
      emailAccount: jsonSerialization['emailAccount'] == null
          ? null
          : _i99s0abf.Protocol().deserialize<_imety4f2.EmailAccount>(
              jsonSerialization['emailAccount'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      challengeId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['challengeId'],
      ),
      challenge: jsonSerialization['challenge'] == null
          ? null
          : _i99s0abf.Protocol().deserialize<_i7k1fa50.SecretChallenge>(
              jsonSerialization['challenge'],
            ),
      setPasswordChallengeId:
          jsonSerialization['setPasswordChallengeId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['setPasswordChallengeId'],
            ),
      setPasswordChallenge: jsonSerialization['setPasswordChallenge'] == null
          ? null
          : _i99s0abf.Protocol().deserialize<_i7k1fa50.SecretChallenge>(
              jsonSerialization['setPasswordChallenge'],
            ),
    );
  }

  static final t = EmailAccountPasswordResetRequestTable();

  static const db = EmailAccountPasswordResetRequestRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue emailAccountId;

  /// Email account this reset requests belongs to
  _imety4f2.EmailAccount? emailAccount;

  /// The time when this request was created.
  DateTime createdAt;

  _is.UuidValue challengeId;

  /// The associated challenge for this reset request
  _i7k1fa50.SecretChallenge? challenge;

  _is.UuidValue? setPasswordChallengeId;

  /// Used to complete the password reset when setting the password.
  /// This will be set after the password reset challenge has been validated.
  _i7k1fa50.SecretChallenge? setPasswordChallenge;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccountPasswordResetRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EmailAccountPasswordResetRequest copyWith({
    _is.UuidValue? id,
    _is.UuidValue? emailAccountId,
    _imety4f2.EmailAccount? emailAccount,
    DateTime? createdAt,
    _is.UuidValue? challengeId,
    _i7k1fa50.SecretChallenge? challenge,
    _is.UuidValue? setPasswordChallengeId,
    _i7k1fa50.SecretChallenge? setPasswordChallenge,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.EmailAccountPasswordResetRequest',
      if (id != null) 'id': id?.toJson(),
      'emailAccountId': emailAccountId.toJson(),
      if (emailAccount != null) 'emailAccount': emailAccount?.toJson(),
      'createdAt': createdAt.toJson(),
      'challengeId': challengeId.toJson(),
      if (challenge != null) 'challenge': challenge?.toJson(),
      if (setPasswordChallengeId != null)
        'setPasswordChallengeId': setPasswordChallengeId?.toJson(),
      if (setPasswordChallenge != null)
        'setPasswordChallenge': setPasswordChallenge?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static EmailAccountPasswordResetRequestInclude include({
    _imety4f2.EmailAccountInclude? emailAccount,
    _i7k1fa50.SecretChallengeInclude? challenge,
    _i7k1fa50.SecretChallengeInclude? setPasswordChallenge,
    _is.SelectColumnsBuilder<EmailAccountPasswordResetRequestTable>? select,
  }) {
    return EmailAccountPasswordResetRequestInclude._(
      emailAccount: emailAccount,
      challenge: challenge,
      setPasswordChallenge: setPasswordChallenge,
      selectedColumns: select?.call(EmailAccountPasswordResetRequest.t),
    );
  }

  static EmailAccountPasswordResetRequestIncludeList includeList({
    _is.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountPasswordResetRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountPasswordResetRequestTable>? orderByList,
    EmailAccountPasswordResetRequestInclude? include,
    _is.SelectColumnsBuilder<EmailAccountPasswordResetRequestTable>? select,
  }) {
    return EmailAccountPasswordResetRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountPasswordResetRequest.t),
      orderByList: orderByList?.call(EmailAccountPasswordResetRequest.t),
      include: include,
      selectedColumns: select?.call(EmailAccountPasswordResetRequest.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountPasswordResetRequestImpl
    extends EmailAccountPasswordResetRequest {
  _EmailAccountPasswordResetRequestImpl({
    _is.UuidValue? id,
    required _is.UuidValue emailAccountId,
    _imety4f2.EmailAccount? emailAccount,
    DateTime? createdAt,
    required _is.UuidValue challengeId,
    _i7k1fa50.SecretChallenge? challenge,
    _is.UuidValue? setPasswordChallengeId,
    _i7k1fa50.SecretChallenge? setPasswordChallenge,
  }) : super._(
         id: id,
         emailAccountId: emailAccountId,
         emailAccount: emailAccount,
         createdAt: createdAt,
         challengeId: challengeId,
         challenge: challenge,
         setPasswordChallengeId: setPasswordChallengeId,
         setPasswordChallenge: setPasswordChallenge,
       );

  /// Returns a shallow copy of this [EmailAccountPasswordResetRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EmailAccountPasswordResetRequest copyWith({
    Object? id = _Undefined,
    _is.UuidValue? emailAccountId,
    Object? emailAccount = _Undefined,
    DateTime? createdAt,
    _is.UuidValue? challengeId,
    Object? challenge = _Undefined,
    Object? setPasswordChallengeId = _Undefined,
    Object? setPasswordChallenge = _Undefined,
  }) {
    return EmailAccountPasswordResetRequest(
      id: id is _is.UuidValue? ? id : this.id,
      emailAccountId: emailAccountId ?? this.emailAccountId,
      emailAccount: emailAccount is _imety4f2.EmailAccount?
          ? emailAccount
          : this.emailAccount?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      challengeId: challengeId ?? this.challengeId,
      challenge: challenge is _i7k1fa50.SecretChallenge?
          ? challenge
          : this.challenge?.copyWith(),
      setPasswordChallengeId: setPasswordChallengeId is _is.UuidValue?
          ? setPasswordChallengeId
          : this.setPasswordChallengeId,
      setPasswordChallenge: setPasswordChallenge is _i7k1fa50.SecretChallenge?
          ? setPasswordChallenge
          : this.setPasswordChallenge?.copyWith(),
    );
  }
}

class EmailAccountPasswordResetRequestUpdateTable
    extends _is.UpdateTable<EmailAccountPasswordResetRequestTable> {
  EmailAccountPasswordResetRequestUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> emailAccountId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.emailAccountId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> challengeId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.challengeId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> setPasswordChallengeId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.setPasswordChallengeId,
    value,
  );
}

class EmailAccountPasswordResetRequestTable extends _is.Table<_is.UuidValue?> {
  EmailAccountPasswordResetRequestTable({super.tableRelation})
    : super(
        tableName: 'serverpod_auth_idp_email_account_password_reset_request',
      ) {
    updateTable = EmailAccountPasswordResetRequestUpdateTable(this);
    emailAccountId = _is.ColumnUuid(
      'emailAccountId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    challengeId = _is.ColumnUuid(
      'challengeId',
      this,
    );
    setPasswordChallengeId = _is.ColumnUuid(
      'setPasswordChallengeId',
      this,
    );
  }

  late final EmailAccountPasswordResetRequestUpdateTable updateTable;

  late final _is.ColumnUuid emailAccountId;

  /// Email account this reset requests belongs to
  _imety4f2.EmailAccountTable? _emailAccount;

  /// The time when this request was created.
  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnUuid challengeId;

  /// The associated challenge for this reset request
  _i7k1fa50.SecretChallengeTable? _challenge;

  late final _is.ColumnUuid setPasswordChallengeId;

  /// Used to complete the password reset when setting the password.
  /// This will be set after the password reset challenge has been validated.
  _i7k1fa50.SecretChallengeTable? _setPasswordChallenge;

  _imety4f2.EmailAccountTable get emailAccount {
    if (_emailAccount != null) return _emailAccount!;
    _emailAccount = _is.createRelationTable(
      relationFieldName: 'emailAccount',
      field: EmailAccountPasswordResetRequest.t.emailAccountId,
      foreignField: _imety4f2.EmailAccount.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _imety4f2.EmailAccountTable(tableRelation: foreignTableRelation),
    );
    return _emailAccount!;
  }

  _i7k1fa50.SecretChallengeTable get challenge {
    if (_challenge != null) return _challenge!;
    _challenge = _is.createRelationTable(
      relationFieldName: 'challenge',
      field: EmailAccountPasswordResetRequest.t.challengeId,
      foreignField: _i7k1fa50.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7k1fa50.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _challenge!;
  }

  _i7k1fa50.SecretChallengeTable get setPasswordChallenge {
    if (_setPasswordChallenge != null) return _setPasswordChallenge!;
    _setPasswordChallenge = _is.createRelationTable(
      relationFieldName: 'setPasswordChallenge',
      field: EmailAccountPasswordResetRequest.t.setPasswordChallengeId,
      foreignField: _i7k1fa50.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7k1fa50.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _setPasswordChallenge!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    emailAccountId,
    createdAt,
    challengeId,
    setPasswordChallengeId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'emailAccount') {
      return emailAccount;
    }
    if (relationField == 'challenge') {
      return challenge;
    }
    if (relationField == 'setPasswordChallenge') {
      return setPasswordChallenge;
    }
    return null;
  }
}

class EmailAccountPasswordResetRequestInclude extends _is.IncludeObject {
  EmailAccountPasswordResetRequestInclude._({
    _imety4f2.EmailAccountInclude? emailAccount,
    _i7k1fa50.SecretChallengeInclude? challenge,
    _i7k1fa50.SecretChallengeInclude? setPasswordChallenge,
    this.selectedColumns,
  }) {
    _emailAccount = emailAccount;
    _challenge = challenge;
    _setPasswordChallenge = setPasswordChallenge;
  }

  _imety4f2.EmailAccountInclude? _emailAccount;

  _i7k1fa50.SecretChallengeInclude? _challenge;

  _i7k1fa50.SecretChallengeInclude? _setPasswordChallenge;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'emailAccount': _emailAccount,
    'challenge': _challenge,
    'setPasswordChallenge': _setPasswordChallenge,
  };

  @override
  _is.Table<_is.UuidValue?> get table => EmailAccountPasswordResetRequest.t;
}

class EmailAccountPasswordResetRequestIncludeList extends _is.IncludeList {
  EmailAccountPasswordResetRequestIncludeList._({
    _is.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(EmailAccountPasswordResetRequest.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => EmailAccountPasswordResetRequest.t;
}

class EmailAccountPasswordResetRequestRepository {
  const EmailAccountPasswordResetRequestRepository._();

  final attachRow =
      const EmailAccountPasswordResetRequestAttachRowRepository._();

  final detachRow =
      const EmailAccountPasswordResetRequestDetachRowRepository._();

  /// Returns a list of [EmailAccountPasswordResetRequest]s matching the given query parameters.
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
  Future<List<EmailAccountPasswordResetRequest>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountPasswordResetRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountPasswordResetRequestTable>? orderByList,
    _is.Transaction? transaction,
    EmailAccountPasswordResetRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EmailAccountPasswordResetRequest>(
      where: where?.call(EmailAccountPasswordResetRequest.t),
      orderBy: orderBy?.call(EmailAccountPasswordResetRequest.t),
      orderByList: orderByList?.call(EmailAccountPasswordResetRequest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EmailAccountPasswordResetRequest] matching the given query parameters.
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
  Future<EmailAccountPasswordResetRequest?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailAccountPasswordResetRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountPasswordResetRequestTable>? orderByList,
    _is.Transaction? transaction,
    EmailAccountPasswordResetRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EmailAccountPasswordResetRequest>(
      where: where?.call(EmailAccountPasswordResetRequest.t),
      orderBy: orderBy?.call(EmailAccountPasswordResetRequest.t),
      orderByList: orderByList?.call(EmailAccountPasswordResetRequest.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EmailAccountPasswordResetRequest] by its [id] or null if no such row exists.
  Future<EmailAccountPasswordResetRequest?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    EmailAccountPasswordResetRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EmailAccountPasswordResetRequest>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountPasswordResetRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountPasswordResetRequestTable>? orderByList,
    _is.Transaction? transaction,
    EmailAccountPasswordResetRequestInclude? include,
    _is.SelectColumnsBuilder<EmailAccountPasswordResetRequestTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<EmailAccountPasswordResetRequest>(
      where: where?.call(EmailAccountPasswordResetRequest.t),
      orderBy: orderBy?.call(EmailAccountPasswordResetRequest.t),
      orderByList: orderByList?.call(EmailAccountPasswordResetRequest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(EmailAccountPasswordResetRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailAccountPasswordResetRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountPasswordResetRequestTable>? orderByList,
    _is.Transaction? transaction,
    EmailAccountPasswordResetRequestInclude? include,
    _is.SelectColumnsBuilder<EmailAccountPasswordResetRequestTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<EmailAccountPasswordResetRequest>(
      where: where?.call(EmailAccountPasswordResetRequest.t),
      orderBy: orderBy?.call(EmailAccountPasswordResetRequest.t),
      orderByList: orderByList?.call(EmailAccountPasswordResetRequest.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(EmailAccountPasswordResetRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    EmailAccountPasswordResetRequestInclude? include,
    _is.SelectColumnsBuilder<EmailAccountPasswordResetRequestTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<EmailAccountPasswordResetRequest>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(EmailAccountPasswordResetRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EmailAccountPasswordResetRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccountPasswordResetRequest]s will have their `id` fields set.
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
  Future<List<EmailAccountPasswordResetRequest>> insert(
    _is.DatabaseSession session,
    List<EmailAccountPasswordResetRequest> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EmailAccountPasswordResetRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EmailAccountPasswordResetRequest] and returns the inserted row.
  ///
  /// The returned [EmailAccountPasswordResetRequest] will have its `id` field set.
  Future<EmailAccountPasswordResetRequest> insertRow(
    _is.DatabaseSession session,
    EmailAccountPasswordResetRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccountPasswordResetRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EmailAccountPasswordResetRequest]s in the list and returns the resulting rows.
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
  /// The returned [EmailAccountPasswordResetRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountPasswordResetRequest>> upsert(
    _is.DatabaseSession session,
    List<EmailAccountPasswordResetRequest> rows, {
    required _is.ColumnSelections<EmailAccountPasswordResetRequestTable>
    conflictColumns,
    _is.ColumnSelections<EmailAccountPasswordResetRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>?
    updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EmailAccountPasswordResetRequest>(
      rows,
      conflictColumns: conflictColumns(EmailAccountPasswordResetRequest.t),
      updateColumns: updateColumns?.call(EmailAccountPasswordResetRequest.t),
      updateWhere: updateWhere?.call(EmailAccountPasswordResetRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EmailAccountPasswordResetRequest] and returns the resulting row.
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
  /// The returned [EmailAccountPasswordResetRequest] will have its `id` field set.
  Future<EmailAccountPasswordResetRequest?> upsertRow(
    _is.DatabaseSession session,
    EmailAccountPasswordResetRequest row, {
    required _is.ColumnSelections<EmailAccountPasswordResetRequestTable>
    conflictColumns,
    _is.ColumnSelections<EmailAccountPasswordResetRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>?
    updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EmailAccountPasswordResetRequest>(
      row,
      conflictColumns: conflictColumns(EmailAccountPasswordResetRequest.t),
      updateColumns: updateColumns?.call(EmailAccountPasswordResetRequest.t),
      updateWhere: updateWhere?.call(EmailAccountPasswordResetRequest.t),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountPasswordResetRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountPasswordResetRequest>> update(
    _is.DatabaseSession session,
    List<EmailAccountPasswordResetRequest> rows, {
    _is.ColumnSelections<EmailAccountPasswordResetRequestTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EmailAccountPasswordResetRequest>(
      rows,
      columns: columns?.call(EmailAccountPasswordResetRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EmailAccountPasswordResetRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccountPasswordResetRequest> updateRow(
    _is.DatabaseSession session,
    EmailAccountPasswordResetRequest row, {
    _is.ColumnSelections<EmailAccountPasswordResetRequestTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAccountPasswordResetRequest>(
      row,
      columns: columns?.call(EmailAccountPasswordResetRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountPasswordResetRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailAccountPasswordResetRequest?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<
      EmailAccountPasswordResetRequestUpdateTable
    >
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailAccountPasswordResetRequest>(
      id,
      columnValues: columnValues(
        EmailAccountPasswordResetRequest.t.updateTable,
      ),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountPasswordResetRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountPasswordResetRequest>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<
      EmailAccountPasswordResetRequestUpdateTable
    >
    columnValues,
    required _is.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountPasswordResetRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountPasswordResetRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EmailAccountPasswordResetRequest>(
      columnValues: columnValues(
        EmailAccountPasswordResetRequest.t.updateTable,
      ),
      where: where(EmailAccountPasswordResetRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountPasswordResetRequest.t),
      orderByList: orderByList?.call(EmailAccountPasswordResetRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EmailAccountPasswordResetRequest]s in the list and returns the deleted rows.
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
  Future<List<EmailAccountPasswordResetRequest>> delete(
    _is.DatabaseSession session,
    List<EmailAccountPasswordResetRequest> rows, {
    _is.OrderByBuilder<EmailAccountPasswordResetRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountPasswordResetRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EmailAccountPasswordResetRequest>(
      rows,
      orderBy: orderBy?.call(EmailAccountPasswordResetRequest.t),
      orderByList: orderByList?.call(EmailAccountPasswordResetRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EmailAccountPasswordResetRequest].
  Future<EmailAccountPasswordResetRequest> deleteRow(
    _is.DatabaseSession session,
    EmailAccountPasswordResetRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccountPasswordResetRequest>(
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
  Future<List<EmailAccountPasswordResetRequest>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>
    where,
    _is.OrderByBuilder<EmailAccountPasswordResetRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountPasswordResetRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EmailAccountPasswordResetRequest>(
      where: where(EmailAccountPasswordResetRequest.t),
      orderBy: orderBy?.call(EmailAccountPasswordResetRequest.t),
      orderByList: orderByList?.call(EmailAccountPasswordResetRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccountPasswordResetRequest>(
      where: where?.call(EmailAccountPasswordResetRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EmailAccountPasswordResetRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>
    where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EmailAccountPasswordResetRequest>(
      where: where(EmailAccountPasswordResetRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class EmailAccountPasswordResetRequestAttachRowRepository {
  const EmailAccountPasswordResetRequestAttachRowRepository._();

  /// Creates a relation between the given [EmailAccountPasswordResetRequest] and [EmailAccount]
  /// by setting the [EmailAccountPasswordResetRequest]'s foreign key `emailAccountId` to refer to the [EmailAccount].
  Future<void> emailAccount(
    _is.DatabaseSession session,
    EmailAccountPasswordResetRequest emailAccountPasswordResetRequest,
    _imety4f2.EmailAccount emailAccount, {
    _is.Transaction? transaction,
  }) async {
    if (emailAccountPasswordResetRequest.id == null) {
      throw ArgumentError.notNull('emailAccountPasswordResetRequest.id');
    }
    if (emailAccount.id == null) {
      throw ArgumentError.notNull('emailAccount.id');
    }

    var $emailAccountPasswordResetRequest = emailAccountPasswordResetRequest
        .copyWith(emailAccountId: emailAccount.id);
    await session.db.updateRow<EmailAccountPasswordResetRequest>(
      $emailAccountPasswordResetRequest,
      columns: [EmailAccountPasswordResetRequest.t.emailAccountId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [EmailAccountPasswordResetRequest] and [SecretChallenge]
  /// by setting the [EmailAccountPasswordResetRequest]'s foreign key `challengeId` to refer to the [SecretChallenge].
  Future<void> challenge(
    _is.DatabaseSession session,
    EmailAccountPasswordResetRequest emailAccountPasswordResetRequest,
    _i7k1fa50.SecretChallenge challenge, {
    _is.Transaction? transaction,
  }) async {
    if (emailAccountPasswordResetRequest.id == null) {
      throw ArgumentError.notNull('emailAccountPasswordResetRequest.id');
    }
    if (challenge.id == null) {
      throw ArgumentError.notNull('challenge.id');
    }

    var $emailAccountPasswordResetRequest = emailAccountPasswordResetRequest
        .copyWith(challengeId: challenge.id);
    await session.db.updateRow<EmailAccountPasswordResetRequest>(
      $emailAccountPasswordResetRequest,
      columns: [EmailAccountPasswordResetRequest.t.challengeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [EmailAccountPasswordResetRequest] and [SecretChallenge]
  /// by setting the [EmailAccountPasswordResetRequest]'s foreign key `setPasswordChallengeId` to refer to the [SecretChallenge].
  Future<void> setPasswordChallenge(
    _is.DatabaseSession session,
    EmailAccountPasswordResetRequest emailAccountPasswordResetRequest,
    _i7k1fa50.SecretChallenge setPasswordChallenge, {
    _is.Transaction? transaction,
  }) async {
    if (emailAccountPasswordResetRequest.id == null) {
      throw ArgumentError.notNull('emailAccountPasswordResetRequest.id');
    }
    if (setPasswordChallenge.id == null) {
      throw ArgumentError.notNull('setPasswordChallenge.id');
    }

    var $emailAccountPasswordResetRequest = emailAccountPasswordResetRequest
        .copyWith(setPasswordChallengeId: setPasswordChallenge.id);
    await session.db.updateRow<EmailAccountPasswordResetRequest>(
      $emailAccountPasswordResetRequest,
      columns: [EmailAccountPasswordResetRequest.t.setPasswordChallengeId],
      transaction: transaction,
    );
  }
}

class EmailAccountPasswordResetRequestDetachRowRepository {
  const EmailAccountPasswordResetRequestDetachRowRepository._();

  /// Detaches the relation between this [EmailAccountPasswordResetRequest] and the [SecretChallenge] set in `setPasswordChallenge`
  /// by setting the [EmailAccountPasswordResetRequest]'s foreign key `setPasswordChallengeId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> setPasswordChallenge(
    _is.DatabaseSession session,
    EmailAccountPasswordResetRequest emailAccountPasswordResetRequest, {
    _is.Transaction? transaction,
  }) async {
    if (emailAccountPasswordResetRequest.id == null) {
      throw ArgumentError.notNull('emailAccountPasswordResetRequest.id');
    }

    var $emailAccountPasswordResetRequest = emailAccountPasswordResetRequest
        .copyWith(setPasswordChallengeId: null);
    await session.db.updateRow<EmailAccountPasswordResetRequest>(
      $emailAccountPasswordResetRequest,
      columns: [EmailAccountPasswordResetRequest.t.setPasswordChallengeId],
      transaction: transaction,
    );
  }
}

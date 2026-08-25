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

/// Pending email account registration.
abstract class EmailAccountRequest
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
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
    _is.UuidValue? id,
    DateTime? createdAt,
    required String email,
    required _is.UuidValue challengeId,
    _i7k1fa50.SecretChallenge? challenge,
    _is.UuidValue? createAccountChallengeId,
    _i7k1fa50.SecretChallenge? createAccountChallenge,
  }) = _EmailAccountRequestImpl;

  factory EmailAccountRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailAccountRequest(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      email: jsonSerialization['email'] as String,
      challengeId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['challengeId'],
      ),
      challenge: jsonSerialization['challenge'] == null
          ? null
          : _i99s0abf.Protocol().deserialize<_i7k1fa50.SecretChallenge>(
              jsonSerialization['challenge'],
            ),
      createAccountChallengeId:
          jsonSerialization['createAccountChallengeId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['createAccountChallengeId'],
            ),
      createAccountChallenge:
          jsonSerialization['createAccountChallenge'] == null
          ? null
          : _i99s0abf.Protocol().deserialize<_i7k1fa50.SecretChallenge>(
              jsonSerialization['createAccountChallenge'],
            ),
    );
  }

  static final t = EmailAccountRequestTable();

  static const db = EmailAccountRequestRepository._();

  @override
  _is.UuidValue? id;

  /// The time when this authentication was created.
  DateTime createdAt;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  String email;

  _is.UuidValue challengeId;

  /// The associated challenge for this request
  _i7k1fa50.SecretChallenge? challenge;

  _is.UuidValue? createAccountChallengeId;

  /// Used to complete the account creation.
  /// This will be set after the account creation challenge has been validated.
  _i7k1fa50.SecretChallenge? createAccountChallenge;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EmailAccountRequest copyWith({
    _is.UuidValue? id,
    DateTime? createdAt,
    String? email,
    _is.UuidValue? challengeId,
    _i7k1fa50.SecretChallenge? challenge,
    _is.UuidValue? createAccountChallengeId,
    _i7k1fa50.SecretChallenge? createAccountChallenge,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.EmailAccountRequest',
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
    _i7k1fa50.SecretChallengeInclude? challenge,
    _i7k1fa50.SecretChallengeInclude? createAccountChallenge,
    _is.SelectColumnsBuilder<EmailAccountRequestTable>? select,
  }) {
    return EmailAccountRequestInclude._(
      challenge: challenge,
      createAccountChallenge: createAccountChallenge,
      selectedColumns: select?.call(EmailAccountRequest.t),
    );
  }

  static EmailAccountRequestIncludeList includeList({
    _is.WhereExpressionBuilder<EmailAccountRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountRequestTable>? orderByList,
    EmailAccountRequestInclude? include,
    _is.SelectColumnsBuilder<EmailAccountRequestTable>? select,
  }) {
    return EmailAccountRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountRequest.t),
      orderByList: orderByList?.call(EmailAccountRequest.t),
      include: include,
      selectedColumns: select?.call(EmailAccountRequest.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountRequestImpl extends EmailAccountRequest {
  _EmailAccountRequestImpl({
    _is.UuidValue? id,
    DateTime? createdAt,
    required String email,
    required _is.UuidValue challengeId,
    _i7k1fa50.SecretChallenge? challenge,
    _is.UuidValue? createAccountChallengeId,
    _i7k1fa50.SecretChallenge? createAccountChallenge,
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
  @_is.useResult
  @override
  EmailAccountRequest copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    String? email,
    _is.UuidValue? challengeId,
    Object? challenge = _Undefined,
    Object? createAccountChallengeId = _Undefined,
    Object? createAccountChallenge = _Undefined,
  }) {
    return EmailAccountRequest(
      id: id is _is.UuidValue? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      challengeId: challengeId ?? this.challengeId,
      challenge: challenge is _i7k1fa50.SecretChallenge?
          ? challenge
          : this.challenge?.copyWith(),
      createAccountChallengeId: createAccountChallengeId is _is.UuidValue?
          ? createAccountChallengeId
          : this.createAccountChallengeId,
      createAccountChallenge:
          createAccountChallenge is _i7k1fa50.SecretChallenge?
          ? createAccountChallenge
          : this.createAccountChallenge?.copyWith(),
    );
  }
}

class EmailAccountRequestUpdateTable
    extends _is.UpdateTable<EmailAccountRequestTable> {
  EmailAccountRequestUpdateTable(super.table);

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> challengeId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.challengeId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> createAccountChallengeId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.createAccountChallengeId,
    value,
  );
}

class EmailAccountRequestTable extends _is.Table<_is.UuidValue?> {
  EmailAccountRequestTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_email_account_request') {
    updateTable = EmailAccountRequestUpdateTable(this);
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    challengeId = _is.ColumnUuid(
      'challengeId',
      this,
    );
    createAccountChallengeId = _is.ColumnUuid(
      'createAccountChallengeId',
      this,
    );
  }

  late final EmailAccountRequestUpdateTable updateTable;

  /// The time when this authentication was created.
  late final _is.ColumnDateTime createdAt;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  late final _is.ColumnString email;

  late final _is.ColumnUuid challengeId;

  /// The associated challenge for this request
  _i7k1fa50.SecretChallengeTable? _challenge;

  late final _is.ColumnUuid createAccountChallengeId;

  /// Used to complete the account creation.
  /// This will be set after the account creation challenge has been validated.
  _i7k1fa50.SecretChallengeTable? _createAccountChallenge;

  _i7k1fa50.SecretChallengeTable get challenge {
    if (_challenge != null) return _challenge!;
    _challenge = _is.createRelationTable(
      relationFieldName: 'challenge',
      field: EmailAccountRequest.t.challengeId,
      foreignField: _i7k1fa50.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7k1fa50.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _challenge!;
  }

  _i7k1fa50.SecretChallengeTable get createAccountChallenge {
    if (_createAccountChallenge != null) return _createAccountChallenge!;
    _createAccountChallenge = _is.createRelationTable(
      relationFieldName: 'createAccountChallenge',
      field: EmailAccountRequest.t.createAccountChallengeId,
      foreignField: _i7k1fa50.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7k1fa50.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _createAccountChallenge!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    createdAt,
    email,
    challengeId,
    createAccountChallengeId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'challenge') {
      return challenge;
    }
    if (relationField == 'createAccountChallenge') {
      return createAccountChallenge;
    }
    return null;
  }
}

class EmailAccountRequestInclude extends _is.IncludeObject {
  EmailAccountRequestInclude._({
    _i7k1fa50.SecretChallengeInclude? challenge,
    _i7k1fa50.SecretChallengeInclude? createAccountChallenge,
    this.selectedColumns,
  }) {
    _challenge = challenge;
    _createAccountChallenge = createAccountChallenge;
  }

  _i7k1fa50.SecretChallengeInclude? _challenge;

  _i7k1fa50.SecretChallengeInclude? _createAccountChallenge;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'challenge': _challenge,
    'createAccountChallenge': _createAccountChallenge,
  };

  @override
  _is.Table<_is.UuidValue?> get table => EmailAccountRequest.t;
}

class EmailAccountRequestIncludeList extends _is.IncludeList {
  EmailAccountRequestIncludeList._({
    _is.WhereExpressionBuilder<EmailAccountRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(EmailAccountRequest.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => EmailAccountRequest.t;
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountRequestTable>? orderByList,
    _is.Transaction? transaction,
    EmailAccountRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EmailAccountRequest>(
      where: where?.call(EmailAccountRequest.t),
      orderBy: orderBy?.call(EmailAccountRequest.t),
      orderByList: orderByList?.call(EmailAccountRequest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountRequestTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountRequestTable>? orderByList,
    _is.Transaction? transaction,
    EmailAccountRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EmailAccountRequest>(
      where: where?.call(EmailAccountRequest.t),
      orderBy: orderBy?.call(EmailAccountRequest.t),
      orderByList: orderByList?.call(EmailAccountRequest.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EmailAccountRequest] by its [id] or null if no such row exists.
  Future<EmailAccountRequest?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    EmailAccountRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EmailAccountRequest>(
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
    _is.WhereExpressionBuilder<EmailAccountRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountRequestTable>? orderByList,
    _is.Transaction? transaction,
    EmailAccountRequestInclude? include,
    _is.SelectColumnsBuilder<EmailAccountRequestTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<EmailAccountRequest>(
      where: where?.call(EmailAccountRequest.t),
      orderBy: orderBy?.call(EmailAccountRequest.t),
      orderByList: orderByList?.call(EmailAccountRequest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(EmailAccountRequest.t),
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
    _is.WhereExpressionBuilder<EmailAccountRequestTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountRequestTable>? orderByList,
    _is.Transaction? transaction,
    EmailAccountRequestInclude? include,
    _is.SelectColumnsBuilder<EmailAccountRequestTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<EmailAccountRequest>(
      where: where?.call(EmailAccountRequest.t),
      orderBy: orderBy?.call(EmailAccountRequest.t),
      orderByList: orderByList?.call(EmailAccountRequest.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(EmailAccountRequest.t),
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
    EmailAccountRequestInclude? include,
    _is.SelectColumnsBuilder<EmailAccountRequestTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<EmailAccountRequest>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(EmailAccountRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EmailAccountRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccountRequest]s will have their `id` fields set.
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
  Future<List<EmailAccountRequest>> insert(
    _is.DatabaseSession session,
    List<EmailAccountRequest> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EmailAccountRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EmailAccountRequest] and returns the inserted row.
  ///
  /// The returned [EmailAccountRequest] will have its `id` field set.
  Future<EmailAccountRequest> insertRow(
    _is.DatabaseSession session,
    EmailAccountRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccountRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EmailAccountRequest]s in the list and returns the resulting rows.
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
  /// The returned [EmailAccountRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountRequest>> upsert(
    _is.DatabaseSession session,
    List<EmailAccountRequest> rows, {
    required _is.ColumnSelections<EmailAccountRequestTable> conflictColumns,
    _is.ColumnSelections<EmailAccountRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailAccountRequestTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EmailAccountRequest>(
      rows,
      conflictColumns: conflictColumns(EmailAccountRequest.t),
      updateColumns: updateColumns?.call(EmailAccountRequest.t),
      updateWhere: updateWhere?.call(EmailAccountRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EmailAccountRequest] and returns the resulting row.
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
  /// The returned [EmailAccountRequest] will have its `id` field set.
  Future<EmailAccountRequest?> upsertRow(
    _is.DatabaseSession session,
    EmailAccountRequest row, {
    required _is.ColumnSelections<EmailAccountRequestTable> conflictColumns,
    _is.ColumnSelections<EmailAccountRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailAccountRequestTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EmailAccountRequest>(
      row,
      conflictColumns: conflictColumns(EmailAccountRequest.t),
      updateColumns: updateColumns?.call(EmailAccountRequest.t),
      updateWhere: updateWhere?.call(EmailAccountRequest.t),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountRequest>> update(
    _is.DatabaseSession session,
    List<EmailAccountRequest> rows, {
    _is.ColumnSelections<EmailAccountRequestTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EmailAccountRequest>(
      rows,
      columns: columns?.call(EmailAccountRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EmailAccountRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccountRequest> updateRow(
    _is.DatabaseSession session,
    EmailAccountRequest row, {
    _is.ColumnSelections<EmailAccountRequestTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<EmailAccountRequestUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailAccountRequest>(
      id,
      columnValues: columnValues(EmailAccountRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountRequest>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EmailAccountRequestUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<EmailAccountRequestTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EmailAccountRequest>(
      columnValues: columnValues(EmailAccountRequest.t.updateTable),
      where: where(EmailAccountRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountRequest.t),
      orderByList: orderByList?.call(EmailAccountRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EmailAccountRequest]s in the list and returns the deleted rows.
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
  Future<List<EmailAccountRequest>> delete(
    _is.DatabaseSession session,
    List<EmailAccountRequest> rows, {
    _is.OrderByBuilder<EmailAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EmailAccountRequest>(
      rows,
      orderBy: orderBy?.call(EmailAccountRequest.t),
      orderByList: orderByList?.call(EmailAccountRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EmailAccountRequest].
  Future<EmailAccountRequest> deleteRow(
    _is.DatabaseSession session,
    EmailAccountRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccountRequest>(
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
  Future<List<EmailAccountRequest>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailAccountRequestTable> where,
    _is.OrderByBuilder<EmailAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EmailAccountRequest>(
      where: where(EmailAccountRequest.t),
      orderBy: orderBy?.call(EmailAccountRequest.t),
      orderByList: orderByList?.call(EmailAccountRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountRequestTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccountRequest>(
      where: where?.call(EmailAccountRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EmailAccountRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailAccountRequestTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EmailAccountRequest>(
      where: where(EmailAccountRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class EmailAccountRequestAttachRowRepository {
  const EmailAccountRequestAttachRowRepository._();

  /// Creates a relation between the given [EmailAccountRequest] and [SecretChallenge]
  /// by setting the [EmailAccountRequest]'s foreign key `challengeId` to refer to the [SecretChallenge].
  Future<void> challenge(
    _is.DatabaseSession session,
    EmailAccountRequest emailAccountRequest,
    _i7k1fa50.SecretChallenge challenge, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    EmailAccountRequest emailAccountRequest,
    _i7k1fa50.SecretChallenge createAccountChallenge, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    EmailAccountRequest emailAccountRequest, {
    _is.Transaction? transaction,
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

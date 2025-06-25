/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;

/// Pending email account registration.
///
/// There is no user ID stored with the request.
/// If an existing user should be assigned to this specific request,
/// store that with the request's `id` and link them up during registration.
abstract class EmailAccountRequest
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  EmailAccountRequest._({
    this.id,
    DateTime? created,
    required this.email,
    required this.passwordHash,
    required this.passwordSalt,
    required this.verificationCodeHash,
    required this.verificationCodeSalt,
    this.verifiedAt,
  }) : created = created ?? DateTime.now();

  factory EmailAccountRequest({
    _i1.UuidValue? id,
    DateTime? created,
    required String email,
    required _i2.ByteData passwordHash,
    required _i2.ByteData passwordSalt,
    required _i2.ByteData verificationCodeHash,
    required _i2.ByteData verificationCodeSalt,
    DateTime? verifiedAt,
  }) = _EmailAccountRequestImpl;

  factory EmailAccountRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailAccountRequest(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      email: jsonSerialization['email'] as String,
      passwordHash:
          _i1.ByteDataJsonExtension.fromJson(jsonSerialization['passwordHash']),
      passwordSalt:
          _i1.ByteDataJsonExtension.fromJson(jsonSerialization['passwordSalt']),
      verificationCodeHash: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['verificationCodeHash']),
      verificationCodeSalt: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['verificationCodeSalt']),
      verifiedAt: jsonSerialization['verifiedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['verifiedAt']),
    );
  }

  static final t = EmailAccountRequestTable();

  static const db = EmailAccountRequestRepository._();

  @override
  _i1.UuidValue? id;

  /// The time when this authentication was created.
  DateTime created;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  String email;

  /// The hashed password of the user.
  ///
  /// Obtained in conjunction with [passwordSalt].
  _i2.ByteData passwordHash;

  /// The salt used for creating the [passwordHash].
  _i2.ByteData passwordSalt;

  /// The hash of the verification code sent to the user.
  _i2.ByteData verificationCodeHash;

  /// The salt used to compute the [verificationCodeHash].
  _i2.ByteData verificationCodeSalt;

  /// Time at which the email address has been verified, or `null` if it did not happen yet.
  ///
  /// The requets can only be turned into an account if this is non-`null`.
  DateTime? verifiedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountRequest copyWith({
    _i1.UuidValue? id,
    DateTime? created,
    String? email,
    _i2.ByteData? passwordHash,
    _i2.ByteData? passwordSalt,
    _i2.ByteData? verificationCodeHash,
    _i2.ByteData? verificationCodeSalt,
    DateTime? verifiedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'created': created.toJson(),
      'email': email,
      'passwordHash': passwordHash.toJson(),
      'passwordSalt': passwordSalt.toJson(),
      'verificationCodeHash': verificationCodeHash.toJson(),
      'verificationCodeSalt': verificationCodeSalt.toJson(),
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id?.toJson()};
  }

  static EmailAccountRequestInclude include() {
    return EmailAccountRequestInclude._();
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
    DateTime? created,
    required String email,
    required _i2.ByteData passwordHash,
    required _i2.ByteData passwordSalt,
    required _i2.ByteData verificationCodeHash,
    required _i2.ByteData verificationCodeSalt,
    DateTime? verifiedAt,
  }) : super._(
          id: id,
          created: created,
          email: email,
          passwordHash: passwordHash,
          passwordSalt: passwordSalt,
          verificationCodeHash: verificationCodeHash,
          verificationCodeSalt: verificationCodeSalt,
          verifiedAt: verifiedAt,
        );

  /// Returns a shallow copy of this [EmailAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountRequest copyWith({
    Object? id = _Undefined,
    DateTime? created,
    String? email,
    _i2.ByteData? passwordHash,
    _i2.ByteData? passwordSalt,
    _i2.ByteData? verificationCodeHash,
    _i2.ByteData? verificationCodeSalt,
    Object? verifiedAt = _Undefined,
  }) {
    return EmailAccountRequest(
      id: id is _i1.UuidValue? ? id : this.id,
      created: created ?? this.created,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash.clone(),
      passwordSalt: passwordSalt ?? this.passwordSalt.clone(),
      verificationCodeHash:
          verificationCodeHash ?? this.verificationCodeHash.clone(),
      verificationCodeSalt:
          verificationCodeSalt ?? this.verificationCodeSalt.clone(),
      verifiedAt: verifiedAt is DateTime? ? verifiedAt : this.verifiedAt,
    );
  }
}

class EmailAccountRequestTable extends _i1.Table<_i1.UuidValue?> {
  EmailAccountRequestTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_email_account_request') {
    created = _i1.ColumnDateTime(
      'created',
      this,
      hasDefault: true,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    passwordHash = _i1.ColumnByteData(
      'passwordHash',
      this,
    );
    passwordSalt = _i1.ColumnByteData(
      'passwordSalt',
      this,
    );
    verificationCodeHash = _i1.ColumnByteData(
      'verificationCodeHash',
      this,
    );
    verificationCodeSalt = _i1.ColumnByteData(
      'verificationCodeSalt',
      this,
    );
    verifiedAt = _i1.ColumnDateTime(
      'verifiedAt',
      this,
    );
  }

  /// The time when this authentication was created.
  late final _i1.ColumnDateTime created;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  late final _i1.ColumnString email;

  /// The hashed password of the user.
  ///
  /// Obtained in conjunction with [passwordSalt].
  late final _i1.ColumnByteData passwordHash;

  /// The salt used for creating the [passwordHash].
  late final _i1.ColumnByteData passwordSalt;

  /// The hash of the verification code sent to the user.
  late final _i1.ColumnByteData verificationCodeHash;

  /// The salt used to compute the [verificationCodeHash].
  late final _i1.ColumnByteData verificationCodeSalt;

  /// Time at which the email address has been verified, or `null` if it did not happen yet.
  ///
  /// The requets can only be turned into an account if this is non-`null`.
  late final _i1.ColumnDateTime verifiedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        created,
        email,
        passwordHash,
        passwordSalt,
        verificationCodeHash,
        verificationCodeSalt,
        verifiedAt,
      ];
}

class EmailAccountRequestInclude extends _i1.IncludeObject {
  EmailAccountRequestInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

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
  }) async {
    return session.db.find<EmailAccountRequest>(
      where: where?.call(EmailAccountRequest.t),
      orderBy: orderBy?.call(EmailAccountRequest.t),
      orderByList: orderByList?.call(EmailAccountRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
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
  }) async {
    return session.db.findFirstRow<EmailAccountRequest>(
      where: where?.call(EmailAccountRequest.t),
      orderBy: orderBy?.call(EmailAccountRequest.t),
      orderByList: orderByList?.call(EmailAccountRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmailAccountRequest] by its [id] or null if no such row exists.
  Future<EmailAccountRequest?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailAccountRequest>(
      id,
      transaction: transaction,
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

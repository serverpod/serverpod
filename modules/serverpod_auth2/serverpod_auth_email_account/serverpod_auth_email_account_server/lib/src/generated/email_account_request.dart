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

/// There is no user ID stored with the request.
/// If an existing user should be assigned to this specific request,
/// store that with the request's `id` and link them up during registration.
abstract class EmailAccountRequest
    implements _i1.TableRow<int>, _i1.ProtocolSerialization {
  EmailAccountRequest._({
    this.id,
    required this.created,
    required this.expiration,
    required this.email,
    required this.passwordHash,
    required this.verificationCode,
  });

  factory EmailAccountRequest({
    int? id,
    required DateTime created,
    required DateTime expiration,
    required String email,
    required String passwordHash,
    required String verificationCode,
  }) = _EmailAccountRequestImpl;

  factory EmailAccountRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailAccountRequest(
      id: jsonSerialization['id'] as int?,
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      expiration:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiration']),
      email: jsonSerialization['email'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      verificationCode: jsonSerialization['verificationCode'] as String,
    );
  }

  static final t = EmailAccountRequestTable();

  static const db = EmailAccountRequestRepository._();

  @override
  int? id;

  /// The time when this authentication was created.
  DateTime created;

  /// The expiration time for the account verification to complete.
  DateTime expiration;

  /// The email of the user.
  ///
  /// Stored in lower-case by convention.
  String email;

  /// The hashed password of the user.
  String passwordHash;

  /// The verification code sent to the user.
  String verificationCode;

  @override
  _i1.Table<int> get table => t;

  /// Returns a shallow copy of this [EmailAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountRequest copyWith({
    int? id,
    DateTime? created,
    DateTime? expiration,
    String? email,
    String? passwordHash,
    String? verificationCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'created': created.toJson(),
      'expiration': expiration.toJson(),
      'email': email,
      'passwordHash': passwordHash,
      'verificationCode': verificationCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'created': created.toJson(),
      'expiration': expiration.toJson(),
      'email': email,
      'passwordHash': passwordHash,
      'verificationCode': verificationCode,
    };
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
    int? id,
    required DateTime created,
    required DateTime expiration,
    required String email,
    required String passwordHash,
    required String verificationCode,
  }) : super._(
          id: id,
          created: created,
          expiration: expiration,
          email: email,
          passwordHash: passwordHash,
          verificationCode: verificationCode,
        );

  /// Returns a shallow copy of this [EmailAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountRequest copyWith({
    Object? id = _Undefined,
    DateTime? created,
    DateTime? expiration,
    String? email,
    String? passwordHash,
    String? verificationCode,
  }) {
    return EmailAccountRequest(
      id: id is int? ? id : this.id,
      created: created ?? this.created,
      expiration: expiration ?? this.expiration,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}

class EmailAccountRequestTable extends _i1.Table<int> {
  EmailAccountRequestTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_email_account_request') {
    created = _i1.ColumnDateTime(
      'created',
      this,
    );
    expiration = _i1.ColumnDateTime(
      'expiration',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    passwordHash = _i1.ColumnString(
      'passwordHash',
      this,
    );
    verificationCode = _i1.ColumnString(
      'verificationCode',
      this,
    );
  }

  /// The time when this authentication was created.
  late final _i1.ColumnDateTime created;

  /// The expiration time for the account verification to complete.
  late final _i1.ColumnDateTime expiration;

  /// The email of the user.
  ///
  /// Stored in lower-case by convention.
  late final _i1.ColumnString email;

  /// The hashed password of the user.
  late final _i1.ColumnString passwordHash;

  /// The verification code sent to the user.
  late final _i1.ColumnString verificationCode;

  @override
  List<_i1.Column> get columns => [
        id,
        created,
        expiration,
        email,
        passwordHash,
        verificationCode,
      ];
}

class EmailAccountRequestInclude extends _i1.IncludeObject {
  EmailAccountRequestInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int> get table => EmailAccountRequest.t;
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
  _i1.Table<int> get table => EmailAccountRequest.t;
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
    int id, {
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

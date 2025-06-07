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

/// A fully configured email account to be used for logins.
abstract class EmailAccount
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  EmailAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? created,
    required this.email,
    required this.passwordHash,
    required this.passwordSalt,
  }) : created = created ?? DateTime.now();

  factory EmailAccount({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? created,
    required String email,
    required _i3.ByteData passwordHash,
    required _i3.ByteData passwordSalt,
  }) = _EmailAccountImpl;

  factory EmailAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailAccount(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i2.AuthUser.fromJson(
              (jsonSerialization['authUser'] as Map<String, dynamic>)),
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      email: jsonSerialization['email'] as String,
      passwordHash:
          _i1.ByteDataJsonExtension.fromJson(jsonSerialization['passwordHash']),
      passwordSalt:
          _i1.ByteDataJsonExtension.fromJson(jsonSerialization['passwordSalt']),
    );
  }

  static final t = EmailAccountTable();

  static const db = EmailAccountRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUser? authUser;

  /// The time when this authentication was created.
  DateTime created;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  String email;

  /// The hashed password of the user.
  ///
  /// Obtained in conjunction with [passwordSalt].
  _i3.ByteData passwordHash;

  /// The salt used for creating the [passwordHash].
  _i3.ByteData passwordSalt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccount copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    DateTime? created,
    String? email,
    _i3.ByteData? passwordHash,
    _i3.ByteData? passwordSalt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'created': created.toJson(),
      'email': email,
      'passwordHash': passwordHash.toJson(),
      'passwordSalt': passwordSalt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id?.toJson()};
  }

  static EmailAccountInclude include({_i2.AuthUserInclude? authUser}) {
    return EmailAccountInclude._(authUser: authUser);
  }

  static EmailAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountTable>? orderByList,
    EmailAccountInclude? include,
  }) {
    return EmailAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountImpl extends EmailAccount {
  _EmailAccountImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? created,
    required String email,
    required _i3.ByteData passwordHash,
    required _i3.ByteData passwordSalt,
  }) : super._(
          id: id,
          authUserId: authUserId,
          authUser: authUser,
          created: created,
          email: email,
          passwordHash: passwordHash,
          passwordSalt: passwordSalt,
        );

  /// Returns a shallow copy of this [EmailAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccount copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? created,
    String? email,
    _i3.ByteData? passwordHash,
    _i3.ByteData? passwordSalt,
  }) {
    return EmailAccount(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser:
          authUser is _i2.AuthUser? ? authUser : this.authUser?.copyWith(),
      created: created ?? this.created,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash.clone(),
      passwordSalt: passwordSalt ?? this.passwordSalt.clone(),
    );
  }
}

class EmailAccountTable extends _i1.Table<_i1.UuidValue?> {
  EmailAccountTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_email_account') {
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
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
  }

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUserTable? _authUser;

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

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: EmailAccount.t.authUserId,
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
        created,
        email,
        passwordHash,
        passwordSalt,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class EmailAccountInclude extends _i1.IncludeObject {
  EmailAccountInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailAccount.t;
}

class EmailAccountIncludeList extends _i1.IncludeList {
  EmailAccountIncludeList._({
    _i1.WhereExpressionBuilder<EmailAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailAccount.t;
}

class EmailAccountRepository {
  const EmailAccountRepository._();

  final attachRow = const EmailAccountAttachRowRepository._();

  /// Returns a list of [EmailAccount]s matching the given query parameters.
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
  Future<List<EmailAccount>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountTable>? orderByList,
    _i1.Transaction? transaction,
    EmailAccountInclude? include,
  }) async {
    return session.db.find<EmailAccount>(
      where: where?.call(EmailAccount.t),
      orderBy: orderBy?.call(EmailAccount.t),
      orderByList: orderByList?.call(EmailAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [EmailAccount] matching the given query parameters.
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
  Future<EmailAccount?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountTable>? orderByList,
    _i1.Transaction? transaction,
    EmailAccountInclude? include,
  }) async {
    return session.db.findFirstRow<EmailAccount>(
      where: where?.call(EmailAccount.t),
      orderBy: orderBy?.call(EmailAccount.t),
      orderByList: orderByList?.call(EmailAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [EmailAccount] by its [id] or null if no such row exists.
  Future<EmailAccount?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    EmailAccountInclude? include,
  }) async {
    return session.db.findById<EmailAccount>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [EmailAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailAccount>> insert(
    _i1.Session session,
    List<EmailAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailAccount] and returns the inserted row.
  ///
  /// The returned [EmailAccount] will have its `id` field set.
  Future<EmailAccount> insertRow(
    _i1.Session session,
    EmailAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailAccount>> update(
    _i1.Session session,
    List<EmailAccount> rows, {
    _i1.ColumnSelections<EmailAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailAccount>(
      rows,
      columns: columns?.call(EmailAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccount> updateRow(
    _i1.Session session,
    EmailAccount row, {
    _i1.ColumnSelections<EmailAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAccount>(
      row,
      columns: columns?.call(EmailAccount.t),
      transaction: transaction,
    );
  }

  /// Deletes all [EmailAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailAccount>> delete(
    _i1.Session session,
    List<EmailAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailAccount].
  Future<EmailAccount> deleteRow(
    _i1.Session session,
    EmailAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailAccount>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailAccount>(
      where: where(EmailAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccount>(
      where: where?.call(EmailAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class EmailAccountAttachRowRepository {
  const EmailAccountAttachRowRepository._();

  /// Creates a relation between the given [EmailAccount] and [AuthUser]
  /// by setting the [EmailAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    EmailAccount emailAccount,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (emailAccount.id == null) {
      throw ArgumentError.notNull('emailAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $emailAccount = emailAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<EmailAccount>(
      $emailAccount,
      columns: [EmailAccount.t.authUserId],
      transaction: transaction,
    );
  }
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef EmailAuthExpressionBuilder = _i1.Expression Function(EmailAuthTable);

/// Database bindings for a sign in with email.
abstract class EmailAuth extends _i1.TableRow {
  const EmailAuth._();

  const factory EmailAuth({
    int? id,
    required int userId,
    required String email,
    required String hash,
  }) = _EmailAuth;

  factory EmailAuth.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailAuth(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      email:
          serializationManager.deserialize<String>(jsonSerialization['email']),
      hash: serializationManager.deserialize<String>(jsonSerialization['hash']),
    );
  }

  static const t = EmailAuthTable();

  EmailAuth copyWith({
    int? id,
    int? userId,
    String? email,
    String? hash,
  });
  @override
  String get tableName => 'serverpod_email_auth';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'userId': userId,
      'email': email,
      'hash': hash,
    };
  }

  static Future<List<EmailAuth>> find(
    _i1.Session session, {
    EmailAuthExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailAuth>(
      where: where != null ? where(EmailAuth.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailAuth?> findSingleRow(
    _i1.Session session, {
    EmailAuthExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<EmailAuth>(
      where: where != null ? where(EmailAuth.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailAuth?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<EmailAuth>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required EmailAuthExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailAuth>(
      where: where(EmailAuth.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    EmailAuth row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    EmailAuth row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    EmailAuth row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    EmailAuthExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailAuth>(
      where: where != null ? where(EmailAuth.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  /// The id of the user, corresponds to the id field in [UserInfo].
  int get userId;

  /// The email of the user.
  String get email;

  /// The hashed password of the user.
  String get hash;
}

class _Undefined {}

/// Database bindings for a sign in with email.
class _EmailAuth extends EmailAuth {
  const _EmailAuth({
    int? id,
    required this.userId,
    required this.email,
    required this.hash,
  }) : super._();

  /// The id of the user, corresponds to the id field in [UserInfo].
  @override
  final int userId;

  /// The email of the user.
  @override
  final String email;

  /// The hashed password of the user.
  @override
  final String hash;

  @override
  String get tableName => 'serverpod_email_auth';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'email': email,
      'hash': hash,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is EmailAuth &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.userId,
                  userId,
                ) ||
                other.userId == userId) &&
            (identical(
                  other.email,
                  email,
                ) ||
                other.email == email) &&
            (identical(
                  other.hash,
                  hash,
                ) ||
                other.hash == hash));
  }

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        email,
        hash,
      );

  @override
  EmailAuth copyWith({
    Object? id = _Undefined,
    int? userId,
    String? email,
    String? hash,
  }) {
    return EmailAuth(
      id: id == _Undefined ? this.id : (id as int?),
      userId: userId ?? this.userId,
      email: email ?? this.email,
      hash: hash ?? this.hash,
    );
  }
}

class EmailAuthTable extends _i1.Table {
  const EmailAuthTable() : super(tableName: 'serverpod_email_auth');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// The id of the user, corresponds to the id field in [UserInfo].
  final userId = const _i1.ColumnInt('userId');

  /// The email of the user.
  final email = const _i1.ColumnString('email');

  /// The hashed password of the user.
  final hash = const _i1.ColumnString('hash');

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        email,
        hash,
      ];
}

@Deprecated('Use EmailAuthTable.t instead.')
EmailAuthTable tEmailAuth = const EmailAuthTable();

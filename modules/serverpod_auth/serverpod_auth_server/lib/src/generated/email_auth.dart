/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Database bindings for a sign in with email.
class EmailAuth extends _i1.TableRow {
  EmailAuth({
    int? id,
    required this.userId,
    required this.email,
    required this.hash,
  }) : super(id);

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

  static final t = EmailAuthTable();

  /// The id of the user, corresponds to the id field in [UserInfo].
  int userId;

  /// The email of the user.
  String email;

  /// The hashed password of the user.
  String hash;

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
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'userId': userId,
      'email': email,
      'hash': hash,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'userId': userId,
      'email': email,
      'hash': hash,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'userId':
        userId = value;
        return;
      case 'email':
        email = value;
        return;
      case 'hash':
        hash = value;
        return;
      default:
        throw UnimplementedError();
    }
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
}

typedef EmailAuthExpressionBuilder = _i1.Expression Function(EmailAuthTable);

class EmailAuthTable extends _i1.Table {
  EmailAuthTable() : super(tableName: 'serverpod_email_auth');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = _i1.ColumnInt('id');

  /// The id of the user, corresponds to the id field in [UserInfo].
  final userId = _i1.ColumnInt('userId');

  /// The email of the user.
  final email = _i1.ColumnString('email');

  /// The hashed password of the user.
  final hash = _i1.ColumnString('hash');

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        email,
        hash,
      ];
}

@Deprecated('Use EmailAuthTable.t instead.')
EmailAuthTable tEmailAuth = EmailAuthTable();

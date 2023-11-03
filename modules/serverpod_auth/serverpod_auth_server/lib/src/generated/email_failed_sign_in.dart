/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Database table for tracking failed email sign-ins. Saves IP-address, time,
/// and email to be prevent brute force attacks.
class EmailFailedSignIn extends _i1.TableRow {
  EmailFailedSignIn({
    int? id,
    required this.email,
    required this.time,
    required this.ipAddress,
  }) : super(id);

  factory EmailFailedSignIn.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailFailedSignIn(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      email:
          serializationManager.deserialize<String>(jsonSerialization['email']),
      time:
          serializationManager.deserialize<DateTime>(jsonSerialization['time']),
      ipAddress: serializationManager
          .deserialize<String>(jsonSerialization['ipAddress']),
    );
  }

  static final t = EmailFailedSignInTable();

  /// Email attempting to sign in with.
  String email;

  /// The time of the sign in attempt.
  DateTime time;

  /// The IP address of the sign in attempt.
  String ipAddress;

  @override
  String get tableName => 'serverpod_email_failed_sign_in';

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'time': time,
      'ipAddress': ipAddress,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'email': email,
      'time': time,
      'ipAddress': ipAddress,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'email': email,
      'time': time,
      'ipAddress': ipAddress,
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
      case 'email':
        email = value;
        return;
      case 'time':
        time = value;
        return;
      case 'ipAddress':
        ipAddress = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<EmailFailedSignIn>> find(
    _i1.Session session, {
    EmailFailedSignInExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailFailedSignIn>(
      where: where != null ? where(EmailFailedSignIn.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailFailedSignIn?> findSingleRow(
    _i1.Session session, {
    EmailFailedSignInExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<EmailFailedSignIn>(
      where: where != null ? where(EmailFailedSignIn.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailFailedSignIn?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<EmailFailedSignIn>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required EmailFailedSignInExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailFailedSignIn>(
      where: where(EmailFailedSignIn.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    EmailFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    EmailFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    EmailFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    EmailFailedSignInExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailFailedSignIn>(
      where: where != null ? where(EmailFailedSignIn.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef EmailFailedSignInExpressionBuilder = _i1.Expression Function(
    EmailFailedSignInTable);

class EmailFailedSignInTable extends _i1.Table {
  EmailFailedSignInTable() : super(tableName: 'serverpod_email_failed_sign_in');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = _i1.ColumnInt('id');

  /// Email attempting to sign in with.
  final email = _i1.ColumnString('email');

  /// The time of the sign in attempt.
  final time = _i1.ColumnDateTime('time');

  /// The IP address of the sign in attempt.
  final ipAddress = _i1.ColumnString('ipAddress');

  @override
  List<_i1.Column> get columns => [
        id,
        email,
        time,
        ipAddress,
      ];
}

@Deprecated('Use EmailFailedSignInTable.t instead.')
EmailFailedSignInTable tEmailFailedSignIn = EmailFailedSignInTable();

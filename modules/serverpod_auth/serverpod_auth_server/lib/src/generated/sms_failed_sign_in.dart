/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Database Table for Tracking failed SMS sign in attempts. Saves IP address, phone number
/// and time to prevent brute force attacks.
class SmsFailedSignIn extends _i1.TableRow {
  SmsFailedSignIn({
    int? id,
    required this.phoneNumber,
    required this.time,
    required this.ipAddress,
  }) : super(id);

  factory SmsFailedSignIn.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SmsFailedSignIn(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      phoneNumber: serializationManager
          .deserialize<String>(jsonSerialization['phoneNumber']),
      time:
          serializationManager.deserialize<DateTime>(jsonSerialization['time']),
      ipAddress: serializationManager
          .deserialize<String>(jsonSerialization['ipAddress']),
    );
  }

  static final t = SmsFailedSignInTable();

  /// The phone number of the user.
  String phoneNumber;

  /// The time of the sign in attempt.
  DateTime time;

  /// The IP address of the sign in attempt.
  String ipAddress;

  @override
  String get tableName => 'serverpod_sms_failed_sign_in';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'time': time,
      'ipAddress': ipAddress,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'time': time,
      'ipAddress': ipAddress,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
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
      case 'phoneNumber':
        phoneNumber = value;
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

  static Future<List<SmsFailedSignIn>> find(
    _i1.Session session, {
    SmsFailedSignInExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SmsFailedSignIn>(
      where: where != null ? where(SmsFailedSignIn.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SmsFailedSignIn?> findSingleRow(
    _i1.Session session, {
    SmsFailedSignInExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<SmsFailedSignIn>(
      where: where != null ? where(SmsFailedSignIn.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SmsFailedSignIn?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<SmsFailedSignIn>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required SmsFailedSignInExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SmsFailedSignIn>(
      where: where(SmsFailedSignIn.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    SmsFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    SmsFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    SmsFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    SmsFailedSignInExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SmsFailedSignIn>(
      where: where != null ? where(SmsFailedSignIn.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static SmsFailedSignInInclude include() {
    return SmsFailedSignInInclude._();
  }
}

typedef SmsFailedSignInExpressionBuilder = _i1.Expression Function(
    SmsFailedSignInTable);

class SmsFailedSignInTable extends _i1.Table {
  SmsFailedSignInTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_sms_failed_sign_in') {
    phoneNumber = _i1.ColumnString(
      'phoneNumber',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    time = _i1.ColumnDateTime(
      'time',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// The phone number of the user.
  late final _i1.ColumnString phoneNumber;

  /// The time of the sign in attempt.
  late final _i1.ColumnDateTime time;

  /// The IP address of the sign in attempt.
  late final _i1.ColumnString ipAddress;

  @override
  List<_i1.Column> get columns => [
        id,
        phoneNumber,
        time,
        ipAddress,
      ];
}

@Deprecated('Use SmsFailedSignInTable.t instead.')
SmsFailedSignInTable tSmsFailedSignIn = SmsFailedSignInTable();

class SmsFailedSignInInclude extends _i1.Include {
  SmsFailedSignInInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => SmsFailedSignIn.t;
}

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

/// Database table for tracking failed phone number sign-ins. Saves IP-address, time,
/// and phone number to be prevent brute force attacks.
abstract class PhoneFailedSignIn
    implements _i1.TableRow, _i1.ProtocolSerialization {
  PhoneFailedSignIn._({
    this.id,
    required this.phoneNumber,
    required this.time,
    required this.ipAddress,
  });

  factory PhoneFailedSignIn({
    int? id,
    required String phoneNumber,
    required DateTime time,
    required String ipAddress,
  }) = _PhoneFailedSignInImpl;

  factory PhoneFailedSignIn.fromJson(Map<String, dynamic> jsonSerialization) {
    return PhoneFailedSignIn(
      id: jsonSerialization['id'] as int?,
      phoneNumber: jsonSerialization['phoneNumber'] as String,
      time: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['time']),
      ipAddress: jsonSerialization['ipAddress'] as String,
    );
  }

  static final t = PhoneFailedSignInTable();

  static const db = PhoneFailedSignInRepository._();

  @override
  int? id;

  /// Phone number attempting to sign in with.
  String phoneNumber;

  /// The time of the sign in attempt.
  DateTime time;

  /// The IP address of the sign in attempt.
  String ipAddress;

  @override
  _i1.Table get table => t;

  PhoneFailedSignIn copyWith({
    int? id,
    String? phoneNumber,
    DateTime? time,
    String? ipAddress,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'phoneNumber': phoneNumber,
      'time': time.toJson(),
      'ipAddress': ipAddress,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'phoneNumber': phoneNumber,
      'time': time.toJson(),
      'ipAddress': ipAddress,
    };
  }

  static PhoneFailedSignInInclude include() {
    return PhoneFailedSignInInclude._();
  }

  static PhoneFailedSignInIncludeList includeList({
    _i1.WhereExpressionBuilder<PhoneFailedSignInTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PhoneFailedSignInTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PhoneFailedSignInTable>? orderByList,
    PhoneFailedSignInInclude? include,
  }) {
    return PhoneFailedSignInIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PhoneFailedSignIn.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PhoneFailedSignIn.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PhoneFailedSignInImpl extends PhoneFailedSignIn {
  _PhoneFailedSignInImpl({
    int? id,
    required String phoneNumber,
    required DateTime time,
    required String ipAddress,
  }) : super._(
          id: id,
          phoneNumber: phoneNumber,
          time: time,
          ipAddress: ipAddress,
        );

  @override
  PhoneFailedSignIn copyWith({
    Object? id = _Undefined,
    String? phoneNumber,
    DateTime? time,
    String? ipAddress,
  }) {
    return PhoneFailedSignIn(
      id: id is int? ? id : this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      time: time ?? this.time,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}

class PhoneFailedSignInTable extends _i1.Table {
  PhoneFailedSignInTable({super.tableRelation})
      : super(tableName: 'serverpod_phone_failed_sign_in') {
    phoneNumber = _i1.ColumnString(
      'phoneNumber',
      this,
    );
    time = _i1.ColumnDateTime(
      'time',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
  }

  /// Phone number attempting to sign in with.
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

class PhoneFailedSignInInclude extends _i1.IncludeObject {
  PhoneFailedSignInInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => PhoneFailedSignIn.t;
}

class PhoneFailedSignInIncludeList extends _i1.IncludeList {
  PhoneFailedSignInIncludeList._({
    _i1.WhereExpressionBuilder<PhoneFailedSignInTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PhoneFailedSignIn.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => PhoneFailedSignIn.t;
}

class PhoneFailedSignInRepository {
  const PhoneFailedSignInRepository._();

  Future<List<PhoneFailedSignIn>> find(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<PhoneFailedSignInTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PhoneFailedSignInTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PhoneFailedSignInTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.find<PhoneFailedSignIn>(
      where: where?.call(PhoneFailedSignIn.t),
      orderBy: orderBy?.call(PhoneFailedSignIn.t),
      orderByList: orderByList?.call(PhoneFailedSignIn.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneFailedSignIn?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<PhoneFailedSignInTable>? where,
    int? offset,
    _i1.OrderByBuilder<PhoneFailedSignInTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PhoneFailedSignInTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findFirstRow<PhoneFailedSignIn>(
      where: where?.call(PhoneFailedSignIn.t),
      orderBy: orderBy?.call(PhoneFailedSignIn.t),
      orderByList: orderByList?.call(PhoneFailedSignIn.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneFailedSignIn?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findById<PhoneFailedSignIn>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<PhoneFailedSignIn>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<PhoneFailedSignIn> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<PhoneFailedSignIn>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneFailedSignIn> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    PhoneFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<PhoneFailedSignIn>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<PhoneFailedSignIn>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<PhoneFailedSignIn> rows, {
    _i1.ColumnSelections<PhoneFailedSignInTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<PhoneFailedSignIn>(
      rows,
      columns: columns?.call(PhoneFailedSignIn.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneFailedSignIn> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    PhoneFailedSignIn row, {
    _i1.ColumnSelections<PhoneFailedSignInTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<PhoneFailedSignIn>(
      row,
      columns: columns?.call(PhoneFailedSignIn.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<PhoneFailedSignIn>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<PhoneFailedSignIn> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<PhoneFailedSignIn>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneFailedSignIn> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    PhoneFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<PhoneFailedSignIn>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<PhoneFailedSignIn>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<PhoneFailedSignInTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<PhoneFailedSignIn>(
      where: where(PhoneFailedSignIn.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<PhoneFailedSignInTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<PhoneFailedSignIn>(
      where: where?.call(PhoneFailedSignIn.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Information about a user. The [UserInfo] should only be shared with the user
/// itself as it may contain sensative information, such as the users email.
/// If you need to share a user's info with other users, use the
/// [UserInfoPublic] instead. You can retrieve a [UserInfoPublic] through the
/// toPublic() method.
abstract class UserInfo extends _i1.TableRow {
  UserInfo._({
    int? id,
    required this.userIdentifier,
    required this.userName,
    this.fullName,
    this.email,
    required this.created,
    this.imageUrl,
    required this.scopeNames,
    required this.blocked,
  }) : super(id);

  factory UserInfo({
    int? id,
    required String userIdentifier,
    required String userName,
    String? fullName,
    String? email,
    required DateTime created,
    String? imageUrl,
    required List<String> scopeNames,
    required bool blocked,
  }) = _UserInfoImpl;

  factory UserInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserInfo(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userIdentifier: serializationManager
          .deserialize<String>(jsonSerialization['userIdentifier']),
      userName: serializationManager
          .deserialize<String>(jsonSerialization['userName']),
      fullName: serializationManager
          .deserialize<String?>(jsonSerialization['fullName']),
      email:
          serializationManager.deserialize<String?>(jsonSerialization['email']),
      created: serializationManager
          .deserialize<DateTime>(jsonSerialization['created']),
      imageUrl: serializationManager
          .deserialize<String?>(jsonSerialization['imageUrl']),
      scopeNames: serializationManager
          .deserialize<List<String>>(jsonSerialization['scopeNames']),
      blocked:
          serializationManager.deserialize<bool>(jsonSerialization['blocked']),
    );
  }

  static final t = UserInfoTable();

  /// Unique identifier of the user, may contain different information depending
  /// on how the user was created.
  String userIdentifier;

  /// The first name of the user or the user's nickname.
  String userName;

  /// The full name of the user.
  String? fullName;

  /// The email of the user.
  String? email;

  /// The time when this user was created.
  DateTime created;

  /// A URL to the user's avatar.
  String? imageUrl;

  /// List of scopes that this user can access.
  List<String> scopeNames;

  /// True if the user is blocked from signing in.
  bool blocked;

  @override
  String get tableName => 'serverpod_user_info';
  UserInfo copyWith({
    int? id,
    String? userIdentifier,
    String? userName,
    String? fullName,
    String? email,
    DateTime? created,
    String? imageUrl,
    List<String>? scopeNames,
    bool? blocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userIdentifier': userIdentifier,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created,
      'imageUrl': imageUrl,
      'scopeNames': scopeNames,
      'blocked': blocked,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'userIdentifier': userIdentifier,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created,
      'imageUrl': imageUrl,
      'scopeNames': scopeNames,
      'blocked': blocked,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'userIdentifier': userIdentifier,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created,
      'imageUrl': imageUrl,
      'scopeNames': scopeNames,
      'blocked': blocked,
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
      case 'userIdentifier':
        userIdentifier = value;
        return;
      case 'userName':
        userName = value;
        return;
      case 'fullName':
        fullName = value;
        return;
      case 'email':
        email = value;
        return;
      case 'created':
        created = value;
        return;
      case 'imageUrl':
        imageUrl = value;
        return;
      case 'scopeNames':
        scopeNames = value;
        return;
      case 'blocked':
        blocked = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<UserInfo>> find(
    _i1.Session session, {
    UserInfoExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserInfo>(
      where: where != null ? where(UserInfo.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<UserInfo?> findSingleRow(
    _i1.Session session, {
    UserInfoExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<UserInfo>(
      where: where != null ? where(UserInfo.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<UserInfo?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<UserInfo>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required UserInfoExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserInfo>(
      where: where(UserInfo.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    UserInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    UserInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    UserInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    UserInfoExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserInfo>(
      where: where != null ? where(UserInfo.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static UserInfoInclude include() {
    return UserInfoInclude._();
  }
}

class _Undefined {}

class _UserInfoImpl extends UserInfo {
  _UserInfoImpl({
    int? id,
    required String userIdentifier,
    required String userName,
    String? fullName,
    String? email,
    required DateTime created,
    String? imageUrl,
    required List<String> scopeNames,
    required bool blocked,
  }) : super._(
          id: id,
          userIdentifier: userIdentifier,
          userName: userName,
          fullName: fullName,
          email: email,
          created: created,
          imageUrl: imageUrl,
          scopeNames: scopeNames,
          blocked: blocked,
        );

  @override
  UserInfo copyWith({
    Object? id = _Undefined,
    String? userIdentifier,
    String? userName,
    Object? fullName = _Undefined,
    Object? email = _Undefined,
    DateTime? created,
    Object? imageUrl = _Undefined,
    List<String>? scopeNames,
    bool? blocked,
  }) {
    return UserInfo(
      id: id is! int? ? this.id : id,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      userName: userName ?? this.userName,
      fullName: fullName is! String? ? this.fullName : fullName,
      email: email is! String? ? this.email : email,
      created: created ?? this.created,
      imageUrl: imageUrl is! String? ? this.imageUrl : imageUrl,
      scopeNames: scopeNames ?? this.scopeNames,
      blocked: blocked ?? this.blocked,
    );
  }
}

typedef UserInfoExpressionBuilder = _i1.Expression Function(UserInfoTable);

class UserInfoTable extends _i1.Table {
  UserInfoTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_user_info') {
    userIdentifier = _i1.ColumnString(
      'userIdentifier',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    userName = _i1.ColumnString(
      'userName',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    fullName = _i1.ColumnString(
      'fullName',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    email = _i1.ColumnString(
      'email',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    created = _i1.ColumnDateTime(
      'created',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    scopeNames = _i1.ColumnSerializable(
      'scopeNames',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    blocked = _i1.ColumnBool(
      'blocked',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// Unique identifier of the user, may contain different information depending
  /// on how the user was created.
  late final _i1.ColumnString userIdentifier;

  /// The first name of the user or the user's nickname.
  late final _i1.ColumnString userName;

  /// The full name of the user.
  late final _i1.ColumnString fullName;

  /// The email of the user.
  late final _i1.ColumnString email;

  /// The time when this user was created.
  late final _i1.ColumnDateTime created;

  /// A URL to the user's avatar.
  late final _i1.ColumnString imageUrl;

  /// List of scopes that this user can access.
  late final _i1.ColumnSerializable scopeNames;

  /// True if the user is blocked from signing in.
  late final _i1.ColumnBool blocked;

  @override
  List<_i1.Column> get columns => [
        id,
        userIdentifier,
        userName,
        fullName,
        email,
        created,
        imageUrl,
        scopeNames,
        blocked,
      ];
}

@Deprecated('Use UserInfoTable.t instead.')
UserInfoTable tUserInfo = UserInfoTable();

class UserInfoInclude extends _i1.Include {
  UserInfoInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => UserInfo.t;
}

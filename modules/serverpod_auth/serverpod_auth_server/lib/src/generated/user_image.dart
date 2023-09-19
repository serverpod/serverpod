/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Database bindings for a user image.
abstract class UserImage extends _i1.TableRow {
  UserImage._({
    int? id,
    required this.userId,
    required this.version,
    required this.url,
  }) : super(id);

  factory UserImage({
    int? id,
    required int userId,
    required int version,
    required String url,
  }) = _UserImageImpl;

  factory UserImage.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserImage(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      version:
          serializationManager.deserialize<int>(jsonSerialization['version']),
      url: serializationManager.deserialize<String>(jsonSerialization['url']),
    );
  }

  static final t = UserImageTable();

  /// The id of the user.
  int userId;

  /// Version of the image. Increased by one for every uploaded image.
  int version;

  /// The URL to the image.
  String url;

  @override
  _i1.Table get table => t;
  UserImage copyWith({
    int? id,
    int? userId,
    int? version,
    String? url,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
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
      case 'version':
        version = value;
        return;
      case 'url':
        url = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<UserImage>> find(
    _i1.Session session, {
    UserImageExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserImage>(
      where: where != null ? where(UserImage.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<UserImage?> findSingleRow(
    _i1.Session session, {
    UserImageExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<UserImage>(
      where: where != null ? where(UserImage.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<UserImage?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<UserImage>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required UserImageExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserImage>(
      where: where(UserImage.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    UserImage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    UserImage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    UserImage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    UserImageExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserImage>(
      where: where != null ? where(UserImage.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static UserImageInclude include() {
    return UserImageInclude._();
  }
}

class _Undefined {}

class _UserImageImpl extends UserImage {
  _UserImageImpl({
    int? id,
    required int userId,
    required int version,
    required String url,
  }) : super._(
          id: id,
          userId: userId,
          version: version,
          url: url,
        );

  @override
  UserImage copyWith({
    Object? id = _Undefined,
    int? userId,
    int? version,
    String? url,
  }) {
    return UserImage(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      version: version ?? this.version,
      url: url ?? this.url,
    );
  }
}

typedef UserImageExpressionBuilder = _i1.Expression Function(UserImageTable);

class UserImageTable extends _i1.Table {
  UserImageTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_user_image') {
    userId = _i1.ColumnInt(
      'userId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    version = _i1.ColumnInt(
      'version',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    url = _i1.ColumnString(
      'url',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// The id of the user.
  late final _i1.ColumnInt userId;

  /// Version of the image. Increased by one for every uploaded image.
  late final _i1.ColumnInt version;

  /// The URL to the image.
  late final _i1.ColumnString url;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        version,
        url,
      ];
}

@Deprecated('Use UserImageTable.t instead.')
UserImageTable tUserImage = UserImageTable();

class UserImageInclude extends _i1.Include {
  UserImageInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => UserImage.t;
}

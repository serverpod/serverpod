/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef UserImageExpressionBuilder = _i1.Expression Function(UserImageTable);

/// Database bindings for a user image.
abstract class UserImage extends _i1.TableRow {
  const UserImage._();

  const factory UserImage({
    int? id,
    required int userId,
    required int version,
    required String url,
  }) = _UserImage;

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

  static const t = UserImageTable();

  UserImage copyWith({
    int? id,
    int? userId,
    int? version,
    String? url,
  });
  @override
  String get tableName => 'serverpod_user_image';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    };
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

  /// The id of the user.
  int get userId;

  /// Version of the image. Increased by one for every uploaded image.
  int get version;

  /// The URL to the image.
  String get url;
}

class _Undefined {}

/// Database bindings for a user image.
class _UserImage extends UserImage {
  const _UserImage({
    int? id,
    required this.userId,
    required this.version,
    required this.url,
  }) : super._();

  /// The id of the user.
  @override
  final int userId;

  /// Version of the image. Increased by one for every uploaded image.
  @override
  final int version;

  /// The URL to the image.
  @override
  final String url;

  @override
  String get tableName => 'serverpod_user_image';
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
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is UserImage &&
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
                  other.version,
                  version,
                ) ||
                other.version == version) &&
            (identical(
                  other.url,
                  url,
                ) ||
                other.url == url));
  }

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        version,
        url,
      );

  @override
  UserImage copyWith({
    Object? id = _Undefined,
    int? userId,
    int? version,
    String? url,
  }) {
    return UserImage(
      id: id == _Undefined ? this.id : (id as int?),
      userId: userId ?? this.userId,
      version: version ?? this.version,
      url: url ?? this.url,
    );
  }
}

class UserImageTable extends _i1.Table {
  const UserImageTable() : super(tableName: 'serverpod_user_image');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// The id of the user.
  final userId = const _i1.ColumnInt('userId');

  /// Version of the image. Increased by one for every uploaded image.
  final version = const _i1.ColumnInt('version');

  /// The URL to the image.
  final url = const _i1.ColumnString('url');

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        version,
        url,
      ];
}

@Deprecated('Use UserImageTable.t instead.')
UserImageTable tUserImage = const UserImageTable();

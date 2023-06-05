/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:collection/collection.dart' as _i2;

class _Undefined {}

/// Information about a user. The [UserInfo] should only be shared with the user
/// itself as it may contain sensative information, such as the users email.
/// If you need to share a user's info with other users, use the
/// [UserInfoPublic] instead. You can retrieve a [UserInfoPublic] through the
/// toPublic() method.
class UserInfo extends _i1.SerializableEntity {
  UserInfo({
    this.id,
    required this.userIdentifier,
    required this.userName,
    this.fullName,
    this.email,
    required this.created,
    this.imageUrl,
    required this.scopeNames,
    required this.blocked,
  });

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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final int? id;

  /// Unique identifier of the user, may contain different information depending
  /// on how the user was created.
  final String userIdentifier;

  /// The first name of the user or the user's nickname.
  final String userName;

  /// The full name of the user.
  final String? fullName;

  /// The email of the user.
  final String? email;

  /// The time when this user was created.
  final DateTime created;

  /// A URL to the user's avatar.
  final String? imageUrl;

  /// List of scopes that this user can access.
  final List<String> scopeNames;

  /// True if the user is blocked from signing in.
  final bool blocked;

  late Function({
    int? id,
    String? userIdentifier,
    String? userName,
    String? fullName,
    String? email,
    DateTime? created,
    String? imageUrl,
    List<String>? scopeNames,
    bool? blocked,
  }) copyWith = _copyWith;

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
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is UserInfo &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.userIdentifier,
                  userIdentifier,
                ) ||
                other.userIdentifier == userIdentifier) &&
            (identical(
                  other.userName,
                  userName,
                ) ||
                other.userName == userName) &&
            (identical(
                  other.fullName,
                  fullName,
                ) ||
                other.fullName == fullName) &&
            (identical(
                  other.email,
                  email,
                ) ||
                other.email == email) &&
            (identical(
                  other.created,
                  created,
                ) ||
                other.created == created) &&
            (identical(
                  other.imageUrl,
                  imageUrl,
                ) ||
                other.imageUrl == imageUrl) &&
            (identical(
                  other.blocked,
                  blocked,
                ) ||
                other.blocked == blocked) &&
            const _i2.DeepCollectionEquality().equals(
              scopeNames,
              other.scopeNames,
            ));
  }

  @override
  int get hashCode => Object.hash(
        id,
        userIdentifier,
        userName,
        fullName,
        email,
        created,
        imageUrl,
        blocked,
        const _i2.DeepCollectionEquality().hash(scopeNames),
      );

  UserInfo _copyWith({
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
      id: id == _Undefined ? this.id : (id as int?),
      userIdentifier: userIdentifier ?? this.userIdentifier,
      userName: userName ?? this.userName,
      fullName: fullName == _Undefined ? this.fullName : (fullName as String?),
      email: email == _Undefined ? this.email : (email as String?),
      created: created ?? this.created,
      imageUrl: imageUrl == _Undefined ? this.imageUrl : (imageUrl as String?),
      scopeNames: scopeNames ?? this.scopeNames,
      blocked: blocked ?? this.blocked,
    );
  }
}

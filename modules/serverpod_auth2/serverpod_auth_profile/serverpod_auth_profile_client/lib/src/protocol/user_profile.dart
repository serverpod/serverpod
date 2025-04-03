/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:uuid/uuid.dart' as _i2;

abstract class UserProfile implements _i1.SerializableModel {
  UserProfile._({
    _i1.UuidValue? id,
    required this.userId,
    this.userName,
    this.fullName,
    this.email,
    required this.created,
    this.imageUrl,
  }) : id = id ?? _i2.Uuid().v4obj();

  factory UserProfile({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    String? userName,
    String? fullName,
    String? email,
    required DateTime created,
    String? imageUrl,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      userName: jsonSerialization['userName'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      email: jsonSerialization['email'] as String?,
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      imageUrl: jsonSerialization['imageUrl'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  /// [AuthenticationUser] ID.
  _i1.UuidValue userId;

  /// The first name of the user or the user's nickname.
  String? userName;

  /// The full name of the user.
  String? fullName;

  /// The email of the user.
  String? email;

  /// The time when this user was created.
  DateTime created;

  /// A URL to the user's avatar.
  String? imageUrl;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfile copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    String? userName,
    String? fullName,
    String? email,
    DateTime? created,
    String? imageUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'created': created.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    String? userName,
    String? fullName,
    String? email,
    required DateTime created,
    String? imageUrl,
  }) : super._(
          id: id,
          userId: userId,
          userName: userName,
          fullName: fullName,
          email: email,
          created: created,
          imageUrl: imageUrl,
        );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? userName = _Undefined,
    Object? fullName = _Undefined,
    Object? email = _Undefined,
    DateTime? created,
    Object? imageUrl = _Undefined,
  }) {
    return UserProfile(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      userName: userName is String? ? userName : this.userName,
      fullName: fullName is String? ? fullName : this.fullName,
      email: email is String? ? email : this.email,
      created: created ?? this.created,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
    );
  }
}

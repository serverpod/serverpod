/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database bindings for a Facebook long-lived server token.
class FacebookLongLivedToken extends _i1.SerializableEntity {
  FacebookLongLivedToken({
    this.id,
    required this.userId,
    required this.fbProfileId,
    required this.token,
    required this.expiresAt,
  });

  factory FacebookLongLivedToken.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return FacebookLongLivedToken(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      fbProfileId: serializationManager
          .deserialize<String>(jsonSerialization['fbProfileId']),
      token:
          serializationManager.deserialize<String>(jsonSerialization['token']),
      expiresAt: serializationManager
          .deserialize<DateTime>(jsonSerialization['expiresAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The Serverpod user id associated with the token.
  int userId;

  /// The Facebook profile id.
  String fbProfileId;

  /// The Facebook long-lived token.
  String token;

  /// The expiry date of the token.
  DateTime expiresAt;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fbProfileId': fbProfileId,
      'token': token,
      'expiresAt': expiresAt,
    };
  }
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class UserInfoPublic extends _i1.SerializableEntity {
  UserInfoPublic({
    this.id,
    required this.userName,
    this.fullName,
    required this.created,
    this.imageUrl,
  });

  factory UserInfoPublic.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserInfoPublic(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userName: serializationManager
          .deserialize<String>(jsonSerialization['userName']),
      fullName: serializationManager
          .deserialize<String?>(jsonSerialization['fullName']),
      created: serializationManager
          .deserialize<DateTime>(jsonSerialization['created']),
      imageUrl: serializationManager
          .deserialize<String?>(jsonSerialization['imageUrl']),
    );
  }

  int? id;

  String userName;

  String? fullName;

  DateTime created;

  String? imageUrl;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'created': created,
      'imageUrl': imageUrl,
    };
  }
}

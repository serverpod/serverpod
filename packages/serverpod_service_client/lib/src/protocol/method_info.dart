/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class MethodInfo extends _i1.SerializableEntity {
  MethodInfo({
    this.id,
    required this.endpoint,
    required this.method,
  });

  factory MethodInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return MethodInfo(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      endpoint: serializationManager
          .deserialize<String>(jsonSerialization['endpoint']),
      method:
          serializationManager.deserialize<String>(jsonSerialization['method']),
    );
  }

  int? id;

  String endpoint;

  String method;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'endpoint': endpoint,
      'method': method,
    };
  }
}

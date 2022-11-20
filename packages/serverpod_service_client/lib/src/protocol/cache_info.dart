/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class CacheInfo extends _i1.SerializableEntity {
  CacheInfo({
    required this.numEntries,
    required this.maxEntries,
    this.keys,
  });

  factory CacheInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return CacheInfo(
      numEntries: serializationManager
          .deserialize<int>(jsonSerialization['numEntries']),
      maxEntries: serializationManager
          .deserialize<int>(jsonSerialization['maxEntries']),
      keys: serializationManager
          .deserialize<List<String>?>(jsonSerialization['keys']),
    );
  }

  int numEntries;

  int maxEntries;

  List<String>? keys;

  @override
  Map<String, dynamic> toJson() {
    return {
      'numEntries': numEntries,
      'maxEntries': maxEntries,
      'keys': keys,
    };
  }
}

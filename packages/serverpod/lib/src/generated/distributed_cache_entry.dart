/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

class DistributedCacheEntry extends _i1.SerializableEntity {
  DistributedCacheEntry({required this.data});

  factory DistributedCacheEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DistributedCacheEntry(
        data: serializationManager
            .deserializeJson<String>(jsonSerialization['data']));
  }

  String data;

  @override
  String get className => 'DistributedCacheEntry';
  @override
  Map<String, dynamic> toJson() {
    return {'data': data};
  }

  @override
  Map<String, dynamic> allToJson() {
    return {'data': data};
  }
}

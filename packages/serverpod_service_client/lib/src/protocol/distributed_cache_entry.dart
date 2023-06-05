/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class _Undefined {}

/// An entry in the distributed cache.
class DistributedCacheEntry extends _i1.SerializableEntity {
  DistributedCacheEntry({required this.data});

  factory DistributedCacheEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DistributedCacheEntry(
        data: serializationManager
            .deserialize<String>(jsonSerialization['data']));
  }

  /// The cached data.
  final String data;

  late Function({String? data}) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {'data': data};
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is DistributedCacheEntry &&
            (identical(
                  other.data,
                  data,
                ) ||
                other.data == data));
  }

  @override
  int get hashCode => data.hashCode;

  DistributedCacheEntry _copyWith({String? data}) {
    return DistributedCacheEntry(data: data ?? this.data);
  }
}

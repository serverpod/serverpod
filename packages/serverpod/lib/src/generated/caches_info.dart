/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

class _Undefined {}

/// High level information about the caches.
class CachesInfo extends _i1.SerializableEntity {
  CachesInfo({
    required this.local,
    required this.localPrio,
    required this.global,
  });

  factory CachesInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return CachesInfo(
      local: serializationManager
          .deserialize<_i2.CacheInfo>(jsonSerialization['local']),
      localPrio: serializationManager
          .deserialize<_i2.CacheInfo>(jsonSerialization['localPrio']),
      global: serializationManager
          .deserialize<_i2.CacheInfo>(jsonSerialization['global']),
    );
  }

  /// Information about the local cache.
  final _i2.CacheInfo local;

  /// Information about the local priority cache.
  final _i2.CacheInfo localPrio;

  /// Information about the global cache.
  final _i2.CacheInfo global;

  late Function({
    _i2.CacheInfo? local,
    _i2.CacheInfo? localPrio,
    _i2.CacheInfo? global,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'local': local,
      'localPrio': localPrio,
      'global': global,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is CachesInfo &&
            (identical(
                  other.local,
                  local,
                ) ||
                other.local == local) &&
            (identical(
                  other.localPrio,
                  localPrio,
                ) ||
                other.localPrio == localPrio) &&
            (identical(
                  other.global,
                  global,
                ) ||
                other.global == global));
  }

  @override
  int get hashCode => Object.hash(
        local,
        localPrio,
        global,
      );

  CachesInfo _copyWith({
    _i2.CacheInfo? local,
    _i2.CacheInfo? localPrio,
    _i2.CacheInfo? global,
  }) {
    return CachesInfo(
      local: local ?? this.local,
      localPrio: localPrio ?? this.localPrio,
      global: global ?? this.global,
    );
  }
}

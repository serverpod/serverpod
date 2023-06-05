/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

/// High level information about the caches.
abstract class CachesInfo extends _i1.SerializableEntity {
  const CachesInfo._();

  const factory CachesInfo({
    required _i2.CacheInfo local,
    required _i2.CacheInfo localPrio,
    required _i2.CacheInfo global,
  }) = _CachesInfo;

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

  CachesInfo copyWith({
    _i2.CacheInfo? local,
    _i2.CacheInfo? localPrio,
    _i2.CacheInfo? global,
  });

  /// Information about the local cache.
  _i2.CacheInfo get local;

  /// Information about the local priority cache.
  _i2.CacheInfo get localPrio;

  /// Information about the global cache.
  _i2.CacheInfo get global;
}

/// High level information about the caches.
class _CachesInfo extends CachesInfo {
  const _CachesInfo({
    required this.local,
    required this.localPrio,
    required this.global,
  }) : super._();

  /// Information about the local cache.
  @override
  final _i2.CacheInfo local;

  /// Information about the local priority cache.
  @override
  final _i2.CacheInfo localPrio;

  /// Information about the global cache.
  @override
  final _i2.CacheInfo global;

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

  @override
  CachesInfo copyWith({
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

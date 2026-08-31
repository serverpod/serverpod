/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod/src/generated/protocol.dart' as _ic00rqxb;
import 'cache_info.dart' as _ihncus9g;

/// High level information about the caches.
abstract class CachesInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CachesInfo._({
    required this.local,
    required this.localPrio,
    required this.global,
  });

  factory CachesInfo({
    required _ihncus9g.CacheInfo local,
    required _ihncus9g.CacheInfo localPrio,
    required _ihncus9g.CacheInfo global,
  }) = _CachesInfoImpl;

  factory CachesInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return CachesInfo(
      local: _ic00rqxb.Protocol().deserialize<_ihncus9g.CacheInfo>(
        jsonSerialization['local'],
      ),
      localPrio: _ic00rqxb.Protocol().deserialize<_ihncus9g.CacheInfo>(
        jsonSerialization['localPrio'],
      ),
      global: _ic00rqxb.Protocol().deserialize<_ihncus9g.CacheInfo>(
        jsonSerialization['global'],
      ),
    );
  }

  /// Information about the local cache.
  _ihncus9g.CacheInfo local;

  /// Information about the local priority cache.
  _ihncus9g.CacheInfo localPrio;

  /// Information about the global cache.
  _ihncus9g.CacheInfo global;

  /// Returns a shallow copy of this [CachesInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CachesInfo copyWith({
    _ihncus9g.CacheInfo? local,
    _ihncus9g.CacheInfo? localPrio,
    _ihncus9g.CacheInfo? global,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.CachesInfo',
      'local': local.toJson(),
      'localPrio': localPrio.toJson(),
      'global': global.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.CachesInfo',
      'local': local.toJsonForProtocol(),
      'localPrio': localPrio.toJsonForProtocol(),
      'global': global.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _CachesInfoImpl extends CachesInfo {
  _CachesInfoImpl({
    required _ihncus9g.CacheInfo local,
    required _ihncus9g.CacheInfo localPrio,
    required _ihncus9g.CacheInfo global,
  }) : super._(
         local: local,
         localPrio: localPrio,
         global: global,
       );

  /// Returns a shallow copy of this [CachesInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CachesInfo copyWith({
    _ihncus9g.CacheInfo? local,
    _ihncus9g.CacheInfo? localPrio,
    _ihncus9g.CacheInfo? global,
  }) {
    return CachesInfo(
      local: local ?? this.local.copyWith(),
      localPrio: localPrio ?? this.localPrio.copyWith(),
      global: global ?? this.global.copyWith(),
    );
  }
}

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
import 'push_platform.dart' as _igl09s3h;

/// A device address for a single send request.
abstract class PushDeviceTarget
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PushDeviceTarget._({
    required this.provider,
    required this.credential,
    required this.platform,
  });

  factory PushDeviceTarget({
    required String provider,
    required String credential,
    required _igl09s3h.PushPlatform platform,
  }) = _PushDeviceTargetImpl;

  factory PushDeviceTarget.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushDeviceTarget(
      provider: jsonSerialization['provider'] as String,
      credential: jsonSerialization['credential'] as String,
      platform: _igl09s3h.PushPlatform.fromJson(
        (jsonSerialization['platform'] as String),
      ),
    );
  }

  String provider;

  /// Opaque provider credential, used for sending. FCM/APNs: the device token.
  /// Web Push: the JSON-encoded subscription (endpoint + p256dh + auth).
  String credential;

  _igl09s3h.PushPlatform platform;

  /// Returns a shallow copy of this [PushDeviceTarget]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PushDeviceTarget copyWith({
    String? provider,
    String? credential,
    _igl09s3h.PushPlatform? platform,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_push_core.PushDeviceTarget',
      'provider': provider,
      'credential': credential,
      'platform': platform.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_push_core.PushDeviceTarget',
      'provider': provider,
      'credential': credential,
      'platform': platform.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PushDeviceTargetImpl extends PushDeviceTarget {
  _PushDeviceTargetImpl({
    required String provider,
    required String credential,
    required _igl09s3h.PushPlatform platform,
  }) : super._(
         provider: provider,
         credential: credential,
         platform: platform,
       );

  /// Returns a shallow copy of this [PushDeviceTarget]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PushDeviceTarget copyWith({
    String? provider,
    String? credential,
    _igl09s3h.PushPlatform? platform,
  }) {
    return PushDeviceTarget(
      provider: provider ?? this.provider,
      credential: credential ?? this.credential,
      platform: platform ?? this.platform,
    );
  }
}

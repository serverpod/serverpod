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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class LegacyUserSettingsConfig implements _i1.SerializableModel {
  LegacyUserSettingsConfig._({
    required this.canSeeUserName,
    required this.canSeeFullName,
    required this.canEditUserName,
    required this.canEditFullName,
    required this.canEditUserImage,
  });

  factory LegacyUserSettingsConfig({
    required bool canSeeUserName,
    required bool canSeeFullName,
    required bool canEditUserName,
    required bool canEditFullName,
    required bool canEditUserImage,
  }) = _LegacyUserSettingsConfigImpl;

  factory LegacyUserSettingsConfig.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return LegacyUserSettingsConfig(
      canSeeUserName: jsonSerialization['canSeeUserName'] as bool,
      canSeeFullName: jsonSerialization['canSeeFullName'] as bool,
      canEditUserName: jsonSerialization['canEditUserName'] as bool,
      canEditFullName: jsonSerialization['canEditFullName'] as bool,
      canEditUserImage: jsonSerialization['canEditUserImage'] as bool,
    );
  }

  bool canSeeUserName;

  bool canSeeFullName;

  bool canEditUserName;

  bool canEditFullName;

  bool canEditUserImage;

  /// Returns a shallow copy of this [LegacyUserSettingsConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LegacyUserSettingsConfig copyWith({
    bool? canSeeUserName,
    bool? canSeeFullName,
    bool? canEditUserName,
    bool? canEditFullName,
    bool? canEditUserImage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_bridge.LegacyUserSettingsConfig',
      'canSeeUserName': canSeeUserName,
      'canSeeFullName': canSeeFullName,
      'canEditUserName': canEditUserName,
      'canEditFullName': canEditFullName,
      'canEditUserImage': canEditUserImage,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _LegacyUserSettingsConfigImpl extends LegacyUserSettingsConfig {
  _LegacyUserSettingsConfigImpl({
    required bool canSeeUserName,
    required bool canSeeFullName,
    required bool canEditUserName,
    required bool canEditFullName,
    required bool canEditUserImage,
  }) : super._(
         canSeeUserName: canSeeUserName,
         canSeeFullName: canSeeFullName,
         canEditUserName: canEditUserName,
         canEditFullName: canEditFullName,
         canEditUserImage: canEditUserImage,
       );

  /// Returns a shallow copy of this [LegacyUserSettingsConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LegacyUserSettingsConfig copyWith({
    bool? canSeeUserName,
    bool? canSeeFullName,
    bool? canEditUserName,
    bool? canEditFullName,
    bool? canEditUserImage,
  }) {
    return LegacyUserSettingsConfig(
      canSeeUserName: canSeeUserName ?? this.canSeeUserName,
      canSeeFullName: canSeeFullName ?? this.canSeeFullName,
      canEditUserName: canEditUserName ?? this.canEditUserName,
      canEditFullName: canEditFullName ?? this.canEditFullName,
      canEditUserImage: canEditUserImage ?? this.canEditUserImage,
    );
  }
}

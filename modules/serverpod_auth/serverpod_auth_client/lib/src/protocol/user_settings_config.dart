/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// User settings.
abstract class UserSettingsConfig extends _i1.SerializableEntity {
  UserSettingsConfig._({
    required this.canSeeUserName,
    required this.canSeeFullName,
    required this.canEditUserName,
    required this.canEditFullName,
    required this.canEditUserImage,
  });

  factory UserSettingsConfig({
    required bool canSeeUserName,
    required bool canSeeFullName,
    required bool canEditUserName,
    required bool canEditFullName,
    required bool canEditUserImage,
  }) = _UserSettingsConfigImpl;

  factory UserSettingsConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserSettingsConfig(
      canSeeUserName: jsonSerialization['canSeeUserName'] as bool,
      canSeeFullName: jsonSerialization['canSeeFullName'] as bool,
      canEditUserName: jsonSerialization['canEditUserName'] as bool,
      canEditFullName: jsonSerialization['canEditFullName'] as bool,
      canEditUserImage: jsonSerialization['canEditUserImage'] as bool,
    );
  }

  /// True if the user's nickname should be visible.
  bool canSeeUserName;

  /// True if the user's full name should be visible.
  bool canSeeFullName;

  /// True if the user should be able to edit its user name.
  bool canEditUserName;

  /// True if the user should be able to edit its full name.
  bool canEditFullName;

  /// True if the user should be able to upload a new user image.
  bool canEditUserImage;

  UserSettingsConfig copyWith({
    bool? canSeeUserName,
    bool? canSeeFullName,
    bool? canEditUserName,
    bool? canEditFullName,
    bool? canEditUserImage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'canSeeUserName': canSeeUserName,
      'canSeeFullName': canSeeFullName,
      'canEditUserName': canEditUserName,
      'canEditFullName': canEditFullName,
      'canEditUserImage': canEditUserImage,
    };
  }
}

class _UserSettingsConfigImpl extends UserSettingsConfig {
  _UserSettingsConfigImpl({
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

  @override
  UserSettingsConfig copyWith({
    bool? canSeeUserName,
    bool? canSeeFullName,
    bool? canEditUserName,
    bool? canEditFullName,
    bool? canEditUserImage,
  }) {
    return UserSettingsConfig(
      canSeeUserName: canSeeUserName ?? this.canSeeUserName,
      canSeeFullName: canSeeFullName ?? this.canSeeFullName,
      canEditUserName: canEditUserName ?? this.canEditUserName,
      canEditFullName: canEditFullName ?? this.canEditFullName,
      canEditUserImage: canEditUserImage ?? this.canEditUserImage,
    );
  }
}

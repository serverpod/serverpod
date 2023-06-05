/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class _Undefined {}

/// User settings.
class UserSettingsConfig extends _i1.SerializableEntity {
  UserSettingsConfig({
    required this.canSeeUserName,
    required this.canSeeFullName,
    required this.canEditUserName,
    required this.canEditFullName,
    required this.canEditUserImage,
  });

  factory UserSettingsConfig.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserSettingsConfig(
      canSeeUserName: serializationManager
          .deserialize<bool>(jsonSerialization['canSeeUserName']),
      canSeeFullName: serializationManager
          .deserialize<bool>(jsonSerialization['canSeeFullName']),
      canEditUserName: serializationManager
          .deserialize<bool>(jsonSerialization['canEditUserName']),
      canEditFullName: serializationManager
          .deserialize<bool>(jsonSerialization['canEditFullName']),
      canEditUserImage: serializationManager
          .deserialize<bool>(jsonSerialization['canEditUserImage']),
    );
  }

  /// True if the user's nickname should be visible.
  final bool canSeeUserName;

  /// True if the user's full name should be visible.
  final bool canSeeFullName;

  /// True if the user should be able to edit its user name.
  final bool canEditUserName;

  /// True if the user should be able to edit its full name.
  final bool canEditFullName;

  /// True if the user should be able to upload a new user image.
  final bool canEditUserImage;

  late Function({
    bool? canSeeUserName,
    bool? canSeeFullName,
    bool? canEditUserName,
    bool? canEditFullName,
    bool? canEditUserImage,
  }) copyWith = _copyWith;

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

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is UserSettingsConfig &&
            (identical(
                  other.canSeeUserName,
                  canSeeUserName,
                ) ||
                other.canSeeUserName == canSeeUserName) &&
            (identical(
                  other.canSeeFullName,
                  canSeeFullName,
                ) ||
                other.canSeeFullName == canSeeFullName) &&
            (identical(
                  other.canEditUserName,
                  canEditUserName,
                ) ||
                other.canEditUserName == canEditUserName) &&
            (identical(
                  other.canEditFullName,
                  canEditFullName,
                ) ||
                other.canEditFullName == canEditFullName) &&
            (identical(
                  other.canEditUserImage,
                  canEditUserImage,
                ) ||
                other.canEditUserImage == canEditUserImage));
  }

  @override
  int get hashCode => Object.hash(
        canSeeUserName,
        canSeeFullName,
        canEditUserName,
        canEditFullName,
        canEditUserImage,
      );

  UserSettingsConfig _copyWith({
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

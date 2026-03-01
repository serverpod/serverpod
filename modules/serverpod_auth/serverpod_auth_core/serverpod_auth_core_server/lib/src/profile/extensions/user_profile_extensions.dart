import 'package:serverpod_auth_core_server/src/generated/protocol.dart';

/// Extensions for [UserProfile].
extension UserProfileMerge on UserProfile {
  /// Merges fields from [other] into this [UserProfile] if they are null or empty
  /// in this profile but present in [other].
  ///
  /// No database save is performed, so these changes are not persisted until
  /// calling code saves the value returned by `UserProfile.merge()`.
  ///
  /// Fields considered:
  /// - userName
  /// - fullName
  /// - email
  /// - imageId
  UserProfile merge(final UserProfile other) {
    return copyWith(
      userName: _mergeString(userName, other.userName),
      fullName: _mergeString(fullName, other.fullName),
      email: _mergeString(email, other.email),
      imageId: imageId ?? other.imageId,
    );
  }

  String? _mergeString(final String? original, final String? candidate) {
    if (original != null && original.isNotEmpty) {
      return original;
    }
    if (candidate != null && candidate.isNotEmpty) {
      return candidate;
    }
    return original;
  }
}

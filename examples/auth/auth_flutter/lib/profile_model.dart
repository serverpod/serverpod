import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

extension XUserProfileModel on UserProfileModel? {
  String get display {
    return this?.fullName ?? this?.userName ?? this?.email ?? 'New user';
  }
}

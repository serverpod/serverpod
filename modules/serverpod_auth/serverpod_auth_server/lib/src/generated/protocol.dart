/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unnecessary_import

library protocol;

// ignore: unused_import
import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';

import 'apple_auth_info.dart';
import 'authentication_fail_reason.dart';
import 'authentication_response.dart';
import 'email_auth.dart';
import 'email_create_account_request.dart';
import 'email_failed_sign_in.dart';
import 'email_password_reset.dart';
import 'email_reset.dart';
import 'google_refresh_token.dart';
import 'user_image.dart';
import 'user_info.dart';
import 'user_settings_config.dart';

export 'apple_auth_info.dart';
export 'authentication_fail_reason.dart';
export 'authentication_response.dart';
export 'email_auth.dart';
export 'email_create_account_request.dart';
export 'email_failed_sign_in.dart';
export 'email_password_reset.dart';
export 'email_reset.dart';
export 'google_refresh_token.dart';
export 'user_image.dart';
export 'user_info.dart';
export 'user_settings_config.dart';

class Protocol extends SerializationManagerServer {
  static final Protocol instance = Protocol();

  final Map<String, constructor> _constructors = {};
  @override
  Map<String, constructor> get constructors => _constructors;

  final Map<String, String> _tableClassMapping = {};
  @override
  Map<String, String> get tableClassMapping => _tableClassMapping;

  final Map<Type, Table> _typeTableMapping = {};
  @override
  Map<Type, Table> get typeTableMapping => _typeTableMapping;

  Protocol() {
    constructors['serverpod_auth_server.AppleAuthInfo'] =
        (Map<String, dynamic> serialization) =>
            AppleAuthInfo.fromSerialization(serialization);
    constructors['serverpod_auth_server.AuthenticationFailReason'] =
        (Map<String, dynamic> serialization) =>
            AuthenticationFailReason.fromSerialization(serialization);
    constructors['serverpod_auth_server.AuthenticationResponse'] =
        (Map<String, dynamic> serialization) =>
            AuthenticationResponse.fromSerialization(serialization);
    constructors['serverpod_auth_server.EmailAuth'] =
        (Map<String, dynamic> serialization) =>
            EmailAuth.fromSerialization(serialization);
    constructors['serverpod_auth_server.EmailCreateAccountRequest'] =
        (Map<String, dynamic> serialization) =>
            EmailCreateAccountRequest.fromSerialization(serialization);
    constructors['serverpod_auth_server.EmailFailedSignIn'] =
        (Map<String, dynamic> serialization) =>
            EmailFailedSignIn.fromSerialization(serialization);
    constructors['serverpod_auth_server.EmailPasswordReset'] =
        (Map<String, dynamic> serialization) =>
            EmailPasswordReset.fromSerialization(serialization);
    constructors['serverpod_auth_server.EmailReset'] =
        (Map<String, dynamic> serialization) =>
            EmailReset.fromSerialization(serialization);
    constructors['serverpod_auth_server.GoogleRefreshToken'] =
        (Map<String, dynamic> serialization) =>
            GoogleRefreshToken.fromSerialization(serialization);
    constructors['serverpod_auth_server.UserImage'] =
        (Map<String, dynamic> serialization) =>
            UserImage.fromSerialization(serialization);
    constructors['serverpod_auth_server.UserInfo'] =
        (Map<String, dynamic> serialization) =>
            UserInfo.fromSerialization(serialization);
    constructors['serverpod_auth_server.UserSettingsConfig'] =
        (Map<String, dynamic> serialization) =>
            UserSettingsConfig.fromSerialization(serialization);

    tableClassMapping['serverpod_email_auth'] =
        'serverpod_auth_server.EmailAuth';
    typeTableMapping[EmailAuth] = EmailAuth.t;
    tableClassMapping['serverpod_email_create_request'] =
        'serverpod_auth_server.EmailCreateAccountRequest';
    typeTableMapping[EmailCreateAccountRequest] = EmailCreateAccountRequest.t;
    tableClassMapping['serverpod_email_failed_sign_in'] =
        'serverpod_auth_server.EmailFailedSignIn';
    typeTableMapping[EmailFailedSignIn] = EmailFailedSignIn.t;
    tableClassMapping['serverpod_email_reset'] =
        'serverpod_auth_server.EmailReset';
    typeTableMapping[EmailReset] = EmailReset.t;
    tableClassMapping['serverpod_google_refresh_token'] =
        'serverpod_auth_server.GoogleRefreshToken';
    typeTableMapping[GoogleRefreshToken] = GoogleRefreshToken.t;
    tableClassMapping['serverpod_user_image'] =
        'serverpod_auth_server.UserImage';
    typeTableMapping[UserImage] = UserImage.t;
    tableClassMapping['serverpod_user_info'] = 'serverpod_auth_server.UserInfo';
    typeTableMapping[UserInfo] = UserInfo.t;
  }
}

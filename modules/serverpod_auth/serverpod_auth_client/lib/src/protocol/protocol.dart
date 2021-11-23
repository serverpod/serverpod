/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs

library protocol;

// ignore: unused_import
import 'dart:typed_data';
import 'package:serverpod_client/serverpod_client.dart';

import 'user_settings_config.dart';
import 'user_info.dart';
import 'email_auth.dart';
import 'email_reset.dart';
import 'authentication_response.dart';
import 'user_image.dart';
import 'apple_auth_info.dart';
import 'email_password_reset.dart';

export 'user_settings_config.dart';
export 'user_info.dart';
export 'email_auth.dart';
export 'email_reset.dart';
export 'authentication_response.dart';
export 'user_image.dart';
export 'apple_auth_info.dart';
export 'email_password_reset.dart';
export 'client.dart';

class Protocol extends SerializationManager {
  static final Protocol instance = Protocol();

  final Map<String, constructor> _constructors = {};
  @override
  Map<String, constructor> get constructors => _constructors;
  final Map<String,String> _tableClassMapping = {};
  @override
  Map<String,String> get tableClassMapping => _tableClassMapping;

  Protocol() {
    constructors['serverpod_auth_server.UserSettingsConfig'] = (Map<String, dynamic> serialization) => UserSettingsConfig.fromSerialization(serialization);
    constructors['serverpod_auth_server.UserInfo'] = (Map<String, dynamic> serialization) => UserInfo.fromSerialization(serialization);
    constructors['serverpod_auth_server.EmailAuth'] = (Map<String, dynamic> serialization) => EmailAuth.fromSerialization(serialization);
    constructors['serverpod_auth_server.EmailReset'] = (Map<String, dynamic> serialization) => EmailReset.fromSerialization(serialization);
    constructors['serverpod_auth_server.AuthenticationResponse'] = (Map<String, dynamic> serialization) => AuthenticationResponse.fromSerialization(serialization);
    constructors['serverpod_auth_server.UserImage'] = (Map<String, dynamic> serialization) => UserImage.fromSerialization(serialization);
    constructors['serverpod_auth_server.AppleAuthInfo'] = (Map<String, dynamic> serialization) => AppleAuthInfo.fromSerialization(serialization);
    constructors['serverpod_auth_server.EmailPasswordReset'] = (Map<String, dynamic> serialization) => EmailPasswordReset.fromSerialization(serialization);
  }
}

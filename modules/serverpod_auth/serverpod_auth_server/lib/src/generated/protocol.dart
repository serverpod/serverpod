/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs

library protocol;

import 'package:serverpod/serverpod.dart';

import 'user_info.dart';
import 'authentication_response.dart';

export 'user_info.dart';
export 'authentication_response.dart';

class Protocol extends SerializationManager {
  static final Protocol instance = Protocol();

  final Map<String, constructor> _constructors = {};
  @override
  Map<String, constructor> get constructors => _constructors;
  final Map<String,String> _tableClassMapping = {};
  @override
  Map<String,String> get tableClassMapping => _tableClassMapping;

  Protocol() {
    constructors['serverpod_auth_server.UserInfo'] = (Map<String, dynamic> serialization) => UserInfo.fromSerialization(serialization);
    constructors['serverpod_auth_server.AuthenticationResponse'] = (Map<String, dynamic> serialization) => AuthenticationResponse.fromSerialization(serialization);

    tableClassMapping['serverpod_user_info'] = 'serverpod_auth_server.UserInfo';
  }
}

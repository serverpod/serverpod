/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'dart:io';
import 'dart:typed_data' as typed_data;
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

class _EndpointApple {
  EndpointCaller caller;
  _EndpointApple(this.caller);

  Future<AuthenticationResponse> authenticate(AppleAuthInfo authInfo,) async {
    return await caller.callServerEndpoint('serverpod_auth.apple', 'authenticate', 'AuthenticationResponse', {
      'authInfo':authInfo,
    });
  }
}

class _EndpointGoogle {
  EndpointCaller caller;
  _EndpointGoogle(this.caller);

  Future<AuthenticationResponse> authenticate(String authenticationCode,) async {
    return await caller.callServerEndpoint('serverpod_auth.google', 'authenticate', 'AuthenticationResponse', {
      'authenticationCode':authenticationCode,
    });
  }
}

class _EndpointUser {
  EndpointCaller caller;
  _EndpointUser(this.caller);

  Future<bool> removeUserImage() async {
    return await caller.callServerEndpoint('serverpod_auth.user', 'removeUserImage', 'bool', {
    });
  }

  Future<bool> setUserImage(typed_data.ByteData image,) async {
    return await caller.callServerEndpoint('serverpod_auth.user', 'setUserImage', 'bool', {
      'image':image,
    });
  }
}

class _EndpointStatus {
  EndpointCaller caller;
  _EndpointStatus(this.caller);

  Future<bool> isSignedIn() async {
    return await caller.callServerEndpoint('serverpod_auth.status', 'isSignedIn', 'bool', {
    });
  }

  Future<void> signOut() async {
    return await caller.callServerEndpoint('serverpod_auth.status', 'signOut', 'void', {
    });
  }

  Future<UserInfo?> getUserInfo() async {
    return await caller.callServerEndpoint('serverpod_auth.status', 'getUserInfo', 'UserInfo', {
    });
  }

  Future<UserSettingsConfig> getUserSettingsConfig() async {
    return await caller.callServerEndpoint('serverpod_auth.status', 'getUserSettingsConfig', 'UserSettingsConfig', {
    });
  }
}

class Caller extends ModuleEndpointCaller {
  late final _EndpointApple apple;
  late final _EndpointGoogle google;
  late final _EndpointUser user;
  late final _EndpointStatus status;

  Caller(ServerpodClientShared client) : super(client) {
    apple = _EndpointApple(this);
    google = _EndpointGoogle(this);
    user = _EndpointUser(this);
    status = _EndpointStatus(this);
  }
}

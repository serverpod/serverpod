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

  Future<bool> isSignedIn() async {
    return await caller.callServerEndpoint('serverpod_auth.user', 'isSignedIn', 'bool', {
    });
  }

  Future<void> signOut() async {
    return await caller.callServerEndpoint('serverpod_auth.user', 'signOut', 'void', {
    });
  }

  Future<UserInfo?> getAuthenticatedUserInfo() async {
    return await caller.callServerEndpoint('serverpod_auth.user', 'getAuthenticatedUserInfo', 'UserInfo', {
    });
  }

  Future<bool> updateUserInfo(UserInfo userInfo,) async {
    return await caller.callServerEndpoint('serverpod_auth.user', 'updateUserInfo', 'bool', {
      'userInfo':userInfo,
    });
  }

  Future<bool> removeUserImage() async {
    return await caller.callServerEndpoint('serverpod_auth.user', 'removeUserImage', 'bool', {
    });
  }
}

class Caller extends ModuleEndpointCaller {
  late final _EndpointApple apple;
  late final _EndpointGoogle google;
  late final _EndpointUser user;

  Caller(ServerpodClientShared client) : super(client) {
    apple = _EndpointApple(this);
    google = _EndpointGoogle(this);
    user = _EndpointUser(this);
  }
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'dart:io';
import 'dart:typed_data' as typed_data;
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

class _EndpointApple extends EndpointRef {
  @override
  String get name => 'serverpod_auth.apple';

  _EndpointApple(EndpointCaller caller) : super(caller);

  Future<AuthenticationResponse> authenticate(AppleAuthInfo authInfo,) async {
    return await caller.callServerEndpoint('serverpod_auth.apple', 'authenticate', 'AuthenticationResponse', {
      'authInfo':authInfo,
    });
  }
}

class _EndpointEmail extends EndpointRef {
  @override
  String get name => 'serverpod_auth.email';

  _EndpointEmail(EndpointCaller caller) : super(caller);

  Future<AuthenticationResponse> authenticate(String email,String password,) async {
    return await caller.callServerEndpoint('serverpod_auth.email', 'authenticate', 'AuthenticationResponse', {
      'email':email,
      'password':password,
    });
  }

  Future<bool> changePassword(String oldPassword,String newPassword,) async {
    return await caller.callServerEndpoint('serverpod_auth.email', 'changePassword', 'bool', {
      'oldPassword':oldPassword,
      'newPassword':newPassword,
    });
  }

  Future<bool> initiatePasswordReset(String email,) async {
    return await caller.callServerEndpoint('serverpod_auth.email', 'initiatePasswordReset', 'bool', {
      'email':email,
    });
  }

  Future<EmailPasswordReset?> verifyEmailPasswordReset(String verificationCode,) async {
    return await caller.callServerEndpoint('serverpod_auth.email', 'verifyEmailPasswordReset', 'EmailPasswordReset', {
      'verificationCode':verificationCode,
    });
  }

  Future<bool> resetPassword(String verificationCode,String password,) async {
    return await caller.callServerEndpoint('serverpod_auth.email', 'resetPassword', 'bool', {
      'verificationCode':verificationCode,
      'password':password,
    });
  }
}

class _EndpointGoogle extends EndpointRef {
  @override
  String get name => 'serverpod_auth.google';

  _EndpointGoogle(EndpointCaller caller) : super(caller);

  Future<AuthenticationResponse> authenticate(String authenticationCode,) async {
    return await caller.callServerEndpoint('serverpod_auth.google', 'authenticate', 'AuthenticationResponse', {
      'authenticationCode':authenticationCode,
    });
  }
}

class _EndpointUser extends EndpointRef {
  @override
  String get name => 'serverpod_auth.user';

  _EndpointUser(EndpointCaller caller) : super(caller);

  Future<bool> removeUserImage() async {
    return await caller.callServerEndpoint('serverpod_auth.user', 'removeUserImage', 'bool', {
    });
  }

  Future<bool> setUserImage(typed_data.ByteData image,) async {
    return await caller.callServerEndpoint('serverpod_auth.user', 'setUserImage', 'bool', {
      'image':image,
    });
  }

  Future<bool> changeUserName(String userName,) async {
    return await caller.callServerEndpoint('serverpod_auth.user', 'changeUserName', 'bool', {
      'userName':userName,
    });
  }
}

class _EndpointStatus extends EndpointRef {
  @override
  String get name => 'serverpod_auth.status';

  _EndpointStatus(EndpointCaller caller) : super(caller);

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

class _EndpointAdmin extends EndpointRef {
  @override
  String get name => 'serverpod_auth.admin';

  _EndpointAdmin(EndpointCaller caller) : super(caller);

  Future<UserInfo?> getUserInfo(int userId,) async {
    return await caller.callServerEndpoint('serverpod_auth.admin', 'getUserInfo', 'UserInfo', {
      'userId':userId,
    });
  }
}

class Caller extends ModuleEndpointCaller {
  late final _EndpointApple apple;
  late final _EndpointEmail email;
  late final _EndpointGoogle google;
  late final _EndpointUser user;
  late final _EndpointStatus status;
  late final _EndpointAdmin admin;

  Caller(ServerpodClientShared client) : super(client) {
    apple = _EndpointApple(this);
    email = _EndpointEmail(this);
    google = _EndpointGoogle(this);
    user = _EndpointUser(this);
    status = _EndpointStatus(this);
    admin = _EndpointAdmin(this);
  }

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
    'serverpod_auth.apple' : apple,
    'serverpod_auth.email' : email,
    'serverpod_auth.google' : google,
    'serverpod_auth.user' : user,
    'serverpod_auth.status' : status,
    'serverpod_auth.admin' : admin,
  };
}

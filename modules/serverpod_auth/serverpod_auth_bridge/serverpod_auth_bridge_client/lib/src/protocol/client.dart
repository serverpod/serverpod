/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_auth_bridge_client/src/protocol/legacy_authentication_response.dart'
    as _i3;
import 'package:serverpod_auth_bridge_client/src/protocol/legacy_user_info.dart'
    as _i4;
import 'package:serverpod_auth_bridge_client/src/protocol/legacy_user_settings_config.dart'
    as _i5;
import 'dart:typed_data' as _i6;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i7;

/// Stub endpoint for legacy admin operations. Requires admin scope.
/// {@category Endpoint}
class EndpointLegacyAdmin extends _i1.EndpointRef {
  EndpointLegacyAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_bridge.legacyAdmin';
}

/// Stub endpoint for legacy Apple authentication. Always returns an error
/// because social auth is not supported via the bridge.
/// {@category Endpoint}
class EndpointLegacyApple extends _i1.EndpointRef {
  EndpointLegacyApple(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_bridge.legacyApple';

  /// Stub — Apple authentication is not supported.
  _i2.Future<_i3.LegacyAuthenticationResponse> authenticate(
    Map<String, dynamic> authInfo,
  ) => caller.callServerEndpoint<_i3.LegacyAuthenticationResponse>(
    'serverpod_auth_bridge.legacyApple',
    'authenticate',
    {'authInfo': authInfo},
  );
}

/// Proxy endpoint that handles legacy email authentication requests from old
/// clients (pre-migration). Delegates to the new auth system internally.
/// {@category Endpoint}
class EndpointLegacyEmail extends _i1.EndpointRef {
  EndpointLegacyEmail(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_bridge.legacyEmail';

  /// Authenticates a user with email and password, returning a legacy-format
  /// response with session key and user info.
  _i2.Future<_i3.LegacyAuthenticationResponse> authenticate(
    String email,
    String password,
  ) => caller.callServerEndpoint<_i3.LegacyAuthenticationResponse>(
    'serverpod_auth_bridge.legacyEmail',
    'authenticate',
    {
      'email': email,
      'password': password,
    },
  );

  /// Stub — registration is not supported via legacy endpoints.
  _i2.Future<bool> createAccountRequest(
    String userName,
    String email,
    String password,
  ) => caller.callServerEndpoint<bool>(
    'serverpod_auth_bridge.legacyEmail',
    'createAccountRequest',
    {
      'userName': userName,
      'email': email,
      'password': password,
    },
  );

  /// Stub — account creation is not supported via legacy endpoints.
  _i2.Future<_i4.LegacyUserInfo?> createAccount(
    String email,
    String verificationCode,
  ) => caller.callServerEndpoint<_i4.LegacyUserInfo?>(
    'serverpod_auth_bridge.legacyEmail',
    'createAccount',
    {
      'email': email,
      'verificationCode': verificationCode,
    },
  );

  /// Stub — password change is not supported via legacy endpoints.
  _i2.Future<bool> changePassword(
    String oldPassword,
    String newPassword,
  ) => caller.callServerEndpoint<bool>(
    'serverpod_auth_bridge.legacyEmail',
    'changePassword',
    {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    },
  );

  /// Stub — password reset initiation is not supported via legacy endpoints.
  _i2.Future<bool> initiatePasswordReset(String email) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth_bridge.legacyEmail',
        'initiatePasswordReset',
        {'email': email},
      );

  /// Stub — password reset is not supported via legacy endpoints.
  _i2.Future<bool> resetPassword(
    String verificationCode,
    String password,
  ) => caller.callServerEndpoint<bool>(
    'serverpod_auth_bridge.legacyEmail',
    'resetPassword',
    {
      'verificationCode': verificationCode,
      'password': password,
    },
  );
}

/// Stub endpoint for legacy Firebase authentication. Always returns an error
/// because social auth is not supported via the bridge.
/// {@category Endpoint}
class EndpointLegacyFirebase extends _i1.EndpointRef {
  EndpointLegacyFirebase(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_bridge.legacyFirebase';

  /// Stub — Firebase authentication is not supported.
  _i2.Future<_i3.LegacyAuthenticationResponse> authenticate(String idToken) =>
      caller.callServerEndpoint<_i3.LegacyAuthenticationResponse>(
        'serverpod_auth_bridge.legacyFirebase',
        'authenticate',
        {'idToken': idToken},
      );
}

/// Stub endpoint for legacy Google authentication. Always returns an error
/// because social auth is not supported via the bridge.
/// {@category Endpoint}
class EndpointLegacyGoogle extends _i1.EndpointRef {
  EndpointLegacyGoogle(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_bridge.legacyGoogle';

  /// Stub — Google server auth code authentication is not supported.
  _i2.Future<_i3.LegacyAuthenticationResponse> authenticateWithServerAuthCode(
    String authenticationCode,
    String? redirectUri,
  ) => caller.callServerEndpoint<_i3.LegacyAuthenticationResponse>(
    'serverpod_auth_bridge.legacyGoogle',
    'authenticateWithServerAuthCode',
    {
      'authenticationCode': authenticationCode,
      'redirectUri': redirectUri,
    },
  );

  /// Stub — Google ID token authentication is not supported.
  _i2.Future<_i3.LegacyAuthenticationResponse> authenticateWithIdToken(
    String idToken,
  ) => caller.callServerEndpoint<_i3.LegacyAuthenticationResponse>(
    'serverpod_auth_bridge.legacyGoogle',
    'authenticateWithIdToken',
    {'idToken': idToken},
  );
}

/// Proxy endpoint for legacy session status operations (sign-in check,
/// sign-out, user info retrieval).
/// {@category Endpoint}
class EndpointLegacyStatus extends _i1.EndpointRef {
  EndpointLegacyStatus(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_bridge.legacyStatus';

  /// Returns whether the current session is authenticated.
  _i2.Future<bool> isSignedIn() => caller.callServerEndpoint<bool>(
    'serverpod_auth_bridge.legacyStatus',
    'isSignedIn',
    {},
  );

  /// Signs out the current device by deleting the legacy session.
  _i2.Future<void> signOutDevice() => caller.callServerEndpoint<void>(
    'serverpod_auth_bridge.legacyStatus',
    'signOutDevice',
    {},
  );

  /// Signs out all devices by deleting all legacy sessions for the user.
  _i2.Future<void> signOutAllDevices() => caller.callServerEndpoint<void>(
    'serverpod_auth_bridge.legacyStatus',
    'signOutAllDevices',
    {},
  );

  /// Returns legacy-format user info for the authenticated user.
  _i2.Future<_i4.LegacyUserInfo?> getUserInfo() =>
      caller.callServerEndpoint<_i4.LegacyUserInfo?>(
        'serverpod_auth_bridge.legacyStatus',
        'getUserInfo',
        {},
      );

  /// Returns a static user settings configuration for legacy clients.
  ///
  /// This mirrors the capabilities supported by the bridge's legacy endpoints,
  /// so clients can show settings that are actually available.
  _i2.Future<_i5.LegacyUserSettingsConfig> getUserSettingsConfig() =>
      caller.callServerEndpoint<_i5.LegacyUserSettingsConfig>(
        'serverpod_auth_bridge.legacyStatus',
        'getUserSettingsConfig',
        {},
      );
}

/// Proxy endpoint for legacy user profile operations (image, name changes).
/// {@category Endpoint}
class EndpointLegacyUser extends _i1.EndpointRef {
  EndpointLegacyUser(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_bridge.legacyUser';

  /// Removes the user's profile image.
  _i2.Future<bool> removeUserImage() => caller.callServerEndpoint<bool>(
    'serverpod_auth_bridge.legacyUser',
    'removeUserImage',
    {},
  );

  /// Sets the user's profile image from binary data.
  _i2.Future<bool> setUserImage(_i6.ByteData image) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth_bridge.legacyUser',
        'setUserImage',
        {'image': image},
      );

  /// Changes the user's display name.
  _i2.Future<bool> changeUserName(String userName) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth_bridge.legacyUser',
        'changeUserName',
        {'userName': userName},
      );

  /// Changes the user's full name.
  _i2.Future<bool> changeFullName(String fullName) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth_bridge.legacyUser',
        'changeFullName',
        {'fullName': fullName},
      );
}

/// Endpoint to convert legacy sessions.
/// {@category Endpoint}
class EndpointSessionMigration extends _i1.EndpointRef {
  EndpointSessionMigration(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_bridge.sessionMigration';

  /// Converts a legacy session into a new token from the token manager.
  _i2.Future<_i7.AuthSuccess?> convertSession({required String sessionKey}) =>
      caller.callServerEndpoint<_i7.AuthSuccess?>(
        'serverpod_auth_bridge.sessionMigration',
        'convertSession',
        {'sessionKey': sessionKey},
      );
}

class Caller extends _i1.ModuleEndpointCaller {
  Caller(_i1.ServerpodClientShared client) : super(client) {
    legacyAdmin = EndpointLegacyAdmin(this);
    legacyApple = EndpointLegacyApple(this);
    legacyEmail = EndpointLegacyEmail(this);
    legacyFirebase = EndpointLegacyFirebase(this);
    legacyGoogle = EndpointLegacyGoogle(this);
    legacyStatus = EndpointLegacyStatus(this);
    legacyUser = EndpointLegacyUser(this);
    sessionMigration = EndpointSessionMigration(this);
  }

  late final EndpointLegacyAdmin legacyAdmin;

  late final EndpointLegacyApple legacyApple;

  late final EndpointLegacyEmail legacyEmail;

  late final EndpointLegacyFirebase legacyFirebase;

  late final EndpointLegacyGoogle legacyGoogle;

  late final EndpointLegacyStatus legacyStatus;

  late final EndpointLegacyUser legacyUser;

  late final EndpointSessionMigration sessionMigration;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'serverpod_auth_bridge.legacyAdmin': legacyAdmin,
    'serverpod_auth_bridge.legacyApple': legacyApple,
    'serverpod_auth_bridge.legacyEmail': legacyEmail,
    'serverpod_auth_bridge.legacyFirebase': legacyFirebase,
    'serverpod_auth_bridge.legacyGoogle': legacyGoogle,
    'serverpod_auth_bridge.legacyStatus': legacyStatus,
    'serverpod_auth_bridge.legacyUser': legacyUser,
    'serverpod_auth_bridge.sessionMigration': sessionMigration,
  };
}

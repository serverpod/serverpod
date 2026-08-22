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
import 'dart:async' as _ida;
import 'dart:typed_data' as _idt;
import 'package:serverpod_auth_bridge_client/src/protocol/legacy_authentication_response.dart'
    as _ipoqf6n1;
import 'package:serverpod_auth_bridge_client/src/protocol/legacy_user_info.dart'
    as _i72lz3dk;
import 'package:serverpod_auth_bridge_client/src/protocol/legacy_user_settings_config.dart'
    as _i028a213;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Endpoint for legacy admin operations. Requires admin scope.
/// {@category Endpoint}
class EndpointLegacyAdmin extends _isc.EndpointRef {
  EndpointLegacyAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_bridge.legacyAdmin';

  /// Finds a user by legacy user id.
  _ida.Future<_i72lz3dk.LegacyUserInfo?> getUserInfo(int userId) =>
      caller.callServerEndpoint<_i72lz3dk.LegacyUserInfo?>(
        'serverpod_auth_bridge.legacyAdmin',
        'getUserInfo',
        {'userId': userId},
      );

  /// Marks a user as blocked and revokes all tokens.
  _ida.Future<void> blockUser(int userId) => caller.callServerEndpoint<void>(
    'serverpod_auth_bridge.legacyAdmin',
    'blockUser',
    {'userId': userId},
  );

  /// Unblocks a user so that they can log in again.
  _ida.Future<void> unblockUser(int userId) => caller.callServerEndpoint<void>(
    'serverpod_auth_bridge.legacyAdmin',
    'unblockUser',
    {'userId': userId},
  );
}

/// Proxy endpoint that handles legacy email authentication requests from old
/// clients (pre-migration). Delegates to the new auth system internally.
/// {@category Endpoint}
class EndpointLegacyEmail extends _isc.EndpointRef {
  EndpointLegacyEmail(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_bridge.legacyEmail';

  /// Authenticates a user with email and password, returning a legacy-format
  /// response with session key and user info.
  _ida.Future<_ipoqf6n1.LegacyAuthenticationResponse> authenticate(
    String email,
    String password,
  ) => caller.callServerEndpoint<_ipoqf6n1.LegacyAuthenticationResponse>(
    'serverpod_auth_bridge.legacyEmail',
    'authenticate',
    {
      'email': email,
      'password': password,
    },
  );

  /// Stub - registration is not supported via legacy endpoints.
  _ida.Future<bool> createAccountRequest(
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

  /// Stub - account creation is not supported via legacy endpoints.
  _ida.Future<_i72lz3dk.LegacyUserInfo?> createAccount(
    String email,
    String verificationCode,
  ) => caller.callServerEndpoint<_i72lz3dk.LegacyUserInfo?>(
    'serverpod_auth_bridge.legacyEmail',
    'createAccount',
    {
      'email': email,
      'verificationCode': verificationCode,
    },
  );

  /// Stub - password change is not supported via legacy endpoints.
  _ida.Future<bool> changePassword(
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

  /// Stub - password reset initiation is not supported via legacy endpoints.
  _ida.Future<bool> initiatePasswordReset(String email) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth_bridge.legacyEmail',
        'initiatePasswordReset',
        {'email': email},
      );

  /// Stub - password reset is not supported via legacy endpoints.
  _ida.Future<bool> resetPassword(
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

/// Proxy endpoint for legacy session status operations (sign-in check,
/// sign-out, user info retrieval).
/// {@category Endpoint}
class EndpointLegacyStatus extends _isc.EndpointRef {
  EndpointLegacyStatus(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_bridge.legacyStatus';

  /// Returns whether the current session is authenticated.
  _ida.Future<bool> isSignedIn() => caller.callServerEndpoint<bool>(
    'serverpod_auth_bridge.legacyStatus',
    'isSignedIn',
    {},
  );

  /// Signs out the current device by deleting the legacy session.
  _ida.Future<void> signOutDevice() => caller.callServerEndpoint<void>(
    'serverpod_auth_bridge.legacyStatus',
    'signOutDevice',
    {},
  );

  /// Signs out all devices by deleting all legacy sessions for the user.
  _ida.Future<void> signOutAllDevices() => caller.callServerEndpoint<void>(
    'serverpod_auth_bridge.legacyStatus',
    'signOutAllDevices',
    {},
  );

  /// Returns legacy-format user info for the authenticated user.
  _ida.Future<_i72lz3dk.LegacyUserInfo?> getUserInfo() =>
      caller.callServerEndpoint<_i72lz3dk.LegacyUserInfo?>(
        'serverpod_auth_bridge.legacyStatus',
        'getUserInfo',
        {},
      );

  /// Returns a static user settings configuration for legacy clients.
  ///
  /// This mirrors the capabilities supported by the bridge's legacy endpoints,
  /// so clients can show settings that are actually available.
  _ida.Future<_i028a213.LegacyUserSettingsConfig> getUserSettingsConfig() =>
      caller.callServerEndpoint<_i028a213.LegacyUserSettingsConfig>(
        'serverpod_auth_bridge.legacyStatus',
        'getUserSettingsConfig',
        {},
      );
}

/// Proxy endpoint for legacy user profile operations (image, name changes).
/// {@category Endpoint}
class EndpointLegacyUser extends _isc.EndpointRef {
  EndpointLegacyUser(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_bridge.legacyUser';

  /// Removes the user's profile image.
  _ida.Future<bool> removeUserImage() => caller.callServerEndpoint<bool>(
    'serverpod_auth_bridge.legacyUser',
    'removeUserImage',
    {},
  );

  /// Sets the user's profile image from binary data.
  _ida.Future<bool> setUserImage(_idt.ByteData image) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth_bridge.legacyUser',
        'setUserImage',
        {'image': image},
      );

  /// Changes the user's display name.
  _ida.Future<bool> changeUserName(String userName) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth_bridge.legacyUser',
        'changeUserName',
        {'userName': userName},
      );

  /// Changes the user's full name.
  _ida.Future<bool> changeFullName(String fullName) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth_bridge.legacyUser',
        'changeFullName',
        {'fullName': fullName},
      );
}

/// Endpoint to convert legacy sessions.
/// {@category Endpoint}
class EndpointSessionMigration extends _isc.EndpointRef {
  EndpointSessionMigration(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_bridge.sessionMigration';

  /// Converts a legacy session into a new token from the token manager.
  _ida.Future<_iacc.AuthSuccess?> convertSession({
    required String sessionKey,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess?>(
    'serverpod_auth_bridge.sessionMigration',
    'convertSession',
    {'sessionKey': sessionKey},
  );
}

class Caller extends _isc.ModuleEndpointCaller {
  Caller(_isc.ServerpodClientShared client) : super(client) {
    legacyAdmin = EndpointLegacyAdmin(this);
    legacyEmail = EndpointLegacyEmail(this);
    legacyStatus = EndpointLegacyStatus(this);
    legacyUser = EndpointLegacyUser(this);
    sessionMigration = EndpointSessionMigration(this);
  }

  late final EndpointLegacyAdmin legacyAdmin;

  late final EndpointLegacyEmail legacyEmail;

  late final EndpointLegacyStatus legacyStatus;

  late final EndpointLegacyUser legacyUser;

  late final EndpointSessionMigration sessionMigration;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'serverpod_auth_bridge.legacyAdmin': legacyAdmin,
    'serverpod_auth_bridge.legacyEmail': legacyEmail,
    'serverpod_auth_bridge.legacyStatus': legacyStatus,
    'serverpod_auth_bridge.legacyUser': legacyUser,
    'serverpod_auth_bridge.sessionMigration': sessionMigration,
  };
}

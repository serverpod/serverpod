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
import 'package:serverpod_auth_core_client/src/protocol/auth_user/models/account_link_result.dart'
    as _i3nw0yci;
import 'package:serverpod_auth_core_client/src/protocol/common/models/auth_success.dart'
    as _i0hc49pk;
import 'package:serverpod_auth_core_client/src/protocol/profile/models/user_profile_model.dart'
    as _i4q88qrd;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Endpoint for linking an additional sign-in method to the current account.
///
/// The flow has three steps:
///
/// 1. Call [createLinkRequest] while signed in.
/// 2. Sign in with the additional provider as usual. The response carries a
///    token for that account, which the client keeps rather than signing in
///    with, since the user stays signed in to their original account.
/// 3. Call [executeLinkRequest] with that token.
///
/// See also:
///   - [AccountLinkRequests], which implements the flow.
/// {@category Endpoint}
class EndpointAccountLinking extends _isc.EndpointRef {
  EndpointAccountLinking(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_core.accountLinking';

  /// Starts an account link flow for the calling user and session.
  ///
  /// Any previous request for this user is replaced, so the flow can be
  /// restarted at any point.
  ///
  /// See [AccountLinkRequests.createLinkRequest].
  _ida.Future<void> createLinkRequest() => caller.callServerEndpoint<void>(
    'serverpod_auth_core.accountLinking',
    'createLinkRequest',
    {},
  );

  /// Cancels the calling user's account link flow, if one is in progress.
  ///
  /// Call this as soon as the user declines a merge or dismisses the linking
  /// UI, so that signing in as another user from this session is rejected
  /// again without waiting for the request to expire.
  ///
  /// See [AccountLinkRequests.cancelLinkRequest].
  _ida.Future<void> cancelLinkRequest() => caller.callServerEndpoint<void>(
    'serverpod_auth_core.accountLinking',
    'cancelLinkRequest',
    {},
  );

  /// Completes the calling user's account link flow.
  ///
  /// [proofToken] is the token returned by the sign-in with the additional
  /// provider, and proves that the caller controls the account being linked.
  ///
  /// Returns [AccountLinkStatus.mergeRequired] without changing anything when
  /// the sign-in method already belongs to another account and [approveMerge]
  /// is not set. Present the returned conflict to the user, then call this
  /// again with [approveMerge] set to merge that account in and remove it.
  ///
  /// See [AccountLinkRequests.executeLinkRequest].
  _ida.Future<_i3nw0yci.AccountLinkResult> executeLinkRequest({
    required String proofToken,
    required bool approveMerge,
  }) => caller.callServerEndpoint<_i3nw0yci.AccountLinkResult>(
    'serverpod_auth_core.accountLinking',
    'executeLinkRequest',
    {
      'proofToken': proofToken,
      'approveMerge': approveMerge,
    },
  );
}

/// Endpoint for getting status and managing a signed in user.
/// {@category Endpoint}
class EndpointStatus extends _isc.EndpointRef {
  EndpointStatus(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_core.status';

  /// Returns true if the client user is signed in.
  _ida.Future<bool> isSignedIn() => caller.callServerEndpoint<bool>(
    'serverpod_auth_core.status',
    'isSignedIn',
    {},
  );

  /// Signs out a user from the current device.
  _ida.Future<void> signOutDevice() => caller.callServerEndpoint<void>(
    'serverpod_auth_core.status',
    'signOutDevice',
    {},
  );

  /// Signs out a user from all active devices.
  _ida.Future<void> signOutAllDevices() => caller.callServerEndpoint<void>(
    'serverpod_auth_core.status',
    'signOutAllDevices',
    {},
  );
}

/// Endpoint for JWT tokens management.
/// {@category Endpoint}
abstract class EndpointRefreshJwtTokens extends _isc.EndpointRef {
  EndpointRefreshJwtTokens(_isc.EndpointCaller caller) : super(caller);

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  _ida.Future<_i0hc49pk.AuthSuccess> refreshAccessToken({String? refreshToken});
}

/// Endpoint for read-only access to user profile information.
/// {@category Endpoint}
class EndpointUserProfileInfo extends _isc.EndpointRef {
  EndpointUserProfileInfo(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_core.userProfileInfo';

  /// Returns the user profile of the current user.
  _ida.Future<_i4q88qrd.UserProfileModel> get() =>
      caller.callServerEndpoint<_i4q88qrd.UserProfileModel>(
        'serverpod_auth_core.userProfileInfo',
        'get',
        {},
      );
}

/// Base endpoint for user profile management.
///
/// To expose these endpoint methods on your server, extend this class in a
/// concrete class on your server.
/// {@category Endpoint}
abstract class EndpointUserProfileEditBase extends EndpointUserProfileInfo {
  EndpointUserProfileEditBase(_isc.EndpointCaller caller) : super(caller);

  /// Removes the user's uploaded image, setting it to null.
  ///
  /// The client should handle displaying a placeholder for users without images.
  _ida.Future<_i4q88qrd.UserProfileModel> removeUserImage();

  /// Sets a new user image for the signed in user.
  _ida.Future<_i4q88qrd.UserProfileModel> setUserImage(_idt.ByteData image);

  /// Changes the name of a user.
  _ida.Future<_i4q88qrd.UserProfileModel> changeUserName(String? userName);

  /// Changes the full name of a user.
  _ida.Future<_i4q88qrd.UserProfileModel> changeFullName(String? fullName);

  /// Returns the user profile of the current user.
  @override
  _ida.Future<_i4q88qrd.UserProfileModel> get();
}

class Caller extends _isc.ModuleEndpointCaller {
  Caller(_isc.ServerpodClientShared client) : super(client) {
    accountLinking = EndpointAccountLinking(this);
    status = EndpointStatus(this);
    userProfileInfo = EndpointUserProfileInfo(this);
  }

  late final EndpointAccountLinking accountLinking;

  late final EndpointStatus status;

  late final EndpointUserProfileInfo userProfileInfo;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'serverpod_auth_core.accountLinking': accountLinking,
    'serverpod_auth_core.status': status,
    'serverpod_auth_core.userProfileInfo': userProfileInfo,
  };
}

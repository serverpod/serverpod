/// This library contains the Passwordless authentication provider for the
/// Serverpod Idp module.
///
/// `PasswordlessIdpConfig<THandle>` and `PasswordlessIdpBaseEndpoint<THandle>`
/// support strongly typed handles. The public RPC contract still accepts a
/// `String handle`; that string is first parsed with `deserializeHandle` and
/// passed to `sendLoginVerificationCode`, then persisted using
/// `serializeHandle`, and deserialized again before `resolveAuthUserId` is
/// invoked.
///
/// `PasswordlessLoginExceptionReason.invalid` is used for invalid handle input
/// during `startLogin()`, and also for invalid verification state during
/// `finishLogin()`, such as missing requests or invalid verification codes.
library;

export 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    show AuthSuccess;

export '../src/generated/protocol.dart'
    show PasswordlessLoginException, PasswordlessLoginExceptionReason;
export '../src/providers/passwordless/business/passwordless_idp.dart';
export '../src/providers/passwordless/business/passwordless_idp_admin.dart';
export '../src/providers/passwordless/business/passwordless_idp_config.dart';
export '../src/providers/passwordless/endpoints/passwordless_idp_base_endpoint.dart';

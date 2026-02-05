/// This library contains the Passwordless authentication provider for the
/// Serverpod Idp module.
library;

export 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    show AuthSuccess;

export '../src/generated/protocol.dart'
    show
        PasswordlessLoginException,
        PasswordlessLoginExceptionReason,
        PasswordlessLoginRequest;
export '../src/providers/passwordless/business/passwordless_idp.dart';
export '../src/providers/passwordless/business/passwordless_idp_config.dart';
export '../src/providers/passwordless/business/passwordless_idp_server_exceptions.dart';
export '../src/providers/passwordless/business/passwordless_idp_utils.dart';
export '../src/providers/passwordless/business/utils/passwordless_idp_login_util.dart';
export '../src/providers/passwordless/endpoints/passwordless_idp_base_endpoint.dart';

/// This library contains the passwordless email authentication provider for
/// the Serverpod Idp module.
///
/// Users log in with a verification code sent to their email address, without
/// a password. See https://github.com/serverpod/serverpod/issues/2100.
library;

export 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    show AuthSuccess;

export '../src/common/rate_limited_request_attempt/rate_limit.dart';
export '../src/generated/protocol.dart'
    show
        EmailAccount,
        EmailAccountLoginRequest,
        EmailPasswordlessLoginException,
        EmailPasswordlessLoginExceptionReason;
export '../src/providers/email/business/email_idp_server_exceptions.dart'
    show EmailAccountNotFoundException;
export '../src/providers/email_passwordless/business/email_passwordless_idp.dart';
export '../src/providers/email_passwordless/business/email_passwordless_idp_admin.dart';
export '../src/providers/email_passwordless/business/email_passwordless_idp_config.dart';
export '../src/providers/email_passwordless/business/email_passwordless_idp_server_exceptions.dart';
export '../src/providers/email_passwordless/business/email_passwordless_idp_utils.dart';
export '../src/providers/email_passwordless/business/serverpod_cloud_email_passwordless_idp_config.dart';
export '../src/providers/email_passwordless/business/utils/email_passwordless_idp_login_util.dart';
export '../src/providers/email_passwordless/endpoints/email_passwordless_idp_base_endpoint.dart';

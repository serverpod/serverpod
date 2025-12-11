/// This library contains the email authentication provider for the
/// Serverpod Idp module.
library;

export 'package:serverpod_auth_core_server/common.dart';
export 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    show AuthSuccess;

export '../src/generated/protocol.dart'
    show
        EmailAccount,
        EmailAccountPasswordResetRequest,
        EmailAccountRequest,
        EmailAccountLoginException,
        EmailAccountLoginExceptionReason,
        EmailAccountPasswordResetException,
        EmailAccountPasswordResetExceptionReason,
        EmailAccountRequestException,
        EmailAccountRequestExceptionReason;
export '../src/providers/email/business/email_idp.dart';
export '../src/providers/email/business/email_idp_admin.dart';
export '../src/providers/email/business/email_idp_config.dart';
export '../src/providers/email/business/email_idp_server_exceptions.dart';
export '../src/providers/email/business/email_idp_utils.dart';
export '../src/providers/email/business/utils/email_idp_account_creation_util.dart';
export '../src/providers/email/business/utils/email_idp_authentication_util.dart';
export '../src/providers/email/business/utils/email_idp_password_reset_util.dart';
export '../src/providers/email/endpoints/email_idp_base_endpoint.dart';

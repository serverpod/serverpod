/// This library contains the Microsoft authentication provider for the
/// Serverpod Idp module.
library;

export 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    show AuthSuccess;

export '../src/generated/protocol.dart'
    show MicrosoftAccount, MicrosoftAccessTokenVerificationException;
export '../src/providers/microsoft/business/microsoft_idp.dart';
export '../src/providers/microsoft/business/microsoft_idp_admin.dart';
export '../src/providers/microsoft/business/microsoft_idp_config.dart';
export '../src/providers/microsoft/business/microsoft_idp_utils.dart';
export '../src/providers/microsoft/endpoints/microsoft_idp_base_endpoint.dart';

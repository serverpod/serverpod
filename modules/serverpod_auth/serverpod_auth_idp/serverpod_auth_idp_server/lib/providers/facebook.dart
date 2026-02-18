/// This library contains the Facebook authentication provider for the
/// Serverpod Idp module.
library;

export 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    show AuthSuccess;

export '../src/generated/protocol.dart'
    show FacebookAccount, FacebookAccessTokenVerificationException;
export '../src/providers/facebook/business/facebook_idp.dart';
export '../src/providers/facebook/business/facebook_idp_admin.dart';
export '../src/providers/facebook/business/facebook_idp_config.dart';
export '../src/providers/facebook/business/facebook_idp_utils.dart';
export '../src/providers/facebook/endpoints/facebook_idp_base_endpoint.dart';

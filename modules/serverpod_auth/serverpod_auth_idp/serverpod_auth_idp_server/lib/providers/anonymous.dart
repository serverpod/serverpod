/// This library contains the Apple authentication provider for the
/// Serverpod Idp module.
library;

export 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    show AuthSuccess;

export '../src/generated/protocol.dart' show AppleAccount;
export '../src/providers/anonymous/business/anonymous_idp.dart';
export '../src/providers/anonymous/business/anonymous_idp_config.dart';
export '../src/providers/anonymous/business/anonymous_idp_utils.dart';
export '../src/providers/anonymous/endpoints/anonymous_idp_base_endpoint.dart';

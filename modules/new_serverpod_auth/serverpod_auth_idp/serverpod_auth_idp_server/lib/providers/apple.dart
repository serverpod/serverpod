/// This library contains the Apple authentication provider for the
/// Serverpod Idp module.
library;

export 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    show AuthSuccess;

export '../src/generated/protocol.dart' show AppleAccount;
export '../src/providers/apple/business/apple_idp.dart';
export '../src/providers/apple/business/apple_idp_admin.dart';
export '../src/providers/apple/business/apple_idp_config.dart';
export '../src/providers/apple/business/apple_idp_utils.dart';
export '../src/providers/apple/endpoints/apple_idp_base_endpoint.dart';

/// This library should not be directly imported in application code.
/// It contains exports required by the code generator to integrate the
/// Serverpod IDP module.
library;

export 'src/common/business/auth_config.dart';
export 'src/common/business/provider_factory.dart';
export 'src/common/business/token_manager.dart';
export 'src/generated/endpoints.dart';
export 'src/generated/protocol.dart';

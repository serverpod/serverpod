/// This library re-exports the core authentication tools for the
/// authentication module.

library;

export 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    hide Endpoints, Protocol;

export 'src/generated/protocol.dart' hide Protocol;
export 'src/integrations/apple_identity_provider_factory.dart';
export 'src/integrations/email_identity_provider_factory.dart';
export 'src/integrations/google_identity_provider_factory.dart';
export 'src/integrations/passkey_identity_provider_factory.dart';

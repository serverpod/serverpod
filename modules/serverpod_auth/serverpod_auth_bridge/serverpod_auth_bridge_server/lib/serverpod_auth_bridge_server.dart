/// This library provides backwards compatibility for the new authentication
/// module with the legacy `serverpod_auth` module.
///
/// It includes utilities to convert legacy sessions, import legacy passwords,
/// and manage legacy authentication data.
library;

export 'src/business/auth_backwards_compatibility.dart';
export 'src/business/config.dart';
export 'src/business/enable_legacy_client_support.dart';
export 'src/business/legacy_session_token_manager.dart';
export 'src/business/legacy_session_token_manager_builder.dart';
export 'src/generated/endpoints.dart';
export 'src/generated/protocol.dart'
    show
        Protocol,
        LegacyAuthenticationFailReason,
        LegacyAuthenticationResponse,
        LegacySession,
        LegacyUserInfo,
        LegacyUserSettingsConfig;

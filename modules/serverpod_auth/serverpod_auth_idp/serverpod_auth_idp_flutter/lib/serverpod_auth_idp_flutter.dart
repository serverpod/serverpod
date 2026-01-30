/// Provides authentication UI widgets for Serverpod applications.
///
/// This library allows developers to integrate authentication flows with various
/// identity providers (email, Google, Apple, GitHub, Twitch) into their Flutter apps. It works
/// with the Serverpod auth system and provides ready-to-use UI components.
library;

// Convenience export of the core auth package.
export 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

export 'src/anonymous/anonymous_auth_controller.dart';
export 'src/anonymous/anonymous_sign_in_widget.dart';
export 'src/apple/apple_auth_controller.dart';
export 'src/apple/apple_sign_in_button.dart';
export 'src/apple/apple_sign_in_service.dart';
export 'src/apple/apple_sign_in_style.dart';
export 'src/apple/apple_sign_in_widget.dart';
export 'src/common/oauth2_pkce/oauth2_pkce_client_config.dart';
export 'src/common/oauth2_pkce/oauth2_pkce_exception.dart';
export 'src/common/oauth2_pkce/oauth2_pkce_result.dart';
export 'src/common/oauth2_pkce/oauth2_pkce_util.dart';
export 'src/email/email_auth_controller.dart';
export 'src/email/email_sign_in_widget.dart';
export 'src/github/github_auth_controller.dart';
export 'src/github/github_sign_in_button.dart';
export 'src/github/github_sign_in_service.dart';
export 'src/github/github_sign_in_style.dart';
export 'src/github/github_sign_in_widget.dart';
export 'src/twitch/twitch_auth_controller.dart';
export 'src/twitch/twitch_sign_in_button.dart';
export 'src/twitch/twitch_sign_in_service.dart';
export 'src/twitch/twitch_sign_in_style.dart';
export 'src/twitch/twitch_sign_in_widget.dart';
export 'src/google/common/style.dart';
export 'src/google/google_auth_controller.dart';
export 'src/google/google_sign_in_service.dart';
export 'src/google/google_sign_in_widget.dart';
export 'src/providers.dart';
export 'src/sign_in_widget.dart';
export 'src/theme.dart';

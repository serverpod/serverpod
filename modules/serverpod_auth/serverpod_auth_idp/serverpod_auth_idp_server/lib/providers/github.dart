/// This library contains the GitHub authentication provider for the
/// Serverpod Idp module.
library;

export 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    show AuthSuccess;

export '../src/generated/protocol.dart'
    show GitHubAccount, GitHubAccessTokenVerificationException;
export '../src/providers/github/business/github_idp.dart';
export '../src/providers/github/business/github_idp_admin.dart';
export '../src/providers/github/business/github_idp_config.dart';
export '../src/providers/github/business/github_idp_utils.dart';
export '../src/providers/github/endpoints/github_idp_base_endpoint.dart';

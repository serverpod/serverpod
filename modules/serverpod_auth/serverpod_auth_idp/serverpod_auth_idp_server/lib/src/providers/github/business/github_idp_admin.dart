import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import 'github_idp_utils.dart';

/// Collection of GitHub-account admin methods.
class GitHubIdpAdmin {
  /// Utility functions for the GitHub identity provider.
  final GitHubIdpUtils utils;

  /// Creates a new instance of [GitHubIdpAdmin].
  const GitHubIdpAdmin({required this.utils});

  /// Returns the account details for the given [accessToken].
  Future<GitHubAccountDetails> fetchAccountDetails(
    final Session session, {
    required final String accessToken,
  }) async {
    return utils.fetchAccountDetails(
      session,
      accessToken: accessToken,
    );
  }

  /// Adds a GitHub authentication to the given [authUserId].
  ///
  /// Returns the newly created GitHub account.
  Future<GitHubAccount> linkGitHubAuthentication(
    final Session session, {
    required final UuidValue authUserId,
    required final GitHubAccountDetails accountDetails,
    final Transaction? transaction,
  }) async {
    return utils.linkGitHubAuthentication(
      session,
      authUserId: authUserId,
      accountDetails: accountDetails,
      transaction: transaction,
    );
  }

  /// Return the `AuthUser` id for the GitHub user id, if any.
  static Future<UuidValue?> findUserByGitHubUserId(
    final Session session, {
    required final String userIdentifier,
    final Transaction? transaction,
  }) async {
    final account = await GitHubAccount.db.findFirstRow(
      session,
      where: (final t) => t.userIdentifier.equals(userIdentifier),
      transaction: transaction,
    );

    return account?.authUserId;
  }
}

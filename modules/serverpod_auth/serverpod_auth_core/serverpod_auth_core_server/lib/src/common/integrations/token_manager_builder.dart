import '../../auth_user/business/auth_users.dart';
import 'token_manager.dart';

/// Interface for builders that can create token managers.
///
/// These builders are responsible for building instances of token managers
/// with the necessary dependencies that should be used in token manager implementations.
abstract interface class TokenManagerBuilder<T extends TokenManager> {
  /// Builds a new instance of the token manager.
  T build({required final AuthUsers authUsers});
}

/// A builder that returns a pre-built token manager.
///
/// Use this builder if you have a token manager built from outside of the
/// Serverpod authentication framework.
class PreBuiltTokenManagerBuilder<T extends TokenManager>
    implements TokenManagerBuilder<T> {
  /// The pre-built token manager.
  final T tokenManager;

  /// Creates a new [PreBuiltTokenManagerBuilder] instance.
  const PreBuiltTokenManagerBuilder(this.tokenManager);

  @override
  T build({required final AuthUsers authUsers}) => tokenManager;
}

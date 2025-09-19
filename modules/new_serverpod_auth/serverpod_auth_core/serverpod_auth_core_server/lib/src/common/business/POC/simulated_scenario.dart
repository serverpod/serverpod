import 'auth_config.dart';
import 'idp_providers/email.dart';
import 'idp_providers/google.dart';
import 'token_providers/jwt_provider.dart';
import 'token_providers/sss_provider.dart';

void main() {
  AuthConfig.set(
    tokenIssuer: JwtTokenIssuer(), //SSSTokenIssuer(),
    identityProviders: [
      EmailAuthFactory(enabled: false),
      GoogleAuthFactory(enabled: true),
    ],
  );

  // Serverpod start

  // Request to google endpoint
  myGoogleEndpoint();
  // Request to email endpoint
  myEmailEndpoint();
  // My own business layer trigger by some way
  myOwnBusinessEmail();
}

/// Simulates the google auth endpoint
void myGoogleEndpoint() async {
  try {
    final provider = AuthConfig.getProvider<GoogleAuthProvider>();

    final token = await provider.authenticate();
    print(token);
  } catch (e) {
    print(e);
  }
}

/// Simulates the email auth endpoint
void myEmailEndpoint() async {
  try {
    final provider = AuthConfig.getProvider<EmailAuthProvider>();

    final token = await provider.authenticate();
    print(token);
  } catch (e) {
    print(e);
  }
}

/// Simulates a custom endpoint that uses it's own instance and configuration of
/// an existing provider.
void myOwnBusinessEmail() async {
  final jwtTokenProvider = SSSTokenIssuer();
  final emailConfig = EmailConfig(enabled: true);
  final emailBusiness = EmailAuthProvider(
    tokenIssuer: jwtTokenProvider,
    config: emailConfig,
  );

  print(await emailBusiness.authenticate());
}

void createTokens() async {
  final jwtTokenProvider = SSSTokenIssuer();
  // jwtTokenProvider.issueToken(
  //   authUserId: authUserId,
  //   method: method,
  //   kind: kind,
  //   scopes: scopes,
  //   transaction: transaction,
  // );
}

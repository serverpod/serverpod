import 'package:openid_client/openid_client_io.dart';

class TokenVerifier {
  final String _projectId;
  final Client? _client;

  TokenVerifier(
    String projectId, {
    Client? client,
  })  : _projectId = projectId,
        _client = client;

  /// Verifies the format and signature of a Firebase Auth JWT token.
  Future<IdToken> verifyJwt(String jwtToken) async {
    var client = _client ?? await _getOpenIdClient();

    var credential = client.createCredential(idToken: jwtToken);

    await for (var e in credential.validateToken()) {
      throw Exception(
        'Validating ID token failed: $e',
      );
    }

    if (!_isUid(credential.idToken.claims.subject)) {
      throw Exception(
        'ID token has "sub" (subject) claim which is not a valid uid',
      );
    }

    return credential.idToken;
  }

  /// Creates a new openid [Client] object
  Future<Client> _getOpenIdClient() async {
    var issuer = await Issuer.discover(Issuer.firebase(_projectId));
    return Client(issuer, _projectId);
  }

  /// Validates that a string is a valid Firebase Auth uid.
  bool _isUid(String? uid) {
    return uid != null && uid.isNotEmpty && uid.length <= 128;
  }
}

import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

class TestTokenIssuer implements TokenIssuer {
  const TestTokenIssuer();

  @override
  Future<AuthSuccess> issueToken(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,
    final Set<Scope>? scopes,
    final Transaction? transaction,
  }) async {
    return AuthSuccess(
      authStrategy: method,
      token: 'test-token',
      authUserId: authUserId,
      scopeNames: (scopes ?? {})
          .map((final scope) => scope.name)
          .nonNulls
          .toSet(),
    );
  }
}

class TestTokenManager extends TestTokenIssuer implements TokenManager {
  const TestTokenManager();

  @override
  Future<List<TokenInfo>> listTokens(
    final Session session, {
    required final UuidValue? authUserId,
    final String? method,
    final String? tokenIssuer,
    final Transaction? transaction,
  }) async {
    return [];
  }

  @override
  Future<void> revokeAllTokens(
    final Session session, {
    required final UuidValue? authUserId,
    final Transaction? transaction,
    final String? method,
    final String? tokenIssuer,
  }) async {}

  @override
  Future<void> revokeToken(
    final Session session, {
    required final String tokenId,
    final Transaction? transaction,
    final String? tokenIssuer,
  }) async {}

  @override
  Future<AuthenticationInfo?> validateToken(
    final Session session,
    final String token,
  ) async {
    return null;
  }
}

String createSignedIdToken({
  required final String subject,
  required final String issuer,
  required final String audience,
  required final Map<String, dynamic> claims,
}) {
  final jwt = JWT(
    {
      ...claims,
      'aud': audience,
    },
    subject: subject,
    issuer: issuer,
  );

  return jwt.sign(
    testRsaPrivateKey,
    algorithm: JWTAlgorithm.RS256,
    expiresIn: const Duration(minutes: 10),
  );
}

http.Client googleJwksClient() {
  return MockClient((final request) async {
    expect(request.method, 'GET');
    expect(
      request.url,
      Uri.parse('https://www.googleapis.com/oauth2/v3/certs'),
    );

    return http.Response(
      jsonEncode({
        'keys': [testRsaPublicJwk],
      }),
      200,
    );
  });
}

http.Client firebaseCertificatesClient() {
  return MockClient((final request) async {
    expect(request.method, 'GET');
    expect(
      request.url,
      Uri.parse(
        'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com',
      ),
    );

    return http.Response(
      jsonEncode({
        'test-key': testRsaCertificatePem,
      }),
      200,
    );
  });
}

final onePixelPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

final testRsaPrivateKey = RSAPrivateKey('''-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC7VJTUt9Us8cKj
MzEfYyjiWA4R4/M2bS1GB4t7NXp98C3SC6dVMvDuictGeurT8jNbvJZHtCSuYEvu
NMoSfm76oqFvAp8Gy0iz5sxjZmSnXyCdPEovGhLa0VzMaQ8s+CLOyS56YyCFGeJZ
qgtzJ6GR3eqoYSW9b9UMvkBpZODSctWSNGj3P7jRFDO5VoTwCQAWbFnOjDfH5Ulg
p2PKSQnSJP3AJLQNFNe7br1XbrhV//eO+t51mIpGSDCUv3E0DDFcWDTH9cXDTTlR
ZVEiR2BwpZOOkE/Z0/BVnhZYL71oZV34bKfWjQIt6V/isSMahdsAASACp4ZTGtwi
VuNd9tybAgMBAAECggEBAKTmjaS6tkK8BlPXClTQ2vpz/N6uxDeS35mXpqasqskV
laAidgg/sWqpjXDbXr93otIMLlWsM+X0CqMDgSXKejLS2jx4GDjI1ZTXg++0AMJ8
sJ74pWzVDOfmCEQ/7wXs3+cbnXhKriO8Z036q92Qc1+N87SI38nkGa0ABH9CN83H
mQqt4fB7UdHzuIRe/me2PGhIq5ZBzj6h3BpoPGzEP+x3l9YmK8t/1cN0pqI+dQwY
dgfGjackLu/2qH80MCF7IyQaseZUOJyKrCLtSD/Iixv/hzDEUPfOCjFDgTpzf3cw
ta8+oE4wHCo1iI1/4TlPkwmXx4qSXtmw4aQPz7IDQvECgYEA8KNThCO2gsC2I9PQ
DM/8Cw0O983WCDY+oi+7JPiNAJwv5DYBqEZB1QYdj06YD16XlC/HAZMsMku1na2T
N0driwenQQWzoev3g2S7gRDoS/FCJSI3jJ+kjgtaA7Qmzlgk1TxODN+G1H91HW7t
0l7VnL27IWyYo2qRRK3jzxqUiPUCgYEAx0oQs2reBQGMVZnApD1jeq7n4MvNLcPv
t8b/eU9iUv6Y4Mj0Suo/AU8lYZXm8ubbqAlwz2VSVunD2tOplHyMUrtCtObAfVDU
AhCndKaA9gApgfb3xw1IKbuQ1u4IF1FJl3VtumfQn//LiH1B3rXhcdyo3/vIttEk
48RakUKClU8CgYEAzV7W3COOlDDcQd935DdtKBFRAPRPAlspQUnzMi5eSHMD/ISL
DY5IiQHbIH83D4bvXq0X7qQoSBSNP7Dvv3HYuqMhf0DaegrlBuJllFVVq9qPVRnK
xt1Il2HgxOBvbhOT+9in1BzA+YJ99UzC85O0Qz06A+CmtHEy4aZ2kj5hHjECgYEA
mNS4+A8Fkss8Js1RieK2LniBxMgmYml3pfVLKGnzmng7H2+cwPLhPIzIuwytXywh
2bzbsYEfYx3EoEVgMEpPhoarQnYPukrJO4gwE2o5Te6T5mJSZGlQJQj9q4ZB2Dfz
et6INsK0oG8XVGXSpQvQh3RUYekCZQkBBFcpqWpbIEsCgYAnM3DQf3FJoSnXaMhr
VBIovic5l0xFkEHskAjFTevO86Fsz1C2aSeRKSqGFoOQ0tmJzBEs1R6KqnHInicD
TQrKhArgLXX4v3CddjfTRJkFWDbE/CkvKZNOrcf1nhaGCPspRJj2KUkj1Fhl9Cnc
dn/RsYEONbwQSjIfMPkvxF+8HQ==
-----END PRIVATE KEY-----''');

final testRsaPublicJwk = RSAPublicKey('''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu1SU1LfVLPHCozMxH2Mo
4lgOEePzNm0tRgeLezV6ffAt0gunVTLw7onLRnrq0/IzW7yWR7QkrmBL7jTKEn5u
+qKhbwKfBstIs+bMY2Zkp18gnTxKLxoS2tFczGkPLPgizskuemMghRniWaoLcyeh
kd3qqGElvW/VDL5AaWTg0nLVkjRo9z+40RQzuVaE8AkAFmxZzow3x+VJYKdjykkJ
0iT9wCS0DRTXu269V264Vf/3jvredZiKRkgwlL9xNAwxXFg0x/XFw005UWVRIkdg
cKWTjpBP2dPwVZ4WWC+9aGVd+Gyn1o0CLelf4rEjGoXbAAEgAqeGUxrcIlbjXfbc
mwIDAQAB
-----END PUBLIC KEY-----''').toJWK(algorithm: JWTAlgorithm.RS256);

const testRsaCertificatePem = '''-----BEGIN CERTIFICATE-----
MIIDGzCCAgOgAwIBAgIUXeVDixEJWQqQF+UiurwzvdfPvSQwDQYJKoZIhvcNAQEL
BQAwHTEbMBkGA1UEAwwSc2VydmVycG9kLWlkcC10ZXN0MB4XDTI2MDcwMTAxMzQ0
NFoXDTM2MDYyODAxMzQ0NFowHTEbMBkGA1UEAwwSc2VydmVycG9kLWlkcC10ZXN0
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu1SU1LfVLPHCozMxH2Mo
4lgOEePzNm0tRgeLezV6ffAt0gunVTLw7onLRnrq0/IzW7yWR7QkrmBL7jTKEn5u
+qKhbwKfBstIs+bMY2Zkp18gnTxKLxoS2tFczGkPLPgizskuemMghRniWaoLcyeh
kd3qqGElvW/VDL5AaWTg0nLVkjRo9z+40RQzuVaE8AkAFmxZzow3x+VJYKdjykkJ
0iT9wCS0DRTXu269V264Vf/3jvredZiKRkgwlL9xNAwxXFg0x/XFw005UWVRIkdg
cKWTjpBP2dPwVZ4WWC+9aGVd+Gyn1o0CLelf4rEjGoXbAAEgAqeGUxrcIlbjXfbc
mwIDAQABo1MwUTAdBgNVHQ4EFgQUZcMlbRfmmNwvd/ura7q2rKau0tYwHwYDVR0j
BBgwFoAUZcMlbRfmmNwvd/ura7q2rKau0tYwDwYDVR0TAQH/BAUwAwEB/zANBgkq
hkiG9w0BAQsFAAOCAQEAuXvA87/9oryydK0HTWS85d1GH2hoNlLU4SW1NMTD7Oed
qEdXfV+tps3eZPTFw7YhmNcGW36MUi8Bno3mXSuMwY7tFubjGflw2Y1PLUpNDEUR
h76SJB95mFHjW2ZunJ7yUjHHc8BSS7jCU+vfxa7fht9E2xUUnYidaY8lFdZg6HNQ
gC5aLDNbKmzaSlfQC07IeCLD/vjWc34cV2gRSAb/7EOK7m+iG99yhMQUTfhJsuzU
64L7M7fCAgPAuwiGEdGM+PCs5BtINzdjUr1ydUhzO6JTKcHTRzLd4dpvA//CH6oy
qvso+oo8QluPoe5lzDOlf3aPkbij4TQt6pKP07sgiQ==
-----END CERTIFICATE-----''';

import 'dart:io';

/// A certificate chain and its private key, both as PEM.
///
/// The chain holds the server's certificate first, then any intermediates.
/// The key is a PKCS#8, SEC 1 or PKCS#1 key, ECDSA, RSA or Ed25519. An
/// encrypted key takes its [password]: PKCS#8 under PBES2 with PBKDF2 and
/// AES-128-CBC or AES-256-CBC, or a key behind OpenSSL's `DEK-Info`
/// headers with the same ciphers.
///
/// On the native HTTP adapter the server speaks TLS 1.3 only and selects
/// `http/1.1` through ALPN.
final class PemCertificate {
  /// The certificate chain as PEM.
  final List<int> certificateChain;

  /// The private key as PEM.
  final List<int> privateKey;

  /// The password of an encrypted [privateKey].
  final String? password;

  /// Creates a [PemCertificate] from PEM bytes.
  const PemCertificate({
    required this.certificateChain,
    required this.privateKey,
    this.password,
  });

  /// Reads a [PemCertificate] from the PEM files at [certificateChain] and
  /// [privateKey]. [password] is the password itself.
  PemCertificate.fromFiles({
    required String certificateChain,
    required String privateKey,
    String? password,
  }) : this(
         certificateChain: File(certificateChain).readAsBytesSync(),
         privateKey: File(privateKey).readAsBytesSync(),
         password: password,
       );
}

/// Configuration for the security context.
///
/// A server configured through [SecurityContextConfig.pem] serves HTTPS on
/// either HTTP adapter. A server configured with a [SecurityContext] alone
/// runs on the io adapter.
class SecurityContextConfig {
  /// Security context for the API server.
  final SecurityContext? apiServer;

  /// Security context for the web server.
  final SecurityContext? webServer;

  /// Security context for the insights server.
  final SecurityContext? insightsServer;

  /// The certificate of the API server, when set through
  /// [SecurityContextConfig.pem].
  final PemCertificate? apiServerCertificate;

  /// The certificate of the web server, when set through
  /// [SecurityContextConfig.pem].
  final PemCertificate? webServerCertificate;

  /// The certificate of the insights server, when set through
  /// [SecurityContextConfig.pem].
  final PemCertificate? insightsServerCertificate;

  /// Creates a new [SecurityContextConfig] object.
  SecurityContextConfig({
    this.apiServer,
    this.webServer,
    this.insightsServer,
  }) : apiServerCertificate = null,
       webServerCertificate = null,
       insightsServerCertificate = null;

  /// Creates a [SecurityContextConfig] from PEM certificates.
  ///
  /// [SecurityContextConfig.apiServer], [SecurityContextConfig.webServer] and
  /// [SecurityContextConfig.insightsServer] hold a [SecurityContext] built
  /// from the same PEM. For PEM that [SecurityContext] cannot use, throws as
  /// [SecurityContext.useCertificateChainBytes] and
  /// [SecurityContext.usePrivateKeyBytes] do.
  SecurityContextConfig.pem({
    PemCertificate? apiServer,
    PemCertificate? webServer,
    PemCertificate? insightsServer,
  }) : apiServer = _securityContextOf(apiServer),
       webServer = _securityContextOf(webServer),
       insightsServer = _securityContextOf(insightsServer),
       apiServerCertificate = apiServer,
       webServerCertificate = webServer,
       insightsServerCertificate = insightsServer;
}

SecurityContext? _securityContextOf(PemCertificate? certificate) {
  if (certificate == null) return null;
  return SecurityContext()
    ..useCertificateChainBytes(certificate.certificateChain)
    ..usePrivateKeyBytes(
      certificate.privateKey,
      password: certificate.password,
    );
}

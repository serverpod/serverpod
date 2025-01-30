import 'dart:io';

/// Configuration for the security context.
class SecurityContextConfig {
  /// Security context for the API server.
  final SecurityContext? apiServer;

  /// Security context for the web server.
  final SecurityContext? webServer;

  /// Security context for the insights server.
  final SecurityContext? insightsServer;

  /// Creates a new [SecurityContextConfig] object.
  SecurityContextConfig({
    this.apiServer,
    this.webServer,
    this.insightsServer,
  });
}

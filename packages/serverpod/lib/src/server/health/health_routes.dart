import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/health_check.dart';
import 'package:serverpod/src/server/serverpod.dart';

/// Registers the standard Kubernetes-style health probes (`/livez`, `/readyz`,
/// `/startupz`) on a [RelicRouter]. Mount via [RelicRouter.injectAt] (or call
/// [injectIn] directly) on any server that should expose probes to an
/// orchestrator.
///
/// The legacy `GET /` health endpoint is intentionally NOT registered by
/// [injectIn] because it would collide with user-defined homepage routes when
/// this module is mounted on the web server. Callers that want it (i.e. the
/// API server) should wire [legacyHealth] explicitly.
class HealthRoutes implements RouterInjectable {
  final Serverpod _serverpod;

  /// Creates probes backed by [serverpod]'s [HealthCheckService].
  HealthRoutes(Serverpod serverpod) : _serverpod = serverpod;

  @override
  void injectIn(RelicRouter router) {
    router
      ..get('/livez', _livez)
      ..get('/readyz', _readyz)
      ..get('/startupz', _startupz);
  }

  /// Legacy `GET /` health endpoint. Returns `200 OK <timestamp>` when all
  /// metrics are healthy, `503` with a body listing failing metrics otherwise.
  ///
  /// Only the API server should wire this up: it would collide with user
  /// homepage routes on the web server.
  @internal
  Future<Result> legacyHealth(Request _) async {
    final metrics = (await performHealthChecks(_serverpod)).metrics;
    final issues = metrics.where((m) => !m.isHealthy);
    final now = DateTime.timestamp();
    if (issues.isEmpty) return Response.ok(body: Body.fromString('OK $now'));
    final body = StringBuffer('SADNESS $now\r\n');
    for (final metric in issues) {
      body.write('${metric.name}: ${metric.value}\r\n');
    }
    return Response(503, body: Body.fromString(body.toString()));
  }

  Future<Result> _livez(Request request) async {
    final response = await _serverpod.healthCheckService.checkLiveness();
    return _healthResponse(request, response);
  }

  Future<Result> _readyz(Request request) async {
    final response = await _serverpod.healthCheckService.checkReadiness();
    return _healthResponse(request, response);
  }

  Future<Result> _startupz(Request request) async {
    final response = await _serverpod.healthCheckService.checkStartup();
    return _healthResponse(request, response);
  }

  Future<Result> _healthResponse(
    Request request,
    HealthResponse response,
  ) async {
    final isAuthenticated = await _isAuthenticatedHealthRequest(request);

    if (isAuthenticated) {
      return Response(
        response.httpStatusCode,
        body: Body.fromString(
          jsonEncode(response.toJson()),
          mimeType: MimeType.json,
        ),
      );
    }
    return Response(response.httpStatusCode);
  }

  Future<bool> _isAuthenticatedHealthRequest(Request request) async {
    final authHeader = request.getAuthorizationHeaderValue(
      _serverpod.config.validateHeaders,
    );
    if (authHeader == null) return false;

    final authKey = unwrapAuthHeaderValue(authHeader);
    if (authKey == null) return false;

    final handler = _serverpod.authenticationHandler;
    if (handler == null) return false;

    try {
      final authInfo = await handler(_serverpod.internalSession, authKey);
      return authInfo != null;
    } catch (e) {
      return false;
    }
  }
}

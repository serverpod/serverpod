---
name: serverpod-health-checks
description: Serverpod health endpoints — /livez, /readyz, /startupz, custom HealthIndicator, HealthConfig. Use when configuring Kubernetes probes or monitoring server health.
---

# Serverpod Health Checks

Kubernetes-style HTTP health endpoints on the main API server (default port 8080), not the optional web server (default port 8082). Unauthenticated: HTTP status only (200/503). Authenticated requests get detailed JSON (RFC Health Check Response Format) through the server's normal authentication handler.

## Endpoints

- **`/livez`** — Process alive? Does **not** check DB/Redis. Use for liveness probes.
- **`/readyz`** — Dependencies healthy? Returns 503 if not. Use for readiness probes.
- **`/startupz`** — Server finished initializing? Use for startup probes.

## Built-in indicators

- **ServerpodStartupIndicator** — startup complete
- **DatabaseHealthIndicator** — configured database (if enabled)
- **RedisHealthIndicator** — Redis (if enabled)

## Custom health indicator

```dart
class StripeApiIndicator extends HealthIndicator<double> {
  @override String get name => 'stripe:api';
  @override String get componentType => HealthComponentType.component.name;
  @override String get observedUnit => 'ms';
  @override Duration get timeout => const Duration(seconds: 3);

  @override
  Future<HealthCheckResult> check() async {
    final sw = Stopwatch()..start();
    try {
      await stripeClient.ping();
      return pass(observedValue: sw.elapsedMilliseconds.toDouble());
    } catch (e) {
      return fail(output: 'Stripe unavailable: $e');
    }
  }
}
```

## Registration

```dart
final pod = Serverpod(args, Protocol(), Endpoints(),
  healthConfig: HealthConfig(
    cacheTtl: Duration(seconds: 2), // default is 1 second
    additionalReadinessIndicators: [StripeApiIndicator()],
    additionalStartupIndicators: [CacheWarmupIndicator()],
  ),
);
```

Each indicator can override `timeout` (default 5s). `cacheTtl` caches results to reduce load under frequent probing. Serverpod also has a legacy `GET /` health response with a different, simpler contract; use `/livez`, `/readyz`, and `/startupz` for Kubernetes probes.

# Tech Spike: Health Check Endpoints and Extensibility

## Executive Summary

This spike investigates the transition of Serverpod from its current internal health metrics system to a modular system. The goal is to support modern orchestration (Kubernetes/AWS) and provide extensibility for custom infrastructure checks.

### Current State

Serverpod currently has health check functionality that:

1. Exposes a `GET /` endpoint (`server.dart`) that returns:
   - `200 OK` with timestamp when all metrics are healthy
   - `503 SADNESS` with details when any metric is unhealthy

2. Collects metrics (`health_check.dart`) for:
   - Database connection status and response time (via `testConnection()`)
   - CPU load average
   - Memory usage
   - Connection pool information (active, closing, idle)

3. Provides an Insights API (`InsightsEndpoint.checkHealth()`) for programmatic access to health data, plus `getHealthData()` for historical metrics.

4. Periodically logs metrics to the database for historical analysis.

While the current `GET /` endpoint can technically be used for orchestrator health checks, the design has limitations:
- A single endpoint conflates liveness and readiness concerns
- Database unavailability triggers an "unhealthy" response, which could cause unnecessary pod restarts
- No startup probe support for migration/initialization delays
- No extensibility for custom health indicators
- Redis connectivity is not checked

### Proposal

Add orchestrator-friendly HTTP endpoints that:
- Allow orchestrators to make informed decisions about container lifecycle and traffic routing
- Provide extensibility for custom health indicators
- Follow Kubernetes conventions for health probing

Modern container orchestration platforms like Kubernetes rely on health probes to make automated decisions about container lifecycle and traffic routing. A poorly designed health check system can cause more harm than good - leading to unnecessary restarts, cascading failures, or services that appear healthy but cannot actually serve requests. This document outlines an approach that tries to balance sensitivity (detecting real problems) with stability (avoiding false positives that destabilize the system).

## Core Architectural Principles

### Separation of Concerns

The most critical insight in health check design is that _Is the process alive?_ and _Can the process handle requests?_ are fundamentally different questions with different consequences for a given answer.

Kubernetes and similar orchestrators provide distinct probe types precisely because conflating these concerns leads to pathological behavior. For example, if a single "health check" endpoint returns unhealthy whenever the database is slow, the orchestrator may restart the container - but restarting doesn't fix a slow database. Worse, the restart destroys all in-flight requests and causes a cold-start penalty, making the situation worse.

We therefore adopt distinct endpoints for:
- Liveness: Is the application fundamentally broken?
- Readiness: Can the application usefully handle new requests?
- Startup: Has the application completed its boot sequence?

### Architectural Decoupling

The new health endpoints should be decoupled from the `Server` core. By extracting health logic into a pluggable `HealthCheckManager`, we achieve:
- Extensibility: Users can add custom indicators
- Maintainability: Changes to health check behavior don't require changes to server lifecycle code
- Testability: Health logic can be unit tested in isolation

### Resiliency: The "Anti-Cascade" Rule

In distributed systems, health checks can inadvertently cause the failures they're meant to detect. Consider a scenario where a brief network partition causes all pods to fail their database health check simultaneously. If the health check is too aggressive, the orchestrator restarts all pods at once, creating a "thundering herd" that overwhelms the database when they all reconnect simultaneously.

The guiding principle is: **liveness probes must be permissive**. A restart is a "nuclear option" that should be reserved for truly unrecoverable states (deadlocks, memory corruption, infinite loops). Transient issues like slow queries, garbage collection pauses, or temporary network blips should not trigger restarts.

## Proposed Endpoints

We adopt the `z-suffix` convention (`/livez`, `/readyz`, `/startupz`) to align with Kubernetes API server conventions.

### `/livez`

"Should this container be killed and restarted?" This should only fail if the process is fundamentally broken.

Rationale: A restart destroys the entire process and all in-flight requests. This is only appropriate when the process is truly unrecoverable. If the server can respond to the health check, the process is fundamentally alive - even if it's experiencing temporary difficulties.

Common scenarios where we should NOT restart:
- A slow database query is blocking a request handler
- Garbage collection pause
- Processing an unusually large request
- Temporary network latency to an external service

In all these cases, the server will typically recover on its own. Restarting would destroy work in progress and potentially make the situation worse (cold start, reconnection storms, lost caches).

Implementation: The `/livez` endpoint should do minimal work - ideally just return `200 OK` immediately. It should NOT check database connectivity, external services, or perform any I/O that could block or fail due to external factors.

### `/readyz` 

"Should traffic be routed to this container?" This can fail for transient reasons like high load, database connectivity issues, or resource pressure.

While we're permissive about liveness, we can be more aggressive about readiness. If a pod is struggling, we want Kubernetes to stop sending it new traffic - but without killing it.

Implementation: The `/readyz` endpoint checks actual service capacity:
- Can we connect to the database?
- Can we connect to Redis (if configured)?
- Are custom health indicators healthy?

If any critical dependency is unavailable, the endpoint returns `503 Service Unavailable`, and Kubernetes stops routing traffic to this pod until it recovers.

### `/startupz`

"Has this container finished initializing?" Without a startup probe, Kubernetes might mark a still-initializing container as failed and restart it repeatedly. The startup probe tells Kubernetes to wait before even beginning liveness/readiness checks.

Questions: 
- How does the server signal that migrations have completed?
- What constitutes "warm-up"? Connection pool initialization? Cache priming?
- Should there be a configurable list of startup indicators similar to readiness indicators?

### Security

As metrics data can be highly sensitive, the metrics endpoints should run on a separate port for easy segregation.
Unauthenticated probes should only receive the status code, and no details.

### Summary

| Endpoint    | Type      | Responsibility                                            | Failure Outcome |
| ----------- | --------- | --------------------------------------------------------- | --------------- |
| `/livez`    | Liveness  | Check the server can respond.                             | Pod Restart     |
| `/readyz`   | Readiness | Checks dependencies like database and Redis connectivity. | Traffic Paused  |
| `/startupz` | Startup   | Checks if migrations and initial warm-up are complete.    | Delayed Ingress |

## Extensibility: The `HealthIndicator` Registry

Different deployments have different health requirements. A payment processing service might need to verify Stripe API connectivity; a media service might need to check CDN availability. Rather than hard-coding every possible check, we provide an extensible registry.

```dart
abstract class HealthIndicator {
  /// Human-readable name for logging and debugging
  String get name;
  
  /// Maximum time to wait for this check before considering it failed.
  /// This prevents a slow check from blocking the entire health endpoint.
  Duration get timeout => Duration(seconds: 5);
  
  /// Perform the health check and return the result.
  Future<HealthCheckResult> check();
}
```

Users register indicators when configuring Serverpod:

```dart
final pod = Serverpod(
  args,
  healthConfig: HealthConfig(
    cacheTtl: Duration(seconds: 1),
    readinessIndicators: [
      DatabaseHealthIndicator(),    // Built-in: checks Postgres connectivity
      RedisHealthIndicator(),       // Built-in: checks Redis connectivity
      StripeApiIndicator(),         // Custom: checks Stripe API availability
      InventoryServiceIndicator(),  // Custom: checks internal microservice      
    ],
    startupIndicators: [...],  // If different from readiness
  ),
);
```

Questions:
- How are timeouts configured per-indicator vs globally?
- What's the cache TTL default and how is it configured?
- Should there be separate `startupIndicators`?
- Is it an error to register indicators for unused services? Or should they just pass?

### Default Indicators

Serverpod will provide built-in indicators for common dependencies:

DatabaseHealthIndicator: Tests database connectivity using a lightweight query. This builds on the existing `testConnection()` functionality in `health_check.dart` but exposes it through the new indicator interface.

RedisHealthIndicator: Tests Redis connectivity with a simple PING command. This is a new addition - currently Serverpod does not probe Redis health.

### Design Considerations for Custom Indicators

Timeout Enforcement: The `HealthCheckManager` enforces the timeout specified by each indicator. If a check takes too long, it's considered failed. This prevents a hung external service from making the health endpoint itself unresponsive.

Failure Isolation: Each indicator runs independently. A failure in one check doesn't prevent other checks from completing. The final health status aggregates all results.

Caching: Health checks can be expensive (database queries, network calls). The manager caches results for a configurable duration (default: 1 second) to prevent a "thundering herd" on the health endpoint itself during high-frequency probing.

## Response Format

Health endpoints should return JSON following the draft RFC: _Health Check Response Format for HTTP APIs_ (https://datatracker.ietf.org/doc/html/draft-inadarei-api-health-check-06) for (hopefully) broad compatibility with monitoring tools:

```json
{
  "status": "pass",
  "checks": {
    "database:latency": [
      {
        "componentId": "primary-db",
        "componentType": "datastore",
        "observedValue": 12,
        "observedUnit": "ms",
        "status": "pass",
        "time": "2026-01-14T10:30:00Z"
      }
    ],
    "redis:latency": [
      {
        "componentId": "cache-cluster",
        "componentType": "datastore",
        "observedValue": 3,
        "observedUnit": "ms",
        "status": "pass",
        "time": "2026-01-14T10:30:00Z"
      }
    ]
  }
}
```

For unhealthy states:

```json
{
  "status": "fail",
  "notes": "Connection timeout while reaching the primary database cluster.",
  "output": "ConnectionError: ETIMEDOUT 10.0.1.5:5432",
  "checks": {
    "database:connection": [
      {
        "componentId": "primary-db",
        "componentType": "datastore",
        "status": "fail",
        "time": "2026-01-19T09:50:00Z",
        "output": "timeout after 5000ms"
      }
    ],
    "redis:latency": [
      {
        "componentId": "cache-cluster",
        "status": "pass",
        "observedValue": 2,
        "observedUnit": "ms",
        "time": "2026-01-19T09:50:00Z"
      }
    ]
  }
}
```

HTTP status codes:
- `200 OK` - All checks passed
- `503 Service Unavailable` - One or more critical checks failed

The `/livez` endpoint returns a minimal response since it performs no checks:

```json
{
  "status": "pass",
  "time": "2026-01-19T10:30:00Z"
}
```

Question: Should we support `"warn"` state as well? (Supported by RFC)

## Future Consideration: Multi-Isolate Architecture

> [!NOTE]
> This section can be disregarded for now. It has not been decided to use multiple isolates.

Serverpod currently runs in a single isolate. However, if Serverpod moves to a multi-isolate architecture in the future (for better CPU utilization on multi-core machines), the health check system will need to account for this. This section outlines how the design would extend.

### The Challenge

In a multi-isolate architecture, the main isolate handles incoming requests and coordinates worker isolates that execute application logic. This introduces complexity for health checks:

- A problem in one isolate doesn't necessarily indicate a problem with the entire pod
- We need to avoid killing the entire pod because one worker is temporarily slow
- The health endpoint runs on the main isolate but needs visibility into worker health

### Permissive Liveness in Multi-Isolate

The pod stays "Live" as long as the main isolate is responding.

If the main isolate can respond to the health check, the process is fundamentally alive - even if some worker isolates are slow or blocked. Common scenarios where we should NOT restart:

- A single worker is blocked on a slow database query
- Garbage collection pause affecting some workers
- One worker processing an unusually large request

In all these cases, the affected worker will typically recover on its own. Restarting would destroy work in progress across all isolates.

### Sensitive Readiness with Worker Awareness

While liveness stays permissive, readiness could incorporate worker health:

Workers would periodically measure their event loop responsiveness by scheduling a zero-delay timer and measuring actual execution delay:

```dart
// Conceptual implementation
final scheduledTime = DateTime.now();
Timer(Duration.zero, () {
  final actualTime = DateTime.now();
  final lag = actualTime.difference(scheduledTime);
  reportLagToMainIsolate(lag);
});
```

If the event loop is blocked (by synchronous code, GC, or I/O wait), the timer executes late, and this latency is detected.

Rather than failing readiness when any single worker is slow, we would use a quorum-based approach:

- If an isolate reports lag > 500ms (configurable), it is marked as "Busy"
- If more than a configurable ratio of isolates (e.g., 50%) are "Busy," `/readyz` returns `503`
- This means one slow worker out of eight doesn't affect traffic, but widespread slowness pauses traffic

Configuration additions for multi-isolate:

```yaml
health:
  readyz:
    # ... existing options ...
    isolate_lag_threshold_ms: 500
    isolate_unhealthy_ratio: 0.5
```

### Communication Pattern

Workers would report their status to the main isolate via `SendPort`/`ReceivePort`. The `HealthCheckManager` on the main isolate would aggregate these reports when responding to `/readyz` probes.

This architecture ensures that health decisions are made centrally with full visibility, while keeping the liveness check simple and permissive.

## Relationship to Existing Health System

The existing health system serves multiple purposes that should be preserved:

| Aspect    | Current `GET /`        | Current Insights API  | Current Periodic Logging | Proposed System        |
| --------- | ---------------------- | --------------------- | ------------------------ | ---------------------- |
| Purpose   | Quick health check     | Programmatic access   | Historical analysis      | Orchestrator lifecycle |
| Consumer  | Load balancers, humans | Serverpod Insights UI | Dashboards, alerting     | Kubernetes probes      |
| Frequency | On-demand              | On-demand             | Periodic (configurable)  | On-demand              |
| Output    | Plain text             | `ServerHealthResult`  | Database records         | JSON HTTP responses    |

### Migration Path

The proposed system should coexist with and eventually supersede the current `GET /` endpoint. Phases:

1. Add `/livez`, `/readyz`, `/startupz` alongside the existing `GET /` endpoint
2. Deprecate `GET /` for health checking (it may still serve other purposes like a welcome message)
3. Document migration path for users currently relying on `GET /`

The new indicators can reuse the existing `testConnection()` logic from `health_check.dart` for database checks. The periodic logging and Insights API should continue to use `performHealthChecks()` as they do today.

## Action Items

1. Create the core manager class with:
   - Timeout enforcement per indicator
   - Result caching with configurable TTL
   - Aggregation logic for determining overall status

2. Implement built-in health indicators:
   - `DatabaseHealthIndicator` - reuses existing `testConnection()` logic from `health_check.dart`
   - `RedisHealthIndicator` - new capability, tests Redis connectivity with PING

3. Register `/livez`, `/readyz`, and `/startupz` routes in `server.dart` alongside the existing `GET /` endpoint.

4. Implement logic to track when server initialization (including migrations) is complete for the `/startupz` endpoint.

5. Add deprecation notice to the `GET /` endpoint for health check purposes, pointing users to the new endpoints.

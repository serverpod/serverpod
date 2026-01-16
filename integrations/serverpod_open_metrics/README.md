# Serverpod OpenMetrics

OpenMetrics middleware and metrics collection for Serverpod servers.

## Features

- OpenMetrics-compatible HTTP metrics collection
- Automatic tracking of requests, duration, and in-flight counts
- Prometheus scraping endpoint
- Path normalization to prevent unbounded cardinality
- Custom metrics support (Counter, Gauge, Histogram)

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  serverpod_open_metrics: ^3.1.1
```

## Quick Start

```dart
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_open_metrics/serverpod_open_metrics.dart';

void run(List<String> args) async {
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Add metrics middleware
  pod.server.addMiddleware(metricsMiddleware());

  await pod.start();
}
```

Metrics will be available at `http://localhost:8080/metrics`

## Security - IP Access Control

**By default, the metrics endpoint is only accessible from localhost** (127.0.0.1, ::1). This follows security best practices - metrics are secure by default.

### Allowing Remote Access

To allow access from your monitoring infrastructure:

```dart
pod.server.addMiddleware(
  metricsMiddleware(
    allowedIps: [
      '127.0.0.1',        // localhost
      '::1',              // IPv6 localhost
      '192.168.0.0/16',   // private network
      '10.0.0.0/8',       // another private network
    ],
  ),
);
```

### Disabling Access Control

To disable access control completely (not recommended for production):

```dart
pod.server.addMiddleware(
  metricsMiddleware(
    allowedIps: [],  // Empty list = allow all
  ),
);
```

### Supported Formats

The middleware supports:
- IPv4 and IPv6 addresses
- CIDR notation for subnets
- Proper handling of proxy headers (X-Forwarded-For, Forwarded)

## Documentation

See the [Serverpod documentation](https://docs.serverpod.dev) for detailed usage and configuration.

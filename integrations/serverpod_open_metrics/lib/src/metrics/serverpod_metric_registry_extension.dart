import 'package:serverpod/serverpod.dart';

import 'metric_registry.dart';

/// Extension to initialize and access the global metrics registry.
extension ServerpodMetricRegistry on Serverpod {
  /// Initializes the global [MetricRegistry] singleton.
  void initializeMetricRegistry({final MetricRegistry? registry}) {
    MetricRegistry.set(registry: registry);
  }

  /// Returns the global metrics registry.
  MetricRegistry get metricsRegistry => MetricRegistry.instance;
}

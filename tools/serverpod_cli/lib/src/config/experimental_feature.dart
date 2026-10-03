class CommandLineExperimentalFeatures {
  static late CommandLineExperimentalFeatures instance;

  static void initialize(List<ExperimentalFeature> features) {
    instance = CommandLineExperimentalFeatures._(features);
  }

  final List<ExperimentalFeature> features;

  CommandLineExperimentalFeatures._(this.features);
}

enum ExperimentalFeature {
  all,

  /// Enables the `database: sync` option on models, which marks a table to be
  /// synchronized between the client and the server through the
  /// `serverpod_offline_sync` package.
  databaseSync,
  ;

  static ExperimentalFeature fromString(String value) {
    for (var feature in ExperimentalFeature.values) {
      if (feature.name == value) {
        return feature;
      }
    }

    throw ArgumentError('Unknown experimental feature: $value');
  }
}

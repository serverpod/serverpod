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

  // TODO: Remove when inheritance is enabled by default.
  // Tracked by issue: https://github.com/serverpod/serverpod/issues/2711
  inheritance;

  // TODO: Remove when the feature is considered stable.
  interfaces,

  // TODO: Remove when the feature is considered stable.
  // Feature tracked by issue: https://github.com/serverpod/serverpod/issues/3255
  changeIdType;

  static ExperimentalFeature fromString(String value) {
    for (var feature in ExperimentalFeature.values) {
      if (feature.name == value) {
        return feature;
      }
    }

    throw ArgumentError('Unknown experimental feature: $value');
  }
}

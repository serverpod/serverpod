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
  // TODO: Remove when column override is enabled by default.
  columnOverride;

  static ExperimentalFeature fromString(String value) {
    for (var feature in ExperimentalFeature.values) {
      if (feature.name == value) {
        return feature;
      }
    }

    throw ArgumentError('Unknown experimental feature: $value');
  }
}

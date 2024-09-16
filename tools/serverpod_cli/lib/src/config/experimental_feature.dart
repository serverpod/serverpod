// TODO: Remove when inheritance is enabled by default.
// Tracked by issue: https://github.com/serverpod/serverpod/issues/2711
enum ExperimentalFeature {
  inheritance;

  static ExperimentalFeature fromString(String value) {
    for (var feature in ExperimentalFeature.values) {
      if (feature.name == value) {
        return feature;
      }
    }

    throw ArgumentError('Unknown experimental feature: $value');
  }
}

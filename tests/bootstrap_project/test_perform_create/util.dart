import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/shared/environment.dart' as env;

void setupForPerformCreateTest() {
  env.loadEnvironmentVars();
  CommandLineExperimentalFeatures.initialize(ExperimentalFeature.values);
}

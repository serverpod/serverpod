class SetupConstants {
  static String dockerVolumeName(String projectName) =>
      '${projectName}_server_${projectName}_data';
}

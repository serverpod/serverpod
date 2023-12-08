class SetupConstants {
  /// The name of the docker volume used to store the database.
  /// This name is a combination of the folder name the compose file is in
  /// and the volume name defined in the compose file.
  static String dockerVolumeName(String projectName) =>
      '${projectName}_server_${projectName}_data';
}

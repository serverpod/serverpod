/// Returns the path to SSL certificate for the specified server.
String sslCertificatePath(String runMode, int serverId) {
  return 'certificates/${runMode}_$serverId.crt';
}

/// Returns the path to the private SSL key for the specified server.
String sslPrivateKeyPath(String runMode, int serverId) {
  return 'certificates/${runMode}_$serverId.key';
}

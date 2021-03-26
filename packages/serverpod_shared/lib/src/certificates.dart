String sslCertificatePath(String runMode, int serverId) {
  return 'certificates/${runMode}_$serverId.crt';
}

String sslPrivateKeyPath(String runMode, int serverId) {
  return 'certificates/${runMode}_$serverId.key';
}
Future<void> performGenerateCerts(String runMode, bool verbose) async {
  // const certConfigFile = '.certconf';

  print('Generating certificates (disabled)');
  // var passwords = PasswordManager(runMode: runMode).loadPasswords() ?? {};
  // var config = ServerConfig(runMode, 0, passwords);
  //
  // for (var serverId in config.cluster.keys) {
  //   var crtFileName = 'certificates/${runMode}_$serverId.crt';
  //   var keyFileName = 'certificates/${runMode}_$serverId.key';
  //
  //   var serverAddress = config.cluster[serverId]!.address;
  //
  //   print(crtFileName);
  //   print(keyFileName);
  //
  //   File(certConfigFile).writeAsStringSync(
  //       '[ req ]\ndistinguished_name = req_distinguished_name\nprompt = no\n\n[ req_distinguished_name ]\nCN = $serverAddress\n');
  //
  //   var args = <String>[
  //     'req',
  //     '-x509',
  //     '-sha256',
  //     '-nodes',
  //     '-days',
  //     '3650',
  //     '-newkey',
  //     'rsa:2048',
  //     '-config',
  //     certConfigFile,
  //     '-keyout',
  //     keyFileName,
  //     '-out',
  //     crtFileName
  //   ];
  //   vPrint(verbose, 'openssl ' + args.join(' '));
  //
  //   var result = await Process.run('openssl', args);
  //
  //     vPrint(verbose, result.stdout);
  //     vPrint(verbose, result.stderr);
  //
  //   File(certConfigFile).deleteSync();
  // }
}

//openssl req -x509 -sha256 -nodes -days 3650 -newkey rsa:2048 -config config/certificate_config.txt -keyout config/ssl_development.key -out config/ssl_development.crt

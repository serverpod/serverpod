import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

({String projectName, String commandRoot}) createRandomProjectName(
  String root,
) {
  final projectName = 'test_${Uuid().v4().replaceAll('-', '_').toLowerCase()}';
  final commandRoot = path.join(root, projectName, '${projectName}_server');

  return (projectName: projectName, commandRoot: commandRoot);
}

({String serverDir, String flutterDir, String clientDir})
    createProjectFolderPaths(String projectName) {
  final serverDir = path.join(projectName, '${projectName}_server');
  final flutterDir = path.join(projectName, '${projectName}_flutter');
  final clientDir = path.join(projectName, '${projectName}_client');

  return (serverDir: serverDir, flutterDir: flutterDir, clientDir: clientDir);
}

String createServerFolderPath(String projectName) {
  return path.join(projectName, '${projectName}_server');
}

Future<bool> isNetworkPortAvailable(int port) async {
  try {
    var socket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    await socket.close();
    return true;
  } catch (e) {
    return false;
  }
}

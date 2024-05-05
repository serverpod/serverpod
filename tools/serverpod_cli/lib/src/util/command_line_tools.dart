import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:xml/xml.dart';

class CommandLineTools {
  static Future<bool> dartPubGet(Directory dir) async {
    log.debug('Running `dart pub get` in ${dir.path}', newParagraph: true);

    var exitCode = await _runProcessWithDefaultLogger(
      executable: 'dart',
      arguments: ['pub', 'get'],
      workingDirectory: dir.path,
    );

    if (exitCode != 0) {
      log.error('Failed to run `dart pub get` in ${dir.path}');
      return false;
    }

    return true;
  }

  static Future<bool> flutterCreate(Directory dir) async {
    log.debug('Running `flutter create .` in ${dir.path}', newParagraph: true);

    var exitCode = await _runProcessWithDefaultLogger(
      executable: 'flutter',
      arguments: ['create', '.'],
      workingDirectory: dir.path,
    );

    if (exitCode != 0) {
      log.error('Failed to run `flutter create .` in ${dir.path}');
      return false;
    }

    return true;
  }

  static Future<bool> existsCommand(
    String command, [
    List<String> arguments = const [],
  ]) async {
    var exitCode = await _runProcessWithDefaultLogger(
      executable: command,
      arguments: arguments,
    );
    return exitCode == 0;
  }

  static Future<bool> addNetworkToEntitlements(Directory dir) async {
    var debugEntitlementsPath =
        '${dir.path}/macos/Runner/DebugProfile.entitlements';
    var releaseEntitlementsPath =
        '${dir.path}/macos/Runner/Release.entitlements';

    bool debugResult = await _modifyEntitlements(debugEntitlementsPath);
    bool releaseResult = await _modifyEntitlements(releaseEntitlementsPath);

    return debugResult && releaseResult;
  }

  static Future<bool> _modifyEntitlements(String filePath) async {
    try {
      var file = File(filePath);
      var document = XmlDocument.parse(file.readAsStringSync());

      var exists = document.findAllElements('key').any(
            (node) => node.innerText == 'com.apple.security.network.client',
          );

      if (!exists) {
        var dict = document.findAllElements('dict').first;
        var keyNode = XmlElement(
            XmlName('key'), [], [XmlText('com.apple.security.network.client')]);
        var trueNode = XmlElement(XmlName('true'));

        dict.children.add(keyNode);
        dict.children.add(trueNode);

        file.writeAsStringSync(document.toXmlString(pretty: true));
        log.debug('Added `com.apple.security.network.client` entitlement.');
      } else {
        log.debug(
            '`com.apple.security.network.client` entitlement already exists.');
      }

      return true;
    } catch (e) {
      log.error('Error modifying entitlements: $e');
      return false;
    }
  }
}

Future<int> _runProcessWithDefaultLogger({
  required String executable,
  String? workingDirectory,
  List<String>? arguments,
}) async {
  var process = await Process.start(
    executable,
    arguments ?? [],
    workingDirectory: workingDirectory,
    runInShell: true,
  );

  process.stderr
      .transform(utf8.decoder)
      .listen((data) => log.debug(data, type: const RawLogType()));
  process.stdout
      .transform(utf8.decoder)
      .listen((data) => log.debug(data, type: const RawLogType()));

  return await process.exitCode;
}

import 'dart:async';

import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/serverpod_cloud/token_listener_server.dart';
import 'package:serverpod_cli/src/util/browser_launcher.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

class CloudLoginCommand extends ServerpodCommand {
  CloudLoginCommand() {
    argParser.addOption(
      'server',
      abbr: 's',
      help: 'The URL to the Serverpod cloud server.',
      defaultsTo: 'https://serverpod.cloud',
    );

    argParser.addOption(
      'timeout',
      abbr: 't',
      help: 'The time in seconds to wait for the authentication to complete.',
      defaultsTo: '120',
    );

    argParser.addFlag(
      'persistent',
      help: 'Store the authentication token.',
      defaultsTo: true,
      negatable: true,
    );
  }
  @override
  final name = 'login';

  @override
  final description = 'Log in to Serverpod cloud.';

  @override
  void run() async {
    var storedCloudData = await resourceManager.tryFetchServerpodCloudData();

    if (storedCloudData != null) {
      log.info('Already logged in to Serverpod cloud.');
      return;
    }

    var cloudServer =
        Uri.parse(argResults!['server']).replace(path: '/cli/signin');
    var timeLimit = Duration(seconds: int.parse(argResults!['timeout']));
    var persistent = argResults!['persistent'] as bool;

    var callbackUrlFuture = Completer<Uri>();
    var tokenFuture = TokenListenerServer.listenForAuthenticationToken(
      onConnected: (Uri callbackUrl) => callbackUrlFuture.complete(callbackUrl),
      timeLimit: timeLimit,
    );

    var callbackUrl = await callbackUrlFuture.future;
    var signInUrl = cloudServer
        .replace(queryParameters: {'callback': callbackUrl.toString()});
    log.info(
        'Please log in to Serverpod Cloud using opened browser or through this link: $signInUrl');

    try {
      await BrowserLauncher.openUrl(signInUrl);
    } catch (e) {
      log.debug('Failed to open browser: $e');
    }

    String? token;
    await log.progress('Waiting for authentication to complete...', () async {
      token = await tokenFuture;
      return token != null;
    });

    if (token == null) {
      log.error('Failed to get authentication token.');
      throw ExitException();
    }

    if (persistent) {
      await resourceManager.storeServerpodCloudData(ServerpodCloudData(token!));
    }
    log.info('Successfully logged in to Serverpod cloud.');
  }
}

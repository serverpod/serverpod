import 'dart:async';
import 'dart:io';

import '../config_info/config_info.dart';
import '../generator/class_generator.dart';
import '../generator/config.dart';
import '../generator/protocol_generator.dart';
import '../port_scanner/port_scanner.dart';
import 'file_watcher.dart';

void performRun(bool verbose, bool runDocker) async {
  if (!config.load()) return;

  var configInfo = ConfigInfo('development');

  // Do an initial serverpod generate
  if (verbose) print('Running serverpod generate');
  performGenerateClasses(verbose);
  await performGenerateProtocol(verbose);

  // Generate continuously and hot reload
  if (verbose) print('Starting up continuous generator');
  var serverRunner = _ServerRunner();
  var dockerRunner = _DockerRunner();
  var generatingAndReloading = false;

  bool protocolIsDirty = false;
  bool libIsDirty = false;

  var watcher = SourceFileWatcher(
    onChangedSourceFile: (changedPath, isProtocol) async {
      protocolIsDirty = protocolIsDirty || isProtocol;
      libIsDirty = true;

      // Batch process changes made within 500 ms.
      while (libIsDirty) {
        Timer(const Duration(milliseconds: 500), () async {
          if (libIsDirty && !generatingAndReloading) {
            var protocolWasDirty = protocolIsDirty;

            generatingAndReloading = true;
            protocolIsDirty = false;
            libIsDirty = false;

            await _generateAndReload(verbose, protocolWasDirty, configInfo);

            generatingAndReloading = false;
          }
        });
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // TODO: Hot reload server
    },
    onRemovedProtocolFile: (removedPath) async {
      // TODO: remove corresponding file
    },
  );

  unawaited(watcher.watch(verbose));

  // Start Docker.
  if (runDocker) {
    if (verbose) print('Starting Docker');
    await dockerRunner.start(verbose);
  }

  // Verify that Postgres & Redis is up and running.
  if (!await PortScanner.waitForPort(
    configInfo.config.dbHost,
    configInfo.config.dbPort,
    printProgress: true,
  )) {
    print('Failed to connect to Postgres.');
    return;
  }

  if (!await PortScanner.waitForPort(
    configInfo.config.redisHost,
    configInfo.config.redisPort,
    printProgress: true,
  )) {
    print('Failed to connect to Redis.');
    return;
  }

  // Run the server
  if (verbose) print('Starting the server');
  unawaited(serverRunner.start());
}

Future<void> _generateAndReload(
    bool verbose, bool generate, ConfigInfo configInfo) async {
  if (generate) {
    try {
      performGenerateClasses(verbose);
    } catch (e, stackTrace) {
      print('Failed to generate classes');
      print(stackTrace);
    }
    try {
      await performGenerateProtocol(verbose);
    } catch (e, stackTrace) {
      print('Failed to generate protocol');
      print(stackTrace);
    }

    // TODO: Dart format generated code
  }

  // TODO: Hot reload server
  var client = configInfo.createServiceClient();
  try {
    var success = await client.insights.hotReload();
  } catch (e) {
    print('Failed hot reload: $e');
  }
  client.close();
}

class _ServerRunner {
  Future<void> start() async {
    var process = await Process.start(
      'dart',
      ['--enable-vm-service', 'bin/main.dart'],
    );

    unawaited(stdout.addStream(process.stdout));
    unawaited(stderr.addStream(process.stderr));
  }
}

class _DockerRunner {
  Future<void> start(bool verbose) async {
    await Process.start(
      'docker-compose',
      ['up', '--build'],
    );

    // TODO: Check if it is possible to also pipe docker output to stdout.
    // if (verbose) {
    //   unawaited(stdout.addStream(process.stdout));
    //   unawaited(stderr.addStream(process.stderr));
    // }
  }
}

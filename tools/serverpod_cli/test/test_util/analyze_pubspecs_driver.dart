// Runs in a child process with a synthetic repository as its working directory.
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod_cli/src/internal_tools/analyze_pubspecs.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

Future<void> main(List<String> args) async {
  final fetched = <String>[];
  try {
    final match = await http.runWithClient(
      () => pubspecDependenciesMatch(
        checkLatestVersion: args[0] == 'true'
            ? CheckLatestVersion(
                onlyMajorUpdate: false,
                ignoreServerpodPackages: args[1] == 'true',
              )
            : null,
      ),
      () => MockClient((request) async {
        final name = request.url.pathSegments.last;
        fetched.add(
          name.endsWith('.json') ? name.substring(0, name.length - 5) : name,
        );
        return http.Response('{"versions":["2.0.0","1.0.0"]}', 200);
      }),
    );
    File('result.json').writeAsStringSync(
      jsonEncode({'match': match, 'fetched': fetched}),
    );
  } finally {
    await closeLogger();
  }
}

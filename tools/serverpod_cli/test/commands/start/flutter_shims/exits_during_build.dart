// Test shim: emits a build-progress event, then exits non-zero without ever
// publishing a VM-service URI or web URL — simulating a pubspec/asset error
// that fails the build.
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  stdout.writeln(
    jsonEncode([
      {
        'event': 'app.progress',
        'params': {'message': 'Building...'},
      },
    ]),
  );
  stderr.writeln('Error: unable to find asset declared in pubspec.yaml.');
  await stdout.flush();
  await stderr.flush();
  exit(1);
}

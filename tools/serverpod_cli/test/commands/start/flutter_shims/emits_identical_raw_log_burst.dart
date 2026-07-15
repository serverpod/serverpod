import 'dart:io';

Future<void> main() async {
  for (var index = 0; index < 3; index++) {
    stderr.writeln('Repeated diagnostic.');
  }
  await stderr.flush();
}

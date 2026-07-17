import 'dart:async';
import 'dart:io';

Future<void> main() async {
  for (var index = 1; index <= 20; index++) {
    stderr.writeln('Line $index');
    await stderr.flush();
    await Future<void>.delayed(const Duration(milliseconds: 30));
  }
}

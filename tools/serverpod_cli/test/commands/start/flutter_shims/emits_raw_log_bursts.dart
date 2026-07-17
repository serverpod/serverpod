import 'dart:async';
import 'dart:io';

Future<void> main() async {
  stderr.writeln('First line of one diagnostic.');
  stderr.writeln('Second line of one diagnostic.');
  await stderr.flush();

  await Future<void>.delayed(const Duration(milliseconds: 100));

  stderr.writeln('A later diagnostic.');
  await stderr.flush();
}

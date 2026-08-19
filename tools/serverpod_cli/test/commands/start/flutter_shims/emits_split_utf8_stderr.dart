import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final bytes = utf8.encode('Falha: conexão\n');
  final splitAt = bytes.indexOf(0xc3) + 1;

  stderr.add(bytes.sublist(0, splitAt));
  await stderr.flush();
  await Future<void>.delayed(const Duration(milliseconds: 50));
  stderr.add(bytes.sublist(splitAt));
  await stderr.flush();
}

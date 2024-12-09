import 'dart:io';

import 'package:relic/src/static/static_handler.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import 'test_util.dart';

void main() {
  setUp(() async {
    await d.file('index.html', '<html></html>').create();
    await d.file('root.txt', 'root txt').create();
    await d.dir('files', [
      d.file('index.html', '<html><body>files</body></html>'),
      d.file('with space.txt', 'with space content'),
      d.dir('empty subfolder', []),
    ]).create();
  });

  test(
      'Given directory listing is enabled when accessing "/" then it lists the directory contents',
      () async {
    final handler = createStaticHandler(d.sandbox, listDirectories: true);

    final response = await makeRequest(handler, '/');
    expect(response.statusCode, HttpStatus.ok);
    expect(response.readAsString(), completes);
  });

  test(
      'Given directory listing is enabled when accessing "/files" then it redirects to "/files/"',
      () async {
    final handler = createStaticHandler(d.sandbox, listDirectories: true);

    final response = await makeRequest(handler, '/files');
    expect(response.statusCode, HttpStatus.movedPermanently);
    expect(
      response.headers.location,
      Uri.parse('http://localhost/files/'),
    );
  });

  test(
      'Given directory listing is enabled when accessing "/files/" then it lists the directory contents',
      () async {
    final handler = createStaticHandler(d.sandbox, listDirectories: true);

    final response = await makeRequest(handler, '/files/');
    expect(response.statusCode, HttpStatus.ok);
    expect(response.readAsString(), completes);
  });

  test(
      'Given directory listing is enabled when accessing "/files/empty subfolder" then it redirects to "/files/empty subfolder/"',
      () async {
    final handler = createStaticHandler(d.sandbox, listDirectories: true);

    final response = await makeRequest(handler, '/files/empty subfolder');
    expect(response.statusCode, HttpStatus.movedPermanently);
    expect(
      response.headers.location,
      Uri.parse('http://localhost/files/empty%20subfolder/'),
    );
  });

  test(
      'Given directory listing is enabled when accessing "/files/empty subfolder/" then it lists the directory contents',
      () async {
    final handler = createStaticHandler(d.sandbox, listDirectories: true);

    final response = await makeRequest(handler, '/files/empty subfolder/');
    expect(response.statusCode, HttpStatus.ok);
    expect(response.readAsString(), completes);
  });
}

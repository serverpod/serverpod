import 'dart:io';

import 'package:relic/src/static/static_handler.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import 'test_util.dart';

void main() {
  setUp(() async {
    await d.file('root.txt', 'root txt').create();
    await d.dir('files', [
      d.file('test.txt', 'test txt content'),
      d.file('with space.txt', 'with space content')
    ]).create();
  });

  test('Given a root file when accessed then it returns the file content',
      () async {
    final handler = createStaticHandler(d.sandbox);

    final response = await makeRequest(
      handler,
      '/static/root.txt',
      handlerPath: 'static',
    );
    expect(response.statusCode, HttpStatus.ok);
    expect(response.body.contentLength, 8);
    expect(response.readAsString(), completion('root txt'));
  });

  test(
      'Given a root file with space when accessed then it returns the file content',
      () async {
    final handler = createStaticHandler(d.sandbox);

    final response = await makeRequest(
        handler, '/static/files/with%20space.txt',
        handlerPath: 'static');
    expect(response.statusCode, HttpStatus.ok);
    expect(response.body.contentLength, 18);
    expect(response.readAsString(), completion('with space content'));
  });

  test(
      'Given a root file with unencoded space when accessed then it returns the file content',
      () async {
    final handler = createStaticHandler(d.sandbox);

    final response = await makeRequest(
        handler, '/static/files/with%20space.txt',
        handlerPath: 'static');
    expect(response.statusCode, HttpStatus.ok);
    expect(response.body.contentLength, 18);
    expect(response.readAsString(), completion('with space content'));
  });

  test(
      'Given a file under directory when accessed then it returns the file content',
      () async {
    final handler = createStaticHandler(d.sandbox);

    final response = await makeRequest(handler, '/static/files/test.txt',
        handlerPath: 'static');
    expect(response.statusCode, HttpStatus.ok);
    expect(response.body.contentLength, 16);
    expect(response.readAsString(), completion('test txt content'));
  });

  test('Given a non-existent file when accessed then it returns a 404 status',
      () async {
    final handler = createStaticHandler(d.sandbox);

    final response = await makeRequest(handler, '/static/not_here.txt',
        handlerPath: 'static');
    expect(response.statusCode, HttpStatus.notFound);
  });
}

// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';

import 'package:serverpod_relic_helpers/serverpod_relic_helpers.dart';
import 'package:serverpod_relic_helpers/src/body.dart';
import 'package:test/test.dart';

void main() {
  test('adds chunked encoding with no transfer-encoding header', () async {
    var response = await _chunkResponse(
      Response.ok(
        Body.fromDataStream(
          Stream.fromIterable([Uint8List.fromList('hi'.codeUnits)]),
        ),
      ),
    );
    expect(response.headers, containsPair('transfer-encoding', 'chunked'));
    expect(response.readAsString(), completion(equals('2\r\nhi\r\n0\r\n\r\n')));
  });

  test('adds chunked encoding with transfer-encoding: identity', () async {
    var response = await _chunkResponse(Response.ok(
      Body.fromDataStream(
        Stream.fromIterable([Uint8List.fromList('hi'.codeUnits)]),
      ),
      headers: {'transfer-encoding': 'identity'},
    ));
    expect(response.headers, containsPair('transfer-encoding', 'chunked'));
    expect(response.readAsString(), completion(equals('2\r\nhi\r\n0\r\n\r\n')));
  });

  test("doesn't add chunked encoding with content length", () async {
    var response = await _chunkResponse(Response.ok(Body.fromString('hi')));
    expect(response.headers, isNot(contains('transfer-encoding')));
    expect(response.readAsString(), completion(equals('hi')));
  });

  test("doesn't add chunked encoding with status 1xx", () async {
    var response = await _chunkResponse(Response(
      123,
      body: Body.fromDataStream(const Stream.empty()),
    ));
    expect(response.headers, isNot(contains('transfer-encoding')));
    expect(response.read().toList(), completion(isEmpty));
  });

  test("doesn't add chunked encoding with status 204", () async {
    var response = await _chunkResponse(Response(
      204,
      body: Body.fromDataStream(const Stream.empty()),
    ));
    expect(response.headers, isNot(contains('transfer-encoding')));
    expect(response.read().toList(), completion(isEmpty));
  });

  test("doesn't add chunked encoding with status 304", () async {
    var response = await _chunkResponse(Response(
      204,
      body: Body.fromDataStream(const Stream.empty()),
    ));
    expect(response.headers, isNot(contains('transfer-encoding')));
    expect(response.read().toList(), completion(isEmpty));
  });

  test("doesn't add chunked encoding with status 204", () async {
    var response = await _chunkResponse(Response(
      204,
      body: Body.fromDataStream(const Stream.empty()),
    ));
    expect(response.headers, isNot(contains('transfer-encoding')));
    expect(response.read().toList(), completion(isEmpty));
  });

  test("doesn't add chunked encoding with status 204", () async {
    var response = await _chunkResponse(Response(
      204,
      body: Body.fromDataStream(const Stream.empty()),
    ));
    expect(response.headers, isNot(contains('transfer-encoding')));
    expect(response.read().toList(), completion(isEmpty));
  });
}

FutureOr<Response> _chunkResponse(Response response) =>
    addChunkedEncoding((_) => response)(
      Request('GET', Uri.parse('http://example.com/')),
    );

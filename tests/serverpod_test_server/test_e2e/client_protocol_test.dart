import 'dart:async';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(
    serverUrl,
    authenticationKeyManager: TestAuthKeyManager(),
  );

  test('when calling method with positional arg then echoes the value',
      () async {
    final result = await client.methodSignaturePermutations
        .echoPositionalArg('PositionalArg');
    expect(result, 'PositionalArg');
  });

  test('when calling method with named arg then echoes the value', () async {
    final result = await client.methodSignaturePermutations
        .echoNamedArg(string: 'NamedArg');
    expect(result, 'NamedArg');
  });

  test(
      'when calling method with a nullable named arg with value then echoes value',
      () async {
    final result = await client.methodSignaturePermutations
        .echoNullableNamedArg(string: 'NamedArg');
    expect(result, 'NamedArg');
  });

  test(
      'when calling method with a nullable named arg without passing value then echoes null',
      () async {
    final result =
        await client.methodSignaturePermutations.echoNullableNamedArg();
    expect(result, isNull);
  });

  test('when calling method with optional arg then echoes the value', () async {
    final result =
        await client.methodSignaturePermutations.echoOptionalArg('OptionalArg');
    expect(result, 'OptionalArg');
  });

  test('when calling method with optional arg without value then echoes null',
      () async {
    final result = await client.methodSignaturePermutations.echoOptionalArg();
    expect(result, isNull);
  });

  test('when calling method with positional and named args then echoes args',
      () async {
    final result =
        await client.methodSignaturePermutations.echoPositionalAndNamedArgs(
      'PositionalArg',
      string2: 'NamedArg',
    );

    expect(result, ['PositionalArg', 'NamedArg']);
  });

  test(
      'when calling method with positional and nullable named args with named arg then echoes args',
      () async {
    final result = await client.methodSignaturePermutations
        .echoPositionalAndNullableNamedArgs(
      'PositionalArg',
      string2: 'NamedArg',
    );

    expect(result, ['PositionalArg', 'NamedArg']);
  });

  test(
      'when calling method with positional and named args without passing named arg then echoes null',
      () async {
    final result = await client.methodSignaturePermutations
        .echoPositionalAndNullableNamedArgs(
      'PositionalArg',
    );

    expect(result, ['PositionalArg', null]);
  });

  test(
      'when calling method with positional and optional args then echoes both args',
      () async {
    final result =
        await client.methodSignaturePermutations.echoPositionalAndOptionalArgs(
      'PositionalArg',
      'OptionalArg',
    );

    expect(result, ['PositionalArg', 'OptionalArg']);
  });

  test(
      'when calling method with positional and optional args without passing value then echoes null',
      () async {
    final result =
        await client.methodSignaturePermutations.echoPositionalAndOptionalArgs(
      'PositionalArg',
    );

    expect(result, ['PositionalArg', null]);
  });

  test('when calling method with named stream arg then echoes stream',
      () async {
    final result = await client.methodSignaturePermutations
        .echoNamedArgStream(
          strings: Stream.fromIterable(['NamedArg']),
        )
        .toList();

    expect(result, ['NamedArg']);
  });

  test('when calling method with named stream arg then echoes list future',
      () async {
    final result =
        await client.methodSignaturePermutations.echoNamedArgStreamAsFuture(
      strings: Stream.fromIterable(['NamedArg']),
    );

    expect(result, 'NamedArg');
  });

  test('when calling method with positional stream arg then echoes stream',
      () async {
    final result = await client.methodSignaturePermutations
        .echoPositionalArgStream(
          Stream.fromIterable(['PositionalArg']),
        )
        .toList();

    expect(result, ['PositionalArg']);
  });

  test('when calling method with named stream arg then echoes list future',
      () async {
    final result = await client.methodSignaturePermutations
        .echoPositionalArgStreamAsFuture(
      Stream.fromIterable(['NamedArg']),
    );

    expect(result, 'NamedArg');
  });
}

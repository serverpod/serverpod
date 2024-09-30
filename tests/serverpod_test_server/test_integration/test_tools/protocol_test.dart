import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod('Given TestToolsEndpoint', (endpoints, session) {
    test('when calling method with positional arg then echoes the value',
        () async {
      final result = await endpoints.testToolsWithArgVariations
          .echoPositionalArg(session, 'PositionalArg');
      expect(result, 'PositionalArg');
    });

    test('when calling method with named arg then echoes the value', () async {
      final result = await endpoints.testToolsWithArgVariations
          .echoNamedArg(session, string: 'NamedArg');
      expect(result, 'NamedArg');
    });

    test(
        'when calling method with a nullable named arg with value then echoes value',
        () async {
      final result = await endpoints.testToolsWithArgVariations
          .echoNullableNamedArg(session, string: 'NamedArg');
      expect(result, 'NamedArg');
    });

    test(
        'when calling method with a nullable named arg without passing value then echoes null',
        () async {
      final result = await endpoints.testToolsWithArgVariations
          .echoNullableNamedArg(session);
      expect(result, isNull);
    });

    test('when calling method with optional arg then echoes the value',
        () async {
      final result = await endpoints.testToolsWithArgVariations
          .echoOptionalArg(session, 'OptionalArg');
      expect(result, 'OptionalArg');
    });

    test('when calling method with optional arg without value then echoes null',
        () async {
      final result =
          await endpoints.testToolsWithArgVariations.echoOptionalArg(session);
      expect(result, isNull);
    });

    test('when calling method with positional and named args then echoes args',
        () async {
      final result =
          await endpoints.testToolsWithArgVariations.echoPositionalAndNamedArgs(
        session,
        'PositionalArg',
        string2: 'NamedArg',
      );

      expect(result, ['PositionalArg', 'NamedArg']);
    });

    test(
        'when calling method with positional and nullable named args when passing value then echoes args',
        () async {
      final result = await endpoints.testToolsWithArgVariations
          .echoPositionalAndNullableNamedArgs(
        session,
        'PositionalArg',
        string2: 'NamedArg',
      );

      expect(result, ['PositionalArg', 'NamedArg']);
    });

    test(
        'when calling method with positional and named args without passing named arg then echoes null',
        () async {
      final result = await endpoints.testToolsWithArgVariations
          .echoPositionalAndNullableNamedArgs(
        session,
        'PositionalArg',
      );

      expect(result, ['PositionalArg', null]);
    });

    test(
        'when calling method with positional and optional args then echoes both args',
        () async {
      final result = await endpoints.testToolsWithArgVariations
          .echoPositionalAndOptionalArgs(
        session,
        'PositionalArg',
        'OptionalArg',
      );

      expect(result, ['PositionalArg', 'OptionalArg']);
    });

    test(
        'when calling method with positional and optional args without passing value then echoes null',
        () async {
      final result = await endpoints.testToolsWithArgVariations
          .echoPositionalAndOptionalArgs(
        session,
        'PositionalArg',
      );

      expect(result, ['PositionalArg', null]);
    });

    test('when calling method with named stream arg then echoes stream',
        () async {
      final result = await endpoints.testToolsWithArgVariations
          .echoNamedArgStream(
            session,
            strings: Stream.fromIterable(['NamedArg']),
          )
          .toList();

      expect(result, ['NamedArg']);
    });

    test('when calling method with positional and optional args', () async {
      final result =
          await endpoints.testToolsWithArgVariations.echoNamedArgStreamAsFuture(
        session,
        strings: Stream.fromIterable(['NamedArg']),
      );

      expect(result, 'NamedArg');
    });
  }, runMode: ServerpodRunMode.production);
}

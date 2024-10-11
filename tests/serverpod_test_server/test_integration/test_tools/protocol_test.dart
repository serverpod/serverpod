import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given TestToolsEndpoint',
    (sessionBuilder, endpoints) {
      test('when calling method with positional arg then echoes the value',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoPositionalArg(sessionBuilder, 'PositionalArg');
        expect(result, 'PositionalArg');
      });

      test('when calling method with named arg then echoes the value',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoNamedArg(sessionBuilder, string: 'NamedArg');
        expect(result, 'NamedArg');
      });

      test(
          'when calling method with a nullable named arg with value then echoes value',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoNullableNamedArg(sessionBuilder, string: 'NamedArg');
        expect(result, 'NamedArg');
      });

      test(
          'when calling method with a nullable named arg without passing value then echoes null',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoNullableNamedArg(sessionBuilder);
        expect(result, isNull);
      });

      test('when calling method with optional arg then echoes the value',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoOptionalArg(sessionBuilder, 'OptionalArg');
        expect(result, 'OptionalArg');
      });

      test(
          'when calling method with optional arg without value then echoes null',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoOptionalArg(sessionBuilder);
        expect(result, isNull);
      });

      test(
          'when calling method with positional and named args then echoes args',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoPositionalAndNamedArgs(
          sessionBuilder,
          'PositionalArg',
          string2: 'NamedArg',
        );

        expect(result, ['PositionalArg', 'NamedArg']);
      });

      test(
          'when calling method with positional and nullable named args with named arg then echoes args',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoPositionalAndNullableNamedArgs(
          sessionBuilder,
          'PositionalArg',
          string2: 'NamedArg',
        );

        expect(result, ['PositionalArg', 'NamedArg']);
      });

      test(
          'when calling method with positional and named args without passing named arg then echoes null',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoPositionalAndNullableNamedArgs(
          sessionBuilder,
          'PositionalArg',
        );

        expect(result, ['PositionalArg', null]);
      });

      test(
          'when calling method with positional and optional args then echoes both args',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoPositionalAndOptionalArgs(
          sessionBuilder,
          'PositionalArg',
          'OptionalArg',
        );

        expect(result, ['PositionalArg', 'OptionalArg']);
      });

      test(
          'when calling method with positional and optional args without passing value then echoes null',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoPositionalAndOptionalArgs(
          sessionBuilder,
          'PositionalArg',
        );

        expect(result, ['PositionalArg', null]);
      });

      test('when calling method with named stream arg then echoes stream',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoNamedArgStream(
              sessionBuilder,
              strings: Stream.fromIterable(['NamedArg']),
            )
            .toList();

        expect(result, ['NamedArg']);
      });

      test('when calling method with named stream arg then echoes list future',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoNamedArgStreamAsFuture(
          sessionBuilder,
          strings: Stream.fromIterable(['NamedArg']),
        );

        expect(result, 'NamedArg');
      });

      test('when calling method with positional stream arg then echoes stream',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoPositionalArgStream(
              sessionBuilder,
              Stream.fromIterable(['PositionalArg']),
            )
            .toList();

        expect(result, ['PositionalArg']);
      });

      test('when calling method with named stream arg then echoes list future',
          () async {
        final result = await endpoints.methodSignaturePermutations
            .echoPositionalArgStreamAsFuture(
          sessionBuilder,
          Stream.fromIterable(['NamedArg']),
        );

        expect(result, 'NamedArg');
      });
    },
  );
}

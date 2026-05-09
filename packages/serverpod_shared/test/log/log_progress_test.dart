import 'package:serverpod_shared/log.dart';
import 'package:test/test.dart';

void main() {
  group('Given Log.progress with a runner that returns bool', () {
    late TestLogWriter writer;
    late Log log;

    setUp(() {
      writer = TestLogWriter();
      log = Log(writer);
    });

    test(
      'when the runner returns true, '
      'then the scope closes with success true',
      () async {
        await log.progress('op', () async => true);

        expect(writer.closedScopes, hasLength(1));
        expect(writer.closedScopes.first.success, isTrue);
      },
    );

    test(
      'when the runner returns false, '
      'then the scope closes with success false',
      () async {
        await log.progress('op', () async => false);

        expect(writer.closedScopes, hasLength(1));
        expect(writer.closedScopes.first.success, isFalse);
      },
    );
  });

  group('Given Log.progress with a runner that returns a non-bool value', () {
    late TestLogWriter writer;
    late Log log;

    setUp(() {
      writer = TestLogWriter();
      log = Log(writer);
    });

    test(
      'when no isSuccess is provided, '
      'then the scope closes with success true',
      () async {
        await log.progress<String>('op', () async => 'ok');

        expect(writer.closedScopes.first.success, isTrue);
      },
    );

    test(
      'when isSuccess is provided, '
      'then the scope uses its verdict',
      () async {
        await log.progress<String>(
          'op',
          () async => 'fail',
          isSuccess: (r) => r == 'ok',
        );

        expect(writer.closedScopes.first.success, isFalse);
      },
    );
  });

  group('Given Log.progress with a runner that throws', () {
    late TestLogWriter writer;
    late Log log;

    setUp(() {
      writer = TestLogWriter();
      log = Log(writer);
    });

    test(
      'when the runner throws, '
      'then the scope closes with success false and rethrows',
      () async {
        await expectLater(
          log.progress<bool>('op', () async => throw StateError('boom')),
          throwsA(isA<StateError>()),
        );

        expect(writer.closedScopes.first.success, isFalse);
        expect(writer.closedScopes.first.error, isA<StateError>());
      },
    );

    test(
      'when isSuccess would return true but runner throws, '
      'then throw takes precedence and scope closes with success false',
      () async {
        await expectLater(
          log.progress<bool>(
            'op',
            () async => throw StateError('boom'),
            isSuccess: (_) => true,
          ),
          throwsA(isA<StateError>()),
        );

        expect(writer.closedScopes.first.success, isFalse);
      },
    );
  });
}

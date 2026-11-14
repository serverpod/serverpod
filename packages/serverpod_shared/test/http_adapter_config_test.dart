import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  const runMode = 'development';
  const passwords = {'serviceSecret': 'longpasswordthatisrequired'};

  ServerpodConfig load(
    Map<String, dynamic> configMap, {
    Map<String, String> environment = const {},
  }) => ServerpodConfig.loadFromMap(
    runMode,
    null,
    passwords,
    configMap,
    environment: environment,
  );

  group('Given a config without httpAdapter,', () {
    test('when loading from Map, then the adapter is native.', () {
      expect(load({}).httpAdapter, ServerpodHttpAdapter.native);
    });
  });

  group('Given a config with httpAdapter set to io,', () {
    test('when loading from Map, then the adapter is io.', () {
      expect(
        load({'httpAdapter': 'io'}).httpAdapter,
        ServerpodHttpAdapter.io,
      );
    });

    test(
      'when SERVERPOD_HTTP_ADAPTER is native, '
      'then the environment variable wins.',
      () {
        expect(
          load(
            {'httpAdapter': 'io'},
            environment: {'SERVERPOD_HTTP_ADAPTER': 'native'},
          ).httpAdapter,
          ServerpodHttpAdapter.native,
        );
      },
    );
  });

  group('Given an httpAdapter that names no adapter,', () {
    test('when loading from Map, then an ArgumentError is thrown.', () {
      expect(
        () => load({'httpAdapter': 'zig'}),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Valid values are: native, io'),
          ),
        ),
      );
    });

    test(
      'when it comes from SERVERPOD_HTTP_ADAPTER, '
      'then the error names the environment variable.',
      () {
        expect(
          () => load({}, environment: {'SERVERPOD_HTTP_ADAPTER': 'zig'}),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('SERVERPOD_HTTP_ADAPTER'),
            ),
          ),
        );
      },
    );
  });

  group('Given a config with httpAdapter io,', () {
    test('when copying it without httpAdapter, then io is kept.', () {
      final config = load({'httpAdapter': 'io'});
      expect(config.copyWith().httpAdapter, ServerpodHttpAdapter.io);
    });
  });
}

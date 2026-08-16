import 'package:serverpod/protocol.dart';
import 'package:serverpod/server.dart';
import 'package:serverpod/src/server/endpoint_parameter_helper.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given no parameter descriptions when parsing null parameter string then empty map is returned.',
    () {
      expect(
        parseParameters({}, {}, Protocol()),
        {},
      );
    },
  );

  group('Given single non nullable parameter description', () {
    var parameterDescriptions = {
      'arg1': ParameterDescription(
        name: 'arg1',
        type: int,
        nullable: false,
      ),
    };

    test('when parsing valid input then parameter is parsed.', () {
      expect(
        parseParameters(
          {'arg1': 42},
          parameterDescriptions,
          Protocol(),
        ),
        {'arg1': 42},
      );
    });

    test(
      'when parsing param with different argument name then an exception is thrown.',
      () {
        expect(
          () => parseParameters(
            {'arg2': 42},
            parameterDescriptions,
            Protocol(),
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'when parsing parameter string with additional parameter then additional parameter is ignored',
      () {
        expect(
          parseParameters(
            {'arg1': 42, 'arg2': 'ignored'},
            parameterDescriptions,
            Protocol(),
          ),
          {'arg1': 42},
        );
      },
    );
  });

  group('Given single nullable parameter description', () {
    var parameterDescriptions = {
      'arg1': ParameterDescription(
        name: 'arg1',
        type: int,
        nullable: true,
      ),
    };

    test('when parsing valid input then parameter is parsed.', () {
      expect(
        parseParameters(
          {'arg1': 42},
          parameterDescriptions,
          Protocol(),
        ),
        {'arg1': 42},
      );
    });

    test(
      'when parsing empty parameter input then an empty map is returned.',
      () {
        expect(
          parseParameters(
            {},
            parameterDescriptions,
            Protocol(),
          ),
          {},
        );
      },
    );
  });

  group('Given multiple non nullable parameter descriptions', () {
    var parameterDescriptions = {
      'arg1': ParameterDescription(
        name: 'arg1',
        type: int,
        nullable: false,
      ),
      'arg2': ParameterDescription(
        name: 'arg2',
        type: String,
        nullable: false,
      ),
    };

    test('when parsing valid parameter string then parameters are parsed.', () {
      expect(
        parseParameters(
          {'arg1': 42, 'arg2': 'value'},
          parameterDescriptions,
          Protocol(),
        ),
        {'arg1': 42, 'arg2': 'value'},
      );
    });

    test(
      'when parsing parameter input is only containing one of the required parameters then an exception is thrown.',
      () {
        expect(
          () => parseParameters(
            {'arg1': 42},
            parameterDescriptions,
            Protocol(),
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}

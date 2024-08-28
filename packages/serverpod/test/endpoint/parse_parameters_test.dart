import 'package:serverpod/protocol.dart';
import 'package:serverpod/server.dart';
import 'package:serverpod/src/server/endpoint_parameter_helper.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given null parameter string when decoding parameters then empty map is returned.',
      () {
    expect(
      decodeParameters(null),
      {},
    );
  });

  test(
      'Given empty parameter string when decoding parameters then empty map is returned.',
      () {
    expect(
      decodeParameters(''),
      {},
    );
  });

  test(
      'Given valid parameter input when decoding parameters then parameters are decoded.',
      () {
    expect(
      decodeParameters('{"arg1": 42}'),
      {'arg1': 42},
    );
  });

  test(
      'Given invalid parameter string when decoding parameters then an exception is thrown.',
      () {
    expect(
      () => decodeParameters('not a json string'),
      throwsA(isA<FormatException>()),
    );
  });

  test(
      'Given no parameter descriptions when parsing null parameter string then empty map is returned.',
      () {
    expect(
      parseParameters({}, {}, Protocol()),
      {},
    );
  });

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

    // test('when parsing null parameter string then an exception is thrown.', () {
    //   expect(
    //     () => parseParameters(
    //       null,
    //       parameterDescriptions,
    //       Protocol(),
    //     ),
    //     throwsA(isA<Exception>()),
    //   );
    // });

    // test(
    //     'when parsing a non json decodable param string then an exception is thrown.',
    //     () {
    //   expect(
    //     () => parseParameters(
    //       'not a json string',
    //       parameterDescriptions,
    //       Protocol(),
    //     ),
    //     throwsA(isA<FormatException>()),
    //   );
    // });

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
    });

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
    });
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

    test('when parsing empty parameter input then an empty map is returned.',
        () {
      expect(
        parseParameters(
          {},
          parameterDescriptions,
          Protocol(),
        ),
        {},
      );
    });
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
    });
  });
}

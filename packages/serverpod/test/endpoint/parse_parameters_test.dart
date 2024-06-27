import 'package:serverpod/protocol.dart';
import 'package:serverpod/server.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given no parameter descriptions when parsing null parameter string then empty map is returned.',
      () {
    expect(
      EndpointDispatch.parseParameters(null, {}, Protocol()),
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

    test('when parsing valid parameter string then parameter is parsed.', () {
      expect(
        EndpointDispatch.parseParameters(
          '{"arg1": 42}',
          parameterDescriptions,
          Protocol(),
        ),
        {'arg1': 42},
      );
    });

    test(
        'when parsing parameter where required parameter is supplied as additional parameters then parameter is parsed.',
        () {
      expect(
        EndpointDispatch.parseParameters(
          null,
          parameterDescriptions,
          Protocol(),
          additionalParameters: {'arg1': 42},
        ),
        {'arg1': 42},
      );
    });

    test('when parsing null parameter string then an exception is thrown.', () {
      expect(
        () => EndpointDispatch.parseParameters(
          null,
          parameterDescriptions,
          Protocol(),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test(
        'when parsing a non json decodable param string then an exception is thrown.',
        () {
      expect(
        () => EndpointDispatch.parseParameters(
          'not a json string',
          parameterDescriptions,
          Protocol(),
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test(
        'when parsing param with different argument name then an exception is thrown.',
        () {
      expect(
        () => EndpointDispatch.parseParameters(
          '{"arg2": 42}',
          parameterDescriptions,
          Protocol(),
        ),
        throwsA(isA<Exception>()),
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

    test('when parsing valid parameter string then parameter is parsed.', () {
      expect(
        EndpointDispatch.parseParameters(
          '{"arg1": 42}',
          parameterDescriptions,
          Protocol(),
        ),
        {'arg1': 42},
      );
    });

    test('when parsing null parameter string then empty map is returned.', () {
      expect(
        EndpointDispatch.parseParameters(
          null,
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
        EndpointDispatch.parseParameters(
          '{"arg1": 42, "arg2": "value"}',
          parameterDescriptions,
          Protocol(),
        ),
        {'arg1': 42, 'arg2': 'value'},
      );
    });

    test(
        'when parsing parameter where required parameters are supplied as additional parameters then parameters are parsed.',
        () {
      expect(
        EndpointDispatch.parseParameters(
          null,
          parameterDescriptions,
          Protocol(),
          additionalParameters: {'arg1': 42, 'arg2': 'value'},
        ),
        {'arg1': 42, 'arg2': 'value'},
      );
    });

    test(
        'when parsing parameter where parameter string contains one parameter and additional parameters contains the other then parameters are parsed.',
        () {
      expect(
        EndpointDispatch.parseParameters(
          '{"arg1": 42}',
          parameterDescriptions,
          Protocol(),
          additionalParameters: {'arg2': 'value'},
        ),
        {'arg1': 42, 'arg2': 'value'},
      );
    });

    test(
        'when parsing parameter string only containing one of the required parameters then an exception is thrown.',
        () {
      expect(
        () => EndpointDispatch.parseParameters(
          "{'arg1': 42}",
          parameterDescriptions,
          Protocol(),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test(
        'when parsing parameter where only one of the required parameters is passed as additional parameters then an exception is thrown.',
        () {
      expect(
        () => EndpointDispatch.parseParameters(
          null,
          parameterDescriptions,
          Protocol(),
          additionalParameters: {'arg1': 42},
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}

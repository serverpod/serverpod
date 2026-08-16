import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given no parameter descriptions when empty parameter list is provided then empty list is returned.',
    () {
      expect(
        EndpointDispatch.parseRequestedInputStreams(
          descriptions: {},
          requestedInputStreams: [],
        ),
        [],
      );
    },
  );

  group('Given single non nullable parameter description', () {
    var streamParameterName = 'stream1';
    var streamParameterDescription = {
      streamParameterName: StreamParameterDescription<int>(
        name: streamParameterName,
        nullable: false,
      ),
    };
    test(
      'when valid stream name is provided then stream description is returned.',
      () {
        var result = EndpointDispatch.parseRequestedInputStreams(
          descriptions: streamParameterDescription,
          requestedInputStreams: [streamParameterName],
        );

        expect(result, hasLength(1));
        expect(result, [streamParameterDescription[streamParameterName]]);
      },
    );

    test(
      'when invalid stream name is provided then exception is thrown informing that required stream parameter is missing.',
      () {
        expect(
          () => EndpointDispatch.parseRequestedInputStreams(
            descriptions: streamParameterDescription,
            requestedInputStreams: ['invalid_stream_name'],
          ),
          throwsA(
            isA<InvalidParametersException>().having(
              (e) => e.message,
              'exception',
              'Missing required stream parameter: $streamParameterName',
            ),
          ),
        );
      },
    );

    test(
      'when additional stream name is provided then only existing stream parameter description is returned.',
      () {
        expect(
          EndpointDispatch.parseRequestedInputStreams(
            descriptions: streamParameterDescription,
            requestedInputStreams: [
              streamParameterName,
              'additional_stream_name',
            ],
          ),
          [streamParameterDescription[streamParameterName]],
        );
      },
    );
  });
  group('Given single nullable parameter description', () {
    var nullableStreamParameterName = 'stream1';
    var streamParameterDescription = {
      nullableStreamParameterName: StreamParameterDescription<int>(
        name: nullableStreamParameterName,
        nullable: true,
      ),
    };
    test(
      'when valid stream name is provided then stream description is returned.',
      () {
        var result = EndpointDispatch.parseRequestedInputStreams(
          descriptions: streamParameterDescription,
          requestedInputStreams: [nullableStreamParameterName],
        );
        expect(result, hasLength(1));
        expect(result, [
          streamParameterDescription[nullableStreamParameterName],
        ]);
      },
    );

    test('when no stream name is provided then empty list returned.', () {
      expect(
        EndpointDispatch.parseRequestedInputStreams(
          descriptions: streamParameterDescription,
          requestedInputStreams: [],
        ),
        [],
      );
    });

    test(
      'when additional stream name is provided then only existing stream parameter description is returned.',
      () {
        expect(
          EndpointDispatch.parseRequestedInputStreams(
            descriptions: streamParameterDescription,
            requestedInputStreams: [
              nullableStreamParameterName,
              'additional_stream_name',
            ],
          ),
          [streamParameterDescription[nullableStreamParameterName]],
        );
      },
    );
  });
  group('Given multiple non nullable parameter descriptions', () {
    var streamParameterName1 = 'stream1';
    var streamParameterName2 = 'stream2';
    var streamParameterDescription = {
      streamParameterName1: StreamParameterDescription<int>(
        name: streamParameterName1,
        nullable: false,
      ),
      streamParameterName2: StreamParameterDescription<int>(
        name: streamParameterName2,
        nullable: false,
      ),
    };
    test(
      'when valid stream names are provided then stream descriptions are returned.',
      () {
        var result = EndpointDispatch.parseRequestedInputStreams(
          descriptions: streamParameterDescription,
          requestedInputStreams: [streamParameterName1, streamParameterName2],
        );
        expect(result, hasLength(2));
        expect(
          result,
          containsAll([
            streamParameterDescription[streamParameterName1],
            streamParameterDescription[streamParameterName2],
          ]),
        );
      },
    );

    test(
      'when only one stream name is provided then exception is thrown informing that required stream parameter is missing.',
      () {
        expect(
          () => EndpointDispatch.parseRequestedInputStreams(
            descriptions: streamParameterDescription,
            requestedInputStreams: [streamParameterName1],
          ),
          throwsA(
            isA<InvalidParametersException>().having(
              (e) => e.message,
              'exception',
              'Missing required stream parameter: $streamParameterName2',
            ),
          ),
        );
      },
    );
  });
}

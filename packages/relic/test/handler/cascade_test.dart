import 'package:relic/relic.dart';
import 'package:relic/src/method/request_method.dart';
import 'package:test/test.dart';

import '../util/test_util.dart';

void main() {
  group('Given a cascade with several handlers', () {
    late Handler handler;
    setUp(() {
      handler = Cascade().add((request) {
        if (request.headers.custom['one']?.first == 'false') {
          return Response.notFound(body: Body.fromString('handler 1'));
        } else {
          return Response.ok(body: Body.fromString('handler 1'));
        }
      }).add((request) {
        if (request.headers.custom['two']?.first == 'false') {
          return Response.notFound(body: Body.fromString('handler 2'));
        } else {
          return Response.ok(body: Body.fromString('handler 2'));
        }
      }).add((request) {
        if (request.headers.custom['three']?.first == 'false') {
          return Response.notFound(body: Body.fromString('handler 3'));
        } else {
          return Response.ok(body: Body.fromString('handler 3'));
        }
      }).handler;
    });

    test(
        'when a request with no headers is processed then the first response should be returned',
        () async {
      var response = await makeSimpleRequest(handler);
      expect(response.statusCode, equals(200));
      expect(response.readAsString(), completion(equals('handler 1')));
    });

    test(
        'when a request with header "one: false" is processed then the second response should be returned',
        () async {
      final response = await handler(
        Request(
          RequestMethod.get,
          localhostUri,
          headers: Headers.response(
            custom: CustomHeaders({
              'one': ['false']
            }),
          ),
        ),
      );
      expect(response.statusCode, equals(200));
      expect(response.readAsString(), completion(equals('handler 2')));
    });

    test(
        'when a request with headers "one: false" and "two: false" is processed then the third response should be returned',
        () async {
      final response = await handler(
        Request(
          RequestMethod.get,
          localhostUri,
          headers: Headers.response(
            custom: CustomHeaders({
              'one': ['false'],
              'two': ['false']
            }),
          ),
        ),
      );

      expect(response.statusCode, equals(200));
      expect(response.readAsString(), completion(equals('handler 3')));
    });

    test(
        'when a request with headers "one: false", "two: false", and "three: false" is processed then a 404 response should be returned',
        () async {
      final response = await handler(
        Request(
          RequestMethod.get,
          localhostUri,
          headers: Headers.response(
            custom: CustomHeaders(
              {
                'one': ['false'],
                'two': ['false'],
                'three': ['false']
              },
            ),
          ),
        ),
      );
      expect(response.statusCode, equals(404));
      expect(response.readAsString(), completion(equals('handler 3')));
    });
  });

  test(
      'Given a cascade with a 404 response when processed then it triggers the next handler',
      () async {
    var handler = Cascade()
        .add((_) => Response.notFound(body: Body.fromString(('handler 1'))))
        .add((_) => Response.ok(body: Body.fromString('handler 2')))
        .handler;

    final response = await makeSimpleRequest(handler);
    expect(response.statusCode, equals(200));
    expect(response.readAsString(), completion(equals('handler 2')));
  });

  test(
      'Given a cascade with a 405 response when processed then it triggers the next handler',
      () async {
    var handler = Cascade()
        .add((_) => Response(405))
        .add((_) => Response.ok(body: Body.fromString('handler 2')))
        .handler;

    final response = await makeSimpleRequest(handler);
    expect(response.statusCode, equals(200));
    expect(response.readAsString(), completion(equals('handler 2')));
  });

  test(
      'Given a cascade with specific statusCodes when processed then it controls which statuses cause cascading',
      () async {
    var handler = Cascade(statusCodes: [302, 403])
        .add((_) => Response.found(Uri.parse('/')))
        .add((_) => Response.forbidden(body: Body.fromString('handler 2')))
        .add((_) => Response.notFound(body: Body.fromString('handler 3')))
        .add((_) => Response.ok(body: Body.fromString('handler 4')))
        .handler;

    final response = await makeSimpleRequest(handler);
    expect(response.statusCode, equals(404));
    expect(response.readAsString(), completion(equals('handler 3')));
  });

  test(
      'Given a cascade with shouldCascade when processed then it controls which responses cause cascading',
      () async {
    var handler =
        Cascade(shouldCascade: (response) => response.statusCode.isOdd)
            .add((_) => Response.movedPermanently(Uri.parse('/')))
            .add((_) => Response.forbidden(body: Body.fromString('handler 2')))
            .add((_) => Response.notFound(body: Body.fromString('handler 3')))
            .add((_) => Response.ok(body: Body.fromString('handler 4')))
            .handler;

    final response = await makeSimpleRequest(handler);
    expect(response.statusCode, equals(404));
    expect(response.readAsString(), completion(equals('handler 3')));
  });

  group('Given error scenarios', () {
    test(
        'when getting the handler for an empty cascade then it throws a StateError',
        () {
      expect(() => Cascade().handler, throwsStateError);
    });

    test(
        'when both statusCodes and shouldCascade are provided then it throws an ArgumentError',
        () {
      expect(
          () => Cascade(statusCodes: [404, 405], shouldCascade: (_) => false),
          throwsArgumentError);
    });
  });
}

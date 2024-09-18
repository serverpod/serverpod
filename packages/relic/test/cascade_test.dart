import 'package:relic/relic.dart';
import 'package:test/test.dart';

import 'test_util.dart';

void main() {
  group('a cascade with several handlers', () {
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

    test('the first response should be returned if it matches', () async {
      var response = await makeSimpleRequest(handler);
      expect(response.statusCode, equals(200));
      expect(response.readAsString(), completion(equals('handler 1')));
    });

    test(
        'the second response should be returned if it matches and the first '
        "doesn't", () async {
      final response = await handler(
        Request(
          'GET',
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
        'the third response should be returned if it matches and the first '
        "two don't", () async {
      final response = await handler(
        Request(
          'GET',
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

    test('the third response should be returned if no response matches',
        () async {
      final response = await handler(
        Request(
          'GET',
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

  test('a 404 response triggers a cascade by default', () async {
    var handler = Cascade()
        .add((_) => Response.notFound(body: Body.fromString(('handler 1'))))
        .add((_) => Response.ok(body: Body.fromString('handler 2')))
        .handler;

    final response = await makeSimpleRequest(handler);
    expect(response.statusCode, equals(200));
    expect(response.readAsString(), completion(equals('handler 2')));
  });

  test('a 405 response triggers a cascade by default', () async {
    var handler = Cascade()
        .add((_) => Response(405))
        .add((_) => Response.ok(body: Body.fromString('handler 2')))
        .handler;

    final response = await makeSimpleRequest(handler);
    expect(response.statusCode, equals(200));
    expect(response.readAsString(), completion(equals('handler 2')));
  });

  test('[statusCodes] controls which statuses cause cascading', () async {
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

  test('[shouldCascade] controls which responses cause cascading', () async {
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

  group('errors', () {
    test('getting the handler for an empty cascade fails', () {
      expect(() => Cascade().handler, throwsStateError);
    });

    test('passing [statusCodes] and [shouldCascade] at the same time fails',
        () {
      expect(
          () => Cascade(statusCodes: [404, 405], shouldCascade: (_) => false),
          throwsArgumentError);
    });
  });
}

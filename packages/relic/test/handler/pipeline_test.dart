import 'package:relic/relic.dart';
import 'package:test/test.dart';

import '../util/test_util.dart';

void main() {
  var accessLocation = 0;

  setUp(() {
    accessLocation = 0;
  });

  Handler middlewareA(Handler innerHandler) => (request) {
        expect(accessLocation, 0);
        accessLocation = 1;
        final response = innerHandler(request);
        expect(accessLocation, 4);
        accessLocation = 5;
        return response;
      };

  Handler middlewareB(Handler innerHandler) => (request) {
        expect(accessLocation, 1);
        accessLocation = 2;
        final response = innerHandler(request);
        expect(accessLocation, 3);
        accessLocation = 4;
        return response;
      };

  Response innerHandler(Request request) {
    expect(accessLocation, 2);
    accessLocation = 3;
    return syncHandler(request);
  }

  test(
      'Given a pipeline with middlewareA and middlewareB when a request is processed then it completes with accessLocation 5',
      () async {
    var handler = const Pipeline()
        .addMiddleware(middlewareA)
        .addMiddleware(middlewareB)
        .addHandler(innerHandler);

    final response = await makeSimpleRequest(handler);
    expect(response, isNotNull);
    expect(accessLocation, 5);
  });

  test(
      'Given middlewareA and middlewareB when composed using extensions then a request completes with accessLocation 5',
      () async {
    var handler =
        middlewareA.addMiddleware(middlewareB).addHandler(innerHandler);

    final response = await makeSimpleRequest(handler);
    expect(response, isNotNull);
    expect(accessLocation, 5);
  });

  test(
      'Given a pipeline used as middleware when a request is processed then it completes with accessLocation 5',
      () async {
    var innerPipeline =
        const Pipeline().addMiddleware(middlewareA).addMiddleware(middlewareB);

    var handler = const Pipeline()
        .addMiddleware(innerPipeline.middleware)
        .addHandler(innerHandler);

    final response = await makeSimpleRequest(handler);
    expect(response, isNotNull);
    expect(accessLocation, 5);
  });
}

import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:relic/relic.dart';
import 'package:relic/src/method/request_method.dart';
import 'package:relic/src/static/extension/datetime_extension.dart';
import 'package:test/test.dart';

final p.Context _ctx = p.url;

/// Makes a simple GET request to [handler] and returns the result.
Future<Response> makeRequest(
  Handler handler,
  String path, {
  String? handlerPath,
  Headers? headers,
  RequestMethod method = RequestMethod.get,
}) async {
  final rootedHandler = _rootHandler(handlerPath, handler);
  return rootedHandler(_fromPath(path, headers, method: method));
}

Request _fromPath(
  String path,
  Headers? headers, {
  required RequestMethod method,
}) =>
    Request(
      method,
      Uri.parse('http://localhost$path'),
      headers: headers,
    );

Handler _rootHandler(String? path, Handler handler) {
  if (path == null || path.isEmpty) {
    return handler;
  }

  return (Request request) {
    if (!_ctx.isWithin('/$path', request.requestedUri.path)) {
      return Response.notFound(
        body: Body.fromString(
          'not found',
        ),
      );
    }
    assert(request.handlerPath == '/');

    final relativeRequest = request.copyWith(path: path);

    return handler(relativeRequest);
  };
}

Matcher atSameTimeToSecond(DateTime value) =>
    _SecondResolutionDateTimeMatcher(value);

class _SecondResolutionDateTimeMatcher extends Matcher {
  final DateTime _target;

  _SecondResolutionDateTimeMatcher(DateTime target)
      : _target = target.toSecondResolution;

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) {
    if (item is! DateTime) return false;

    return _datesEqualToSecond(_target, item);
  }

  @override
  Description describe(Description description) =>
      description.add('Must be at the same moment as $_target with resolution '
          'to the second.');
}

bool _datesEqualToSecond(DateTime d1, DateTime d2) =>
    d1.toSecondResolution.isAtSameMomentAs(d2.toSecondResolution);

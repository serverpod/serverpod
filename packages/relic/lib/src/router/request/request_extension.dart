import 'dart:collection' show UnmodifiableMapView;

import 'package:relic/relic.dart';

final _emptyParams = UnmodifiableMapView(<String, String>{});

extension RouterParams on Request {
  /// Get URL parameters captured by the [Router].
  ///
  /// **Example**
  /// ```dart
  /// final app = Router();
  ///
  /// app.get('/hello/<name>', (Request request) {
  ///   final name = request.params['name'];
  ///   return Response.ok('Hello $name');
  /// });
  /// ```
  ///
  /// If no parameters are captured this returns an empty map.
  ///
  /// The returned map is unmodifiable.
  Map<String, String> get params {
    final p = context['shelf_router/params'];
    if (p is Map<String, String>) {
      return UnmodifiableMapView(p);
    }
    return _emptyParams;
  }
}

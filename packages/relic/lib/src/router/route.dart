
// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:meta/meta.dart' show sealed;
import 'router.dart';

/// Annotation for handler methods that requests should be routed when using
/// package `shelf_router_generator`.
///
/// The `shelf_router_generator` packages makes it easy to generate a function
/// that wraps your class and returns a [Router] that forwards requests to
/// annotated methods. Simply add the `shelf_router_generator` and
/// `build_runner` packages to `dev_dependencies`, write as illustrated in the
/// following example and run `pub run build_runner build` to generate code.
///
/// **Example**
/// ```dart
/// // Always import 'shelf_router' without 'show' or 'as'.
/// import 'package:shelf_router/shelf_router.dart';
/// import 'package:shelf/shelf.dart' show Request, Response;
///
/// // Include generated code, this assumes current file is 'my_service.dart'.
/// part 'my_service.g.dart';
///
/// class MyService {
///   @Route.get('/say-hello/<name>')
///   Future<Response> _sayHello(Request request, String name) async {
///     return Response.ok('hello $name');
///   }
///
///   /// Get a router for this service.
///   Router get router => _$MyServiceRouter(this);
/// }
/// ```
///
/// It is also permitted to annotate public members, the only requirement is
/// that the member has a signature accepted by [Router] as `handler`.
@sealed
class Route {
  /// HTTP verb for requests routed to the annotated method.
  final String verb;

  /// HTTP route for request routed to the annotated method.
  final String route;

  /// Create an annotation that routes requests matching [verb] and [route] to
  /// the annotated method.
  const Route(this.verb, this.route);

  /// Route all requests matching [route] to annotated method.
  const Route.all(this.route) : verb = r'$all';

  /// Route `GET` requests matching [route] to annotated method.
  const Route.get(this.route) : verb = 'GET';

  /// Route `HEAD` requests matching [route] to annotated method.
  const Route.head(this.route) : verb = 'HEAD';

  /// Route `POST` requests matching [route] to annotated method.
  const Route.post(this.route) : verb = 'POST';

  /// Route `PUT` requests matching [route] to annotated method.
  const Route.put(this.route) : verb = 'PUT';

  /// Route `DELETE` requests matching [route] to annotated method.
  const Route.delete(this.route) : verb = 'DELETE';

  /// Route `CONNECT` requests matching [route] to annotated method.
  const Route.connect(this.route) : verb = 'CONNECT';

  /// Route `OPTIONS` requests matching [route] to annotated method.
  const Route.options(this.route) : verb = 'OPTIONS';

  /// Route `TRACE` requests matching [route] to annotated method.
  const Route.trace(this.route) : verb = 'TRACE';

  /// Route `MOUNT` requests matching [route] to annotated method.
  const Route.mount(String prefix)
      : verb = r'$mount',
        route = prefix;
}

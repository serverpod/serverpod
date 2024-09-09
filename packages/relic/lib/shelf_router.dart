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

/// A request routing library for shelf.
///
/// When writing a shelf web server it is often desirable to route requests to
/// different handlers based on HTTP method and path patterns. The following
/// example demonstrates how to do this using [Router].
///
/// **Example**
/// ```dart
/// import 'package:shelf_router/shelf_router.dart';
/// import 'package:shelf/shelf.dart' show Request, Response;
/// import 'package:shelf/shelf_io.dart' as io;
///
/// void main() async {
///   // Create a router
///   final router = Router();
///
///   // Handle GET requests with a path matching ^/say-hello/[^\]*$
///   router.get('/say-hello/<name>', (Request request, String name) async {
///     return Response.ok('hello $name');
///   });
///
///   // Listen for requests on port localhost:8080
///   await io.serve(router, 'localhost', 8080);
/// }
/// ```
///
/// As it is often useful to organize request handlers in classes, methods can
/// be annotated with the [Route] annotation, allowing the
/// `shelf_router_generator` package to generated a method for creating a
/// [Router] wrapping the class.
///
/// To automatically generate add the `shelf_router_generator` and
/// `build_runner` packages to `dev_dependencies`. The follow the example
/// below and generate code using `pub run build_runner build`.
///
/// **Example**, assume file name is `hello.dart`.
/// ```dart
/// import 'package:shelf_router/shelf_router.dart';
/// import 'package:shelf/shelf.dart' show Request, Response;
/// import 'package:shelf/shelf_io.dart' as io;
///
/// // include the generated part, assumes current file is 'hello.dart'.
/// part 'hello.g.dart';
///
/// class HelloService {
///   // Annotate a handler with the `Route` annotation.
///   @Route.get('/say-hello/<name>')
///   Future<Response> _sayHello(Request request, String name) async {
///     return Response.ok('hello $name');
///   }
///
///   // Use the generated function `_$<ClassName>Router(<ClassName> instance)`
///   // to create a getter returning a `Router` for this instance of
///   // `HelloService`
///   Router get router => _$HelloServiceRouter(this);
/// }
///
/// void main() async {
///   // Create a `HelloService` instance
///   final service = HelloService();
///
///   await io.serve(service.router.handler, 'localhost', 8080);
/// }
/// ```
library;

export 'src/router/route.dart';
export 'src/router/router.dart';

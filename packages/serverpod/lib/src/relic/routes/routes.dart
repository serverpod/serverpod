part of '../web_server.dart';

/// Defines HTTP call methods for routes.
enum RouteMethod {
  /// HTTP get.
  get,

  /// HTTP post.
  post,
}

/// A [Route] defines a destination in Serverpod's web server. It will handle
/// a call and generate an appropriate response by manipulating the
/// [HttpRequest] object. You override [Route], or more likely it's subclass
/// [WidgetRoute] to create your own custom routes in your server.
abstract class Route {
  /// The method this route will respond to, i.e. HTTP get or post.
  final RouteMethod method;
  String? _matchPath;

  /// Creates a new [Route].
  Route({this.method = RouteMethod.get});

  /// Handles a call to this route. This method is responsible for setting
  /// a correct response headers, status code, and write the response body to
  /// `request.response`.
  Future<Response> handleCall(Session session, Request request);

  bool _isMatch(String path) {
    if (_matchPath == null) {
      return false;
    }
    if (_matchPath!.endsWith('*')) {
      var start = _matchPath!.substring(0, _matchPath!.length - 1);
      return path.startsWith(start);
    } else {
      return _matchPath == path;
    }
  }

  // TODO: May want to create another abstraction layer here, to handle other
  // types of responses too. Or at least clarify the naming of the method.

  /// Returns the body of the request, assuming it is standard URL encoded form
  /// post request.
  static Future<Map<String, String>> getBody(HttpRequest request) async {
    var body = await _readBody(request);

    var params = <String, String>{};

    if (body != null) {
      var encodedParams = body.split('&');
      for (var encodedParam in encodedParams) {
        var comps = encodedParam.split('=');
        if (comps.length != 2) {
          continue;
        }

        var name = Uri.decodeQueryComponent(comps[0]);
        var value = Uri.decodeQueryComponent(comps[1]);

        params[name] = value;
      }
    }

    return params;
  }

  static Future<String?> _readBody(HttpRequest request) async {

    var builder = BytesBuilder();
    var len = 0;

    await for (var segment in request) {
      len += segment.length;
      if (len > 10240) {
        /// Limit exceeded
        return null;
      }
      builder.add(segment);
    }

    /// Converts the accumulated bytes
    return const Utf8Decoder().convert(
      builder.takeBytes(),
    );
  }
}

/// A [WidgetRoute] is the most convenient way to create routes in your server.
/// Override the [build] method and return an appropriate [Widget].
abstract class WidgetRoute extends Route {
  /// Override this method to build your web [Widget] from the current [session]
  /// and [request].
  Future<AbstractWidget> build(Session session, Request request);

  @override
  Future<Response> handleCall(Session session, Request request) async {
    var widget = await build(session, request);
    return widget.handleResponse(session, request);
  }
}

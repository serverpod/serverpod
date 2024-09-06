import 'package:mustache_template/mustache.dart';
import 'package:serverpod/serverpod.dart';
import 'dart:convert';

/// The base class for all web widgets. Override this class to create a custom
/// widget type, or use one of the default types which covers most common use
/// cases.
abstract class AbstractWidget {
  /// Handles the HTTP response for the widget. Subclasses should override this
  /// to return the appropriate [Response] based on the [session] and [request].
  Future<Response> handleResponse(Session session, Request request);
}

/// A widget based on a HTML template. The [name] of the template should
/// correspond to a template file in your server's web/templates directory.
/// Set the custom values of the template by populating the [values] field. If
/// values are set that aren't [String]s, the `toString` method will be called
/// on the value. The templates are loaded when the server starts. If you add
/// new templates or modify existing templates, you will need to restart the
/// server for them to take effect.
class Widget extends AbstractWidget {
  /// The name of the template used by this [Widget].
  final String name;

  /// The template used by this widget.
  late final Template template;

  /// Key/value pairs passed to the template. The values will be converted to
  /// strings using the toString method of the values.
  Map<String, dynamic> values = {};

  /// Creates a new [Widget].
  Widget({
    required this.name,
  }) {
    assert(templates[name] != null,
        'Template $name.html missing for $runtimeType');
    template = templates[name]!;
  }

  @override
  Future<Response> handleResponse(
    Session session,
    Request request,
  ) async {
    return Response.ok(
      body: Body.fromString(
        template.renderString(values),
        contentType: BodyType.xml,
      ),
    );
  }
}

/// Combines a List of [Widget]s into a single widget.
class WidgetList extends AbstractWidget {
  /// List of original widgets.
  final List<Widget> widgets;

  /// Creates a new widget list.
  WidgetList({required this.widgets});

  @override
  Future<Response> handleResponse(
    Session session,
    Request request,
  ) async {
    var rendered = <String>[];
    for (var widget in widgets) {
      rendered.add(widget.toString());
    }
    return Response.ok(
      body: Body.fromString(
        rendered.join('\n'),
        contentType: BodyType.xml,
      ),
    );
  }
}

/// A widget that renders JSON output. The output will be the result of passing
/// the provided [object] to [jsonEncode].
class WidgetJson extends AbstractWidget {
  /// The original object to be rendered as JSON.
  final dynamic object;

  /// Creates a new [WidgetJson].
  WidgetJson({required this.object});

  @override
  Future<Response> handleResponse(
    Session session,
    Request request,
  ) async {
    return Response.ok(
      body: Body.fromString(
        SerializationManager.encode(object),
        contentType: BodyType.json,
      ),
    );
  }
}

/// A widget that renders a HTTP redirect to the provided [url].
class WidgetRedirectPermanently extends AbstractWidget {
  /// The [url] to redirect to.
  final Uri url;

  /// Creates a new widget that renders a redirect.
  WidgetRedirectPermanently({required this.url});

  @override
  Future<Response> handleResponse(
    Session session,
    Request request,
  ) async {
    return Response.movedPermanently(url);
  }
}

/// A widget that renders a HTTP redirect to the provided [url].
class WidgetRedirectTemporarily extends AbstractWidget {
  /// The [url] to redirect to.
  final Uri url;

  /// Creates a new widget that renders a redirect.
  WidgetRedirectTemporarily({required this.url});

  @override
  Future<Response> handleResponse(
    Session session,
    Request request,
  ) async {
    return Response.seeOther(url);
  }
}

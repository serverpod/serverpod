import 'package:mustache_template/mustache.dart';
import 'package:serverpod/serverpod.dart';
import 'dart:convert';

/// The base class for all web widgets. Override this class to create a custom
/// widget type, or use one of the default types which covers most common use
/// cases.
abstract class AbstractComponent {}

/// A component based on a HTML template. The [name] of the template should
/// correspond to a template file in your server's web/templates directory.
/// Set the custom values of the template by populating the [values] field. If
/// values are set that aren't [String]s, the `toString` method will be called
/// on the value. The templates are loaded when the server starts. If you add
/// new templates or modify existing templates, you will need to restart the
/// server for them to take effect.
class Component extends AbstractComponent {
  /// The name of the template used by this [Component].
  final String name;

  /// The template used by this component.
  late final Template template;

  /// Key/value pairs passed to the template. The values will be converted to
  /// strings using the toString method of the values.
  Map<String, dynamic> values = {};

  /// Creates a new [Component].
  Component({
    required this.name,
  }) {
    var cachedTemplate = templates[name];
    if (cachedTemplate == null) {
      throw StateError('Template $name.html missing for $runtimeType');
    }
    template = cachedTemplate;
  }

  @override
  String toString() {
    return template.renderString(values);
  }
}

/// Combines a List of [Component]s into a single component.
class ListComponent extends AbstractComponent {
  /// List of original widgets.
  final List<Component> widgets;

  /// Creates a new list component.
  ListComponent({required this.widgets});

  @override
  String toString() {
    var rendered = <String>[];
    for (var widget in widgets) {
      rendered.add(widget.toString());
    }
    return rendered.join('\n');
  }
}

/// A component that renders JSON output. The output will be the result of passing
/// the provided [object] to [jsonEncode].
class JsonComponent extends AbstractComponent {
  /// The original object to be rendered as JSON.
  final dynamic object;

  /// Creates a new [JsonComponent].
  JsonComponent({required this.object});

  @override
  String toString() {
    return SerializationManager.encode(object);
  }
}

/// A component that renders a HTTP redirect to the provided [url].
class RedirectComponent extends AbstractComponent {
  /// The [url] to redirect to.
  final String url;

  /// Creates a new component that renders a redirect.
  RedirectComponent({required this.url});

  @override
  String toString() {
    return '';
  }
}

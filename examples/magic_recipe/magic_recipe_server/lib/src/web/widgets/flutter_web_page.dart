import 'package:serverpod/serverpod.dart';

/// A widget that displays the Serverpod version and the current run mode.
/// It uses the built_with_serverpod.html template to render the page.
/// The [name] of the template should correspond to a template file in your
/// server's web/templates directory.
class FlutterWebPage extends Widget {
  FlutterWebPage() : super(name: 'index');
}

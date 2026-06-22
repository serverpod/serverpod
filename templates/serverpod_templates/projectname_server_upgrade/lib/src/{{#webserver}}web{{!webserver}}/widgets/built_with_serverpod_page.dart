import 'package:serverpod/serverpod.dart';

/// A widget that displays the Serverpod version and the current run mode.
/// It uses the built_with_serverpod.html template to render the page.
/// The [name] of the template should correspond to a template file in your
/// server's web/templates directory.
class BuiltWithServerpodPageWidget extends TemplateWidget {
  BuiltWithServerpodPageWidget() : super(name: 'built_with_serverpod') {
    values = {'served': DateTime.now(), 'runmode': Serverpod.instance.runMode};
  }
}

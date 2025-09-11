import 'package:serverpod/serverpod.dart';

/// A widget that displays the static assets example page.
/// It uses the index.html template to render the page with cache-busted assets.
class IndexPageWidget extends TemplateWidget {
  IndexPageWidget() : super(name: 'index') {
    // Note: The template uses direct paths since RouteStaticDirectory
    // with enableAutomaticCacheBusting: true handles cache busting automatically.
    values = {
      'title': 'Static Assets Example',
      'message': 'This example demonstrates static asset cache busting',
    };
  }
}

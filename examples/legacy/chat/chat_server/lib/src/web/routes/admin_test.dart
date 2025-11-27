import 'package:serverpod/serverpod.dart';
import '../widgets/admin_dashboard_widget.dart';

class AdminTestRoute extends WidgetRoute {
  @override
  Future<TemplateWidget> build(Session session, Request request) async {
    var path = request.requestedUri.path;

    if (path == '/admin/dashboard') {
      return AdminDashboardWidget();
    } else if (path == '/admin/test') {
      // admin dashboard to demonstrate nested template works
      return AdminDashboardWidget();
    }

    // Default admin test page
    return AdminDashboardWidget();
  }
}

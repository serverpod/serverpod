import 'package:serverpod/serverpod.dart';

class DefaultPageWidget extends WebWidget {
  DefaultPageWidget() : super(name: 'default') {
    values = {
      'served': DateTime.now(),
      'runmode': Serverpod.instance.runMode,
    };
  }
}

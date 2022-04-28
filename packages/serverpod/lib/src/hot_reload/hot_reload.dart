import 'dart:developer' as dev;
import 'dart:io';

import 'package:vm_service/utils.dart' as vms_utils;
import 'package:vm_service/vm_service.dart' as vms;
import 'package:vm_service/vm_service_io.dart' as vms_io;

/// Manages Serverpod hot reloads, normally invoked through `serverpod run`.
class HotReloader {
  static Future<vms.VmService> _getVmService() async {
    Uri? devServiceURL = (await dev.Service.getInfo()).serverUri;
    if (devServiceURL == null) {
      throw StateError(
        'Hot reload not available. You need to run dart with --enable-vm-service.',
      );
    }
    Uri wsURL =
        vms_utils.convertToWebSocketUrl(serviceProtocolUrl: devServiceURL);
    return vms_io.vmServiceConnectUri(wsURL.toString());
  }

  /// Returns true if hot reload is available.
  static Future<bool> isHotReloadAvailable() async {
    try {
      await _getVmService();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Hot reloads the server code. You should probably only call this method
  /// if you really know what you are doing.
  static Future<bool> hotReload() async {
    vms.VmService vmService = await _getVmService();
    vms.VM vm = await vmService.getVM();
    vms.IsolateRef mainIsolate = vm.isolates!.first;
    vms.ReloadReport report = await vmService.reloadSources(mainIsolate.id!);

    if (report.success ?? false) {
      stdout.writeln('Performed hot reload');
      return true;
    } else {
      stderr.writeln('Failed to perform hot reload');

      if (report.json!['type'] == 'ReloadReport') {
        List<Map<String, dynamic>> notices = report.json!['notices'];
        for (Map<String, dynamic> notice in notices) {
          notice;
          stderr.writeln(notice['message']);
        }
      } else {
        stderr.writeln(report.json);
      }
      return false;
    }
  }
}

import 'dart:io';

import 'package:dds/dap.dart';
// `DartCliDebugAdapter` is the right base class but it lives in `dds/src/`
// and isn't re-exported from `package:dds/dap.dart`. Subclassing it is what
// flutter_tools does for its own DAP, and pinning `dds: ^5.3.0` (matched to
// the SDK floor) bounds the risk that the surface changes under us.
// ignore: implementation_imports
import 'package:dds/src/dap/adapters/dart_cli_adapter.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
import 'package:vm_service/vm_service.dart' as vm;

/// Service alias the `serverpod start` process uses when it registers its
/// hot-reload / hot-restart entrypoints on the pod's VM service. See
/// `ServerProcess.connectToVmService`.
const _serverpodAlias = 'serverpod-cli';
const _hotReloadService = 'hotReload';
const _hotRestartService = 'hotRestart';

/// Serverpod's Debug Adapter.
///
/// Adds an override for the IDE's `hotReload` / `hotRestart` custom requests:
/// instead of letting the base adapter call the VM's built-in `reloadSources`
/// (which crashes the kernel_service when the isolate was booted from a
/// precompiled dill), we route the call to the `serverpod-cli.hotReload` /
/// `serverpod-cli.hotRestart` VM service method registered by the running
/// `serverpod start` process. That process owns the FES, build hooks, and
/// code-gen pipeline and runs the full reload / restart cycle through them.
class ServerpodDebugAdapter extends DartCliDebugAdapter {
  /// Fully-qualified namespaced method name (e.g. `s0.hotReload`) discovered
  /// via `ServiceRegistered` events. Null until we observe the registration.
  String? _hotReloadMethod;

  /// Fully-qualified namespaced method name for the hot-restart entrypoint.
  /// Tracked separately so VS Code's restart button doesn't quietly fall
  /// back to a reload when only one of the two is registered.
  String? _hotRestartMethod;

  ServerpodDebugAdapter(
    super.channel, {
    super.ipv6,
    super.logger,
    super.onError,
  });

  /// Enriches incoming attach args with `cwd` and `vmServiceInfoFile`
  /// derived from [ServerDirectoryFinder] so the user's launch.json can be
  /// just `{name, type: 'serverpod', request: 'attach'}`. Both fields are
  /// only filled when missing - a user-supplied value always wins.
  ///
  /// `args` is `late final` on the base class, so we substitute an enriched
  /// copy *before* delegating to super (which sets it).
  @override
  Future<void> attachRequest(
    Request request,
    DartAttachRequestArguments args,
    void Function() sendResponse,
  ) async {
    final enriched = await _enrichAttachArgs(args);
    return super.attachRequest(request, enriched, sendResponse);
  }

  Future<DartAttachRequestArguments> _enrichAttachArgs(
    DartAttachRequestArguments args,
  ) async {
    final hasUri = args.vmServiceUri != null;
    final hasInfoFile = args.vmServiceInfoFile != null;
    final hasCwd = args.cwd != null;
    if (hasCwd && (hasUri || hasInfoFile)) return args;

    // Only run the directory walk when we actually need a server dir.
    // If the user already provided cwd, derive vmServiceInfoFile from it.
    if (hasCwd) {
      final json = Map<String, Object?>.from(args.toJson());
      json['vmServiceInfoFile'] = p.join(
        args.cwd!,
        '.dart_tool',
        'serverpod',
        'vm-service-info.json',
      );
      return DartAttachRequestArguments.fromJson(json);
    }

    final Directory dir;
    try {
      dir = await ServerDirectoryFinder.findOrPrompt(interactive: false);
    } on Object {
      // Discovery failed; let the base adapter raise its standard error.
      return args;
    }

    final json = Map<String, Object?>.from(args.toJson());
    json['cwd'] = dir.path;
    if (!hasUri && !hasInfoFile) {
      json['vmServiceInfoFile'] = p.join(
        dir.path,
        '.dart_tool',
        'serverpod',
        'vm-service-info.json',
      );
    }
    return DartAttachRequestArguments.fromJson(json);
  }

  @override
  Future<void> handleServiceEvent(vm.Event event) async {
    final isRegister = event.kind == vm.EventKind.kServiceRegistered;
    final isUnregister = event.kind == vm.EventKind.kServiceUnregistered;
    if ((isRegister || isUnregister) && event.alias == _serverpodAlias) {
      final method = isRegister ? event.method : null;
      switch (event.service) {
        case _hotReloadService:
          _hotReloadMethod = method;
        case _hotRestartService:
          _hotRestartMethod = method;
      }
    }
    await super.handleServiceEvent(event);
  }

  @override
  Future<void> customRequest(
    Request request,
    RawRequestArguments? args,
    void Function(Object?) sendResponse,
  ) async {
    switch (request.command) {
      case 'hotReload':
        await _callServerpodService(
          method: _hotReloadMethod,
          serviceName: 'serverpod-cli.hotReload',
          action: 'hot reload',
          sendResponse: sendResponse,
        );
        return;
      case 'hotRestart':
        await _callServerpodService(
          method: _hotRestartMethod,
          serviceName: 'serverpod-cli.hotRestart',
          action: 'hot restart',
          sendResponse: sendResponse,
        );
        return;
      default:
        await super.customRequest(request, args, sendResponse);
    }
  }

  Future<void> _callServerpodService({
    required String? method,
    required String serviceName,
    required String action,
    required void Function(Object?) sendResponse,
  }) async {
    if (method == null) {
      throw DebugAdapterException(
        'Cannot $action: $serviceName is not registered on the VM '
        'service. Make sure `serverpod start --watch` is running.',
      );
    }
    final service = vmService;
    if (service == null) {
      throw DebugAdapterException(
        'Cannot $action: no VM service connection.',
      );
    }
    try {
      final response = await service.callMethod(method);
      sendResponse(response.json);
    } on vm.RPCError catch (e) {
      throw DebugAdapterException(
        '${action[0].toUpperCase()}${action.substring(1)} failed: '
        '${e.details ?? e.message}',
      );
    }
  }
}

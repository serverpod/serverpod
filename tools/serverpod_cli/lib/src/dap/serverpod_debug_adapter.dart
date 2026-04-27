// `DartCliDebugAdapter` is the right base class but it lives in `dds/src/`
// and isn't re-exported from `package:dds/dap.dart`. Subclassing it is what
// flutter_tools does for its own DAP, and pinning `dds: ^5.3.0` (matched to
// the SDK floor) bounds the risk that the surface changes under us.
// ignore: implementation_imports
import 'package:dds/src/dap/adapters/dart_cli_adapter.dart';

/// Serverpod's Debug Adapter.
///
/// Currently a thin pass-through over [DartCliDebugAdapter]; the next step
/// adds a `customRequest` override that routes `hotReload` / `hotRestart`
/// from the IDE through a `serverpod-cli.hotReload` VM service method
/// registered by the running `serverpod start` process. Until that override
/// lands, this class behaves exactly like the stock Dart adapter.
class ServerpodDebugAdapter extends DartCliDebugAdapter {
  ServerpodDebugAdapter(
    super.channel, {
    super.ipv6,
    super.logger,
    super.onError,
  });
}

// Generated protocol file for static assets example
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;

/// Empty protocol for the static assets example
class Protocol extends _i1.SerializationManagerServer {
  Protocol() : super();

  @override
  String getModuleName() => 'static_assets_example';

  @override
  _i1.Table? getTableForType(Type type) => null;

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() => [];
}

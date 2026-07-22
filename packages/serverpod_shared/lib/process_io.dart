/// Process-control primitives that depend on `dart:io` + `dart:ffi` +
/// `package:win32` and therefore do not work on the web. Import this in
/// addition to `package:serverpod_shared/serverpod_shared.dart` when you
/// need [isProcessAlive] / [readProcessExecutable] / [InterProcessLock].
///
/// Kept out of the main barrel so dart2js / dart2wasm consumers (e.g.
/// browser code transitively reaching us via `serverpod_service_client`)
/// don't pull `package:win32`'s `external Pointer<...>` types into the
/// compile graph.
library;

export 'src/utils/interprocess_lock.dart';
export 'src/utils/process_alive.dart';
export 'src/utils/sdk_path.dart';
export 'src/utils/serverpod_cli_build.dart';
export 'src/utils/shared_test_dir.dart';

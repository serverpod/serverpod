/// Moved to serverpod_shared so tests and other packages resolve the SDK the
/// same way (through version-manager shims like puro/fvm); re-exported here
/// for the existing call sites.
library;

export 'package:serverpod_shared/process_io.dart'
    show getSdkPath, dartExecutablePath;

// Generate command messages
const initialCodeGenerationComplete =
    '✓ Initial code generation complete. Listening for changes.';
const incrementalCodeGenerationComplete =
    '✓ Incremental code generation complete.';
const generatedCodeAlreadyUpToDate = '✓ Generated code is already up to date.';

// Start command messages
const serverRunning = 'Server running.';
const startingDockerServices = 'Starting Docker services';
const dockerComposeFileMissing =
    'No Docker Compose file (e.g. docker-compose.yaml) was found in the '
    'server project. Restore the project Docker configuration or run without '
    '`--docker`.';
const dockerNotInstalled =
    'Docker does not seem to be installed. Install Docker and try again, or '
    'pass `--no-docker` to skip starting Docker services.';
const dockerNotRunning =
    'Docker is not running. Start Docker and try again, or pass `--no-docker` '
    'to skip starting Docker services.';
const dockerComposeStartFailed =
    'Docker Compose could not start the project services. Check the Docker '
    'output, correct the problem, and try again.';

/// Shown when `serverpod start --watch` cannot bring the server up because the
/// project does not generate or compile. The file watcher keeps running, so a
/// fix is picked up automatically.
const startBlockedByErrorsWatch =
    'Waiting for the project to build. Once the errors above are resolved, '
    'the server will start automatically.';

/// Shown in `--no-watch` mode, where there is no file watcher to recover; the
/// user triggers a rebuild manually (the "R" action in the TUI).
const startBlockedByErrorsManual =
    'Waiting for the project to build. Once the errors above are resolved, '
    'press "R" to rebuild and start the server.';

// Watch command messages
const serverStarted = '✓ Server started.';
const serverReloaded = '✓ Server reloaded.';
const serverRestarted = '✓ Server restarted.';
const serverNativeAssetsChanged =
    'Server native assets changed. Restarting the server...';
const flutterAppReloaded = '✓ Flutter app reloaded.';
const flutterAppRestarted = '✓ Flutter app restarted.';
const browserRefreshTriggered = '✓ Browser refresh triggered.';
const flutterDependenciesChangedNative =
    'Flutter dependencies with native code changed. '
    'Relaunching the Flutter app...';
const flutterDependenciesChangedDart =
    'Flutter dependencies changed. Hot restarting the Flutter app...';
const flutterAssetsFontsChanged =
    'Flutter assets or fonts changed. Relaunching the Flutter app...';
const flutterAppsConfigChanged =
    'Flutter apps configuration changed. Reloading apps.';
const flutterPackageNotFound =
    'No Flutter package found; skipping --flutter. '
    'Pass --no-flutter to silence this notice.';

// Flutter process messages
const flutterAppLaunching = 'Launching Flutter app...';

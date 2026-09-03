import 'dart:io';

/// How a socket bind failure should be presented to the user.
enum SocketBindFailureKind {
  /// The OS reported the address/port is already in use.
  addressInUse,

  /// Any other bind failure (permission denied, bad address, etc.).
  other,
}

/// User-facing details for a failed [HttpServer]/[ServerSocket] bind.
final class SocketBindFailure {
  /// Creates a [SocketBindFailure].
  const SocketBindFailure({
    required this.kind,
    required this.userMessage,
    required this.omitStackTrace,
  });

  /// Classification of the failure.
  final SocketBindFailureKind kind;

  /// Message suitable for logging to the user.
  final String userMessage;

  /// Whether the stack trace should be omitted from the user-facing log.
  final bool omitStackTrace;
}

/// OS error codes for address-already-in-use across common platforms.
///
/// - 48: EADDRINUSE on macOS / BSD
/// - 98: EADDRINUSE on Linux
/// - 10048: WSAEADDRINUSE on Windows
const _addressInUseErrorCodes = {48, 98, 10048};

/// Returns true when [error] indicates a port/address bind conflict.
///
/// Covers:
/// - Classic EADDRINUSE / WSAEADDRINUSE (another process holds the port)
/// - Dart's same-process rebind error when api/insights/web share a port in
///   the same Serverpod process (`shared flag to bind()...`)
///
/// Prefers stable [OSError.errorCode] values, with a message substring fallback
/// for environments where the code is missing, non-standard (-1), or the OS
/// message is localized but still contains a recognizable English phrase.
bool isAddressAlreadyInUse(Object error) {
  if (error is! SocketException) return false;

  final osError = error.osError;
  final errorCode = osError?.errorCode;
  if (errorCode != null && _addressInUseErrorCodes.contains(errorCode)) {
    return true;
  }

  final message = [
    error.message,
    if (osError?.message != null) osError!.message,
  ].join(' ').toLowerCase();

  return message.contains('address already in use') ||
      message.contains('already in use') ||
      // Same process binding the same (address, port) twice (config overlap).
      message.contains('shared flag to bind') ||
      message.contains('binding multiple times on the same');
}

/// Builds a user-facing bind failure for [serverLabel] on [port].
///
/// [runMode] selects which config file to mention (e.g. `development` →
/// `config/development.yaml`). Only address-in-use failures omit the stack.
SocketBindFailure describeSocketBindFailure({
  required Object error,
  required String serverLabel,
  required int port,
  required String runMode,
}) {
  final configPath = 'config/$runMode.yaml';

  if (isAddressAlreadyInUse(error)) {
    return SocketBindFailure(
      kind: SocketBindFailureKind.addressInUse,
      userMessage:
          'Failed to bind $serverLabel on port $port: address already in use. '
          'Another process may be using this port, or api/insights/web ports '
          'may overlap in $configPath. Stop the process holding the port '
          '(including any leftover Serverpod from a partial start), or change '
          'the port in $configPath.',
      omitStackTrace: true,
    );
  }

  return SocketBindFailure(
    kind: SocketBindFailureKind.other,
    userMessage: 'Failed to bind $serverLabel on port $port.',
    omitStackTrace: false,
  );
}

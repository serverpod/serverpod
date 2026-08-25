/// The VM service extension event the pod posts once its listeners are bound.
///
/// The runner cannot know the addresses the pod resolved: with a configured
/// port of 0 they are only decided at bind time. It already subscribes to the
/// pod's `Extension` events for logs, so this rides the same channel rather
/// than adding a second one, and lands in the runner manifest that `serverpod
/// status` prints and pod clients read.
const serverpodAddressesEvent = 'ext.serverpod.addresses';

/// The addresses the pod's listeners actually resolved to.
///
/// Each is the URL a client should use, built from the public scheme, host and
/// port, which follow the bind port when it was ephemeral. A listener the
/// project did not configure is absent rather than null.
///
/// This lives in `serverpod_shared` because it is a contract between two
/// packages: the pod posts it and the CLI decodes it. Stated in either one it
/// would be a string literal and a hand-written map on the other side, with
/// nothing to catch the two drifting apart.
class ServerpodAddresses {
  /// Creates a set of resolved addresses.
  const ServerpodAddresses({this.api, this.insights, this.web});

  /// The URL clients should use for the API server, if it is configured.
  final String? api;

  /// The URL of the insights server, if it is configured.
  final String? insights;

  /// The URL of the web server, if it is configured.
  final String? web;

  /// Encodes these addresses as the event payload.
  Map<String, Object?> toJson() => {
    if (api != null) 'api': api,
    if (insights != null) 'insights': insights,
    if (web != null) 'web': web,
  };

  /// Decodes what [toJson] produced.
  static ServerpodAddresses fromJson(Map<String, Object?> json) =>
      ServerpodAddresses(
        api: json['api'] as String?,
        insights: json['insights'] as String?,
        web: json['web'] as String?,
      );
}

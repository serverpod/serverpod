/// The VM service extension event the pod posts once its listeners are bound.
///
/// See `docs/design/runner.md#address-publication`.
const serverpodAddressesEvent = 'ext.serverpod.addresses';

/// The public listener URLs a [serverpodAddressesEvent] carries.
class ServerpodAddresses {
  /// Creates addresses for the given listeners.
  const ServerpodAddresses({this.api, this.insights, this.web});

  /// The URL of the API server, or null when it is not running.
  final String? api;

  /// The URL of the insights server, or null when it is not running.
  final String? insights;

  /// The URL of the web server, or null when it is not running.
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

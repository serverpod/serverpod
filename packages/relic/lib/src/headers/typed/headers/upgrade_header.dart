import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Upgrade header.
///
/// This class manages the protocols that the client supports for upgrading the
/// connection.
class UpgradeHeader implements TypedHeader {
  /// The list of protocols that the client supports.
  final List<UpgradeProtocol> protocols;

  /// Constructs an [UpgradeHeader] instance with the specified protocols.
  UpgradeHeader({required this.protocols});

  /// Parses the Upgrade header value and returns an [UpgradeHeader] instance.
  ///
  /// This method processes the header value, extracting the list of protocols.
  factory UpgradeHeader.parse(List<String> values) {
    final splitValues = values.splitTrimAndFilterUnique(separator: ',');
    if (splitValues.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    final protocols =
        splitValues.map((protocol) => UpgradeProtocol.parse(protocol)).toList();

    return UpgradeHeader(protocols: protocols);
  }

  /// Converts the [UpgradeHeader] instance into a string representation
  /// suitable for HTTP headers.
  @override
  String toHeaderString() {
    return protocols.map((protocol) => protocol.toHeaderString()).join(', ');
  }

  @override
  String toString() {
    return 'UpgradeHeader(protocols: $protocols)';
  }
}

/// A class representing a single protocol in the Upgrade header.
class UpgradeProtocol {
  /// The name of the protocol.
  final String protocol;

  /// The version of the protocol.
  final double? version;

  /// Constructs an [UpgradeProtocol] instance with the specified name and version.
  UpgradeProtocol({
    required this.protocol,
    this.version,
  });

  /// Parses a protocol string and returns an [UpgradeProtocol] instance.
  factory UpgradeProtocol.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Protocol cannot be empty');
    }

    var split = trimmed.split('/');
    if (split.length == 1) {
      return UpgradeProtocol(protocol: split[0]);
    }

    var protocol = split[0];
    if (protocol.isEmpty) {
      throw FormatException('Protocol cannot be empty');
    }

    var version = split[1];
    if (version.isEmpty) {
      throw FormatException('Version cannot be empty');
    }

    var parsedVersion = double.tryParse(version);
    if (parsedVersion == null) {
      throw FormatException('Invalid version');
    }

    return UpgradeProtocol(
      protocol: protocol,
      version: parsedVersion,
    );
  }

  /// Converts the [UpgradeProtocol] instance into a string representation.
  String toHeaderString() => '$protocol${version != null ? '/$version' : ''}';

  @override
  String toString() {
    return 'UpgradeProtocol(protocol: $protocol, version: $version)';
  }
}

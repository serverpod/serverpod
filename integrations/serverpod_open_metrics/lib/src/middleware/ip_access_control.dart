import 'dart:io';
import 'dart:typed_data';

/// Represents a single IP address or subnet (CIDR) access rule.
///
/// This class can match both individual IP addresses and subnet ranges
/// specified in CIDR notation. Supports both IPv4 and IPv6.
///
/// ## Examples
///
/// ```dart
/// // Single IPv4 address
/// final rule1 = IpAccessRule.parse('192.168.1.100');
///
/// // IPv4 subnet in CIDR notation
/// final rule2 = IpAccessRule.parse('192.168.0.0/16');
///
/// // IPv6 address
/// final rule3 = IpAccessRule.parse('::1');
///
/// // IPv6 subnet
/// final rule4 = IpAccessRule.parse('2001:db8::/32');
///
/// // Check if an IP matches
/// final ip = InternetAddress('192.168.1.150');
/// if (rule2.matches(ip)) {
///   print('IP is in the allowed subnet');
/// }
/// ```
class IpAccessRule {
  /// The base address of this rule.
  final InternetAddress address;

  /// The CIDR prefix length, or null for single IP addresses.
  ///
  /// For IPv4: 0-32
  /// For IPv6: 0-128
  /// null means exact IP match (equivalent to /32 or /128)
  final int? prefixLength;

  IpAccessRule._(this.address, this.prefixLength);

  /// Parse an IP address or CIDR subnet from a string.
  ///
  /// Accepts formats:
  /// - IPv4: `192.168.1.100` or `192.168.0.0/16`
  /// - IPv6: `::1` or `2001:db8::/32`
  ///
  /// Throws [ArgumentError] if the format is invalid or the prefix length
  /// is out of range.
  factory IpAccessRule.parse(final String rule) {
    try {
      // Split on '/' to separate IP from optional CIDR prefix
      final parts = rule.split('/');
      if (parts.isEmpty || parts.length > 2) {
        throw ArgumentError('Invalid IP rule format: $rule');
      }

      // Parse the IP address
      final address = InternetAddress(parts[0].trim());

      // Parse optional CIDR prefix
      int? prefixLength;
      if (parts.length == 2) {
        prefixLength = int.parse(parts[1].trim());

        // Validate prefix length based on IP type
        final maxPrefix = address.type == InternetAddressType.IPv4 ? 32 : 128;
        if (prefixLength < 0 || prefixLength > maxPrefix) {
          throw ArgumentError(
            'Invalid CIDR prefix length $prefixLength for ${address.type.name}. '
            'Must be 0-$maxPrefix.',
          );
        }
      }

      return IpAccessRule._(address, prefixLength);
    } on FormatException catch (e) {
      throw ArgumentError('Invalid IP address format in rule "$rule": $e');
    } catch (e) {
      if (e is ArgumentError) rethrow;
      throw ArgumentError('Failed to parse IP rule "$rule": $e');
    }
  }

  /// Check if the given IP address matches this rule.
  ///
  /// For single IP rules (no prefix), performs exact match.
  /// For subnet rules (with CIDR prefix), checks if the IP is within the subnet.
  ///
  /// Returns false if the IP address family (IPv4/IPv6) doesn't match.
  bool matches(final InternetAddress ip) {
    // IP families must match (IPv4 != IPv6)
    if (ip.type != address.type) {
      return false;
    }

    // Single IP match (no CIDR prefix)
    if (prefixLength == null) {
      return ip.address == address.address;
    }

    // Subnet match - compare network portions
    return _isInSubnet(
      ip.rawAddress,
      address.rawAddress,
      prefixLength!,
    );
  }

  /// Check if an IP address is within a subnet using bitwise comparison.
  ///
  /// Compares the first [prefixLen] bits of [ipBytes] with [subnetBytes].
  /// Returns true if all prefix bits match.
  bool _isInSubnet(
    final Uint8List ipBytes,
    final Uint8List subnetBytes,
    final int prefixLen,
  ) {
    // Calculate how many full bytes to compare
    final fullBytes = prefixLen ~/ 8;
    final remainingBits = prefixLen % 8;

    // Compare full bytes
    for (var i = 0; i < fullBytes; i++) {
      if (ipBytes[i] != subnetBytes[i]) {
        return false;
      }
    }

    // Compare remaining bits in the partial byte
    if (remainingBits > 0) {
      // Create a mask for the remaining bits
      // E.g., for 3 bits: 11100000 = 0xE0
      final mask = (0xFF << (8 - remainingBits)) & 0xFF;
      if ((ipBytes[fullBytes] & mask) != (subnetBytes[fullBytes] & mask)) {
        return false;
      }
    }

    return true;
  }

  @override
  String toString() {
    if (prefixLength != null) {
      return '${address.address}/$prefixLength';
    }
    return address.address;
  }
}

/// Manages IP-based access control using an allowlist of IP addresses and subnets.
///
/// This class validates client IP addresses against a configured set of allowed
/// IP addresses and CIDR subnets. It's designed for fail-fast operation - all
/// rules are parsed and validated at creation time.
///
/// ## Basic Usage
///
/// ```dart
/// // Allow specific IPs and subnets
/// final control = IpAccessControl([
///   '127.0.0.1',        // localhost
///   '::1',              // IPv6 localhost
///   '192.168.0.0/16',   // private network
///   '10.0.0.0/8',       // another private network
/// ]);
///
/// // Check if an IP is allowed
/// if (control.isAllowed('192.168.1.100')) {
///   print('Access granted');
/// } else {
///   print('Access denied');
/// }
/// ```
///
/// ## Localhost Only
///
/// ```dart
/// // Use the factory for localhost-only access
/// final control = IpAccessControl.localhostOnly();
/// ```
class IpAccessControl {
  /// The parsed access rules.
  final List<IpAccessRule> rules;

  /// Default localhost-only allowlist (both IPv4 and IPv6).
  static const List<String> _defaultLocalhostRules = ['127.0.0.1', '::1'];

  /// Create an IP access control with the given allowlist.
  ///
  /// The [allowedIps] list can contain:
  /// - IPv4 addresses: `192.168.1.100`
  /// - IPv4 CIDR subnets: `192.168.0.0/16`
  /// - IPv6 addresses: `::1`, `2001:db8::1`
  /// - IPv6 CIDR subnets: `2001:db8::/32`
  ///
  /// Throws [ArgumentError] if any rule has an invalid format.
  /// This fail-fast behavior ensures errors are caught at configuration time,
  /// not during request handling.
  IpAccessControl(final List<String> allowedIps)
    : rules = allowedIps.map(IpAccessRule.parse).toList();

  /// Create a localhost-only access control.
  ///
  /// Allows access from both IPv4 (127.0.0.1) and IPv6 (::1) localhost.
  factory IpAccessControl.localhostOnly() =>
      IpAccessControl(_defaultLocalhostRules);

  /// Check if the given IP address string is allowed.
  ///
  /// Returns true if the IP matches any of the configured rules.
  /// Returns false if:
  /// - The IP doesn't match any rule
  /// - The IP format is invalid (silently denies without throwing)
  ///
  /// The silent denial for invalid IPs is intentional - it prevents
  /// information leakage about the validation logic and treats malformed
  /// IPs as unauthorized.
  bool isAllowed(final String ipString) {
    try {
      final ip = InternetAddress(ipString);
      return rules.any((final rule) => rule.matches(ip));
    } catch (e) {
      // Invalid IP format - deny silently
      return false;
    }
  }
}

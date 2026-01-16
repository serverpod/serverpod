import 'dart:io';

import 'package:serverpod_open_metrics/src/middleware/ip_access_control.dart';
import 'package:test/test.dart';

void main() {
  group('IpAccessRule.parse', () {
    test('parses IPv4 address', () {
      final rule = IpAccessRule.parse('192.168.1.100');
      expect(rule.address.address, equals('192.168.1.100'));
      expect(rule.prefixLength, isNull);
      expect(rule.address.type, equals(InternetAddressType.IPv4));
    });

    test('parses IPv4 CIDR notation', () {
      final rule = IpAccessRule.parse('192.168.1.0/24');
      expect(rule.address.address, equals('192.168.1.0'));
      expect(rule.prefixLength, equals(24));
      expect(rule.address.type, equals(InternetAddressType.IPv4));
    });

    test('parses IPv6 address', () {
      final rule = IpAccessRule.parse('::1');
      expect(rule.address.address, equals('::1'));
      expect(rule.prefixLength, isNull);
      expect(rule.address.type, equals(InternetAddressType.IPv6));
    });

    test('parses IPv6 CIDR notation', () {
      final rule = IpAccessRule.parse('2001:db8::/32');
      expect(rule.address.address, equals('2001:db8::'));
      expect(rule.prefixLength, equals(32));
      expect(rule.address.type, equals(InternetAddressType.IPv6));
    });

    test('parses IPv6 full address', () {
      final rule = IpAccessRule.parse(
        '2001:0db8:85a3:0000:0000:8a2e:0370:7334',
      );
      expect(rule.address.type, equals(InternetAddressType.IPv6));
      expect(rule.prefixLength, isNull);
    });

    test('throws on invalid IP format', () {
      expect(
        () => IpAccessRule.parse('not-an-ip'),
        throwsArgumentError,
      );
    });

    test('throws on invalid CIDR prefix for IPv4 (too large)', () {
      expect(
        () => IpAccessRule.parse('192.168.1.0/33'),
        throwsArgumentError,
      );
    });

    test('throws on invalid CIDR prefix for IPv4 (negative)', () {
      expect(
        () => IpAccessRule.parse('192.168.1.0/-1'),
        throwsArgumentError,
      );
    });

    test('throws on invalid CIDR prefix for IPv6 (too large)', () {
      expect(
        () => IpAccessRule.parse('2001:db8::/129'),
        throwsArgumentError,
      );
    });

    test('parses IPv4 with /0 prefix', () {
      final rule = IpAccessRule.parse('0.0.0.0/0');
      expect(rule.prefixLength, equals(0));
    });

    test('parses IPv4 with /32 prefix (full host)', () {
      final rule = IpAccessRule.parse('192.168.1.100/32');
      expect(rule.prefixLength, equals(32));
    });

    test('parses IPv6 with /128 prefix (full host)', () {
      final rule = IpAccessRule.parse('::1/128');
      expect(rule.prefixLength, equals(128));
    });

    test('handles whitespace around IP', () {
      final rule = IpAccessRule.parse('  192.168.1.100  ');
      expect(rule.address.address, equals('192.168.1.100'));
    });

    test('handles whitespace around CIDR', () {
      final rule = IpAccessRule.parse('192.168.1.0 / 24');
      expect(rule.address.address, equals('192.168.1.0'));
      expect(rule.prefixLength, equals(24));
    });

    test('toString returns IP for single address', () {
      final rule = IpAccessRule.parse('192.168.1.100');
      expect(rule.toString(), equals('192.168.1.100'));
    });

    test('toString returns CIDR notation for subnet', () {
      final rule = IpAccessRule.parse('192.168.0.0/16');
      expect(rule.toString(), equals('192.168.0.0/16'));
    });
  });

  group('IpAccessRule.matches', () {
    test('matches exact IPv4', () {
      final rule = IpAccessRule.parse('192.168.1.100');
      final ip = InternetAddress('192.168.1.100');
      expect(rule.matches(ip), isTrue);
    });

    test('does not match different IPv4', () {
      final rule = IpAccessRule.parse('192.168.1.100');
      final ip = InternetAddress('192.168.1.101');
      expect(rule.matches(ip), isFalse);
    });

    test('matches IPv4 in subnet (/24)', () {
      final rule = IpAccessRule.parse('192.168.1.0/24');
      expect(rule.matches(InternetAddress('192.168.1.0')), isTrue);
      expect(rule.matches(InternetAddress('192.168.1.1')), isTrue);
      expect(rule.matches(InternetAddress('192.168.1.150')), isTrue);
      expect(rule.matches(InternetAddress('192.168.1.255')), isTrue);
    });

    test('does not match IPv4 outside subnet (/24)', () {
      final rule = IpAccessRule.parse('192.168.1.0/24');
      expect(rule.matches(InternetAddress('192.168.0.255')), isFalse);
      expect(rule.matches(InternetAddress('192.168.2.0')), isFalse);
      expect(rule.matches(InternetAddress('10.0.0.1')), isFalse);
    });

    test('matches IPv4 in large subnet (/16)', () {
      final rule = IpAccessRule.parse('192.168.0.0/16');
      expect(rule.matches(InternetAddress('192.168.0.1')), isTrue);
      expect(rule.matches(InternetAddress('192.168.1.1')), isTrue);
      expect(rule.matches(InternetAddress('192.168.255.255')), isTrue);
    });

    test('does not match IPv4 outside large subnet (/16)', () {
      final rule = IpAccessRule.parse('192.168.0.0/16');
      expect(rule.matches(InternetAddress('192.167.255.255')), isFalse);
      expect(rule.matches(InternetAddress('192.169.0.0')), isFalse);
    });

    test('matches IPv4 in small subnet (/8)', () {
      final rule = IpAccessRule.parse('10.0.0.0/8');
      expect(rule.matches(InternetAddress('10.0.0.1')), isTrue);
      expect(rule.matches(InternetAddress('10.255.255.255')), isTrue);
      expect(rule.matches(InternetAddress('10.123.45.67')), isTrue);
    });

    test('does not match IPv4 outside small subnet (/8)', () {
      final rule = IpAccessRule.parse('10.0.0.0/8');
      expect(rule.matches(InternetAddress('9.255.255.255')), isFalse);
      expect(rule.matches(InternetAddress('11.0.0.0')), isFalse);
    });

    test('matches IPv4 in /0 subnet (all IPv4)', () {
      final rule = IpAccessRule.parse('0.0.0.0/0');
      expect(rule.matches(InternetAddress('0.0.0.0')), isTrue);
      expect(rule.matches(InternetAddress('127.0.0.1')), isTrue);
      expect(rule.matches(InternetAddress('192.168.1.1')), isTrue);
      expect(rule.matches(InternetAddress('255.255.255.255')), isTrue);
    });

    test('matches IPv4 with /32 (acts like single IP)', () {
      final rule = IpAccessRule.parse('192.168.1.100/32');
      expect(rule.matches(InternetAddress('192.168.1.100')), isTrue);
      expect(rule.matches(InternetAddress('192.168.1.101')), isFalse);
    });

    test('matches exact IPv6', () {
      final rule = IpAccessRule.parse('::1');
      final ip = InternetAddress('::1');
      expect(rule.matches(ip), isTrue);
    });

    test('does not match different IPv6', () {
      final rule = IpAccessRule.parse('::1');
      final ip = InternetAddress('::2');
      expect(rule.matches(ip), isFalse);
    });

    test('matches IPv6 in subnet', () {
      final rule = IpAccessRule.parse('2001:db8::/32');
      expect(rule.matches(InternetAddress('2001:db8::')), isTrue);
      expect(rule.matches(InternetAddress('2001:db8::1')), isTrue);
      expect(
        rule.matches(InternetAddress('2001:db8:ffff:ffff:ffff:ffff:ffff:ffff')),
        isTrue,
      );
    });

    test('does not match IPv6 outside subnet', () {
      final rule = IpAccessRule.parse('2001:db8::/32');
      expect(
        rule.matches(InternetAddress('2001:db7:ffff:ffff:ffff:ffff:ffff:ffff')),
        isFalse,
      );
      expect(rule.matches(InternetAddress('2001:db9::')), isFalse);
      expect(rule.matches(InternetAddress('::1')), isFalse);
    });

    test('matches IPv6 with /128 (acts like single IP)', () {
      final rule = IpAccessRule.parse('2001:db8::1/128');
      expect(rule.matches(InternetAddress('2001:db8::1')), isTrue);
      expect(rule.matches(InternetAddress('2001:db8::2')), isFalse);
    });

    test('does not cross IPv4/IPv6 families', () {
      final ipv4Rule = IpAccessRule.parse('192.168.1.0/24');
      final ipv6 = InternetAddress('::1');
      expect(ipv4Rule.matches(ipv6), isFalse);
    });

    test('does not cross IPv6/IPv4 families', () {
      final ipv6Rule = IpAccessRule.parse('2001:db8::/32');
      final ipv4 = InternetAddress('192.168.1.1');
      expect(ipv6Rule.matches(ipv4), isFalse);
    });

    test('handles partial byte boundaries correctly (/25)', () {
      // /25 means first 25 bits, which is 3 full bytes + 1 bit
      final rule = IpAccessRule.parse('192.168.1.0/25');
      // First half: 192.168.1.0 - 192.168.1.127
      expect(rule.matches(InternetAddress('192.168.1.0')), isTrue);
      expect(rule.matches(InternetAddress('192.168.1.127')), isTrue);
      // Second half should not match: 192.168.1.128 - 192.168.1.255
      expect(rule.matches(InternetAddress('192.168.1.128')), isFalse);
      expect(rule.matches(InternetAddress('192.168.1.255')), isFalse);
    });

    test('handles /31 subnet (point-to-point link)', () {
      final rule = IpAccessRule.parse('192.168.1.0/31');
      expect(rule.matches(InternetAddress('192.168.1.0')), isTrue);
      expect(rule.matches(InternetAddress('192.168.1.1')), isTrue);
      expect(rule.matches(InternetAddress('192.168.1.2')), isFalse);
    });
  });

  group('IpAccessControl', () {
    test('allows IP in allowlist', () {
      final control = IpAccessControl(['192.168.1.0/24']);
      expect(control.isAllowed('192.168.1.100'), isTrue);
    });

    test('denies IP not in allowlist', () {
      final control = IpAccessControl(['192.168.1.0/24']);
      expect(control.isAllowed('10.0.0.1'), isFalse);
    });

    test('handles multiple rules', () {
      final control = IpAccessControl([
        '192.168.1.0/24',
        '10.0.0.1',
        '172.16.0.0/12',
      ]);
      expect(control.isAllowed('192.168.1.100'), isTrue);
      expect(control.isAllowed('10.0.0.1'), isTrue);
      expect(control.isAllowed('172.16.0.1'), isTrue);
      expect(control.isAllowed('172.31.255.255'), isTrue);
      expect(control.isAllowed('11.0.0.1'), isFalse);
    });

    test('denies invalid IP format', () {
      final control = IpAccessControl(['192.168.1.0/24']);
      expect(control.isAllowed('not-an-ip'), isFalse);
      expect(control.isAllowed(''), isFalse);
      expect(control.isAllowed('192.168.1'), isFalse);
      expect(control.isAllowed('192.168.1.1.1'), isFalse);
    });

    test('handles IPv6 addresses', () {
      final control = IpAccessControl(['::1', '2001:db8::/32']);
      expect(control.isAllowed('::1'), isTrue);
      expect(control.isAllowed('2001:db8::1'), isTrue);
      expect(control.isAllowed('2001:db8:1234::5678'), isTrue);
      expect(control.isAllowed('::2'), isFalse);
      expect(control.isAllowed('2001:db9::1'), isFalse);
    });

    test('handles mixed IPv4 and IPv6', () {
      final control = IpAccessControl([
        '127.0.0.1',
        '::1',
        '192.168.0.0/16',
        '2001:db8::/32',
      ]);
      expect(control.isAllowed('127.0.0.1'), isTrue);
      expect(control.isAllowed('::1'), isTrue);
      expect(control.isAllowed('192.168.5.10'), isTrue);
      expect(control.isAllowed('2001:db8::5'), isTrue);
      expect(control.isAllowed('10.0.0.1'), isFalse);
      expect(control.isAllowed('::2'), isFalse);
    });

    test('localhostOnly factory creates localhost allowlist', () {
      final control = IpAccessControl.localhostOnly();
      expect(control.isAllowed('127.0.0.1'), isTrue);
      expect(control.isAllowed('::1'), isTrue);
      expect(control.isAllowed('192.168.1.1'), isFalse);
      expect(control.isAllowed('10.0.0.1'), isFalse);
    });

    test('throws on invalid rule at creation time', () {
      expect(
        () => IpAccessControl(['not-an-ip']),
        throwsArgumentError,
      );
    });

    test('throws on invalid CIDR at creation time', () {
      expect(
        () => IpAccessControl(['192.168.1.0/33']),
        throwsArgumentError,
      );
    });

    test('empty allowlist has no rules', () {
      final control = IpAccessControl([]);
      expect(control.rules, isEmpty);
      expect(control.isAllowed('127.0.0.1'), isFalse);
      expect(control.isAllowed('::1'), isFalse);
    });

    test('handles duplicate rules', () {
      final control = IpAccessControl([
        '192.168.1.0/24',
        '192.168.1.0/24', // duplicate
      ]);
      expect(control.isAllowed('192.168.1.100'), isTrue);
      expect(control.rules.length, equals(2)); // Both rules are stored
    });

    test('handles overlapping rules', () {
      final control = IpAccessControl([
        '192.168.0.0/16', // Covers entire 192.168.x.x
        '192.168.1.0/24', // More specific subnet within above
      ]);
      expect(control.isAllowed('192.168.1.100'), isTrue);
      expect(control.isAllowed('192.168.2.100'), isTrue);
    });
  });
}

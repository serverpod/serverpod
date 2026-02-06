import 'dart:io';

import 'package:serverpod_open_metrics/src/middleware/ip_access_control.dart';
import 'package:test/test.dart';

void main() {
  group('given IpAccessRule.parse', () {
    test(
      'given an IPv4 address string, when parsed, then returns correct address with no prefix',
      () {
        final rule = IpAccessRule.parse('192.168.1.100');
        expect(rule.address.address, equals('192.168.1.100'));
        expect(rule.prefixLength, isNull);
        expect(rule.address.type, equals(InternetAddressType.IPv4));
      },
    );

    test(
      'given an IPv4 CIDR notation, when parsed, then returns correct address and prefix length',
      () {
        final rule = IpAccessRule.parse('192.168.1.0/24');
        expect(rule.address.address, equals('192.168.1.0'));
        expect(rule.prefixLength, equals(24));
        expect(rule.address.type, equals(InternetAddressType.IPv4));
      },
    );

    test(
      'given an IPv6 address string, when parsed, then returns correct address with no prefix',
      () {
        final rule = IpAccessRule.parse('::1');
        expect(rule.address.address, equals('::1'));
        expect(rule.prefixLength, isNull);
        expect(rule.address.type, equals(InternetAddressType.IPv6));
      },
    );

    test(
      'given an IPv6 CIDR notation, when parsed, then returns correct address and prefix length',
      () {
        final rule = IpAccessRule.parse('2001:db8::/32');
        expect(rule.address.address, equals('2001:db8::'));
        expect(rule.prefixLength, equals(32));
        expect(rule.address.type, equals(InternetAddressType.IPv6));
      },
    );

    test(
      'given a full IPv6 address, when parsed, then returns IPv6 type with no prefix',
      () {
        final rule = IpAccessRule.parse(
          '2001:0db8:85a3:0000:0000:8a2e:0370:7334',
        );
        expect(rule.address.type, equals(InternetAddressType.IPv6));
        expect(rule.prefixLength, isNull);
      },
    );

    test(
      'given an invalid IP format, when parsed, then throws ArgumentError',
      () {
        expect(
          () => IpAccessRule.parse('not-an-ip'),
          throwsArgumentError,
        );
      },
    );

    test(
      'given an IPv4 CIDR prefix that is too large, when parsed, then throws ArgumentError',
      () {
        expect(
          () => IpAccessRule.parse('192.168.1.0/33'),
          throwsArgumentError,
        );
      },
    );

    test(
      'given an IPv4 CIDR prefix that is negative, when parsed, then throws ArgumentError',
      () {
        expect(
          () => IpAccessRule.parse('192.168.1.0/-1'),
          throwsArgumentError,
        );
      },
    );

    test(
      'given an IPv6 CIDR prefix that is too large, when parsed, then throws ArgumentError',
      () {
        expect(
          () => IpAccessRule.parse('2001:db8::/129'),
          throwsArgumentError,
        );
      },
    );

    test(
      'given an IPv4 with /0 prefix, when parsed, then returns prefix length of 0',
      () {
        final rule = IpAccessRule.parse('0.0.0.0/0');
        expect(rule.prefixLength, equals(0));
      },
    );

    test(
      'given an IPv4 with /32 prefix, when parsed, then returns prefix length of 32',
      () {
        final rule = IpAccessRule.parse('192.168.1.100/32');
        expect(rule.prefixLength, equals(32));
      },
    );

    test(
      'given an IPv6 with /128 prefix, when parsed, then returns prefix length of 128',
      () {
        final rule = IpAccessRule.parse('::1/128');
        expect(rule.prefixLength, equals(128));
      },
    );

    test(
      'given whitespace around an IP address, when parsed, then trims and returns correct address',
      () {
        final rule = IpAccessRule.parse('  192.168.1.100  ');
        expect(rule.address.address, equals('192.168.1.100'));
      },
    );

    test(
      'given whitespace around CIDR notation, when parsed, then trims and returns correct address and prefix',
      () {
        final rule = IpAccessRule.parse('192.168.1.0 / 24');
        expect(rule.address.address, equals('192.168.1.0'));
        expect(rule.prefixLength, equals(24));
      },
    );

    test(
      'given a single address rule, when toString is called, then returns the IP string',
      () {
        final rule = IpAccessRule.parse('192.168.1.100');
        expect(rule.toString(), equals('192.168.1.100'));
      },
    );

    test(
      'given a subnet rule, when toString is called, then returns CIDR notation',
      () {
        final rule = IpAccessRule.parse('192.168.0.0/16');
        expect(rule.toString(), equals('192.168.0.0/16'));
      },
    );
  });

  group('given IpAccessRule.matches', () {
    test(
      'given an exact IPv4 rule, when matched against the same IP, then returns true',
      () {
        final rule = IpAccessRule.parse('192.168.1.100');
        final ip = InternetAddress('192.168.1.100');
        expect(rule.matches(ip), isTrue);
      },
    );

    test(
      'given an exact IPv4 rule, when matched against a different IP, then returns false',
      () {
        final rule = IpAccessRule.parse('192.168.1.100');
        final ip = InternetAddress('192.168.1.101');
        expect(rule.matches(ip), isFalse);
      },
    );

    test(
      'given an IPv4 /24 subnet rule, when matched against IPs in the subnet, then returns true',
      () {
        final rule = IpAccessRule.parse('192.168.1.0/24');
        expect(rule.matches(InternetAddress('192.168.1.0')), isTrue);
        expect(rule.matches(InternetAddress('192.168.1.1')), isTrue);
        expect(rule.matches(InternetAddress('192.168.1.150')), isTrue);
        expect(rule.matches(InternetAddress('192.168.1.255')), isTrue);
      },
    );

    test(
      'given an IPv4 /24 subnet rule, when matched against IPs outside the subnet, then returns false',
      () {
        final rule = IpAccessRule.parse('192.168.1.0/24');
        expect(rule.matches(InternetAddress('192.168.0.255')), isFalse);
        expect(rule.matches(InternetAddress('192.168.2.0')), isFalse);
        expect(rule.matches(InternetAddress('10.0.0.1')), isFalse);
      },
    );

    test(
      'given an IPv4 /16 subnet rule, when matched against IPs in the subnet, then returns true',
      () {
        final rule = IpAccessRule.parse('192.168.0.0/16');
        expect(rule.matches(InternetAddress('192.168.0.1')), isTrue);
        expect(rule.matches(InternetAddress('192.168.1.1')), isTrue);
        expect(rule.matches(InternetAddress('192.168.255.255')), isTrue);
      },
    );

    test(
      'given an IPv4 /16 subnet rule, when matched against IPs outside the subnet, then returns false',
      () {
        final rule = IpAccessRule.parse('192.168.0.0/16');
        expect(rule.matches(InternetAddress('192.167.255.255')), isFalse);
        expect(rule.matches(InternetAddress('192.169.0.0')), isFalse);
      },
    );

    test(
      'given an IPv4 /8 subnet rule, when matched against IPs in the subnet, then returns true',
      () {
        final rule = IpAccessRule.parse('10.0.0.0/8');
        expect(rule.matches(InternetAddress('10.0.0.1')), isTrue);
        expect(rule.matches(InternetAddress('10.255.255.255')), isTrue);
        expect(rule.matches(InternetAddress('10.123.45.67')), isTrue);
      },
    );

    test(
      'given an IPv4 /8 subnet rule, when matched against IPs outside the subnet, then returns false',
      () {
        final rule = IpAccessRule.parse('10.0.0.0/8');
        expect(rule.matches(InternetAddress('9.255.255.255')), isFalse);
        expect(rule.matches(InternetAddress('11.0.0.0')), isFalse);
      },
    );

    test(
      'given an IPv4 /0 subnet rule, when matched against any IPv4 address, then returns true',
      () {
        final rule = IpAccessRule.parse('0.0.0.0/0');
        expect(rule.matches(InternetAddress('0.0.0.0')), isTrue);
        expect(rule.matches(InternetAddress('127.0.0.1')), isTrue);
        expect(rule.matches(InternetAddress('192.168.1.1')), isTrue);
        expect(rule.matches(InternetAddress('255.255.255.255')), isTrue);
      },
    );

    test(
      'given an IPv4 /32 rule, when matched against the exact IP, then returns true and others false',
      () {
        final rule = IpAccessRule.parse('192.168.1.100/32');
        expect(rule.matches(InternetAddress('192.168.1.100')), isTrue);
        expect(rule.matches(InternetAddress('192.168.1.101')), isFalse);
      },
    );

    test(
      'given an exact IPv6 rule, when matched against the same IP, then returns true',
      () {
        final rule = IpAccessRule.parse('::1');
        final ip = InternetAddress('::1');
        expect(rule.matches(ip), isTrue);
      },
    );

    test(
      'given an exact IPv6 rule, when matched against a different IP, then returns false',
      () {
        final rule = IpAccessRule.parse('::1');
        final ip = InternetAddress('::2');
        expect(rule.matches(ip), isFalse);
      },
    );

    test(
      'given an IPv6 /32 subnet rule, when matched against IPs in the subnet, then returns true',
      () {
        final rule = IpAccessRule.parse('2001:db8::/32');
        expect(rule.matches(InternetAddress('2001:db8::')), isTrue);
        expect(rule.matches(InternetAddress('2001:db8::1')), isTrue);
        expect(
          rule.matches(
            InternetAddress('2001:db8:ffff:ffff:ffff:ffff:ffff:ffff'),
          ),
          isTrue,
        );
      },
    );

    test(
      'given an IPv6 /32 subnet rule, when matched against IPs outside the subnet, then returns false',
      () {
        final rule = IpAccessRule.parse('2001:db8::/32');
        expect(
          rule.matches(
            InternetAddress('2001:db7:ffff:ffff:ffff:ffff:ffff:ffff'),
          ),
          isFalse,
        );
        expect(rule.matches(InternetAddress('2001:db9::')), isFalse);
        expect(rule.matches(InternetAddress('::1')), isFalse);
      },
    );

    test(
      'given an IPv6 /128 rule, when matched against the exact IP, then returns true and others false',
      () {
        final rule = IpAccessRule.parse('2001:db8::1/128');
        expect(rule.matches(InternetAddress('2001:db8::1')), isTrue);
        expect(rule.matches(InternetAddress('2001:db8::2')), isFalse);
      },
    );

    test(
      'given an IPv4 subnet rule, when matched against an IPv6 address, then returns false',
      () {
        final ipv4Rule = IpAccessRule.parse('192.168.1.0/24');
        final ipv6 = InternetAddress('::1');
        expect(ipv4Rule.matches(ipv6), isFalse);
      },
    );

    test(
      'given an IPv6 subnet rule, when matched against an IPv4 address, then returns false',
      () {
        final ipv6Rule = IpAccessRule.parse('2001:db8::/32');
        final ipv4 = InternetAddress('192.168.1.1');
        expect(ipv6Rule.matches(ipv4), isFalse);
      },
    );

    test(
      'given a /25 subnet rule, when matched against IPs at partial byte boundaries, then matches correctly',
      () {
        // /25 means first 25 bits, which is 3 full bytes + 1 bit
        final rule = IpAccessRule.parse('192.168.1.0/25');
        // First half: 192.168.1.0 - 192.168.1.127
        expect(rule.matches(InternetAddress('192.168.1.0')), isTrue);
        expect(rule.matches(InternetAddress('192.168.1.127')), isTrue);
        // Second half should not match: 192.168.1.128 - 192.168.1.255
        expect(rule.matches(InternetAddress('192.168.1.128')), isFalse);
        expect(rule.matches(InternetAddress('192.168.1.255')), isFalse);
      },
    );

    test(
      'given a /31 subnet rule, when matched against the two-address range, then matches correctly',
      () {
        final rule = IpAccessRule.parse('192.168.1.0/31');
        expect(rule.matches(InternetAddress('192.168.1.0')), isTrue);
        expect(rule.matches(InternetAddress('192.168.1.1')), isTrue);
        expect(rule.matches(InternetAddress('192.168.1.2')), isFalse);
      },
    );
  });

  group('given IpAccessControl', () {
    test(
      'given an allowlist with a /24 subnet, when checking an IP in the subnet, then allows it',
      () {
        final control = IpAccessControl(['192.168.1.0/24']);
        expect(control.isAllowed('192.168.1.100'), isTrue);
      },
    );

    test(
      'given an allowlist with a /24 subnet, when checking an IP outside the subnet, then denies it',
      () {
        final control = IpAccessControl(['192.168.1.0/24']);
        expect(control.isAllowed('10.0.0.1'), isFalse);
      },
    );

    test(
      'given multiple rules in the allowlist, when checking various IPs, then allows matching and denies non-matching',
      () {
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
      },
    );

    test(
      'given an allowlist, when checking invalid IP formats, then denies them',
      () {
        final control = IpAccessControl(['192.168.1.0/24']);
        expect(control.isAllowed('not-an-ip'), isFalse);
        expect(control.isAllowed(''), isFalse);
        expect(control.isAllowed('192.168.1'), isFalse);
        expect(control.isAllowed('192.168.1.1.1'), isFalse);
      },
    );

    test(
      'given an allowlist with IPv6 rules, when checking IPv6 addresses, then allows matching and denies non-matching',
      () {
        final control = IpAccessControl(['::1', '2001:db8::/32']);
        expect(control.isAllowed('::1'), isTrue);
        expect(control.isAllowed('2001:db8::1'), isTrue);
        expect(control.isAllowed('2001:db8:1234::5678'), isTrue);
        expect(control.isAllowed('::2'), isFalse);
        expect(control.isAllowed('2001:db9::1'), isFalse);
      },
    );

    test(
      'given an allowlist with mixed IPv4 and IPv6 rules, when checking both families, then allows matching and denies non-matching',
      () {
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
      },
    );

    test(
      'given the localhostOnly factory, when checking localhost and non-localhost IPs, then allows only localhost',
      () {
        final control = IpAccessControl.localhostOnly();
        expect(control.isAllowed('127.0.0.1'), isTrue);
        expect(control.isAllowed('::1'), isTrue);
        expect(control.isAllowed('192.168.1.1'), isFalse);
        expect(control.isAllowed('10.0.0.1'), isFalse);
      },
    );

    test(
      'given an invalid IP rule, when creating IpAccessControl, then throws ArgumentError',
      () {
        expect(
          () => IpAccessControl(['not-an-ip']),
          throwsArgumentError,
        );
      },
    );

    test(
      'given an invalid CIDR prefix rule, when creating IpAccessControl, then throws ArgumentError',
      () {
        expect(
          () => IpAccessControl(['192.168.1.0/33']),
          throwsArgumentError,
        );
      },
    );

    test('given an empty allowlist, when checking any IP, then denies all', () {
      final control = IpAccessControl([]);
      expect(control.rules, isEmpty);
      expect(control.isAllowed('127.0.0.1'), isFalse);
      expect(control.isAllowed('::1'), isFalse);
    });

    test(
      'given duplicate rules in the allowlist, when checking a matching IP, then still allows it',
      () {
        final control = IpAccessControl([
          '192.168.1.0/24',
          '192.168.1.0/24', // duplicate
        ]);
        expect(control.isAllowed('192.168.1.100'), isTrue);
        expect(control.rules.length, equals(2)); // Both rules are stored
      },
    );

    test(
      'given overlapping rules in the allowlist, when checking IPs in the broader range, then allows them',
      () {
        final control = IpAccessControl([
          '192.168.0.0/16', // Covers entire 192.168.x.x
          '192.168.1.0/24', // More specific subnet within above
        ]);
        expect(control.isAllowed('192.168.1.100'), isTrue);
        expect(control.isAllowed('192.168.2.100'), isTrue);
      },
    );
  });
}

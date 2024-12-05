import 'package:serverpod_test_shared/serverpod_test_shared.dart';
import 'package:test/test.dart';

import '../test_integration/test_tools/serverpod_test_tools.dart';

/// Unit tests for custom class serialization.
/// These tests are designed to avoid creating multiple endpoint methods for each test case.
/// Instead, custom class parameters are passed from the client side, and the server validates
/// whether the expected values are returned correctly.
void main() {
  withServerpod('Given a custom class ', (sessionBuilder, endpoints) {
    group('that does not implement ProtocolSerialization', () {
      test(
        'with the "serverSideValue" field set when the method is called then the server returns the "serverSideValue"',
        () async {
          final customClass = CustomClassWithoutProtocolSerialization(
            serverSideValue: 'serverSideValue',
          );
          final result = await endpoints.customTypes
              .returnCustomClassWithoutProtocolSerialization(
            sessionBuilder,
            customClass,
          );
          expect(
            result.serverSideValue,
            customClass.serverSideValue,
          );
        },
      );

      test(
        'with the "value" field set when the method is called then the server returns the "value"',
        () async {
          final customClass = CustomClassWithoutProtocolSerialization(
            value: 'value',
          );
          final result = await endpoints.customTypes
              .returnCustomClassWithoutProtocolSerialization(
            sessionBuilder,
            customClass,
          );
          expect(
            result.value,
            customClass.value,
          );
        },
      );
    });

    group('that implements ProtocolSerialization', () {
      test(
        'with the "serverSideValue" field set when the method is called then the server does not return the "serverSideValue"',
        () async {
          final customClass = CustomClassWithProtocolSerialization(
            serverSideValue: 'serverSideValue',
            value: 'value',
          );
          final result = await endpoints.customTypes
              .returnCustomClassWithProtocolSerialization(
            sessionBuilder,
            customClass,
          );
          expect(
            result.serverSideValue,
            isNull,
          );
        },
      );

      test(
        'with the "value" field set when the method is called then the server returns the "value"',
        () async {
          final customClass = CustomClassWithProtocolSerialization(
            value: 'value',
          );
          final result = await endpoints.customTypes
              .returnCustomClassWithProtocolSerialization(
            sessionBuilder,
            customClass,
          );
          expect(
            result.value,
            customClass.value,
          );
        },
      );
    });

    group(
        'that does not implement ProtocolSerialization but has the "toJsonForProtocol" method',
        () {
      test(
        'with the "serverSideValue" field set when the method is called then the server returns the "serverSideValue"',
        () async {
          final customClass = CustomClassWithProtocolSerializationMethod(
            serverSideValue: 'serverSideValue',
          );
          final result = await endpoints.customTypes
              .returnCustomClassWithProtocolSerializationMethod(
            sessionBuilder,
            customClass,
          );
          expect(
            result.serverSideValue,
            customClass.serverSideValue,
          );
        },
      );

      test(
        'with the "value" field set when the method is called then the server returns the "value"',
        () async {
          final customClass = CustomClassWithProtocolSerializationMethod(
            value: 'value',
          );
          final result = await endpoints.customTypes
              .returnCustomClassWithProtocolSerializationMethod(
            sessionBuilder,
            customClass,
          );
          expect(
            result.value,
            customClass.value,
          );
        },
      );
    });
  });
}

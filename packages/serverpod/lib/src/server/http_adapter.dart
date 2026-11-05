import 'dart:io';

import 'package:relic/relic.dart';
import 'package:relic_native/relic_native.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'package:serverpod/src/config/security_context_config.dart';

/// Binds the [Adapter] that [kind] names on [address] and [port].
///
/// [ServerpodHttpAdapter.native] binds a [NativeAdapter], serving HTTPS when
/// [certificate] is set. It binds an [IOAdapter] instead, with a warning
/// naming [serverName], for a [securityContext] without a [certificate],
/// and on a platform without a relic_native library.
Future<Adapter> bindHttpAdapter({
  required ServerpodHttpAdapter kind,
  required String serverName,
  required InternetAddress address,
  required int port,
  SecurityContext? securityContext,
  PemCertificate? certificate,
}) async {
  if (kind == ServerpodHttpAdapter.native) {
    if (securityContext != null && certificate == null) {
      log.warning(
        '$serverName: Using the io HTTP adapter, as a SecurityContext cannot '
        'configure the native one. Use SecurityContextConfig.pem to serve '
        'HTTPS on the native adapter.',
      );
    } else {
      try {
        return await NativeAdapter.bind(
          address,
          port: port,
          tls: certificate == null
              ? null
              : NativeTls(
                  certificateChain: certificate.certificateChain,
                  privateKey: certificate.privateKey,
                  password: certificate.password,
                ),
        );
      } on UnsupportedError catch (e) {
        log.warning(
          '$serverName: Using the io HTTP adapter, as the native one is not '
          'available on this platform (${e.message}).',
        );
      }
    }
  }
  return IOAdapter.bind(address, port: port, context: securityContext);
}

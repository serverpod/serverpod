import 'dart:io';

import 'package:relic/relic.dart';
import 'package:relic_native/relic_native.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Binds the [Adapter] that [kind] names on [address] and [port].
///
/// [ServerpodHttpAdapter.native] binds a [NativeAdapter]. It binds an
/// [IOAdapter] instead, with a warning naming [serverName], for a
/// [securityContext] and on a platform without a relic_native library.
Future<Adapter> bindHttpAdapter({
  required ServerpodHttpAdapter kind,
  required String serverName,
  required InternetAddress address,
  required int port,
  SecurityContext? securityContext,
}) async {
  if (kind == ServerpodHttpAdapter.native) {
    if (securityContext != null) {
      log.warning(
        '$serverName: Using the io HTTP adapter, as a SecurityContext cannot '
        'configure the native one.',
      );
    } else {
      try {
        return await NativeAdapter.bind(address, port: port);
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

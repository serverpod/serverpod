export 'package:relic/src/headers/typed/headers/authorization_header.dart';
export 'package:relic/src/headers/typed/headers/content_range_header.dart';
export 'package:relic/src/headers/typed/headers/cookie_header.dart';
export 'package:relic/src/headers/typed/headers/from_header.dart';
export 'package:relic/src/headers/typed/headers/if_range_header.dart';
export 'package:relic/src/headers/typed/headers/expect_header.dart';
export 'package:relic/src/headers/typed/headers/upgrade_header.dart';
export 'package:relic/src/headers/typed/headers/vary_header.dart';
export 'package:relic/src/headers/typed/headers/etag_header.dart';
export 'package:relic/src/headers/typed/headers/content_security_policy_header.dart';
export 'package:relic/src/headers/typed/headers/referrer_policy_header.dart';
export 'package:relic/src/headers/typed/headers/permission_policy_header.dart';
export 'package:relic/src/headers/typed/headers/access_control_allow_methods_header.dart';
export 'package:relic/src/headers/typed/headers/clear_site_data_header.dart';
export 'package:relic/src/headers/typed/headers/sec_fetch_dest_header.dart';
export 'package:relic/src/headers/typed/headers/sec_fetch_mode_header.dart';
export 'package:relic/src/headers/typed/headers/sec_fetch_site_header.dart';
export 'package:relic/src/headers/typed/headers/cross_origin_resource_policy_header.dart';
export 'package:relic/src/headers/typed/headers/cross_origin_embedder_policy_header.dart';
export 'package:relic/src/headers/typed/headers/cross_origin_opener_policy_header.dart';
export 'package:relic/src/headers/typed/headers/accept_encoding_header.dart';
export 'package:relic/src/headers/typed/headers/accept_language_header.dart';
export 'package:relic/src/headers/typed/headers/etag_condition_header.dart';
export 'package:relic/src/headers/typed/headers/content_encoding_header.dart';
export 'package:relic/src/headers/typed/headers/te_header.dart';
export 'package:relic/src/headers/typed/headers/content_language_header.dart';
export 'package:relic/src/headers/typed/headers/accept_ranges_header.dart';
export 'package:relic/src/headers/typed/headers/retry_after_header.dart';
export 'package:relic/src/headers/typed/headers/content_disposition_header.dart';
export 'package:relic/src/headers/typed/headers/range_header.dart';
export 'package:relic/src/headers/typed/headers/strict_transport_security_header.dart';
export 'package:relic/src/headers/typed/headers/transfer_encoding_header.dart';
export 'package:relic/src/headers/typed/headers/authentication_header.dart';
export 'package:relic/src/headers/typed/headers/cache_control_header.dart';
export 'package:relic/src/headers/typed/headers/connection_header.dart';
export 'package:relic/src/headers/typed/headers/access_control_allow_origin_header.dart';
export 'package:relic/src/headers/typed/headers/access_control_allow_headers_header.dart';
export 'package:relic/src/headers/typed/headers/access_control_expose_headers_header.dart';
export 'package:relic/src/headers/typed/headers/accept_header.dart';

/// A typed header that can be converted to a header string.
abstract interface class TypedHeader {
  const TypedHeader();

  /// Converts the header to a header string.
  String toHeaderString();
}
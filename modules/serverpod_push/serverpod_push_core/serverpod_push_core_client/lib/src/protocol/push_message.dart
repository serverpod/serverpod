/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_push_core_client/src/protocol/protocol.dart'
    as _iqi84yf1;
import 'push_priority.dart' as _i393k73i;

/// A platform-agnostic push payload.
///
/// SCHEMA RULE (locked): this class is append-only and nullable-only,
/// permanently. It is persisted inside a JSON column, so there is no migration
/// for its interior, and a rolling deploy will read rows written by the previous
/// release. Renaming or un-nullabling a field here is a data-format break, not a
/// schema change.
abstract class PushMessage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PushMessage._({
    this.title,
    this.body,
    required this.data,
    this.imageUrl,
    this.collapseKey,
    required this.priority,
    this.timeToLive,
  });

  factory PushMessage({
    String? title,
    String? body,
    required Map<String, String> data,
    String? imageUrl,
    String? collapseKey,
    required _i393k73i.PushPriority priority,
    Duration? timeToLive,
  }) = _PushMessageImpl;

  factory PushMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushMessage(
      title: jsonSerialization['title'] as String?,
      body: jsonSerialization['body'] as String?,
      data: _iqi84yf1.Protocol().deserialize<Map<String, String>>(
        jsonSerialization['data'],
      ),
      imageUrl: jsonSerialization['imageUrl'] as String?,
      collapseKey: jsonSerialization['collapseKey'] as String?,
      priority: _i393k73i.PushPriority.fromJson(
        (jsonSerialization['priority'] as String),
      ),
      timeToLive: jsonSerialization['timeToLive'] == null
          ? null
          : _isc.DurationJsonExtension.fromJson(
              jsonSerialization['timeToLive'],
            ),
    );
  }

  String? title;

  String? body;

  Map<String, String> data;

  String? imageUrl;

  String? collapseKey;

  _i393k73i.PushPriority priority;

  /// Authored duration. Converted once, at enqueue, into PushDelivery.expiresAt.
  /// Never recomputed, never re-derived at send time.
  Duration? timeToLive;

  /// Returns a shallow copy of this [PushMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PushMessage copyWith({
    String? title,
    String? body,
    Map<String, String>? data,
    String? imageUrl,
    String? collapseKey,
    _i393k73i.PushPriority? priority,
    Duration? timeToLive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_push_core.PushMessage',
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      'data': data.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (collapseKey != null) 'collapseKey': collapseKey,
      'priority': priority.toJson(),
      if (timeToLive != null) 'timeToLive': timeToLive?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_push_core.PushMessage',
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      'data': data.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (collapseKey != null) 'collapseKey': collapseKey,
      'priority': priority.toJson(),
      if (timeToLive != null) 'timeToLive': timeToLive?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PushMessageImpl extends PushMessage {
  _PushMessageImpl({
    String? title,
    String? body,
    required Map<String, String> data,
    String? imageUrl,
    String? collapseKey,
    required _i393k73i.PushPriority priority,
    Duration? timeToLive,
  }) : super._(
         title: title,
         body: body,
         data: data,
         imageUrl: imageUrl,
         collapseKey: collapseKey,
         priority: priority,
         timeToLive: timeToLive,
       );

  /// Returns a shallow copy of this [PushMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PushMessage copyWith({
    Object? title = _Undefined,
    Object? body = _Undefined,
    Map<String, String>? data,
    Object? imageUrl = _Undefined,
    Object? collapseKey = _Undefined,
    _i393k73i.PushPriority? priority,
    Object? timeToLive = _Undefined,
  }) {
    return PushMessage(
      title: title is String? ? title : this.title,
      body: body is String? ? body : this.body,
      data:
          data ??
          this.data.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      collapseKey: collapseKey is String? ? collapseKey : this.collapseKey,
      priority: priority ?? this.priority,
      timeToLive: timeToLive is Duration? ? timeToLive : this.timeToLive,
    );
  }
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A greeting message which can be sent to or from the server.
abstract class Greeting implements _i1.SerializableModel {
  Greeting._({
    required this.message,
    required this.author,
    required this.timestamp,
  });

  factory Greeting({
    required String message,
    required String author,
    required DateTime timestamp,
  }) = _GreetingImpl;

  factory Greeting.fromJson(Map<String, dynamic> jsonSerialization) {
    return Greeting(
      message: jsonSerialization['message'] as String,
      author: jsonSerialization['author'] as String,
      timestamp:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  /// The greeting message.
  String message;

  /// The author of the greeting message.
  String author;

  /// The time when the message was created.
  DateTime timestamp;

  /// Returns a shallow copy of this [Greeting]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Greeting copyWith({
    String? message,
    String? author,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'author': author,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _GreetingImpl extends Greeting {
  _GreetingImpl({
    required String message,
    required String author,
    required DateTime timestamp,
  }) : super._(
          message: message,
          author: author,
          timestamp: timestamp,
        );

  /// Returns a shallow copy of this [Greeting]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Greeting copyWith({
    String? message,
    String? author,
    DateTime? timestamp,
  }) {
    return Greeting(
      message: message ?? this.message,
      author: author ?? this.author,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

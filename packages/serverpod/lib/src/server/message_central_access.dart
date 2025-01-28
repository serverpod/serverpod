import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart';
import 'package:serverpod/src/service/service_manager.dart';

/// Provides access to the Serverpod's [MessageCentral].
class MessageCentralAccess {
  final ServiceLocator _serviceLocator;

  /// Create a new instance that knows how to find [MessageCentral] with a [ServiceLocator]
  MessageCentralAccess(this._serviceLocator);

  /// Adds a listener to a named channel. Whenever a message is posted using
  /// [postMessage], the [listener] will be notified.
  void addListener(
    Session session,
    String channelName,
    MessageCentralListenerCallback listener,
  ) {
    _serviceLocator.locate<MessageCentral>()!.addListener(
          session,
          channelName,
          listener,
        );
  }

  /// Removes a listener from a named channel.
  void removeListener(Session session, String channelName,
      MessageCentralListenerCallback listener) {
    _serviceLocator
        .locate<MessageCentral>()!
        .removeListener(session, channelName, listener);
  }

  /// Posts a [message] to a named channel. If [global] is set to true, the
  /// message will be posted to all servers in the cluster, otherwise it will
  /// only be posted locally on the current server. Returns true if the message
  /// was successfully posted.
  ///
  /// Returns true if the message was successfully posted.
  ///
  /// Throws a [StateError] if Redis is not enabled and [global] is set to true.
  Future<bool> postMessage(
    String channelName,
    SerializableModel message, {
    bool global = false,
  }) =>
      _serviceLocator.locate<MessageCentral>()!.postMessage(
            channelName,
            message,
            global: global,
          );

  /// Creates a stream that listens to a specified channel.
  ///
  /// This stream emits messages of type [T] whenever a message is received on
  /// the specified channel.
  ///
  /// If messages on the channel does not match the type [T], the stream will
  /// emit an error.
  Stream<T> createStream<T>(Session session, String channelName) =>
      _serviceLocator
          .locate<MessageCentral>()!
          .createStream<T>(session, channelName);

  /// Broadcasts revoked authentication events to the Serverpod framework.
  /// This message ensures authenticated connections to the user are closed.
  ///
  /// The [userId] should be the [AuthenticationInfo.userId] for the concerned
  /// user.
  ///
  /// The [message] must be of type [RevokedAuthenticationUser],
  /// [RevokedAuthenticationAuthId], or [RevokedAuthenticationScope].
  ///
  /// [RevokedAuthenticationUser] is used to communicate that all the user's
  /// authentication is revoked.
  ///
  /// [RevokedAuthenticationAuthId] is used to communicate that a specific
  /// authentication id has been revoked for a user.
  ///
  /// [RevokedAuthenticationScope] is used to communicate that a specific
  /// scope or scopes have been revoked for the user.
  Future<bool> authenticationRevoked(
    int userId,
    SerializableModel message,
  ) async {
    if (message is! RevokedAuthenticationUser &&
        message is! RevokedAuthenticationAuthId &&
        message is! RevokedAuthenticationScope) {
      throw ArgumentError(
        'Message must be of type RevokedAuthenticationUser, '
        'RevokedAuthenticationAuthId, or RevokedAuthenticationScope',
      );
    }

    try {
      return await _serviceLocator.locate<MessageCentral>()!.postMessage(
            MessageCentralServerpodChannels.revokedAuthentication(userId),
            message,
            global: true,
          );
    } on StateError catch (_) {
      // Throws StateError if Redis is not enabled that is ignored.
    }

    // If Redis is not enabled, send the message locally.
    return _serviceLocator.locate<MessageCentral>()!.postMessage(
          MessageCentralServerpodChannels.revokedAuthentication(userId),
          message,
          global: false,
        );
  }
}

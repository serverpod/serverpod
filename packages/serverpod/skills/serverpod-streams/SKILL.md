---
name: serverpod-streams
description: Real-time streaming in Serverpod — Stream parameters and return types, WebSocket lifecycle, error handling. Use when building real-time features, chat, live updates, or WebSocket streaming.
---

# Serverpod Streams

Endpoint methods that take or return `Stream<T>` get WebSocket-managed client stubs. Types must be serializable.

## Defining a streaming method

```dart
class ExampleEndpoint extends Endpoint {
  Stream<String> echoStream(Session session, Stream<String> stream) async* {
    await for (var message in stream) {
      yield message;
    }
  }
}
```

Run `serverpod generate` for client stubs.

## Client usage

```dart
var inStream = StreamController<String>();
var outStream = client.example.echoStream(inStream.stream);

outStream.listen((message) => print('Received: $message'));
inStream.add('Hello');
```

Close the `StreamController` when done. Cancelling the subscription closes both sides. We can use the in/out stream independently (often only need for stream from server). Methods may take multiple stream parameters when needed. Keep the API shape explicit and regenerate after changes.

## Lifecycle

- Each call creates a server `Session`; for return-stream methods, the session stays alive until the returned stream completes or is cancelled.
- WebSocket disconnect closes streams on both sides.
- Return-stream methods stay alive until cancelled or completed.

## Error handling

Throwing a serializable exception closes the stream; the client receives it in `onError`. Exceptions can flow in both directions. Define exception types in `.spy.yaml`.

## Deprecated pattern

The older `streamOpened`/`handleStreamMessage`/`sendStreamMessage` pattern and `openStreamingConnection()` still exists for legacy code but is deprecated. Use only streaming methods (Stream as parameter/return type) for new code.

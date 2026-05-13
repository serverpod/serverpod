---
name: serverpod-streams
description: Real-time streaming in Serverpod — Stream parameters and return types, WebSocket lifecycle, error handling. Use when building real-time features, chat, live updates, or WebSocket streaming.
---

# Serverpod Streams

Endpoint methods that take or return `Stream<T>` get WebSocket-managed client stubs. Types must be serializable.

It's a common use case to use streams together with server events. See [Server Events](../serverpod-server-events/SKILL.md).

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

## Example combined with server events (simplified)

```dart
class PixelDrawingEndpoint extends Endpoint {
  static const _channelPixelAdded = 'pixel-added';
  final _pixelData = Uint8List(_numPixels);

  Future<void> setPixel(
    Session session, {
    required int colorIndex,
    required int pixelIndex,
  }) async {
    _pixelData[pixelIndex] = colorIndex;

    // Notify all connected clients that we set a pixel, by posting a message
    // to the _channelPixelAdded channel.
    session.messages.postMessage(
      _channelPixelAdded,
      ImageUpdate(
        pixelIndex: pixelIndex,
        colorIndex: colorIndex,
      ),
    );
  }

  /// Returns a stream of image updates. The first message will always be a
  /// `ImageData` object, which contains the full image. Sequential updates
  /// will be `ImageUpdate` objects, which contains a single updated pixel.
  Stream imageUpdates(Session session) async* {
    var updateStream =
        session.messages.createStream<ImageUpdate>(_channelPixelAdded);

    yield ImageData(
      pixels: _pixelData.buffer.asByteData(),
      width: _imageWidth,
      height: _imageHeight,
    );

    await for (var imageUpdate in updateStream) {
      yield imageUpdate;
    }
  }
}
```

## Deprecated pattern

The older `streamOpened`/`handleStreamMessage`/`sendStreamMessage` pattern and `openStreamingConnection()` still exists for legacy code but is deprecated. Use only streaming methods (Stream as parameter/return type) for new code.

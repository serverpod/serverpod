import 'package:collection/collection.dart';

/// A [QueueList] with a fixed maximum length.
///
/// When the list exceeds [maxLength], the oldest entries are dropped
/// automatically on [addLast] and [addAll].
class BoundedQueueList<E> extends QueueList<E> {
  BoundedQueueList(this.maxLength);

  final int maxLength;

  @override
  void addLast(E element) {
    super.addLast(element);
    _trim();
  }

  @override
  void add(E element) => addLast(element);

  @override
  void addAll(Iterable<E> iterable) {
    super.addAll(iterable);
    _trim();
  }

  void _trim() {
    while (length > maxLength) {
      removeFirst();
    }
  }
}

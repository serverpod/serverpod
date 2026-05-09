// Vendored from tuid (https://github.com/AstroNvim/tuid)
// SPDX-License-Identifier: BSD-3-Clause
import 'package:nocterm/nocterm.dart';

/// Notifier that broadcasts animation ticks to listeners.
///
/// Used by [SpinnerIcon] for frame changes, and also available to other
/// widgets (e.g. live duration displays) that want to piggyback on the
/// same tick without creating their own timers.
class SpinnerNotifier {
  String _value;
  int _tick = 0;
  final List<VoidCallback> _listeners = [];

  SpinnerNotifier(this._value);

  String get value => _value;
  int get tick => _tick;

  set value(String newValue) {
    if (_value != newValue) {
      _value = newValue;
      _tick++;
      for (final listener in _listeners) {
        listener();
      }
    }
  }

  void addListener(VoidCallback listener) => _listeners.add(listener);
  void removeListener(VoidCallback listener) => _listeners.remove(listener);
  void dispose() => _listeners.clear();
}

/// Provides shared spinner animation state to descendants.
///
/// This allows all spinner icons to share a single animation controller,
/// avoiding the performance overhead of many independent animations.
/// Other widgets can access the notifier via [SpinnerScope.of] to
/// piggyback on the same tick.
class SpinnerScope extends StatefulComponent {
  final bool active;
  final List<String> frames;
  final Duration frameDuration;
  final Component child;

  const SpinnerScope({
    this.active = true,
    this.frames = runningFrames,
    this.frameDuration = const Duration(milliseconds: 80),
    required this.child,
    super.key,
  });

  /// Returns the [SpinnerNotifier] from the closest ancestor, or null.
  static SpinnerNotifier? of(BuildContext context) {
    return _SpinnerInherited.of(context);
  }

  @override
  State<SpinnerScope> createState() => _SpinnerScopeState();
}

class _SpinnerScopeState extends State<SpinnerScope>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late SpinnerNotifier _notifier;
  int _frameIndex = 0;
  double _prevValue = 0.0;

  @override
  void initState() {
    super.initState();
    _notifier = SpinnerNotifier(component.frames[_frameIndex]);
    _controller = AnimationController(
      duration: component.frameDuration,
      vsync: this,
    )..addListener(_onTick);
    if (component.active) {
      _controller.repeat();
    }
  }

  // Advance the frame
  void _onTick() {
    final current = _controller.value;
    if (current < _prevValue) {
      _frameIndex = (_frameIndex + 1) % component.frames.length;
      _notifier.value = component.frames[_frameIndex];
    }
    _prevValue = current;
  }

  @override
  void didUpdateComponent(SpinnerScope oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (component.active && !_controller.isAnimating) {
      _prevValue = 0.0;
      _controller.repeat();
    } else if (!component.active && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTick);
    _controller.dispose();
    _notifier.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return _SpinnerInherited(notifier: _notifier, child: component.child);
  }
}

/// Inherited component that provides the spinner notifier.
class _SpinnerInherited extends InheritedComponent {
  final SpinnerNotifier notifier;

  const _SpinnerInherited({required this.notifier, required super.child});

  static SpinnerNotifier? of(BuildContext context) {
    final state = context
        .dependOnInheritedComponentOfExactType<_SpinnerInherited>();
    return state?.notifier;
  }

  @override
  bool updateShouldNotify(_SpinnerInherited oldComponent) {
    // Notifier reference never changes, so never trigger inherited rebuild
    return notifier != oldComponent.notifier;
  }
}

/// Braille frames that circle.
const runningFrames = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];

/// Braille frames that fill upward.
const setupFrames = [' ', '⣀', '⣤', '⣶', '⣿', '⠿', '⠛', '⠉', ' '];

/// Braille frames that fill downward.
const teardownFrames = [' ', '⠉', '⠛', '⠿', '⣿', '⣶', '⣤', '⣀', ' '];

/// A spinner icon that uses the shared animation from [SpinnerScope].
///
/// If no [SpinnerScope] ancestor exists, displays a static '●' character.
/// When [frames] is provided, maps the shared tick index to the custom
/// frame sequence instead of using the default rotating braille pattern.
class SpinnerIcon extends StatefulComponent {
  final Color? color;

  /// Custom frame sequence. When null, uses the shared SpinnerScope frames.
  final List<String>? frames;

  const SpinnerIcon({this.color, this.frames, super.key});

  @override
  State<SpinnerIcon> createState() => _SpinnerIconState();
}

class _SpinnerIconState extends State<SpinnerIcon> {
  SpinnerNotifier? _notifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newNotifier = SpinnerScope.of(context);
    if (newNotifier != _notifier) {
      _notifier?.removeListener(_onFrameChanged);
      _notifier = newNotifier;
      _notifier?.addListener(_onFrameChanged);
    }
  }

  void _onFrameChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _notifier?.removeListener(_onFrameChanged);
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final notifier = _notifier;
    final customFrames = component.frames;
    final String frame;
    if (customFrames != null && notifier != null) {
      frame = customFrames[notifier.tick % customFrames.length];
    } else {
      frame = notifier?.value ?? '●';
    }
    final color = component.color;
    return Text(frame, style: color != null ? TextStyle(color: color) : null);
  }
}

// Derived from mason_logger: https://github.com/felangel/mason/blob/master/packages/mason_logger/lib/src/progress.dart Licenced under the MIT Licence.

// The MIT License (MIT)
// Copyright (c) 2023 Felix Angelov
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.

import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/util/ansi_style.dart';

/// {@template progress_options}
/// An object containing configuration for a [Progress] instance.
/// {@endtemplate}
class ProgressOptions {
  /// {@macro progress_options}
  const ProgressOptions({this.animation = const ProgressAnimation()});

  /// The progress animation configuration.
  final ProgressAnimation animation;
}

/// {@template progress_animation}
/// An object which contains configuration for the animation
/// of a [Progress] instance.
/// {@endtemplate}
class ProgressAnimation {
  /// {@macro progress_animation}
  const ProgressAnimation({this.frames = _defaultFrames});

  static const _defaultFrames = [
    '⠋',
    '⠙',
    '⠹',
    '⠸',
    '⠼',
    '⠴',
    '⠦',
    '⠧',
    '⠇',
    '⠏'
  ];

  /// The list of animation frames.
  final List<String> frames;
}

/// {@template progress}
/// A class that can be used to display progress information to the user.
/// {@endtemplate}
class Progress {
  /// {@macro progress}
  Progress(
    this._message,
    this._stdout, {
    ProgressOptions options = const ProgressOptions(),
  })  : _stopwatch = Stopwatch(),
        _options = options {
    _stopwatch
      ..reset()
      ..start();

    // The animation is only shown when it would be meaningful.
    // Do not animate if the stdio type is not a terminal.
    // Do not animate if the log level is lower than info since other logs
    // might interrupt the animation
    if (!_stdout.hasTerminal) {
      var frames = _options.animation.frames;
      var char = frames.isEmpty ? '' : frames.first;
      var prefix = char.isEmpty ? char : '${AnsiStyle.lightGreen.wrap(char)} ';
      _write('$prefix$_message...\n');
      return;
    }

    _timer = Timer.periodic(const Duration(milliseconds: 80), _onTick);
    _onTick(_timer);
  }

  final ProgressOptions _options;

  final Stdout _stdout;

  final Stopwatch _stopwatch;

  Timer? _timer;

  String _message;

  int _index = 0;

  /// End the progress and mark it as a successful completion.
  ///
  /// See also:
  ///
  /// * [fail], to end the progress and mark it as failed.
  /// * [cancel], to cancel the progress entirely and remove the written line.
  void complete([String? update]) {
    _stopwatch.stop();
    _write(
      '''$_clearLine${AnsiStyle.lightGreen.wrap('✓')} ${update ?? _message} $_time\n''',
    );
    _timer?.cancel();
  }

  /// End the progress and mark it as failed.
  ///
  /// See also:
  ///
  /// * [complete], to end the progress and mark it as a successful completion.
  /// * [cancel], to cancel the progress entirely and remove the written line.
  void fail([String? update]) {
    _timer?.cancel();
    _write(
        '$_clearLine${AnsiStyle.red.wrap('✗')} ${update ?? _message} $_time\n');
    _stopwatch.stop();
  }

  /// Update the progress message.
  void update(String update) {
    if (_timer != null) _write(_clearLine);
    _message = update;
    _onTick(_timer);
  }

  /// Cancel the progress and remove the written line.
  void cancel() {
    _timer?.cancel();
    _write(_clearLine);
    _stopwatch.stop();
  }

  // Stops timer from calling [_onTick(...)].
  void stopAnimation() {
    _timer?.cancel();
  }

  String get _clearLine {
    return '\u001b[2K' // clear current line
        '\r'; // bring cursor to the start of the current line
  }

  void _onTick(Timer? _) {
    _index++;
    var frames = _options.animation.frames;
    var char = frames.isEmpty ? '' : frames[_index % frames.length];
    var prefix = char.isEmpty ? char : '${AnsiStyle.lightGreen.wrap(char)} ';

    _write('$_clearLine$prefix$_message... $_time');
  }

  void _write(String object) {
    _stdout.write(object);
  }

  String get _time {
    var elapsedTime = _stopwatch.elapsed.inMilliseconds;
    var displayInMilliseconds = elapsedTime < 100;
    var time = displayInMilliseconds ? elapsedTime : elapsedTime / 1000;
    var formattedTime =
        displayInMilliseconds ? '${time}ms' : '${time.toStringAsFixed(1)}s';
    return AnsiStyle.darkGray.wrap('($formattedTime)');
  }
}

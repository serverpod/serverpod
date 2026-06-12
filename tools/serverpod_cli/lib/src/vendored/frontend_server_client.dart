/*
 * This file is adapted from the original source in the `frontend_server_client`
 * package and licensed under a BSD-style license.
 * Source: https://pub.dev/packages/frontend_server_client
 *
 * The scope of the below license ("Software") is limited to this file only,
 * which is a derivative work of the original package. The license does
 * not apply to any other part of the codebase.
 *
 * Modifications: Simplified to use sdkRoot to locate the dart executable and
 * frontend server snapshots. The upstream version uses
 * Platform.resolvedExecutable which breaks when running as an AOT binary.
 * Added optional `nativeAssetsPath` parameter to forward the
 * `--native-assets <path>` flag, used to feed `frontend_server` the manifest
 * produced by `package:hooks_runner` so `@Native` lookups resolve correctly.
 *
 * Copyright 2020 The Dart Authors. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Google LLC nor the names of its contributors may
 *       be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' show Random;

import 'package:async/async.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

class FrontendServerClient {
  final String _entrypoint;
  final Process _feServer;
  final StreamQueue<String> _feServerStdoutLines;

  _ClientState _state;

  FrontendServerClient._(
    this._entrypoint,
    this._feServer,
    this._feServerStdoutLines,
    IOSink errorSink,
  ) : _state = _ClientState.waitingForFirstCompile {
    _feServer.stderr.transform(utf8.decoder).listen(errorSink.write);
  }

  static Future<FrontendServerClient> start(
    String entrypoint,
    String outputDillPath,
    String platformKernel, {
    required String sdkRoot,
    String target = 'vm',
    String? packagesJson,
    String? nativeAssetsPath,
    IOSink? errorSink,
  }) async {
    final entrypointUri = Uri.file(p.absolute(entrypoint));
    final arguments = <String>[
      '--sdk-root',
      sdkRoot,
      '--platform=${Uri.file(platformKernel)}',
      '--target=$target',
      '--output-dill',
      outputDillPath,
      if (packagesJson != null)
        '--packages=${Uri.file(p.absolute(packagesJson))}',
      if (nativeAssetsPath != null) ...[
        '--native-assets',
        p.absolute(nativeAssetsPath),
      ],
      '--incremental',
    ];
    final exe = Platform.isWindows ? '.exe' : '';
    final Process feServer;

    // Locate frontend server from SDK root.
    final aotSnapshot = p.join(
      sdkRoot,
      'bin',
      'snapshots',
      'frontend_server_aot.dart.snapshot',
    );
    if (File(aotSnapshot).existsSync()) {
      feServer = await Process.start(
        p.join(sdkRoot, 'bin', 'dartaotruntime$exe'),
        [aotSnapshot, ...arguments],
      );
    } else {
      feServer = await Process.start(p.join(sdkRoot, 'bin', 'dart$exe'), [
        p.join(sdkRoot, 'bin', 'snapshots', 'frontend_server.dart.snapshot'),
        ...arguments,
      ]);
    }

    final feServerStdoutLines = StreamQueue(
      feServer.stdout.transform(utf8.decoder).transform(const LineSplitter()),
    );
    final outputDir = Directory(p.dirname(outputDillPath));
    if (!await outputDir.exists()) await outputDir.create(recursive: true);
    return FrontendServerClient._(
      '$entrypointUri',
      feServer,
      feServerStdoutLines,
      errorSink ?? stderr,
    );
  }

  Future<CompileResult> compile([List<Uri>? invalidatedUris]) async {
    final action = switch (_state) {
      _ClientState.waitingForFirstCompile => 'compile',
      _ClientState.waitingForRecompile => 'recompile',
      _ => throw StateError('Cannot compile in state $_state'),
    };
    _state = _ClientState.compiling;

    try {
      final command = StringBuffer('$action $_entrypoint');
      if (action == 'recompile') {
        // After `reset()`, FES discards its incremental state but still
        // requires at least one invalidated URI. Default to the entry point
        // so callers can simply call `compile()` after `reset()`.
        final uris = (invalidatedUris == null || invalidatedUris.isEmpty)
            ? [Uri.parse(_entrypoint)]
            : invalidatedUris;
        final boundaryKey = _generateUuidV4();
        command.writeln(' $boundaryKey');
        for (final uri in uris) {
          command.writeln('$uri');
        }
        command.write(boundaryKey);
      }

      _feServer.stdin.writeln(command);
      var state = _CompileState.started;
      late String feBoundaryKey;
      final newSources = <Uri>{};
      final compilerOutputLines = <String>[];
      var errorCount = 0;
      String? outputDillPath;
      while (state != _CompileState.done &&
          await _feServerStdoutLines.hasNext) {
        final line = await _feServerStdoutLines.next;
        switch (state) {
          case _CompileState.started:
            assert(line.startsWith('result'));
            feBoundaryKey = line.substring(line.indexOf(' ') + 1);
            state = _CompileState.waitingForKey;
          case _CompileState.waitingForKey:
            if (line == feBoundaryKey) {
              state = _CompileState.gettingSourceDiffs;
            } else {
              compilerOutputLines.add(line);
            }
          case _CompileState.gettingSourceDiffs:
            if (line.startsWith(feBoundaryKey)) {
              state = _CompileState.done;
              final parts = line.split(' ');
              outputDillPath = parts.getRange(1, parts.length - 1).join(' ');
              errorCount = int.parse(parts.last);
            } else if (line.startsWith('+')) {
              newSources.add(Uri.parse(line.substring(1)));
            }
          case _CompileState.done:
            break;
        }
      }

      // If the loop exited before reaching the 'done' state, the FES
      // process likely crashed. Report this as a compile failure.
      if (state != _CompileState.done) {
        return CompileResult._(
          dillOutput: null,
          errorCount: 1,
          compilerOutputLines: [
            ...compilerOutputLines,
            'Frontend server exited unexpectedly during compilation.',
          ],
          newSources: const {},
        );
      }

      return CompileResult._(
        dillOutput: outputDillPath,
        errorCount: errorCount,
        compilerOutputLines: compilerOutputLines,
        newSources: newSources,
      );
    } finally {
      _state = _ClientState.waitingForAcceptOrReject;
    }
  }

  void accept() {
    _feServer.stdin.writeln('accept');
    _state = _ClientState.waitingForRecompile;
  }

  Future<void> reject() async {
    _state = _ClientState.rejecting;
    _feServer.stdin.writeln('reject');
    late String boundaryKey;
    var rejectState = _RejectState.started;
    while (rejectState != _RejectState.done &&
        await _feServerStdoutLines.hasNext) {
      final line = await _feServerStdoutLines.next;
      switch (rejectState) {
        case _RejectState.started:
          boundaryKey = line.split(' ').last;
          rejectState = _RejectState.waitingForKey;
        case _RejectState.waitingForKey:
          if (line == boundaryKey) rejectState = _RejectState.done;
        case _RejectState.done:
          break;
      }
    }
    _state = _ClientState.waitingForRecompile;
  }

  void reset() {
    _feServer.stdin.writeln('reset');
    _state = _ClientState.waitingForRecompile;
  }

  bool kill({ProcessSignal processSignal = ProcessSignal.sigterm}) {
    _feServerStdoutLines.cancel();
    return _feServer.kill(processSignal);
  }
}

class CompileResult {
  const CompileResult._({
    required this.dillOutput,
    required this.compilerOutputLines,
    required this.errorCount,
    required this.newSources,
  });

  final String? dillOutput;
  final Iterable<String> compilerOutputLines;
  final int errorCount;
  final Iterable<Uri> newSources;
}

@internal
extension CompileResultInternal on CompileResult {
  static const create = CompileResult._;
}

enum _ClientState {
  compiling,
  rejecting,
  waitingForAcceptOrReject,
  waitingForFirstCompile,
  waitingForRecompile,
}

enum _CompileState { started, waitingForKey, gettingSourceDiffs, done }

enum _RejectState { started, waitingForKey, done }

String _generateUuidV4() {
  final r = Random();
  String hex(int bits, int digits) =>
      r.nextInt(1 << bits).toRadixString(16).padLeft(digits, '0');
  final special = 8 + r.nextInt(4);
  return '${hex(16, 4)}${hex(16, 4)}-${hex(16, 4)}-4${hex(12, 3)}-'
      '${special.toRadixString(16)}${hex(12, 3)}-'
      '${hex(16, 4)}${hex(16, 4)}${hex(16, 4)}';
}

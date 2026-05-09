/*
 * This file is adapted from the original source in `pkg/dartdev` of the Dart
 * SDK (`pkg/dartdev/lib/src/native_assets_macos.dart`) and licensed under
 * a BSD-style license.
 * Source: https://github.com/dart-lang/sdk/tree/main/pkg/dartdev
 *
 * Vendored against Dart SDK 3.11.x (matches the version pinned in this
 * package's pubspec). When re-syncing, diff against the upstream
 * `pkg/dartdev/lib/src/native_assets_macos.dart` at the SDK tag matching
 * the `code_assets` / `hooks_runner` versions in pubspec.yaml.
 *
 * The scope of the below license ("Software") is limited to this file only,
 * which is a derivative work of the original. The license does not apply to
 * any other part of the codebase.
 *
 * Modifications: none, except for adjusting the import of the bundling
 * helpers to point at the vendored copy in this directory.
 *
 * Copyright 2024 The Dart project authors. All rights reserved.
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

import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:serverpod_cli/src/vendored/native_assets_bundling.dart';

final _rpathUri = Uri.file('@rpath/');

Future<void> rewriteInstallNames(
  List<Uri> dylibs, {
  required bool relocatable,
}) async {
  final oldToNewInstallNames = <String, String>{};
  final dylibInfos = <(Uri, String)>[];

  await Future.wait(
    dylibs.map((dylib) async {
      final newInstallName = relocatable
          ? _rpathUri
                .resolveUri(libOutputDirectoryUri)
                .resolve(dylib.pathSegments.last)
                .toFilePath()
          : dylib.toFilePath();
      final oldInstallName = await _getInstallName(dylib);
      oldToNewInstallNames[oldInstallName] = newInstallName;
      dylibInfos.add((dylib, newInstallName));
    }),
  );

  await Future.wait(
    dylibInfos.map((info) async {
      final (dylib, newInstallName) = info;
      await _setInstallNames(dylib, newInstallName, oldToNewInstallNames);
      await _codeSignDylib(dylib);
    }),
  );
}

Future<String> _getInstallName(Uri dylib) async {
  final otoolResult = await Process.run('otool', ['-D', dylib.toFilePath()]);
  if (otoolResult.exitCode != 0) {
    throw Exception(
      'Failed to get install name for dylib $dylib: ${otoolResult.stderr}',
    );
  }
  final architectureSections = parseOtoolArchitectureSections(
    otoolResult.stdout as String,
  );
  if (architectureSections.length != 1) {
    throw Exception(
      'Expected a single architecture section in otool output: $otoolResult',
    );
  }
  return architectureSections.values.first.single;
}

Future<void> _setInstallNames(
  Uri dylib,
  String newInstallName,
  Map<String, String> oldToNewInstallNames,
) async {
  final installNameToolResult = await Process.run('install_name_tool', [
    '-id',
    newInstallName,
    for (final entry in oldToNewInstallNames.entries) ...[
      '-change',
      entry.key,
      entry.value,
    ],
    dylib.toFilePath(),
  ]);
  if (installNameToolResult.exitCode != 0) {
    throw Exception(
      'Failed to set install names for dylib $dylib:\n'
      'id -> $newInstallName\n'
      'dependencies -> $oldToNewInstallNames\n'
      '${installNameToolResult.stderr}',
    );
  }
}

Future<void> _codeSignDylib(Uri dylib) async {
  final codesignResult = await Process.run('codesign', [
    '--force',
    '--sign',
    '-',
    dylib.toFilePath(),
  ]);
  if (codesignResult.exitCode != 0) {
    throw Exception(
      'Failed to codesign dylib $dylib: ${codesignResult.stderr}',
    );
  }
}

Map<Architecture?, List<String>> parseOtoolArchitectureSections(String output) {
  // The output of `otool -D`, for example, looks like below. For each
  // architecture, there is a separate section.
  //
  // /build/native_assets/ios/buz.framework/buz (architecture x86_64):
  // @rpath/libbuz.dylib
  // /build/native_assets/ios/buz.framework/buz (architecture arm64):
  // @rpath/libbuz.dylib
  //
  // Some versions of `otool` don't print the architecture name if the
  // binary only has one architecture:
  //
  // /build/native_assets/ios/buz.framework/buz:
  // @rpath/libbuz.dylib

  const Map<String, Architecture> outputArchitectures = <String, Architecture>{
    'arm': Architecture.arm,
    'arm64': Architecture.arm64,
    'x86_64': Architecture.x64,
  };
  final RegExp architectureHeaderPattern = RegExp(
    r'^[^(]+( \(architecture (.+)\))?:$',
  );
  final Iterator<String> lines = output.trim().split('\n').iterator;
  Architecture? currentArchitecture;
  final Map<Architecture?, List<String>> architectureSections =
      <Architecture?, List<String>>{};

  while (lines.moveNext()) {
    final String line = lines.current;
    final Match? architectureHeader = architectureHeaderPattern.firstMatch(
      line,
    );
    if (architectureHeader != null) {
      if (architectureSections.containsKey(null)) {
        throw Exception(
          'Expected a single architecture section in otool output: $output',
        );
      }
      final String? architectureString = architectureHeader[2];
      if (architectureString != null) {
        currentArchitecture = outputArchitectures[architectureString];
        if (currentArchitecture == null) {
          throw Exception(
            'Unknown architecture in otool output: $architectureString',
          );
        }
      }
      architectureSections[currentArchitecture] = <String>[];
      continue;
    } else {
      architectureSections[currentArchitecture]!.add(line.trim());
    }
  }

  return architectureSections;
}

/*
 * This file is adapted from the original source in `pkg/dartdev` of the Dart
 * SDK (`pkg/dartdev/lib/src/native_assets_bundling.dart`) and licensed under
 * a BSD-style license.
 * Source: https://github.com/dart-lang/sdk/tree/main/pkg/dartdev
 *
 * Vendored against Dart SDK 3.11.x (matches the version pinned in this
 * package's pubspec). When re-syncing, diff against the upstream
 * `pkg/dartdev/lib/src/native_assets_bundling.dart` at the SDK tag matching
 * the `code_assets` / `hooks_runner` versions in pubspec.yaml.
 *
 * The scope of the below license ("Software") is limited to this file only,
 * which is a derivative work of the original. The license does not apply to
 * any other part of the codebase.
 *
 * Modifications: none, except for adjusting the import of the macOS install
 * name rewriter to point at the vendored copy in this directory.
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
import 'package:data_assets/data_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:hooks_runner/hooks_runner.dart';
import 'package:serverpod_cli/src/vendored/native_assets_macos.dart';

final libOutputDirectoryUriFromBin = Uri.file(
  '../',
).resolveUri(libOutputDirectoryUri);
final libOutputDirectoryUri = Uri.file('lib/');
final dataOutputDirectoryUri = Uri.file('assets/');

Future<KernelAssets> bundleNativeAssets(
  Iterable<EncodedAsset> assets,
  Target target,
  Uri outputUri, {
  required bool relocatable,
  bool verbose = false,
}) async {
  final targetMapping = _targetMapping(assets, target, outputUri, relocatable);
  await _copyAssets(targetMapping, target, outputUri, relocatable, verbose);
  return KernelAssets(targetMapping.map((asset) => asset.target).toList());
}

Future<Uri> writeNativeAssetsYaml(
  KernelAssets assets,
  Uri outputUri, {
  String? header,
}) async {
  final nativeAssetsYamlUri = outputUri.resolve('native_assets.yaml');
  final nativeAssetsYamlFile = File(nativeAssetsYamlUri.toFilePath());
  await nativeAssetsYamlFile.create(recursive: true);

  var contents = assets.toNativeAssetsFile();
  if (header != null) {
    contents = '$header\n$contents';
  }

  await nativeAssetsYamlFile.writeAsString(contents);
  return nativeAssetsYamlUri;
}

Future<void> _copyAssets(
  List<({Object asset, KernelAsset target})> targetMapping,
  Target target,
  Uri outputUri,
  bool relocatable,
  bool verbose,
) async {
  final filesToCopy = <({String id, Uri src, Uri dest})>[];
  final codeAssetUris = <Uri>[];

  for (final (:asset, :target) in targetMapping) {
    final targetPath = target.path;
    if (targetPath
        case KernelAssetRelativePath(:final uri) ||
            KernelAssetAbsolutePath(:final uri)) {
      final targetUri = outputUri.resolveUri(uri);

      switch (asset) {
        case CodeAsset(:final file!):
          filesToCopy.add((id: asset.id, src: file, dest: targetUri));
          codeAssetUris.add(targetUri);
        case DataAsset(:final file):
          filesToCopy.add((id: asset.id, src: file, dest: targetUri));
        default:
          throw UnimplementedError();
      }
    }
  }

  if (filesToCopy.isNotEmpty) {
    if (verbose) {
      stdout.writeln(
        'Copying ${filesToCopy.length} build assets:\n'
        '${filesToCopy.map((e) => e.id).join('\n')}',
      );
    }

    // TODO(https://dartbug.com/59668): Cache copying and rewriting of install
    // names.
    await Future.wait(filesToCopy.map((file) => file.src.copyTo(file.dest)));

    if (target.os == OS.macOS) {
      await rewriteInstallNames(codeAssetUris, relocatable: relocatable);
    }
  }
}

List<({Object asset, KernelAsset target})> _targetMapping(
  Iterable<EncodedAsset> assets,
  Target target,
  Uri outputUri,
  bool relocatable,
) {
  final codeAssets = assets
      .where((asset) => asset.isCodeAsset)
      .map(CodeAsset.fromEncoded);
  final dataAssets = assets
      .where((asset) => asset.isDataAsset)
      .map(DataAsset.fromEncoded);

  return [
    for (final asset in codeAssets)
      (
        asset: asset,
        target: asset.targetLocation(target, outputUri, relocatable),
      ),
    for (final asset in dataAssets)
      (
        asset: asset,
        target: asset.targetLocation(target, outputUri, relocatable),
      ),
  ];
}

extension on CodeAsset {
  KernelAsset targetLocation(Target target, Uri outputUri, bool relocatable) {
    final kernelAssetPath = switch (linkMode) {
      DynamicLoadingSystem(:final uri) => KernelAssetSystemPath(uri),
      LookupInExecutable() => KernelAssetInExecutable(),
      LookupInProcess() => KernelAssetInProcess(),
      DynamicLoadingBundled() => () {
        final relativeUri = libOutputDirectoryUriFromBin.resolve(
          file!.pathSegments.last,
        );
        return relocatable
            ? KernelAssetRelativePath(relativeUri)
            : KernelAssetAbsolutePath(outputUri.resolveUri(relativeUri));
      }(),
      _ => throw UnsupportedError(
        'Unsupported NativeCodeAsset linkMode '
        '${linkMode.runtimeType} in asset $this',
      ),
    };
    return KernelAsset(id: id, target: target, path: kernelAssetPath);
  }
}

extension on DataAsset {
  KernelAsset targetLocation(Target target, Uri outputUri, bool relocatable) {
    final relativeUri = dataOutputDirectoryUri.resolve(file.pathSegments.last);
    return KernelAsset(
      id: id,
      target: target,
      path: relocatable
          ? KernelAssetRelativePath(relativeUri)
          : KernelAssetAbsolutePath(outputUri.resolveUri(relativeUri)),
    );
  }
}

extension on Uri {
  Future<void> copyTo(Uri targetUri) async {
    var targetFile = File.fromUri(targetUri);
    // File.copy truncates. So, first delete to ensure that if it was dlopened
    // it doesn't get truncated on disk.
    // https://github.com/dart-lang/sdk/issues/62361
    if (await targetFile.exists()) await targetFile.delete();
    await targetFile.create(recursive: true);
    await File.fromUri(this).copy(targetUri.toFilePath());
  }
}

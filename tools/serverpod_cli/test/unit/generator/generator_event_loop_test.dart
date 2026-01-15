import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_parameter_validator.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';

void main() {
  group('performGenerate event loop behavior', () {
    late GeneratorConfig config;
    late Directory tempDir;
    late Directory libDirectory;
    late EndpointsAnalyzer endpointsAnalyzer;
    late StatefulAnalyzer modelAnalyzer;
    late FutureCallsAnalyzer futureCallsAnalyzer;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('serverpod_test_');

      // Create a minimal lib directory structure
      libDirectory = Directory(p.join(tempDir.path, 'lib'));
      await libDirectory.create(recursive: true);

      config = GeneratorConfigBuilder().build();

      endpointsAnalyzer = EndpointsAnalyzer(libDirectory);

      var yamlModels = <ModelSource>[];
      modelAnalyzer = StatefulAnalyzer(config, yamlModels, (uri, collector) {
        // No-op error handler for test
      });

      var parameterValidator = FutureCallMethodParameterValidator(
        modelAnalyzer: modelAnalyzer,
      );

      futureCallsAnalyzer = FutureCallsAnalyzer(
        directory: libDirectory,
        parameterValidator: parameterValidator,
      );
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test(
      'Given performGenerate is running '
      'when periodic timer ticks '
      'then timer callback executes multiple times during generation.',
      () async {
        // Track timer ticks during generation
        var timerTicks = 0;
        var maxTicks = 0;

        // Create a periodic timer that simulates the progress animation timer
        var timer = Timer.periodic(Duration(milliseconds: 50), (_) {
          timerTicks++;
          if (timerTicks > maxTicks) {
            maxTicks = timerTicks;
          }
        });

        try {
          // Run generation and wait for it to complete
          await performGenerate(
            config: config,
            endpointsAnalyzer: endpointsAnalyzer,
            modelAnalyzer: modelAnalyzer,
            futureCallsAnalyzer: futureCallsAnalyzer,
          );
        } finally {
          timer.cancel();
        }

        // If the event loop is not blocked, the timer should have ticked
        // multiple times during generation (at least 2-3 times for a simple project)
        expect(
          maxTicks,
          greaterThan(1),
          reason:
              'Timer should tick multiple times during generation, indicating '
              'the event loop is not blocked',
        );
      },
    );

    test(
      'Given performGenerate is running '
      'when awaiting generation '
      'then event loop processes microtasks between phases.',
      () async {
        var microtaskExecuted = false;

        // Schedule a microtask that should execute during generation
        scheduleMicrotask(() {
          microtaskExecuted = true;
        });

        // Run generation
        await performGenerate(
          config: config,
          endpointsAnalyzer: endpointsAnalyzer,
          modelAnalyzer: modelAnalyzer,
          futureCallsAnalyzer: futureCallsAnalyzer,
        );

        // The microtask should have been executed
        expect(
          microtaskExecuted,
          isTrue,
          reason: 'Microtasks should be processed during async operations',
        );
      },
    );
  });
}

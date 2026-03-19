import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/commands/start/watch_session.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a FileChangeEvent with only dart files, '
    'when toGenerationRequirements is called, '
    'then it returns protocol-only requirements.',
    () {
      final event = FileChangeEvent(
        dartFiles: {'/lib/endpoint.dart'},
        modelFiles: {},
      );

      final requirements = event.toGenerationRequirements();

      expect(requirements.generateModels, isFalse);
      expect(requirements.generateProtocol, isTrue);
    },
  );

  test(
    'Given a FileChangeEvent with only model files, '
    'when toGenerationRequirements is called, '
    'then it returns full generation requirements.',
    () {
      final event = FileChangeEvent(
        dartFiles: {},
        modelFiles: {'/models/user.spy.yaml'},
      );

      final requirements = event.toGenerationRequirements();

      expect(requirements.generateModels, isTrue);
      expect(requirements.generateProtocol, isTrue);
    },
  );

  test(
    'Given a FileChangeEvent with both dart and model files, '
    'when toGenerationRequirements is called, '
    'then it returns full generation requirements.',
    () {
      final event = FileChangeEvent(
        dartFiles: {'/lib/endpoint.dart'},
        modelFiles: {'/models/user.spy.yaml'},
      );

      final requirements = event.toGenerationRequirements();

      expect(requirements.generateModels, isTrue);
      expect(requirements.generateProtocol, isTrue);
    },
  );
}

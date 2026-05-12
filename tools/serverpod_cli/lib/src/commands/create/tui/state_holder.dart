import 'package:serverpod_cli/src/commands/create/tui/app.dart';
import 'package:serverpod_cli/src/commands/create/tui/state.dart';
import 'package:serverpod_cli/src/commands/tui/app.dart';
import 'package:serverpod_cli/src/commands/tui/app_state_holder.dart';

/// State holder for [ServerpodCreateApp].
class CreateAppStateHolder extends ServerpodAppStateHolder<CreateConfigState> {
  CreateAppStateHolder(this._state);

  final CreateConfigState _state;

  ServerpodCreateAppState? _widgetState;

  @override
  CreateConfigState get state => _state;

  @override
  ServerpodAppState? get widgetState => _widgetState;

  @override
  void attach(ServerpodCreateAppState widgetState) {
    _widgetState = widgetState;
  }

  @override
  void detach(ServerpodCreateAppState widgetState) {
    if (_widgetState == widgetState) _widgetState = null;
  }
}

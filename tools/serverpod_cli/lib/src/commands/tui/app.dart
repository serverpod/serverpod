import 'package:meta/meta.dart';
import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/tui/app_state_holder.dart';
import 'package:serverpod_cli/src/commands/tui/components/spinner.dart';

/// A root TUI component.
abstract class ServerpodApp<T extends ServerpodAppStateHolder>
    extends StatefulComponent {
  const ServerpodApp({super.key, required this.holder});

  final T holder;

  @override
  ServerpodAppState<ServerpodApp> createState();
}

/// The logic and internal state for a [ServerpodApp].
abstract class ServerpodAppState<S extends ServerpodApp> extends State<S> {
  @override
  void initState() {
    super.initState();
    component.holder.attach(this);
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void dispose() {
    component.holder.detach(this);
    super.dispose();
  }

  void rebuild() {
    setState(() {});
  }

  /// Describes the part of the user interface represented by this component.
  Component buildApp(BuildContext context);

  @override
  @protected
  Component build(BuildContext context) {
    final state = component.holder.state;

    return NoctermApp(
      child: Builder(
        builder: (context) {
          final themeData = TuiTheme.of(context);
          return TuiTheme(
            data: themeData.copyWith(
              background: Color.defaultColor,
            ),
            child: SpinnerScope(
              active: state.activeOperations.isNotEmpty,
              child: buildApp(context),
            ),
          );
        },
      ),
    );
  }
}

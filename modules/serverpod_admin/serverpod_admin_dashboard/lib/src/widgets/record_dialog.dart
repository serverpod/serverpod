import 'package:flutter/material.dart';
import 'package:serverpod_admin_client/serverpod_admin_client.dart';
import 'package:serverpod_admin_dashboard/src/controller/record_dialog_state.dart';
import 'package:serverpod_admin_dashboard/src/widgets/dialog_field.dart';

class RecordDialog extends StatefulWidget {
  const RecordDialog({
    required this.resource,
    required this.onSubmit,
    this.initialValues = const {},
    this.isUpdate = false,
  });

  final AdminResource resource;
  final Future<bool> Function(Map<String, String> payload) onSubmit;
  final Map<String, String> initialValues;
  final bool isUpdate;

  @override
  State<RecordDialog> createState() => _RecordDialogState();
}

class _RecordDialogState extends State<RecordDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _readOnlyFields = {};
  final ScrollController _formScrollController = ScrollController();
  late final RecordDialogStateController _stateController =
      RecordDialogStateController();

  @override
  void initState() {
    super.initState();
    for (final column in widget.resource.columns) {
      final includeColumn = widget.isUpdate
          ? true
          : column.isPrimary
              ? false
              : true;
      if (!includeColumn) continue;
      final initialValue = widget.initialValues[column.name] ?? '';
      _controllers[column.name] = TextEditingController(text: initialValue);
      _readOnlyFields[column.name] =
          widget.isUpdate && column.isPrimary ? true : false;
    }
  }

  @override
  void dispose() {
    _formScrollController.dispose();
    _stateController.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fields = widget.resource.columns
        .where((column) => _controllers.containsKey(column.name))
        .map(
          (column) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Field(
              column: column,
              controller: _controllers[column.name]!,
              readOnly: _readOnlyFields[column.name] ?? false,
            ),
          ),
        )
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final maxWidth = isWide ? 720.0 : 520.0;
        final maxHeight =
            MediaQuery.of(context).size.height * (isWide ? 0.85 : 0.9);

        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: isWide ? 64 : 24,
            vertical: isWide ? 48 : 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.add_box_outlined,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isUpdate
                                  ? 'Update ${widget.resource.tableName}'
                                  : 'Add ${widget.resource.tableName}',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.isUpdate
                                  ? 'Modify the fields and save your changes.'
                                  : 'Complete the form to create a new record.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListenableBuilder(
                        listenable: _stateController,
                        builder: (context, _) {
                          return IconButton(
                            tooltip: 'Close dialog',
                            onPressed: _stateController.isSubmitting
                                ? null
                                : () => Navigator.of(context).pop(false),
                            icon: const Icon(Icons.close_rounded),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Material(
                      color: theme.colorScheme.surface.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(18),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Scrollbar(
                          controller: _formScrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _formScrollController,
                            primary: false,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  ...fields,
                                  ListenableBuilder(
                                    listenable: _stateController,
                                    builder: (context, _) {
                                      if (_stateController.submitError ==
                                          null) {
                                        return const SizedBox.shrink();
                                      }
                                      return Column(
                                        children: [
                                          const SizedBox(height: 14),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              _stateController.submitError!,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: theme.colorScheme.error,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListenableBuilder(
                    listenable: _stateController,
                    builder: (context, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _stateController.isSubmitting
                                ? null
                                : () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            onPressed: _stateController.isSubmitting
                                ? null
                                : _handleSubmit,
                            icon: _stateController.isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.check_circle_outline),
                            label: Text(
                              _stateController.isSubmitting
                                  ? (widget.isUpdate
                                      ? 'Updating...'
                                      : 'Saving...')
                                  : (widget.isUpdate ? 'Update' : 'Create'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final payload = <String, String>{};
    for (final entry in _controllers.entries) {
      payload[entry.key] = entry.value.text.trim();
    }

    _stateController.startSubmission();

    final success = await widget.onSubmit(payload);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      _stateController.stopSubmission(
        error:
            'Failed to ${widget.isUpdate ? 'update' : 'create'} record. Please try again.',
      );
    }
  }
}

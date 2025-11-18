import 'package:flutter/material.dart';
import 'package:serverpod_admin_dashboard/src/helpers/admin_resources.dart';
import 'package:serverpod_admin_dashboard/src/widgets/records_body.dart';

class RecordsPane extends StatelessWidget {
  const RecordsPane({
    required this.resource,
    required this.records,
    required this.isLoading,
    required this.errorMessage,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    this.onView,
  });

  final AdminResource? resource;
  final List<Map<String, String>> records;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onAdd;
  final void Function(Map<String, String> record)? onEdit;
  final void Function(Map<String, String> record)? onDelete;
  final void Function(Map<String, String> record)? onView;

  @override
  Widget build(BuildContext context) {
    if (resource == null) {
      return Center(
        child: Text(
          'Select a resource to view its records.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              color: theme.colorScheme.primary.withOpacity(0.06),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource!.tableName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            '${records.length} records',
                            style: theme.textTheme.labelLarge,
                          ),
                          avatar: const Icon(Icons.table_rows, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: Text('Add ${resource!.tableName}'),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: RecordsBody(
                resource: resource!,
                records: records,
                isLoading: isLoading,
                errorMessage: errorMessage,
                onEdit: onEdit,
                onDelete: onDelete,
                onView: onView,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:serverpod_admin_dashboard/src/helpers/admin_resources.dart';
import 'package:serverpod_admin_dashboard/src/helpers/format_value.dart';

class RecordDetails extends StatelessWidget {
  const RecordDetails({
    required this.resource,
    required this.record,
    this.onEdit,
    this.onDelete,
  });

  final AdminResource resource;
  final Map<String, String> record;
  final void Function(Map<String, String> record)? onEdit;
  final void Function(Map<String, String> record)? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final columns = resource.columns;

    return Scaffold(
      appBar: AppBar(
        title: Text('${resource.tableName} Details'),
        actions: [
          if (onEdit != null)
            IconButton(
              tooltip: 'Edit record',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.of(context).pop();
                onEdit!(record);
              },
            ),
          if (onDelete != null)
            IconButton(
              tooltip: 'Delete record',
              icon: Icon(
                Icons.delete_outline,
                color: theme.colorScheme.error,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onDelete!(record);
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color:
                                  theme.colorScheme.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: theme.colorScheme.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  resource.tableName,
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Record Details',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.textTheme.bodyMedium?.color
                                        ?.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 24),
                      // Fields
                      ...columns.map((column) {
                        final value = record[column.name];
                        final formattedValue = formatRecordValue(column, value);
                        final isEmpty = formattedValue.isEmpty;
                        final isPrimary = column.isPrimary;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isPrimary
                                        ? Icons.vpn_key
                                        : Icons.label_outline,
                                    size: 18,
                                    color: isPrimary
                                        ? theme.colorScheme.primary
                                        : theme.textTheme.bodyMedium?.color
                                            ?.withOpacity(0.6),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    column.name,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isPrimary
                                          ? theme.colorScheme.primary
                                          : null,
                                    ),
                                  ),
                                  if (isPrimary) ...[
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: const Text(
                                        'Primary Key',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                      backgroundColor: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      labelStyle: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                  if (column.hasDefault) ...[
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: const Text(
                                        'Default',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                      backgroundColor: theme
                                          .colorScheme.secondary
                                          .withOpacity(0.1),
                                      labelStyle: TextStyle(
                                        color: theme.colorScheme.secondary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isEmpty
                                      ? theme.colorScheme.surface
                                      : theme
                                          .colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isEmpty
                                        ? theme.dividerColor.withOpacity(0.2)
                                        : theme.dividerColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  isEmpty ? '(empty)' : formattedValue,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: isEmpty
                                        ? theme.textTheme.bodyLarge?.color
                                            ?.withOpacity(0.5)
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:serverpod_admin_dashboard/src/helpers/admin_resources.dart';
import 'package:serverpod_admin_dashboard/src/widgets/side_bar_error.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    required this.resources,
    required this.isLoading,
    required this.errorMessage,
    required this.selectedResource,
    required this.onSelect,
    required this.onRetry,
    required this.isCollapsed,
    required this.onToggleCollapse,
    this.isInDrawer = false,
  });

  final List<AdminResource> resources;
  final bool isLoading;
  final String? errorMessage;
  final AdminResource? selectedResource;
  final void Function(AdminResource resource) onSelect;
  final VoidCallback onRetry;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;
  final bool isInDrawer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 280,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.dashboard_customize_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resources',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${resources.length} available',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: isInDrawer
                        ? 'Close drawer'
                        : (isCollapsed ? 'Expand sidebar' : 'Collapse sidebar'),
                    icon: Icon(
                      isInDrawer
                          ? Icons.close_rounded
                          : (isCollapsed
                              ? Icons.chevron_right_rounded
                              : Icons.chevron_left_rounded),
                    ),
                    onPressed: onToggleCollapse,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: _buildContent(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return SidebarError(
        message: errorMessage!,
        onRetry: onRetry,
      );
    }

    if (resources.isEmpty) {
      return const Center(
        child: Text('No resources registered.'),
      );
    }

    final theme = Theme.of(context);
    return ListView.separated(
      itemCount: resources.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final resource = resources[index];
        final isSelected = selectedResource?.key == resource.key;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.12)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.dividerColor.withOpacity(0.2),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: CircleAvatar(
              radius: 18,
              backgroundColor:
                  theme.colorScheme.primary.withOpacity(isSelected ? 0.2 : 0.1),
              child: Icon(
                Icons.data_object_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            title: Text(
              resource.tableName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.chevron_right_rounded,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.iconTheme.color?.withOpacity(0.4),
            ),
            onTap: () => onSelect(resource),
          ),
        );
      },
    );
  }
}

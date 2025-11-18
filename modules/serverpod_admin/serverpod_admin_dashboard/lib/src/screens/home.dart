import 'package:flutter/material.dart';
import 'package:serverpod_admin_dashboard/src/controller/admin_dashboard.dart';
import 'package:serverpod_admin_dashboard/src/screens/home_operations.dart';
import 'package:serverpod_admin_dashboard/src/widgets/footer.dart';
import 'package:serverpod_admin_dashboard/src/widgets/records_pane.dart';
import 'package:serverpod_admin_dashboard/src/widgets/side_bar.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.controller,
  });

  final AdminDashboardController controller;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeOperations? _operations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize operations after context is available
    _operations ??= HomeOperations(
      controller: widget.controller,
      context: context,
    );
  }

  HomeOperations get operations {
    // This should only be called after didChangeDependencies
    return _operations ??= HomeOperations(
      controller: widget.controller,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final width = MediaQuery.of(context).size.width;
        final isSmallScreen = width < 800;

        return Scaffold(
          appBar: AppBar(
            leading: isSmallScreen
                ? Builder(
                    builder: (context) => IconButton(
                      tooltip: 'Open navigation',
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  )
                : null,
            title: const Text('Admin Dashboard'),
            actions: [
              IconButton(
                tooltip: widget.controller.themeMode == ThemeMode.dark
                    ? 'Switch to light mode'
                    : 'Switch to dark mode',
                onPressed: widget.controller.toggleThemeMode,
                icon: Icon(
                  widget.controller.themeMode == ThemeMode.dark
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          drawer: isSmallScreen
              ? Drawer(
                  child: SafeArea(
                    child: Sidebar(
                      resources: widget.controller.resources,
                      isLoading: widget.controller.isResourcesLoading,
                      errorMessage: widget.controller.resourcesError,
                      selectedResource: widget.controller.selectedResource,
                      onRetry: widget.controller.loadResources,
                      onSelect: (resource) {
                        Navigator.of(context).pop(); // close drawer
                        widget.controller.selectResource(resource);
                      },
                      isCollapsed: false,
                      onToggleCollapse: () {
                        Navigator.of(context).pop(); // close drawer
                      },
                      isInDrawer: true,
                    ),
                  ),
                )
              : null,
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0x1A6A5AE0),
                    Color(0x106A5AE0),
                    Color(0x006A5AE0),
                  ],
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1440),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Column(
                      children: [
                        Expanded(
                          child: isSmallScreen
                              ? RecordsPane(
                                  resource: widget.controller.selectedResource,
                                  records: widget.controller.records,
                                  isLoading: widget.controller.isRecordsLoading,
                                  errorMessage: widget.controller.recordsError,
                                  onAdd:
                                      widget.controller.selectedResource == null
                                          ? null
                                          : () {
                                              final resource = widget
                                                  .controller.selectedResource;
                                              if (resource != null) {
                                                operations
                                                    .showCreateDialog(resource);
                                              }
                                            },
                                  onEdit:
                                      widget.controller.selectedResource == null
                                          ? null
                                          : (record) {
                                              final resource = widget
                                                  .controller.selectedResource;
                                              if (resource != null) {
                                                operations.showEditDialog(
                                                    resource, record);
                                              }
                                            },
                                  onDelete:
                                      widget.controller.selectedResource == null
                                          ? null
                                          : (record) {
                                              final resource = widget
                                                  .controller.selectedResource;
                                              if (resource != null) {
                                                operations
                                                    .showDeleteConfirmation(
                                                        resource, record);
                                              }
                                            },
                                  onView:
                                      widget.controller.selectedResource == null
                                          ? null
                                          : (record) {
                                              final resource = widget
                                                  .controller.selectedResource;
                                              if (resource != null) {
                                                operations.showDetailsPage(
                                                    resource, record);
                                              }
                                            },
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (widget.controller.isSidebarCollapsed)
                                      Container(
                                        width: 40,
                                        alignment: Alignment.topCenter,
                                        child: IconButton(
                                          tooltip: 'Expand sidebar',
                                          icon: const Icon(
                                            Icons.chevron_right_rounded,
                                          ),
                                          onPressed: () {
                                            widget.controller
                                                .toggleSidebarCollapsed();
                                          },
                                        ),
                                      )
                                    else
                                      Sidebar(
                                        resources: widget.controller.resources,
                                        isLoading: widget
                                            .controller.isResourcesLoading,
                                        errorMessage:
                                            widget.controller.resourcesError,
                                        selectedResource:
                                            widget.controller.selectedResource,
                                        onRetry:
                                            widget.controller.loadResources,
                                        onSelect:
                                            widget.controller.selectResource,
                                        isCollapsed: widget
                                            .controller.isSidebarCollapsed,
                                        onToggleCollapse: () {
                                          widget.controller
                                              .toggleSidebarCollapsed();
                                        },
                                      ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: RecordsPane(
                                        resource:
                                            widget.controller.selectedResource,
                                        records: widget.controller.records,
                                        isLoading:
                                            widget.controller.isRecordsLoading,
                                        errorMessage:
                                            widget.controller.recordsError,
                                        onAdd: widget.controller
                                                    .selectedResource ==
                                                null
                                            ? null
                                            : () {
                                                final resource = widget
                                                    .controller
                                                    .selectedResource;
                                                if (resource != null) {
                                                  operations.showCreateDialog(
                                                      resource);
                                                }
                                              },
                                        onEdit: widget.controller
                                                    .selectedResource ==
                                                null
                                            ? null
                                            : (record) {
                                                final resource = widget
                                                    .controller
                                                    .selectedResource;
                                                if (resource != null) {
                                                  operations.showEditDialog(
                                                      resource, record);
                                                }
                                              },
                                        onDelete: widget.controller
                                                    .selectedResource ==
                                                null
                                            ? null
                                            : (record) {
                                                final resource = widget
                                                    .controller
                                                    .selectedResource;
                                                if (resource != null) {
                                                  operations
                                                      .showDeleteConfirmation(
                                                          resource, record);
                                                }
                                              },
                                        onView: widget.controller
                                                    .selectedResource ==
                                                null
                                            ? null
                                            : (record) {
                                                final resource = widget
                                                    .controller
                                                    .selectedResource;
                                                if (resource != null) {
                                                  operations.showDetailsPage(
                                                      resource, record);
                                                }
                                              },
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 16),
                        const Footer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

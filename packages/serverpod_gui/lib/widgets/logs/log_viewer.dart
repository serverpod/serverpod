import 'package:flutter/material.dart';
import 'package:serverpod_gui/widgets/logs/session_log_filter.dart';
import 'package:serverpod_gui/widgets/logs/session_log_properties.dart';
import 'package:serverpod_gui/widgets/logs/session_log_table.dart';
import '../../business/app_state.dart';
import 'package:serverpod_service_client/protocol/protocol.dart';

class LogViewer extends StatefulWidget {
  @override
  _LogViewerState createState() => _LogViewerState();
}

class _LogViewerState extends State<LogViewer> {
  SessionLogResult? _logs;
  SessionLogInfo? _selectedLogEntry;

  @override
  void initState() {
    super.initState();
    state.client?.insights.getSessionLog(100).then((SessionLogResult? result) {
      setState(() {
        _logs = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_logs == null) {
      return Container();
    }
    else {
      return Column(
        children: [
          SessionLogFilter(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SessionLogTable(
                    logInfos: _logs!.sessionLog!,
                    onSelectedEntry: (SessionLogInfo? entry) {
                      setState(() {
                        _selectedLogEntry = entry;
                      });
                    },
                  ),
                ),
                SessionLogProperties(
                  logInfo: _selectedLogEntry,
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}


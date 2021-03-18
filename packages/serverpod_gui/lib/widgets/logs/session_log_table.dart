import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_gui/util/formatters.dart';
import 'package:serverpod_gui/widgets/tables/fancy_data_table.dart';
import '../tables/resizable_table.dart';
import 'package:serverpod_service_client/protocol/protocol.dart';

typedef void SessionLogTableSelectionCallback(SessionLogInfo? info);

class SessionLogTable extends StatelessWidget {
  final List<SessionLogInfo> logInfos;
  final SessionLogTableSelectionCallback onSelectedEntry;

  SessionLogTable({
    required this.logInfos,
    required this.onSelectedEntry,
  });

  @override
  Widget build(BuildContext context) {
    var cells = <List<Widget>>[];
    for (var logEntry in logInfos) {
      var row = <Widget>[
        _buildIndicator(context, logEntry),
        Text(logEntry.sessionLogEntry.id.toString()),
        Text(logEntry.sessionLogEntry.endpoint),
        Text(logEntry.sessionLogEntry.method),
        Text('${logEntry.sessionLogEntry.serverId}'),
        Text(durationFormat.format(logEntry.sessionLogEntry.duration)),
        Text(logEntry.sessionLogEntry.numQueries.toString()),
        Text(dateFormat.format(logEntry.sessionLogEntry.time.toLocal())),
      ];

      cells.add(
        row,
      );
    }

    return FancyDataTable(
      columnLabels: [
        '',
        'Session ID',
        'Endpoint',
        'Method',
        'Server',
        'Duration',
        'Queries',
        'Time',
      ],
      cells: cells,
      widths: [
        50.0,
        100.0,
        100.0,
        200.0,
        80.0,
        80.0,
        80.0,
        180.0,
      ],
      onSelectedRow: (int index) {
        onSelectedEntry(logInfos[index]);
      },
    );
  }

  Widget _buildIndicator(BuildContext context, SessionLogInfo info) {
    List<Widget> row = [];
    if (info.sessionLogEntry.error != null) {
      row.add(
        Icon(
          Icons.error_rounded,
          color: Colors.red,
          size: 18.0,
        ),
      );
    }

    if (info.sessionLogEntry.slow) {
      row.add(
        Icon(
          Icons.timelapse_rounded,
          color: Colors.amber,
          size: 18.0,
        ),
      );
    }

    if (row.length == 0) {
      row.add(
        Icon(
          Icons.check_circle_rounded,
          color: Colors.green,
          size: 18.0,
        ),
      );
    }

    return Row(
      children: row,
    );
  }
}

class SessionLogSource extends DataTableSource {
  final List<SessionLogInfo> logInfos;

  SessionLogSource({required this.logInfos});

  @override
  DataRow? getRow(int index) {
    if (index >= logInfos.length)
      return null;

    var logInfo = logInfos[index];

    return DataRow(
      cells: [
        DataCell(
          Text(logInfo.sessionLogEntry.endpoint),
        ),
        DataCell(
          Text(logInfo.sessionLogEntry.method),
        ),
        DataCell(
          Text(logInfo.sessionLogEntry.duration.toString()),
        ),
      ],
    );
  }

  @override
  int get rowCount => logInfos.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
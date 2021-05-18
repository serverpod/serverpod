import 'dart:math';

import 'package:flutter/material.dart';
import 'package:serverpod_gui/widgets/generic/propery_inspector.dart';
import 'package:serverpod_service_client/protocol/protocol.dart';

class SessionLogProperties extends StatelessWidget {
  final SessionLogInfo? logInfo;

  SessionLogProperties({this.logInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: logInfo != null ? _PropertyInspector(logInfo: logInfo!,) : null,
    );
  }
}

class _PropertyInspector extends StatelessWidget {
  final SessionLogInfo logInfo;

  _PropertyInspector({required this.logInfo});

  @override
  Widget build(BuildContext context) {
    List<String> queries = [];
    if (logInfo.queries != null && logInfo.queries!.length > 0) {
      for (var query in logInfo.queries!) {
        queries.add(query.query!);
      }
    }

    List<String>? logs;
    if (logInfo.messageLog != null && logInfo.messageLog!.length > 0) {
      logs = [];
      for (var log in logInfo.messageLog!) {
        logs.add(log.message!);
      }
    }

    return PropertyInspector(
      header: PropertyInspectorHeader(
        child: Text('Session Log Entry'),
      ),
      properties: [
        PropertyInspectorTextProp(name: 'Session ID', value: logInfo.sessionLogEntry!.id.toString()),
        PropertyInspectorTextProp(name: 'Endpoint', value: logInfo.sessionLogEntry!.endpoint!),
        PropertyInspectorTextProp(name: 'Method', value: logInfo.sessionLogEntry!.method!),
        PropertyInspectorDivider(),
        PropertyInspectorListProp(name: 'Log Entries', list: logs, fallbackText: 'No log entries were captured for this session.',),
        PropertyInspectorDivider(),
        PropertyInspectorListProp(name: 'Queries', list: queries, fallbackText: 'No queries were captured for this session.',),
      ],
    );
  }
}


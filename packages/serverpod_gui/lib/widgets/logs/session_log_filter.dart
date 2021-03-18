import 'package:flutter/material.dart';
import 'package:serverpod_gui/widgets/generic/fancy_checkbox.dart';
import 'package:serverpod_gui/widgets/generic/fancy_toolbar_button.dart';
import '../generic/fancy_drop_down_button.dart';
import '../../business/app_state.dart';

class SessionLogFilter extends StatefulWidget {
  @override
  _SessionLogFilterState createState() => _SessionLogFilterState();
}

class _SessionLogFilterState extends State<SessionLogFilter> {
  String _endpoint = '';
  String _method = '';
  bool _slow = false;
  bool _error = false;
  bool _updated = false;

  @override
  Widget build(BuildContext context) {
    var endpointItems = <DropdownMenuItem<String>>[];
    endpointItems.add(
      DropdownMenuItem<String>(
        child: Text('Any'),
        value: '',
      ),
    );
    for (var endpoint in state.connectionHandler.endpoints) {
      endpointItems.add(
        DropdownMenuItem<String>(
          child: Text(endpoint),
          value: endpoint,
        ),
      );
    }

    var methodItems = <DropdownMenuItem<String>>[];
    methodItems.add(
      DropdownMenuItem<String>(
        child: Text('Any'),
        value: '',
      ),
    );
    if (_endpoint != '' && state.connectionHandler.methods[_endpoint] != null) {
      for (var method in state.connectionHandler.methods[_endpoint]!) {
        methodItems.add(
          DropdownMenuItem<String>(
            child: Text(method),
            value: method,
          ),
        );
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 2.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text('Endpoint'),
          ),
          FancyDropdownButton<String>(
            width: 150.0,
            items: endpointItems,
            value: _endpoint,
            onChanged: (String? value) {
              setState(() {
                _endpoint = value!;
                _method = '';
                _updated = true;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.0, left: 16.0),
            child: Text('Method'),
          ),
          FancyDropdownButton<String>(
            width: 250.0,
            items: methodItems,
            value: _method,
            onChanged: (String? value) {
              setState(() {
                _method = value!;
                _updated = true;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: FancyCheckbox(
              label: 'Slow',
              value: _slow,
              onChanged: (bool? value) {
                setState(() {
                  _slow = value!;
                  _updated = true;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: FancyCheckbox(
              label: 'Error',
              value: _error,
              onChanged: (bool? value) {
                setState(() {
                  _error = value!;
                  _updated = true;
                });
              },
            ),
          ),
          FancyToolbarButton(
            // label: _updated ? 'Fetch' : 'Refresh',
            label: 'Reload',
            icon: Icons.refresh,
            color: Colors.green,
            onPressed: () {},
          ),
          Spacer(),
          FancyToolbarButton(
            icon: Icons.highlight_remove,
            color: Colors.red,
            label: 'Clear Log',
            onPressed: () {},
          ),
          FancyToolbarButton(
            icon: Icons.settings,
            label: 'Log Settings',
            color: Colors.grey[700],
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

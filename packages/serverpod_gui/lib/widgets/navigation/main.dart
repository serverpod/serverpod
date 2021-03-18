import 'package:flutter/material.dart';
import 'package:serverpod_gui/widgets/navigation/project_selector.dart';
import '../logs/log_viewer.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedNavigation = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                NavigationRail(
                  backgroundColor: Theme.of(context).backgroundColor,
                  extended: true,
                  selectedIndex: _selectedNavigation,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedNavigation = index;
                    });
                  },
                  // labelType: NavigationRailLabelType.selected,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.fact_check_outlined),
                      label: Text('Logs'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.memory),
                      label: Text('Cache'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.bar_chart),
                      label: Text('Analytics'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.local_hospital_outlined),
                      label: Text('Health'),
                    ),
                  ],
                ),
                VerticalDivider(thickness: 1, width: 1,),
                Expanded(
                  child: LogViewer(),
                ),
              ],
            ),
          ),
          ProjectSelector(),
        ],
      ),
    );
  }
}

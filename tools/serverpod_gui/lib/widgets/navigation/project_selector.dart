import 'package:flutter/material.dart';

class ProjectSelector extends StatefulWidget {
  @override
  _ProjectSelectorState createState() => _ProjectSelectorState();
}

class _ProjectSelectorState extends State<ProjectSelector> {
  String _enviroment = 'development';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Material(
        elevation: 8,
        child: Row(
          children: [
            SizedBox(width: 16.0,),
            DropdownButton<String>(
              isDense: true,
              value: _enviroment,
              onChanged: (String? environment) {
                setState(() {
                  _enviroment = environment!;
                });
              },
              underline: SizedBox(),
              items: [
                DropdownMenuItem<String>(
                  child: Text('Development'),
                  value: 'development',
                ),
                DropdownMenuItem<String>(
                  child: Text('Staging'),
                  value: 'staging',
                ),
                DropdownMenuItem<String>(
                  child: Text('Production'),
                  value: 'production',
                ),
              ],
            ),
            SizedBox(
              width: 16.0,
            ),
            Icon(
              Icons.offline_bolt_outlined,
              color: Colors.green,
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              'Connected',
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
              iconSize: 18.0,
            ),
          ],
        ),
      ),
    );
  }
}

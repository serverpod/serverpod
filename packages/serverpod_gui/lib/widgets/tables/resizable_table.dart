import 'package:flutter/material.dart';

class ResizableTable extends StatelessWidget {
  final List<String> columnLabels;
  final List<List<ResizableCell>> cells;
  final List<double> widths;

  ResizableTable({
    required this.columnLabels,
    required this.cells,
    required this.widths,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _TableHeader(
          labels: columnLabels,
          widths: widths,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cells.length,
            itemBuilder: (BuildContext context, int index) {
              var row = <Widget>[];
              int cellIndex = 0;
              for (var c in cells[index]) {
                row.add(
                  SizedBox(
                    width: widths[cellIndex],
                    child: c,
                  )
                );
                cellIndex += 1;
              }

              return Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
                ),
                child: Row(
                  children: row,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  final List<String> labels;
  final List<double> widths;

  _TableHeader({required this.labels, required this.widths});

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    int labelIndex = 0;
    for (var label in labels) {
      children.add(
        SizedBox(
          width: widths[labelIndex],
          child: _TableHeaderLabel(
            label: label,
          ),
        ),
      );
      labelIndex += 1;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
      ),
      child: Row(
        children: children,
      ),
    );
  }
}

class _TableHeaderLabel extends StatelessWidget {
  final String label;

  _TableHeaderLabel({required this.label,});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Text(
          label,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}

class ResizableCell extends StatelessWidget {
  final String text;

  ResizableCell({required this.text,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class ResizableTableController {
  final List<double> widths;

  ResizableTableController({required this.widths});
}

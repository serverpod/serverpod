import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

typedef void FancyDataTableCallback(int seletedIndex);

class FancyDataTable extends StatefulWidget {
  final List<String> columnLabels;
  final List<List<Widget>> cells;
  final List<double> widths;
  final FancyDataTableCallback onSelectedRow;

  FancyDataTable({
    required this.columnLabels,
    required this.cells,
    required this.widths,
    required this.onSelectedRow,
  });

  @override
  State<StatefulWidget> createState() => FancyDataTableState();
}

class FancyDataTableState extends State<FancyDataTable> {
  static const _cellHeight = 24.0;

  int? _selectedRow;

  ScrollControllers _scrollControllers = ScrollControllers();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: StickyHeadersTable(
        scrollControllers: _scrollControllers,
        cellDimensions: CellDimensions.variableColumnWidth(
          columnWidths: widget.widths.sublist(1),
          contentCellHeight: _cellHeight,
          stickyLegendWidth: widget.widths[0],
          stickyLegendHeight: _cellHeight,
        ),
        cellAlignments: CellAlignments.fixed(
          contentCellAlignment: Alignment.centerLeft,
          stickyColumnAlignment: Alignment.centerLeft,
          stickyRowAlignment: Alignment.centerLeft,
          stickyLegendAlignment: Alignment.centerLeft,
        ),
        legendCell: _FancyDataCell(
          text: Text(widget.columnLabels[0]),
          width: widget.widths[0],
          height: _cellHeight,
          isHeader: true,
        ),
        columnsLength: widget.columnLabels.length - 1,
        rowsLength: widget.cells.length,
        columnsTitleBuilder: (int col) {
          return _FancyDataCell(
            text: Text(widget.columnLabels[col+1]),
            height: _cellHeight,
            width: widget.widths[col + 1],
            isHeader: true,
          );
        },
        contentCellBuilder: (int col, int row) {
          return _FancyDataCell(
            text: widget.cells[row][col + 1],
            height: _cellHeight,
            width: widget.widths[col + 1],
            selected: _selectedRow == row,
          );
        },
        rowsTitleBuilder: (int row) {
          return _FancyDataCell(
            text: widget.cells[row][0],
            height: _cellHeight,
            width: widget.widths[0],
            selected: _selectedRow == row,
          );
        },
        onContentCellPressed: (int col, int row) {
          setState((){
            _selectedRow = row;
            widget.onSelectedRow(row);
          });
        },
      ),
    );
  }
}

class _FancyDataCell extends StatelessWidget {
  final Widget text;
  final double width;
  final double height;
  final bool selected;
  final bool isHeader;

  _FancyDataCell({
    required this.text,
    required this.width,
    required this.height,
    this.selected = false,
    this.isHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    var baseStyle = isHeader ? Theme.of(context).textTheme.bodyText1! : Theme.of(context).textTheme.bodyText2!;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
        color: isHeader ? Theme.of(context).backgroundColor : (selected ? Theme.of(context).indicatorColor : null),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DefaultTextStyle(
          style: baseStyle.copyWith(
            color: selected ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyText2?.color,
          ),
          child: text,
        ),
      ),
    );
  }
}

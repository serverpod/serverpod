import 'package:flutter/material.dart';

class PropertyInspector extends StatelessWidget {
  final PropertyInspectorHeader header;
  final List<Widget> properties;

  static const defaultPropertyHeight = 24.0;
  static const defaultPadding = EdgeInsets.symmetric(horizontal: 8.0);
  static const defaultDescriptionWidth = 80.0;

  PropertyInspector({
    required this.header,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        Expanded(
          child: ListView(
            children: properties,
          ),
        ),
      ],
    );
  }
}

class PropertyInspectorHeader extends StatelessWidget {
  final Widget child;

  PropertyInspectorHeader({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: PropertyInspector.defaultPadding,
      height: PropertyInspector.defaultPropertyHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText1!,
        child: Align(
          alignment: Alignment.centerLeft,
          child: child,
        ),
      ),
    );
  }
}

class PropertyInspectorOneLineProp extends StatelessWidget {
  final String name;
  final Widget value;

  PropertyInspectorOneLineProp({
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: PropertyInspector.defaultPadding,
      height: PropertyInspector.defaultPropertyHeight,
      child: Row(
        children: [
          SizedBox(
            width: PropertyInspector.defaultDescriptionWidth,
            child: Text(
              name,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: value,
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyInspectorLargeProp extends StatelessWidget {
  final String name;
  final Widget value;

  PropertyInspectorLargeProp({
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: PropertyInspector.defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: PropertyInspector.defaultPropertyHeight,
            width: PropertyInspector.defaultDescriptionWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: value,
          ),
        ],
      ),
    );
  }
}


class PropertyInspectorTextProp extends StatelessWidget {
  final String name;
  final String value;

  PropertyInspectorTextProp({
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return PropertyInspectorOneLineProp(
      name: name,
      value: Text(value),
    );
  }
}

class PropertyInspectorListProp extends StatelessWidget {
  final String name;
  final String fallbackText;
  final List<String>? list;
  final double height;

  PropertyInspectorListProp({
    required this.name,
    required this.fallbackText,
    this.list,
    this.height = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget contents;
    if (list == null || list?.length == 0) {
      contents = Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          fallbackText,
          style: Theme.of(context).textTheme.caption,
        ),
      );
    }
    else {
      contents = Container();
    }

    return PropertyInspectorLargeProp(
      name: name,
      value: Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          border: Border.all(width: 0.5, color: Theme.of(context).dividerColor),
        ),
        child: contents,
      ),
    );
  }
}


class PropertyInspectorDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 4.0,
      thickness: 0.5,
    );
  }
}


import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final double height;
  LoadingContainer({this.height = 24.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: buildContainer(),
          subtitle: buildContainer(),
        ),
        Divider(
          height: 8.0,
        )
      ],
    );
  }

  Widget buildContainer() {
    return Container(
      color: Colors.grey[200],
      height: height,
      width: 150.0,
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 15.0),
    );
  }
}

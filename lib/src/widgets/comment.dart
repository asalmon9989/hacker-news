import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../models/item_model.dart';

class Comment extends StatelessWidget {
  final int itemId, depth;
  final Map<int, Future<ItemModel>> itemMap;

  Comment({this.itemId, this.itemMap, this.depth});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: itemMap[itemId],
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (!snapshot.hasData) {
            return LoadingContainer();
          }
          final leading = SizedBox(
            width: 3.0,
            child: Container(color: Colors.grey[500]),
          );
          final children = <Widget>[
            ListTile(
              title: Html(data: snapshot.data.text),
              subtitle: snapshot.data.by == ""
                  ? Text("[Deleted]")
                  : Text(snapshot.data.by),
              contentPadding: EdgeInsets.only(
                right: 16.0,
                left: 16.0 * depth + 10.0,
              ),
              //leading: leading,
            ),
            Divider(),
            ...snapshot.data.kids.map((kidId) => Comment(
                  itemId: kidId,
                  itemMap: itemMap,
                  depth: depth + 1,
                )),
          ];

          return Column(
            children: children,
          );
        });
  }
}

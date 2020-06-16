import 'package:flutter/material.dart';
import 'package:news/src/screens/news_detail.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (BuildContext context,
          AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingContainer();
            }
            return buildTile(context, itemSnapshot.data);
          },
        );
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: <Widget>[
        ListTile(
            onTap: () {
              print("ID: ${item.id}");
              Navigator.pushNamed(
                context,
                "/news-detail",
                arguments: NewsDetailScreenArguments(itemId: item.id),
              );
            },
            title: Text(item.title),
            subtitle: Text('${item.score} points by ${item.by}'),
            trailing: item.type == 'job'
                ? Icon(Icons.announcement, size: 26)
                : Column(
                    children: [
                      Icon(Icons.comment, size: 24),
                      Text("${item.descendants}")
                    ],
                  )),
        Divider(
          height: 6.0,
        )
      ],
    );
  }
}

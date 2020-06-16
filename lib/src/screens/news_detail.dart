import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/comments_provider.dart';
import '../widgets/comment.dart';

class NewsDetailScreenArguments {
  final int itemId;
  NewsDetailScreenArguments({this.itemId});
}

class NewsDetail extends StatelessWidget {
  static const routeName = "/news-detail";
  final int itemId;
  NewsDetail({this.itemId});

  @override
  Widget build(context) {
    final bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Title"),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (BuildContext context,
          AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading");
        }
        final itemFuture = snapshot.data[itemId];

        return FutureBuilder(
          future: itemFuture,
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Text("Inner Loading...");
            }
            return buildList(itemSnapshot.data, snapshot.data);
          },
        );
      },
    );
  }

  Widget buildTitle(ItemModel item) {
    return Container(
        margin: EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0),
        alignment: Alignment.topCenter,
        child: Text(
          item.title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ));
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final List<Widget> commentsList = item.kids.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: itemMap,
        depth: 0,
      );
    }).toList();

    return ListView(
      children: <Widget>[
        buildTitle(item),
        ...commentsList,
      ],
    );
  }
}

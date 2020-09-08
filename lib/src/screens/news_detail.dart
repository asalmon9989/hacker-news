import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/persistent_webview.dart';
import '../models/item_model.dart';
import '../blocs/comments_provider.dart';
import '../widgets/comment.dart';

class NewsTabs extends StatefulWidget {
  final int itemId;
  final String url;
  static const routeName = "/news-detail";

  NewsTabs({Key key, this.itemId, this.url}) : super(key: key);
  @override
  _NewsTabsState createState() => _NewsTabsState();
}

class _NewsTabsState extends State<NewsTabs> {
  final List<Tab> tabs = <Tab>[
    Tab(text: "Article"),
    Tab(text: "Comments"),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Detail Title"),
              bottom: TabBar(
                tabs: tabs,
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                PersistentWebView(url: widget.url),
                NewsDetail(
                  itemId: widget.itemId,
                ),
              ],
            )));
  }
}

class NewsDetailScreenArguments {
  final int itemId;
  final String url;
  NewsDetailScreenArguments({this.itemId, this.url});
}

class NewsDetail extends StatefulWidget {
  final int itemId;
  NewsDetail({this.itemId});
  @override
  State<StatefulWidget> createState() => _NewsDetail(itemId: itemId);
}

class _NewsDetail extends State<NewsDetail>
    with AutomaticKeepAliveClientMixin<NewsDetail> {
  final int itemId;
  _NewsDetail({this.itemId});

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(context) {
    final bloc = CommentsProvider.of(context);
    super.build(context);
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Detail Title"),
    //   ),
    //   body: buildBody(bloc),
    // );
    return buildBody(bloc);
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
            return NewsDetailComments(
                item: itemSnapshot.data, itemMap: snapshot.data);
          },
        );
      },
    );
  }
}

class NewsDetailComments extends StatelessWidget {
  const NewsDetailComments({
    Key key,
    @required this.item,
    @required this.itemMap,
  }) : super(key: key);

  final ItemModel item;
  final Map<int, Future<ItemModel>> itemMap;

  @override
  Widget build(BuildContext context) {
    final List<Widget> commentsList = item.kids.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: itemMap,
        depth: 0,
      );
    }).toList();

    return commentsList.length > 0
        ? ListView(
            children: <Widget>[
              NewsDetailTitle(item: item),
              ...commentsList,
            ],
          )
        : Center(
            child: Text("No comments yet."),
          );
  }
}

class NewsDetailTitle extends StatelessWidget {
  const NewsDetailTitle({
    Key key,
    @required this.item,
  }) : super(key: key);

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0),
        alignment: Alignment.topCenter,
        child: Text(
          item.title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ));
  }
}

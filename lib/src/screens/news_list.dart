import 'package:flutter/material.dart';
import 'package:news/src/widgets/news_list_tile.dart';
import 'package:news/src/widgets/refresh.dart';
import '../blocs/stories_provider.dart';

class NewsList extends StatelessWidget {
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    // Get the bloc from the stories provider
    final bloc = StoriesProvider.of(context);
    bloc.fetchTopIds();
    return Scaffold(
        appBar: AppBar(
          title: Text('Top News'),
        ),
        body: buildList(bloc));
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
        stream: bloc.topIds,
        builder: (context, AsyncSnapshot<List<int>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Refresh(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  bloc.fetchItem(snapshot.data[index]);
                  return NewsListTile(itemId: snapshot.data[index]);
                },
              ),
            );
          }
        });
  }

  getFuture() {
    return Future.delayed(Duration(seconds: 2), () => 'hi');
  }
}

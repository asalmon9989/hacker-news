import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_provider.dart';
import './screens/news_detail.dart';
import './screens/news_list.dart';

// Route route(RouteSettings settings) {
//   if (settings.name == "/") {
//     return MaterialPageRoute(builder: (context) {
//       return NewsList();
//     });
//   } else {
//     int itemId = int.parse(settings.name.replaceFirst("/", ""));
//     return MaterialPageRoute(
//       builder: (context) {
//         return NewsDetail(itemId: itemId);
//       },
//     );
//   }
// }

Map<String, Widget Function(BuildContext)> routes = {
  NewsList.routeName: (BuildContext context) => NewsList(),
  NewsTabs.routeName: (BuildContext context) {
    NewsDetailScreenArguments args = ModalRoute.of(context).settings.arguments;
    final commentsBloc = CommentsProvider.of(context);
    commentsBloc.fetchItemWithComments(args.itemId);

    return NewsTabs(itemId: args.itemId, url: args.url);
  }
};

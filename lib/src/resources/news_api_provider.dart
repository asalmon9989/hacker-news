import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import '../models/item_model.dart';
import './repository.dart';

class NewsApiProvider implements Source {
  Client client = Client();
  static const String root = 'https://hacker-news.firebaseio.com/v0';

  Future<List<int>> fetchTopIds() async {
    final Response response = await client.get('${root}/topstories.json');
    final ids = json.decode(response.body);
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final Response response = await client.get('${root}/item/${id}.json');
    final ItemModel item = ItemModel.fromJson(json.decode(response.body));
    return item;
  }
}
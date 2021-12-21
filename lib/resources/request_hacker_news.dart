import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/hacker_news.dart';

class HackerNewsApi {
  http.Client client = http.Client();
  final hackerNewsUrl =
      'https://hacker-news.firebaseio.com/v0/beststories.json?print=pretty&orderBy="\$priority"&limitToFirst=50';

  Future<List<HackerNewsModel>?> requestHackerNewsModels() async {
    try {
      const headers = {"Content-Type": "application/json"};

      final http.Response response = await client.get(
        Uri.parse(hackerNewsUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final items = jsonDecode(response.body) as List<dynamic>;
        final result = await _requestAllItems(items);
        return result;
      }
    } catch (e) {
      Logger().e(
        e.toString(),
      );
    }
  }

  Future<List<HackerNewsModel>?> _requestAllItems(List items) async {
    try {
      final futures = <List<Future<http.Response>>>[];
      final rangeOfTen = <Future<http.Response>>[];
      const headers = {"Content-Type": "application/json"};

      var i = 0;
      for (final item in items) {
        final itemUrl = 'https://hacker-news.firebaseio.com/v0/item/$item.json';
        final future = client.get(
          Uri.parse(
            itemUrl,
          ),
          headers: headers,
        );
        rangeOfTen.add(future);
        final lessThanTen = items.length < 10 && items.length == i + 1;
        final div = i % 10 == 0;
        if (lessThanTen || (i != 0 && (div || items.length == i + 1))) {
          final list = [...rangeOfTen];
          futures.add(list);
          rangeOfTen.clear();
        }
        i++;
      }
      final results = [];
      for (final range in futures) {
        final responses = await Future.wait(range);
        for (final response in responses) {
          if (response.statusCode == 200) {
            results.add(
              jsonDecode(
                response.body,
              ),
            );
          }
        }
      }

      final hackerNewsModelModels = results
          .map(
            (e) => HackerNewsModel.fromMap(
              e,
            ),
          )
          .toList();
      return hackerNewsModelModels;
    } catch (e) {
      Logger().e(
        e.toString(),
      );
    }
  }
}

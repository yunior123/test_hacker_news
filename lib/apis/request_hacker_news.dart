import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/hacker_news.dart';

Future<List<HackerNewsModel>?> requestHackerNewsModels() async {
  try {
    const hackerNewsUrl =
        'https://hacker-news.firebaseio.com/v0/beststories.json?print=pretty&orderBy="\$priority"&limitToFirst=50';

    const headers = {"Content-Type": "application/json"};

    final http.Response response = await http.get(
      Uri.parse(hackerNewsUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final items = jsonDecode(response.body) as List<dynamic>;
      final futures = <List<Future<http.Response>>>[];
      final rangeOfTen = <Future<http.Response>>[];
      var i = 0;
      for (final item in items) {
        final itemUrl = 'https://hacker-news.firebaseio.com/v0/item/$item.json';
        final future = http.get(
          Uri.parse(
            itemUrl,
          ),
          headers: headers,
        );
        rangeOfTen.add(future);
        final div = i % 10 == 0;
        if (i != 0 && (div || items.length == i + 1)) {
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
    }
  } catch (e) {
    Logger().e(
      e.toString(),
    );
  }
}

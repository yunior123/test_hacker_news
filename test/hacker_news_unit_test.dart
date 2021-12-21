import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:test_hacker_news/resources/request_hacker_news.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as testing;

void main() {
  group(
    'HN',
    () {
      test(
        'test request to API',
        () async {
          final hackerNewsApi = HackerNewsApi();
          const item = 236678400;
          const itemUrl =
              'https://hacker-news.firebaseio.com/v0/item/$item.json';
          hackerNewsApi.client = testing.MockClient(
            (request) async {
              final allItemsPath = Uri.parse(hackerNewsApi.hackerNewsUrl).path;
              final itemPath = Uri.parse(itemUrl).path;
              final path = request.url.path;
              if (path == allItemsPath) {
                final testHackerNewsItems = [236678400];
                return http.Response(jsonEncode(testHackerNewsItems), 200);
              } else if (path == itemPath) {
                final testHackerNewsItem = <String, dynamic>{
                  "time": 236678400,
                  "score": 500,
                  "text": 'dghsdhdfj',
                  "title": 'test',
                };
                return http.Response(jsonEncode(testHackerNewsItem), 200);
              }
              return http.Response('Error', 400);
            },
          );

          final result = await hackerNewsApi.requestHackerNewsModels();

          expect(
            result?.length,
            1,
          );
        },
      );
    },
  );
}

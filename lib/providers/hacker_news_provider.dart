import 'package:flutter/material.dart';
import 'package:test_hacker_news/models/hacker_news.dart';

class HackerNewsProvider with ChangeNotifier {
  late final List<HackerNewsModel> hackerNews;
  var filteredHackerNews = <HackerNewsModel>[];

  set setHackerNews(List<HackerNewsModel> list) {
    hackerNews = list;
    filteredHackerNews = hackerNews;
  }

  void onFiltered(String? string) {
    if (string != null && string.isNotEmpty) {
      filteredHackerNews = hackerNews
          .where(
            (e) => e.title.toLowerCase().trim().contains(
                  string.toLowerCase().trim(),
                ),
          )
          .toList();
    } else {
      filteredHackerNews = hackerNews;
    }
    notifyListeners();
  }
}

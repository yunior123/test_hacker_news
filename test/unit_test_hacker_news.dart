import 'package:flutter_test/flutter_test.dart';
import 'package:test_hacker_news/apis/request_hacker_news.dart';

void main() {
  group(
    'HN',
    () async {
      //TODO
      final result = await requestHackerNewsModels();
      test(
        'test request to API',
        () {
          expect(
            result?.length,
            50,
          );
        },
      );
    },
  );
}

class HackerNewsModel {
  final String text;
  final String title;
  final DateTime datetime;
  final int score;
  HackerNewsModel({
    required this.text,
    required this.title,
    required this.datetime,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'title': title,
      'time': datetime.millisecondsSinceEpoch,
      'score': score,
    };
  }

  factory HackerNewsModel.fromMap(Map<String, dynamic> map) {
    return HackerNewsModel(
      text: map['text'] ?? '',
      title: map['title'] ?? '',
      datetime: DateTime.fromMillisecondsSinceEpoch(map['time']),
      score: map['score']?.toInt() ?? 0,
    );
  }
}

import 'package:flutter/material.dart';

import 'views/home_page.dart';

void main() {
  runApp(const HackerNewsApp());
}

class HackerNewsApp extends StatelessWidget {
  const HackerNewsApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hacker News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

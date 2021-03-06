import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_hacker_news/providers/hacker_news_provider.dart';

import '../resources/request_hacker_news.dart';
import '../models/hacker_news.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hackerNewsApi = HackerNewsApi();
    PreferredSize _getAppBar(BuildContext ctx) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Stack(
          children: <Widget>[
            Container(
              child: const Center(
                child: Text(
                  "Hacker News",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              color: Colors.green[800]!,
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
            ),

            Container(), // Required some widget in between to float AppBar

            Positioned(
              top: 100.0,
              left: 20.0,
              right: 20.0,
              child: AppBar(
                //shadowColor: Colors.grey[700],
                backgroundColor: Colors.white,
                leading: Icon(
                  Icons.menu,
                  color: Colors.green[800]!,
                ),
                primary: false,
                title: TextField(
                  onChanged: (value) {
                    ctx.read<HackerNewsProvider>().onFiltered(
                          value,
                        );
                  },
                  decoration: const InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.green[800]!),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.green[800]!),
                    onPressed: () {},
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    return ChangeNotifierProvider<HackerNewsProvider>(
      create: (context) => HackerNewsProvider(),
      builder: (context, _) {
        return Scaffold(
          endDrawer: const Drawer(),
          appBar: _getAppBar(context),
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: FutureBuilder<List<HackerNewsModel>?>(
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SpinKitChasingDots(
                    color: Colors.blue,
                  );
                }
                final items = snapshot.data;

                if (items != null && items.isNotEmpty) {
                  final hackerNewsProvider = Provider.of<HackerNewsProvider>(
                    context,
                    listen: false,
                  );
                  hackerNewsProvider.setHackerNews = items;
                  return _HackerNewsList();
                }
                return const Center(
                  child: Text("No data"),
                );
              },
              future: hackerNewsApi.requestHackerNewsModels(),
            ),
          ),
        );
      },
    );
  }
}

class _HackerNewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hackerNewsProvider = Provider.of<HackerNewsProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: hackerNewsProvider.filteredHackerNews.length,
        itemBuilder: (context, index) {
          final item = hackerNewsProvider.filteredHackerNews[index];
          final formatter = DateFormat.yMEd();
          final time = formatter.format(item.datetime);
          return Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(item.title),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: Text(item.text),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Score: ${item.score}',
                          style: TextStyle(
                            color: Theme.of(context).errorColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            time,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

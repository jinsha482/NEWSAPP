import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class News {
  String title;
  String description;
  String imageUrl;
  String newsUrl;

  News(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.newsUrl});
}

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<News> newsList = [];
  int pageNumber = 1;
  int pageSize = 20;
  bool isLoading = false;

  Future<void> fetchNews() async {
    final apiKey = 'b40c3f4df011486ebb43991034ca73db';

    setState(() {
      isLoading = true;
    });

    final url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey&page=$pageNumber&pageSize=$pageSize&timestamp=${DateTime.now().millisecondsSinceEpoch}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final articles = data['articles'];

      setState(() {
        newsList = List.generate(
          articles.length,
          (index) => News(
            title: articles[index]['title'],
            description: articles[index]['description'],
            imageUrl: articles[index]['urlToImage'],
            newsUrl: articles[index]['url'],
          ),
        );
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load news');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  void _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green.shade300,centerTitle: true,
        title: Text('News'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(newsList[index].imageUrl),
                  title: Text(newsList[index].title),
                  subtitle: Text(newsList[index].description),
                  onTap: () {
                    _openUrl(newsList[index].newsUrl);
                  },
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageNumber - 1,
        items: List.generate(
          5,
          (index) => BottomNavigationBarItem(
            icon: Text('${index + 1}'),
            label: 'Page ${index + 1}',
          ),
        ),
        onTap: (int index) {
          setState(() {
            pageNumber = index + 1;
          });
          fetchNews();
        },
      ),
    );
  }
}

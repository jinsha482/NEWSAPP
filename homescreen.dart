import 'package:flutter/material.dart';
import 'package:newsapp/categories.dart';
import 'package:newsapp/dashboard.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<NewsArticle> topHeadlines = [];
  List<NewsArticle> allNews = [];

  @override
  void initState() {
    super.initState();
    _getTopHeadlines();
    _getAllNews();
  }

  Future<void> _getTopHeadlines() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=b40c3f4df011486ebb43991034ca73db');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        topHeadlines = List<NewsArticle>.from(
          jsonData['articles'].map((x) => NewsArticle.fromJson(x)),
        );
      });
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  Future<void> _getAllNews() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=apple&apiKey=b40c3f4df011486ebb43991034ca73db');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        allNews = List<NewsArticle>.from(
          jsonData['articles'].map((x) => NewsArticle.fromJson(x)),
        );
      });
    } else {
      throw Exception('Failed to load all news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        centerTitle: true,
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: ((context) => NewsPage())));
                },
                icon: Icon(Icons.arrow_right_alt_rounded,color: Colors.white,),
              ),SizedBox(width: 3,),Text('Dashboard')
            ],
          )
        ],
        title: Text(
          'News App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.green.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ Categories(),SizedBox(height: 50,),
             
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Top Headlines',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topHeadlines.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(8),
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: topHeadlines[index].imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            topHeadlines[index].title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'All News',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: allNews.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: allNews[index].imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                allNews[index].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsArticle {
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  NewsArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'],
      description: json['description'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      source: json['source']['name'] ?? '',
    );
  }
}

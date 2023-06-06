import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  String _currentCategory = "general";
  List<dynamic> _newsData = [];

  @override
  void initState() {
    super.initState();
    _getNewsData();
  }

  void _getNewsData() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&category=$_currentCategory&apiKey=b40c3f4df011486ebb43991034ca73db";
    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    setState(() {
      _newsData = data["articles"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentCategory = "general";
                        _getNewsData();
                      });
                    },
                    child: Text("General"),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentCategory = "business";
                        _getNewsData();
                      });
                    },
                    child: Text("Business"),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentCategory = "sports";
                        _getNewsData();
                      });
                    },
                    child: Text("Sports"),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentCategory = "health";
                        _getNewsData();
                      });
                    },
                    child: Text("Health"),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _newsData.length,
                itemBuilder: (BuildContext context, int index) {
                  var article = _newsData[index];
                  return Container(
                    margin: EdgeInsets.all(8),
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child:
                                Image.network(article["urlToImage"])),
                        SizedBox(height: 4),
                        Text(
                         article["title"],
                          maxLines: 3,
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
          ),
        ],
      ),
    );
  }
}

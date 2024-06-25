import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyektes2/user_manage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'services/api.dart';
import 'article_extractor.dart';

class Travelnews extends StatefulWidget {
  const Travelnews({Key? key}) : super(key: key);

  @override
  _TravelnewsState createState() => _TravelnewsState();
}

class _TravelnewsState extends State<Travelnews> {
  late List<NewsArticle> _articles;
  bool _loading = true;

  final NewsApiClient newsApiClient = NewsApiClient();

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    UserManager.updateUser(null);
  }

  @override
  void initState() {
    super.initState();
    _articles = [];
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      String responseBody = await newsApiClient.fetchNews('travel');
      // print('API Response:');
      // print(responseBody);

      dynamic data = jsonDecode(responseBody);

      if (data is List) {
        List<NewsArticle> articles =
            data.map<NewsArticle>((articleJson) => NewsArticle.fromJson(articleJson)).toList();
        articles = articles.take(5).toList();

        if (mounted) {
          setState(() {
            _articles = articles;
            _loading = false;
          });
        }
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print('Failed to fetch articles: $e');
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  String _normalizeNewlines(String text) {
    return text.trim().replaceAll(RegExp(r'\n\s*\n'), '\n\n');
  }

  Future<void> fetchArticleSummaryAndShowDialog(String articleUrl) async {
    try {
      String summary = await fetchArticleSummary(articleUrl);
      summary = _normalizeNewlines(summary);

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Article Summary'),
          content: SingleChildScrollView(
            child: Text(summary, textAlign: TextAlign.justify,),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Failed to fetch article summary: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch article summary'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text('Travel News', style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
            color: Colors.black,
          ),
        ],
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _articles.isNotEmpty
              ? ListView.builder(
                  itemCount: _articles.length,
                  itemBuilder: (context, index) {
                    return buildArticleItem(_articles[index]);
                  },
                )
              : Center(child: Text('No articles found'),),
    );
  }

  Widget buildArticleItem(NewsArticle article) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          print('Card tapped: ${article.link}');
          fetchArticleSummaryAndShowDialog(article.link); 
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.publisher,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                article.preview,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Image.network(
                article.image,
                height: 300,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error);
                },
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  print('Read More button pressed: ${article.link}');
                  fetchArticleSummaryAndShowDialog(article.link);
                },
                child: Text('Read More'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsArticle {
  final int date;
  final String domain;
  final String image;
  final bool isVideo;
  final String link;
  final String preview;
  final String pubLogo;
  final String publisher;
  final String title;

  NewsArticle({
    required this.date,
    required this.domain,
    required this.image,
    required this.isVideo,
    required this.link,
    required this.preview,
    required this.pubLogo,
    required this.publisher,
    required this.title,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      date: json['date'] ?? 0,
      domain: json['domain'] ?? '',
      image: json['image'] ?? '',
      isVideo: json['isVideo'] ?? false,
      link: json['link'] ?? '',
      preview: json['preview'] ?? '',
      pubLogo: json['pubLogo'] ?? '',
      publisher: json['publisher'] ?? '',
      title: json['title'] ?? '',
    );
  }
}

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlaceDetail extends StatefulWidget {
  final String placeName;
  final String location;
  final String imageUrl;
  final String description;
  final String totalScore;
  final String humidity;
  final String temperature;

  const PlaceDetail(
      {Key? key,
      required this.placeName,
      required this.location,
      required this.imageUrl,
      required this.description,
      required this.totalScore,
      required this.humidity,
      required this.temperature})
      : super(key: key);

  @override
  State<PlaceDetail> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  bool isFavorite = false;
  String? favoriteKey;

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    String userName = user?.email?.split('@').first ?? 'User';
    _checkFavoriteStatus(userName);
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String userName = user?.email?.split('@').first ?? 'User';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 100,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.placeName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 0,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: 10,
              right: 0,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                  if (isFavorite) {
                    _postKeFirebase(userName);
                  } else {
                    _deleteFromFirebase();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkFavoriteStatus(String userName) async {
    final url = Uri.https(
      'fluttercrudkevin-default-rtdb.asia-southeast1.firebasedatabase.app',
      'favorite.json',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      data.forEach((key, value) {
        if (value['user'] == userName && value['placeName'] == widget.placeName) {
          if (mounted) {
            setState(() {
              isFavorite = true;
              favoriteKey = key;
            });
          }
        }
      });
    } else {
      debugPrint('Get failed with status: ${response.statusCode}');
    }
  }

  void _postKeFirebase(String userName) async {
    final url = Uri.https(
      'fluttercrudkevin-default-rtdb.asia-southeast1.firebasedatabase.app',
      'favorite.json',
    );

    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode(
          {
            'user': userName,
            'placeName': widget.placeName,
            'location': widget.location,
            'imageUrl': widget.imageUrl,
            'description': widget.description,
            'totalScore': widget.totalScore,
            'humidity': widget.humidity,
            'temperature': widget.temperature,
          },
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('Post successful: ${response.body}');
      final responseBody = json.decode(response.body);
      if (mounted) {
        setState(() {
          favoriteKey = responseBody['name'];
        });
      }
    } else {
      debugPrint('Post failed with status: ${response.statusCode}');
      return;
    }

    final response2 = await http.get(url);
    if (response2.statusCode == 200) {
      debugPrint('Get successful: ${response2.body}');
    } else {
      debugPrint('Get failed with status: ${response2.statusCode}');
    }
  }

  void _deleteFromFirebase() async {
    if (favoriteKey == null) return;

    final url = Uri.https(
      'fluttercrudkevin-default-rtdb.asia-southeast1.firebasedatabase.app',
      'favorite/$favoriteKey.json',
    );

    final response = await http.delete(url);
    if (response.statusCode == 200) {
      debugPrint('Delete successful');
      if (mounted) {
        setState(() {
          favoriteKey = null;
        });
      }
    } else {
      debugPrint('Delete failed with status: ${response.statusCode}');
    }
  }
}

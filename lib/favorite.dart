import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyektes2/place_card_favorite.dart';
import 'package:flutter_proyektes2/user_manage.dart';
import 'package:http/http.dart' as http;

import 'place_detail.dart';  
import 'place_card2.dart';  

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<Map<String, dynamic>> favoritePlaces = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    String userName = user?.email?.split('@').first ?? 'User';
    _fetchFavoritePlaces(userName);
  }

  Future<void> _fetchFavoritePlaces(String userName) async {
    final url = Uri.https(
      'fluttercrudkevin-default-rtdb.asia-southeast1.firebasedatabase.app',
      'favorite.json',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      List<Map<String, dynamic>> places = [];
      data.forEach((key, value) {
        if (value['user'] == userName) {
          places.add(value);
        }
      });
      setState(() {
        favoritePlaces = places;
      });
    } else {
      debugPrint('Get failed with status: ${response.statusCode}');
    }
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    UserManager.updateUser(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Favorite', style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
            color: Colors.black,
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
         iconTheme: IconThemeData(
    color: Colors.black, 
  ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: favoritePlaces.length,
        itemBuilder: (BuildContext context, int index) {
          final place = favoritePlaces[index];
          return PlaceCardDetail(
            placeName: place['placeName'] ?? 'Unknown Name',
            location: place['location'] ?? 'Unknown Location',
            imageUrl: place['imageUrl'] ?? 'https://via.placeholder.com/150',
            totalScore: place['totalScore'] ?? '0',
            humidity: place['humidity'] ?? '0',
            temperature: place['temperature'] ?? '0',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaceDetail(
                    placeName: place['placeName'] ?? 'Unknown Name',
                    location: place['location'] ?? 'Unknown Location',
                    imageUrl: place['imageUrl'] ?? 'https://via.placeholder.com/150',
                    description: place['description'] ?? 'N/A',
                    totalScore: place['totalScore'] ?? '0',
                    humidity: place['humidity'] ?? '0',
                    temperature: place['temperature'] ?? '0',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

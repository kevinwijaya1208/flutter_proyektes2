import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyektes2/place_card2.dart';
import 'package:flutter_proyektes2/place_detail.dart';
import 'package:flutter_proyektes2/user_manage.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, String>> places = [];
  List<Map<String, String>> filteredPlaces = [];
  bool isLoading = true;
  String errorMessage = '';
  String searchText = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://nomadlist-digital-nomad-travel-api.p.rapidapi.com/cities?orderBy=total_score&order=desc&page=1&limit=15');

    try {
      final response = await http.get(
        url,
        headers: {
          'X-Rapidapi-Key':
              '095f18298amsh70bcfbf81d92a31p141569jsnbb473630481b',
          'X-Rapidapi-Host':
              'nomadlist-digital-nomad-travel-api.p.rapidapi.com',
          'Host': 'nomadlist-digital-nomad-travel-api.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['cities'];
        if (data.isNotEmpty) {
          setState(() {
            places = data.map((item) {
              String totalScore = item['total_score'].toString();
              String humidity = item['humidity'].toString();
              String temperature = item['temperatureC'].toString();

              return {
                'name': item['name'] as String,
                'country': item['country'] as String,
                'image': item['image'] as String,
                'totalScore': totalScore,
                'humidity': humidity,
                'temperature': temperature,
                'descriptionFromReview': item['descriptionFromReview'] as String
              };
            }).toList();
            filteredPlaces = List.from(places); 
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
    }
  }

  void filterPlaces(String query) {
    setState(() {
      searchText = query;
      if (query.isEmpty) {
        filteredPlaces = List.from(places); 
      } else {
        filteredPlaces = places
            .where((place) =>
                place['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });

    // Scroll to the first filtered result
    if (filteredPlaces.isNotEmpty) {
      final index = places.indexOf(filteredPlaces.first);
      _scrollController.animateTo(index * 200.0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = UserManager.getUser();
    String userName = user?.email?.split('@').first ?? 'User';

    void signUserOut() {
    FirebaseAuth.instance.signOut();
    UserManager.updateUser(null);
  }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
            color: Colors.black,
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Travel App',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Hello $userName',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.flight_takeoff_rounded,
              color: Colors.black,
              size: 30,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search for places',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: filterPlaces,
              ),
              SizedBox(height: 10.0),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 500),
                  viewportFraction: 0.8,
                ),
                items: filteredPlaces
                    .map((item) => Container(
                          child: Center(
                            child: Image.network(item['image']!,
                                fit: BoxFit.fill),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 10.0),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(child: Text(errorMessage))
                      : ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredPlaces.length,
                          itemBuilder: (BuildContext context, int index) {
                            final place = filteredPlaces[index];
                            return PlaceCard2(
                              placeName: place['name'] ?? 'Unknown Name',
                              location: place['country'] ?? 'Unknown Country',
                              imageUrl: place['image'] ??'https://via.placeholder.com/150',
                              totalScore: place['totalScore'] ?? '0',
                              humidity: place['humidity'] ?? '0',
                              temperature: place['temperature'] ?? '0',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlaceDetail(
                                      placeName: place['name'] ??
                                          'Unknown Name',
                                      location: place['country'] ??
                                          'Unknown Country',
                                      imageUrl: place['image'] ??
                                          'https://via.placeholder.com/150',
                                      description:
                                          place['descriptionFromReview'] ??
                                              'N/A',
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
            ],
          ),
        ),
      ),
    );
  }
}

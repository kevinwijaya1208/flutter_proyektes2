import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyektes2/exchange.dart';
import 'package:flutter_proyektes2/favorite.dart';
import 'package:flutter_proyektes2/home.dart';
import 'package:flutter_proyektes2/place_detail.dart';
import 'package:flutter_proyektes2/travelnews.dart';
import 'package:flutter_proyektes2/user_manage.dart';
import 'package:flutter_proyektes2/weather.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? theUser;
  late StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        theUser = user;
         UserManager.updateUser(user);
      });
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel(); 
    super.dispose();
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    UserManager.updateUser(null);
  }

  int indexNow = 0; 

  final List<Widget> _pages = [
    Home(),
    Travelnews(),
    WeatherPage(),
    Exchange(),
    Favorite(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[indexNow], 
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: "Travel News",
            icon: Icon(Icons.newspaper_outlined),
          ),
          BottomNavigationBarItem(
            label: "Weather",
            icon: Icon(Icons.sunny),
          ),
          BottomNavigationBarItem(
            label: "Exchange",
            icon: Icon(Icons.currency_exchange_outlined),
          ),
          BottomNavigationBarItem(
            label: "Favorite",
            icon: Icon(Icons.favorite_outline),
          )
        ],
        currentIndex: indexNow,
        selectedItemColor: Colors.blue,
        onTap: (int index) {
          setState(() {
            indexNow = index;
          });
        },
      ),
    );
  }
}

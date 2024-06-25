import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyektes2/exchange.dart';
import 'package:flutter_proyektes2/favorite.dart';
import 'package:flutter_proyektes2/home.dart';
import 'package:flutter_proyektes2/home_page.dart';
import 'package:flutter_proyektes2/travelnews.dart';
import 'package:flutter_proyektes2/weather.dart';
import 'auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/signin',
      routes: {
        '/': (context) => HomePage(),
        '/signin': (context) => AuthPage(),
        '/home': (context) => Home(),
        '/travelnews': (context) => const Travelnews(),
        '/weather': (context) => const WeatherPage(),
        '/exchange': (context) => const Exchange(),
        '/favorite': (context) => const Favorite(),
      },
      theme: ThemeData(brightness: Brightness.light),
    );
  }
}

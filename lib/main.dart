import 'package:flutter/material.dart';
import 'package:login_page/fundraiser_screen.dart';
import 'package:login_page/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data == true) {
            return FundraiserScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
      routes: {
        '/home': (context) => FundraiserScreen(),
      },
    );
  }
}

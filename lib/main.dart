import 'package:flutter/material.dart';
import 'package:jumping_screen/home/home.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'dsfhkdshf',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreenPage(),
    );
  }
}

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Center(
          child: Lottie.asset(
              'assets/youtube.json'), // Ensure this path matches your asset location
        ),
      ),
    );
  }
}


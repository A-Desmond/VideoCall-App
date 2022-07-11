import 'package:flutter/material.dart';
import 'package:video_call/View/home.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VIDEO CALL Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  HomePAGE(title: 'Video call'),
    );
  }
}

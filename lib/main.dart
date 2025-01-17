import 'package:flutter/material.dart';
import 'package:edu_app/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Educational app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(137, 120, 244, 1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: "OpenSans",
      ),
      home: const HomePage(),
    );
  }
}

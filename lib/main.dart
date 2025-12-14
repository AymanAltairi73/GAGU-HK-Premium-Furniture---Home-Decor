import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const GaguApp());
}

class GaguApp extends StatelessWidget {
  const GaguApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GAGU HK',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF141E30)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(UniversityApp());
}

class UniversityApp extends StatelessWidget {
  const UniversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'project 2',
      home: LoginPage(),
    );
  }
}
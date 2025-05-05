import 'package:flutter/material.dart';
import 'music_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App', // میتونید عنوان رو تغییر بدید
      theme: ThemeData(
        primarySwatch: Colors.blue, // میتونید تم رو تغییر بدید
      ),
      // اینجا MusicPage رو به عنوان صفحه اصلی تنظیم می‌کنیم
      home: const MusicPage(), // <--- اینجا تغییر اصلی هست
    );
  }
}
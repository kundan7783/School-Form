import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_form/providers/api_provider.dart';
import 'package:school_form/screens/subject_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ApiProvider(),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Admission',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  SubjectListScreen(),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/add_new.dart';
import 'pages/content.dart';
import 'pages/signIn_page.dart';
import 'pages/signUp_page.dart';

Future main() async {
  String __version__ = '2.0.0';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const SignIn(),
      routes: {
        '/content': (context) => const ToDoList(),
        '/add_new': (context) => const AddNew(),
        '/signup': (context) => const SignUp(),
      },
    );
  }
}

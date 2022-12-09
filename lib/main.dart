import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/add_new.dart';
import 'pages/content.dart';

Future main() async {
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
      home: const ToDoList(),
      routes: {
        '/add_new': (context) => const AddNew(),
      },
    );
  }
}

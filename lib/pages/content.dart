import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/item.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  void dispose() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print(user.email);
      FirebaseAuth.instance.signOut();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('To Do List'),
            Button(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_new');
                },
                icon: Icons.add,
                color: const Color(0xFF424242)),
          ],
        ),
      ),
      body: StreamBuilder<List<Item>>(
        stream: readTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return snapshot.data![index];
              },
            );
          } else {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Center(
              child: Text('Add your first task'),
            );
          }
        },
      ),
    );
  }

  Stream<List<Item>> readTasks() {
    final user = FirebaseAuth.instance.currentUser;
    final docUser =
        FirebaseFirestore.instance.collection('tasks').doc(user?.uid);
    if (user == null) {
      return const Stream.empty();
    }
    return docUser.snapshots().map((snapshot) {
      final tasks = snapshot.data()!['tasks'] as List;
      return tasks.map((task) {
        final taskMap = task as Map;
        return Item(
          task: taskMap['task'],
          date: taskMap['date'],
        );
      }).toList();
    });
  }
}

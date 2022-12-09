import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'item.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
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
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Stream<List<Item>> readTasks() {
    final docUser = FirebaseFirestore.instance.collection('tasks').doc('tasks');
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

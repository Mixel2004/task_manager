import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNew extends StatefulWidget {
  const AddNew({Key? key}) : super(key: key);

  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  final TextEditingController? text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter a new task',
                ),
                style: const TextStyle(fontSize: 20),
                controller: text,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final task = text!.text;
                addTask(task: task);
                Navigator.pop(context);
              },
              child: const Text('Add', style: TextStyle(fontSize: 40)),
            ),
          ],
        ),
      ),
    );
  }

  Future addTask({required String task}) async {
    final user = FirebaseAuth.instance.currentUser;
    final docUser =
        FirebaseFirestore.instance.collection('tasks').doc(user?.uid);
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd  kk:mm');
    String formatted = formatter.format(now);
    var taskMap = {
      'task': task,
      'date': formatted,
    };
    final doc = await docUser.get();
    if (doc.exists) {
      docUser.update({
        'tasks': FieldValue.arrayUnion([taskMap])
      });
    } else {
      docUser.set({
        'tasks': FieldValue.arrayUnion([taskMap])
      });
    }
  }
}

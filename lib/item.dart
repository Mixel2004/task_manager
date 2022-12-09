import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'components/button.dart';

class Item extends StatelessWidget {
  final String task;
  final String date;
  Item({super.key, required this.task, required this.date});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, left: 10.0, right: 8.0, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
          Button(
            onPressed: () {
              deleteTask(task: task);
            },
          ),
        ],
      ),
    );
  }

  void deleteTask({required String task}) {
    final docUser = FirebaseFirestore.instance.collection('tasks').doc('tasks');
    docUser.update({
      'tasks': FieldValue.arrayRemove([
        {
          'task': task,
          'date': date,
        }
      ])
    });

    docUser.update({
      'tasks': FieldValue.arrayRemove([task])
    });
  }
}

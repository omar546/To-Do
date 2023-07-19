import 'package:flutter/material.dart';
import '../shared/components/components.dart';
import '../shared/components/constants.dart';

class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index]),
        separatorBuilder: (context, index) => const SizedBox(height: 1,),
        itemCount: tasks.length);
  }
}

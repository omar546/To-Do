import 'package:flutter/material.dart';
import 'package:todo_app/shared/styles/styles.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'New Tasks',
        style: TextStyle(
          fontSize: 25,
          fontFamily: 'Thunder',
          color: Styles.greyColor
        ),
      ),
    );
  }
}

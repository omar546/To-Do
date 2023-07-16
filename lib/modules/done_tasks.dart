import 'package:flutter/material.dart';
import 'package:todo_app/shared/styles/styles.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Done Tasks',
        style: TextStyle(
            fontSize: 25,
            fontFamily: 'Thunder',
            color: Styles.greyColor
        ),
      ),
    );
  }
}

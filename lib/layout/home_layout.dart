import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks.dart';
import 'package:todo_app/modules/done_tasks.dart';
import 'package:todo_app/shared/styles/styles.dart';
import '../modules/new_tasks.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);


  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screens =
  [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
@override
  void initState() {
    super.initState();
    CreateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Styles.blackColor,
      appBar: AppBar(
        backgroundColor: Styles.blackColor,
        title: Center(
          child: Text('ToDo',
          style: TextStyle(
            color: Styles.greyColor,
            fontFamily: 'Thunder-semi',
            fontSize: 32,
          ),
          ),
        ),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.gumColor,
        onPressed: (){},
        child: const Icon(
          Icons.add,
          color: Styles.blackColor,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Styles.gumColor,
        unselectedItemColor: Styles.greyColor,
        backgroundColor: Styles.blackColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index){
          setState(()
          {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded),
          label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.task_alt_rounded),
          label: 'Done'),
          BottomNavigationBarItem(icon: Icon(Icons.archive_outlined),
          label: "Archived"),
        ],
      ),
    );
  }

  void CreateDatabase() async
  {
    var database= await openDatabase('todo.db',
    version: 1,
    onCreate: (database,version)
    {
      print('database created');
       database.execute(
           'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, data TEXT, time TEXT, status TEXT)'
       ).then((value)
       {
         print('table created');
       }
       ).catchError((error)
      {
        print('error creating table ${error.toStringg()}');
      });
    },
    onOpen:(database)
    {
      print('database opened');
    }
    );
  }

  void InsertToDatabse()
  {

  }

}

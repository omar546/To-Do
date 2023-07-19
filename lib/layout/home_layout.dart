import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks.dart';
import 'package:todo_app/modules/done_tasks.dart';
import 'package:todo_app/shared/styles/styles.dart';
import '../modules/new_tasks.dart';
import '../shared/components/components.dart';
import '../shared/components/constants.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isButtonSheetShown = false;
  IconData fabIcon = Icons.edit;
  int currentIndex = 0;

  // TextEditingController instances for each input field
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  // final TextEditingController _statusController = TextEditingController();

  late Database database;
  List<Widget> screens = [
     NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];
  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Styles.blackColor,
      appBar: AppBar(
        elevation: 2,
        automaticallyImplyLeading: false,
        backgroundColor: Styles.blackColor,
        title: const Center(
          child: Text(
            'To Do',
            style: TextStyle(
              color: Styles.greyColor,
              fontFamily: 'Thunder-semi',
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: ConditionalBuilder(
        condition: tasks.length > 0,
        builder: (context)=> screens[currentIndex],
        fallback: (context)=> Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.gumColor,
        onPressed: () {
          if (isButtonSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDatabase(
                title: _titleController.text,
                time: _timeController.text,
                date: _dateController.text,
              ).then((value) {
                getDataFromDatabase(database).then((value)
                {
                  Navigator.pop(context);
                  setState(() {
                    isButtonSheetShown = false;
                      fabIcon = Icons.edit;
                    tasks =value;
                  });
                });
              });
            }
          } else {
            scaffoldKey.currentState
                ?.showBottomSheet(
                  (context) => Container(
                    color: Styles.lightBlackColor,
                    child: Container(
                      color: Styles.lightBlackColor,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 35.0, width: double.infinity),
                            buildTextField(
                              context: context,
                              labelText: 'Title',
                              controller: _titleController,
                              prefix: Icons.title_rounded,
                              validate: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a title';
                                }
                                return null; // Return null to indicate the input is valid
                              },
                              type: TextInputType.text,
                            ),
                            const SizedBox(height: 10.0, width: double.infinity),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(iconSize: 30,
                                    icon: Icon(Icons.date_range_rounded,color: Styles.gumColor,),
                                  onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2025),
                                  ).then((date) {
                                    _dateController.text =
                                        DateFormat.yMMMd()
                                            .format(date!);
                                  }); },),
                                Text('Date',style: TextStyle(color: Styles.greyColor,fontFamily: "Thunder",fontSize: 20),),
                                IconButton(
                                  iconSize: 30,
                                    icon: Icon(Icons.access_time_rounded,color: Styles.gumColor,size: 30,),
                                    onPressed: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then(
                                        (time) {
                                          _timeController.text =
                                              time!.format(context);
                                        },
                                      ).catchError(
                                        (error) {
                                          _timeController.text = "";
                                        },
                                      );
                                    }),
                                Text('Time',style: TextStyle(color: Styles.greyColor,fontFamily: "Thunder",fontSize: 20),),



                                // buildTextField(
                                //     context: context,
                                //     labelText: 'Status',
                                //     controller: _statusController,
                                //     prefix: Icons.task_outlined,
                                //     onTap: null,
                                //     validate: (value) {
                                //       if (value == null || value.isEmpty) {
                                //         value = "new";
                                //       }
                                //       return null; // Return null to indicate the input is valid
                                //     },
                                //     type: TextInputType.text),
                              ],
                            ),
                            // const SizedBox(height: 80.0, width: double.infinity),
                            const SizedBox(height: 35.0, width: double.infinity),

                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .closed
                .then((value) {
              isButtonSheetShown = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            });
            isButtonSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(
          fabIcon,
          color: Styles.blackColor,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Styles.gumColor,
        unselectedItemColor: Styles.greyColor,
        backgroundColor: Styles.blackColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_rounded), label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: "Archived"),
        ],
      ),
    );
  }

  void createDatabase() async {
    database = await openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
      print('database created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('error creating table ${error.toStringg()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database).then((value)
      {
        setState(() {
          tasks =value;
        });
      });
      print('database opened');
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async
  {
    return  await database.rawQuery('SELECT * FROM tasks');
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      // Example of inserting data into the 'tasks' table.
      await txn.rawInsert(
          'INSERT INTO tasks(title, date, time,status) VALUES("$title","$date","$time","new")');
    }).then((_) {
      // The transaction was successful.
      print('$_ inserted successfully.');
    }).catchError((error) {
      // Handle the error if the transaction fails.
      print('Error inserting data: $error');
    });
  }
}

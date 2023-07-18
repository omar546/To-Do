import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks.dart';
import 'package:todo_app/modules/done_tasks.dart';
import 'package:todo_app/shared/styles/styles.dart';
import '../modules/new_tasks.dart';
import '../shared/components/components.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var ScaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isButtonSheetShown = false;
  IconData fabIcon = Icons.edit;
  int currentIndex = 0;
  List<Map> tasks=[];
  // TextEditingController instances for each input field
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  // final TextEditingController _statusController = TextEditingController();

  late Database database;
  List<Widget> screens = [
    const NewTasksScreen(),
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
      key: ScaffoldKey,
      backgroundColor: Styles.blackColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Styles.blackColor,
        title: const Center(
          child: Text(
            'ToDo',
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
        onPressed: () {
          if (isButtonSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDatabase(
                title: _titleController.text,
                time: _timeController.text,
                date: _dateController.text,
              ).then((value) {
                Navigator.pop(context);
                isButtonSheetShown = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              });
            }
          } else {
            ScaffoldKey.currentState
                ?.showBottomSheet(
                  (context) => FractionallySizedBox(
                    alignment: Alignment.center,
                    heightFactor: 0.45,
                    child: Container(
                      color: Styles.lightBlackColor,
                      child: SingleChildScrollView(
                        child: Container(
                          color: Styles.lightBlackColor,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 35.0, width: double.infinity),
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
                                SizedBox(height: 35.0, width: double.infinity),
                                Wrap(
                                  spacing: 16.0,
                                  runSpacing: 16.0,
                                  children: [
                                    buildTextField(
                                        widthRit: 0.4,
                                        context: context,
                                        labelText: 'Date',
                                        controller: _dateController,
                                        prefix: Icons.date_range_rounded,
                                        type: TextInputType.datetime,
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2025),
                                          ).then((date) {
                                            _dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(date!);
                                          });
                                        }),
                                    buildTextField(
                                        widthRit: 0.4,
                                        context: context,
                                        labelText: 'Time',
                                        controller: _timeController,
                                        prefix: Icons.access_time_rounded,
                                        type: TextInputType.datetime,
                                        onTap: () {
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
                                    SizedBox(
                                        height: 0,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4),
                                    SizedBox(
                                        height: 0,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4),

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
                                SizedBox(height: 60.0, width: double.infinity),
                              ],
                            ),
                          ),
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
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded), label: 'Tasks'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_rounded), label: 'Done'),
          const BottomNavigationBarItem(
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
        tasks =value;
        print(tasks);
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
          'INSERT INTO tasks VALUES("$currentIndex","$title","$date","$time","new")');
    }).then((_) {
      // The transaction was successful.
      print('$_ inserted successfully.');
    }).catchError((error) {
      // Handle the error if the transaction fails.
      print('Error inserting data: $error');
    });
  }
}

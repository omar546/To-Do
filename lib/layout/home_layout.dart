import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import '../shared/styles/styles.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

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
              condition:
                  state is AppGetDatabaseLoadingState, //cubit.tasks.isEmpty,
              builder: ((context) =>
                  const Center(child: CircularProgressIndicator())),
              fallback: ((context) => cubit.screens[cubit.currentIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Styles.gumColor,
              child: Icon(
                cubit.fabIcon,
                color: Styles.blackColor,
              ),
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertIntoDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    )
                        .then(
                      (value) {
                        titleController.text = '';
                        dateController.text = '';
                        timeController.text = '';
                      },
                    ).catchError(
                      (error) {},
                    );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Styles.lightBlackColor,
                          child: Container(
                            color: Styles.lightBlackColor,
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                      height: 35.0, width: double.infinity),
                                  buildTextField(
                                    context: context,
                                    labelText: 'Title',
                                    controller: titleController,
                                    prefix: Icons.title_rounded,
                                    validate: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please type a title';
                                      }
                                      return null; // Return null to indicate the input is valid
                                    },
                                    type: TextInputType.text,
                                  ),
                                  const SizedBox(
                                      height: 15.0, width: double.infinity),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          showDatePicker(
                                            builder: (context, child) {
                                              return Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  colorScheme:
                                                      const ColorScheme.dark(
                                                    primary: Styles.gumColor,
                                                    onPrimary:
                                                        Styles.lightBlackColor,
                                                    onSurface: Styles.greyColor,
                                                  ),
                                                  dialogBackgroundColor:
                                                      Styles.blackColor,
                                                  textButtonTheme:
                                                      TextButtonThemeData(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Styles.gumColor,
                                                    ),
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2050),
                                          ).then((date) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(date!);
                                          });
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.date_range_rounded,
                                              color: Styles.gumColor,
                                              size: 25,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Date',
                                              style: TextStyle(
                                                  color: Styles.greyColor,
                                                  fontFamily: "Thunder",
                                                  fontSize: 16),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          showTimePicker(
                                                  builder: (context, child) {
                                                    return Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        colorScheme:
                                                            const ColorScheme
                                                                .dark(
                                                          primary: Styles
                                                              .gumColor, // <-- SEE HERE
                                                          onPrimary: Styles
                                                              .blackColor, // <-- SEE HERE
                                                          onSurface: Styles
                                                              .greyColor, // <-- SEE HERE
                                                        ),
                                                        textButtonTheme:
                                                            TextButtonThemeData(
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor: Styles
                                                                .gumColor, // button text color
                                                          ),
                                                        ),
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then(
                                            (time) {
                                              timeController.text =
                                                  time!.format(context);
                                            },
                                          ).catchError(
                                            (error) {
                                              timeController.text = "";
                                            },
                                          );
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.access_time_rounded,
                                              color: Styles.gumColor,
                                              size: 25,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Time',
                                              style: TextStyle(
                                                  color: Styles.greyColor,
                                                  fontFamily: "Thunder",
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(height: 80.0, width: double.infinity),
                                  const SizedBox(
                                      height: 35.0, width: double.infinity),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then(
                    (value) {
                      cubit.changeAddTaskIcon(false, Icons.edit);

                    },
                  ).catchError(
                    (error) {},
                  );

                  cubit.changeAddTaskIcon(true, Icons.add);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Styles.gumColor,
              unselectedItemColor: Styles.greyColor,
              backgroundColor: Styles.blackColor,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) => cubit.changeBottomNavBarState(index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_list),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done_outline_rounded),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
//tasks

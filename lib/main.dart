import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'layout/home_layout.dart';
import 'shared/bloc_observer.dart';
import 'shared/cubit/cubit.dart';

void main()
{
  Bloc.observer = MyBlocObserver();
  runApp(
    BlocProvider(
      create: (context) => AppCubit(), // Provide your AppCubit here
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget
{
  const MyApp({super.key});
  // constructor
  // build
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
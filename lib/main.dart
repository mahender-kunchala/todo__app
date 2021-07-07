import 'package:flutter/material.dart';
import 'package:todo_list/todo_list.dart';
import 'package:todo_list/loading.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                body: Center(
              child: Text(snapshot.error.toString()),
            ));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return (Loading());
          }
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.grey[900],
                primarySwatch: Colors.pink,
              ),
              home: TodoList());
        });
  }
}

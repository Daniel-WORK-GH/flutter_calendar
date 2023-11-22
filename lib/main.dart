import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Calendar example")),
        ),
        body: Calendar(
          ondayclick: (p0) => print("on click"),
        ),
      ),
    );
  }
}

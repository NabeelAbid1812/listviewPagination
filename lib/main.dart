import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginatet_list/view/home.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return Sizer(
      builder: (context, orientation, deviceType) {
    return GetMaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeClass(),
    );
      }
     );
  }
}


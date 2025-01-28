import 'package:flutter/material.dart';
import 'package:network_database_app/screens/users_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Users and Posts',
      home: UsersScreen(), // This should now be recognized
    );
  }
}

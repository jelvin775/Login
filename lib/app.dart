import 'package:flutter/material.dart';
import 'package:login_app/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: LoginScreen(),
    );
  }
}

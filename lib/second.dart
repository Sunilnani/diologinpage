import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  SecondPage({this.user});

  final String user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(user),
      ),
    );
  }
}

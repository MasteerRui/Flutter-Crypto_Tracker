import 'package:cryptoss/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:after_layout/after_layout.dart';
import 'dart:async';

class FirstTimeCheckPage extends StatefulWidget {
  const FirstTimeCheckPage({Key? key}) : super(key: key);

  @override
  State<FirstTimeCheckPage> createState() => _FirstTimeCheckPageState();
}

class _FirstTimeCheckPageState extends State<FirstTimeCheckPage>
    with AfterLayoutMixin<FirstTimeCheckPage> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen) {
      Timer(const Duration(milliseconds: 2000), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AuthWrapper()));
      });
    } else {
      await prefs.setBool('seen', true);
      Timer(const Duration(milliseconds: 2000), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AuthWrapper()));
      });
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF181616),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

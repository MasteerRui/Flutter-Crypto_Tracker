import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cryptoss/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../provider/firebase_auth_methods.dart';
import 'loginpage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;

  void signUpUser() async {
    context.read<FirebaseAuthMethods>().signUpWithEmail(
          username: usernameController.text,
          email: emailController.text.trim(),
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181616),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFF181616),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/animation_640_lcvsh5jp.gif",
                height: 40.h,
              ),
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                width: 80.w,
                child: TextField(
                  controller: usernameController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 8.sp),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.21),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    // icon: Icon(Icons.mail),
                    suffixIcon: usernameController.text.isEmpty
                        ? const Text('')
                        : GestureDetector(
                            onTap: () {
                              usernameController.clear();
                            },
                            child: const Icon(Icons.close)),
                    hintText: 'type your username',
                    hintStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 8.sp),
                    labelText: 'Username',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 8.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 0.8.h,
              ),
              SizedBox(
                width: 80.w,
                child: TextField(
                  controller: emailController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 8.sp),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.21),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    // icon: Icon(Icons.mail),
                    suffixIcon: emailController.text.isEmpty
                        ? const Text('')
                        : GestureDetector(
                            onTap: () {
                              emailController.clear();
                            },
                            child: const Icon(Icons.close)),
                    hintText: 'exemplo@mail.com',
                    hintStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 8.sp),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 8.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 0.8.h,
              ),
              SizedBox(
                width: 80.w,
                child: TextField(
                  obscureText: isVisible,
                  controller: passwordController,
                  onChanged: (value) {},
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 8.sp),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.21),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    // icon: Icon(Icons.mail),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          isVisible = !isVisible;
                          setState(() {});
                        },
                        child: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.orangeAccent,
                        )),
                    hintText: 'type your password',
                    hintStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 8.sp),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 8.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              GestureDetector(
                onTap: signUpUser,
                child: SizedBox(
                  width: 80.w,
                  height: 5.5.h,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(18)),
                    child: const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[800],
                    )),
                    Text(
                      'Or continue with',
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.w400),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[800],
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (Platform.isIOS)
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey[200]),
                          child: Image.asset(
                            'assets/apple.png',
                            height: 35,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            context
                                .read<FirebaseAuthMethods>()
                                .signInWithGoogle(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey[200]),
                            child: Image.asset(
                              'assets/google.png',
                              height: 35,
                            ),
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: 7.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                            maintainState: false,
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Sign in now',
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cryptoss/pages/auth_pages/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';

import '../../provider/firebase_auth_methods.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;

  void loginUser() async {
    context.read<FirebaseAuthMethods>().loginWithEmail(
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
                        child: Icon(isVisible
                            ? Icons.visibility
                            : Icons.visibility_off)),
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
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //Navigator.push(
                        //  context,
                        //  MaterialPageRoute(
                        //      builder: (context) =>
                        //          const ForgotPassWordPage()),
                        //);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              GestureDetector(
                onTap: loginUser,
                child: SizedBox(
                  width: 80.w,
                  height: 5.5.h,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(18)),
                    child: const Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text(
                      'Register now',
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

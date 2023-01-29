import 'package:another_flushbar/flushbar.dart';
import 'package:cryptoss/pages/auth_pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      Flushbar(
        messageText: Text(
          e.toString().replaceFirst(new RegExp(r'\[.*\]'), ""),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        flushbarStyle: FlushbarStyle.FLOATING,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(20),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        reverseAnimationCurve: Curves.decelerate,
        isDismissible: false,
        maxWidth: 85.w,
        icon: const Icon(
          Icons.error,
          size: 25.0,
          color: Colors.orangeAccent,
        ),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Reset Password'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                    maintainState: false,
                    builder: (context) => const LoginPage()),
              );
            },
            icon: Icon(Icons.arrow_back)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/animation_640_ldhft841.gif",
                height: 33.h,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Text(
                'Enter your email and we will send a password reset link',
                style: TextStyle(
                    color: Theme.of(context).iconTheme.color, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 23, bottom: 20),
              child: SizedBox(
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
            ),
            GestureDetector(
              onTap: () {
                passwordReset();
              },
              child: SizedBox(
                width: 80.w,
                height: 5.5.h,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(18)),
                  child: const Center(
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

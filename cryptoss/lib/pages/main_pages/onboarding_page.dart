import 'package:cryptoss/main.dart';
import 'package:cryptoss/pages/intro_pages/intro_page_2.dart';
import 'package:cryptoss/pages/intro_pages/intro_page_3.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../intro_pages/intro_page_1.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  PageController _controller = PageController();

  bool onLastPage = false;

  void setbool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (() {
                    _controller.jumpToPage(2);
                  }),
                  child: Text(
                    'Skip',
                    style: TextStyle(color: Theme.of(context).iconTheme.color),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    dotColor: Colors.orangeAccent[100]!,
                    activeDotColor: Colors.orangeAccent,
                  ),
                ),
                onLastPage
                    ? GestureDetector(
                        onTap: (() async {
                          setbool();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthWrapper()),
                          );
                        }),
                        child: Text(
                          'Done',
                          style: TextStyle(color: Colors.orangeAccent),
                        ),
                      )
                    : GestureDetector(
                        onTap: (() {
                          _controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        }),
                        child: Text(
                          'Next',
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color),
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}

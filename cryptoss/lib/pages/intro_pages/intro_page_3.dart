import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class IntroPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/animation_640_ldg3a3sa.gif",
              height: 33.h,
              width: 50.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tracking',
                  style: TextStyle(color: Colors.orangeAccent, fontSize: 17),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Keep track of all your favourite coins',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      color: Theme.of(context).primaryColor,
    );
  }
}

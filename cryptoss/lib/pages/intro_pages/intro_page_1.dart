import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class IntroPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/animation_640_ldg2ru11.gif",
              height: 33.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome to ',
                    style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontSize: 17)),
                Text(
                  'Crypto Kiu',
                  style: TextStyle(color: Colors.orangeAccent, fontSize: 17),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Cryptocurrency tracker',
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

import 'package:adan_russia/constatnts.dart';
import 'package:flutter/material.dart';

class MyProgressLoader extends StatelessWidget {
  const MyProgressLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BACKGROUND_SCREEN,
        child: Center(
            child: RefreshProgressIndicator(
          backgroundColor: MAIN_COLOR,
          color: Colors.black,
          elevation: 5.0,
          strokeWidth: 2,
        )));
  }
}

import 'dart:developer';

import 'package:adan_russia/screens/calender_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AboutPage'),
      ),
      body: aboutMe(context),
    );
  }
}

Widget aboutMe(context) {
  return Material(
    color: Colors.transparent,
    child: Container(
      height: MediaQuery.of(context).size.height / 1.5,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0))),
      child: SingleChildScrollView(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
                height: 450,
                alignment: Alignment.bottomRight,
                transform: Matrix4.translationValues(100, 270, 0.0),
                child: Opacity(
                  opacity: 0.8,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Image.asset(
                      "assets/Asset 2.png",
                      color: const Color(0xffE26B26).withOpacity(0.3),
                    ),
                  ),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Image.asset('assets/Logo_Original.png', width: 172, height: 92),
                const SizedBox(height: 18),
                const Text("تطبيق ميقاتي لمواعيد الصلاة"),
                const Text("تقبل الله طاعتكم"),
                const Text("تم تصميم  و تطوير التطبيق من قبل شركة"),
                const Text("Sky Services Group", style: secondTextStyle),
                const Text(
                    "المختصة بتطوير التطبيقات و مواقع الويب و الاستضافة"),
                const SizedBox(height: 12),
                const Text("لمعرفة المزيد زورو موقعنا"),
                const SizedBox(height: 5),
                InkWell(
                  child: Text("www.ssg-tech.com",
                      style: TextStyle(color: Color(0xffE26B26), fontSize: 15)),
                  onTap: () async {
                    log("Click me now !!!!!!!");
                    // await launch('https://www.ssg-tech.com');
                  },
                ),
                const SizedBox(height: 18),
                const Text("للتواصل معنا",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(children: [
                    const WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          Icons.email,
                          color: Color(0xffE26B26),
                        ),
                      ),
                    ),
                    TextSpan(
                        text: "rwsoftware59@gmail.com",
                        style: const TextStyle(color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            // await launch("mailto:info@ssg-tech.com");
                          }),
                  ]),
                ),
                const SizedBox(height: 14),
                RichText(
                  text: TextSpan(children: [
                    const WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(Icons.phone, color: Color(0xffE26B26)),
                      ),
                    ),
                    TextSpan(
                        text: "+7 996 564 16 55",
                        style: const TextStyle(color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            // await launch("tel:+963-955-310-484");
                          }),
                  ]),
                ),
                const SizedBox(height: 14),
                RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(Icons.phone, color: Color(0xffE26B26)),
                        ),
                      ),
                      TextSpan(
                          text: "+963 11 3310 484",
                          style: const TextStyle(color: Colors.black),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              // await launchUrl(Uri.parse("tel:+963-11-310-484"));
                            }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

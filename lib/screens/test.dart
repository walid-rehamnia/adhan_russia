// import 'package:adan_russia/constatnts.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:share_plus/share_plus.dart';

// import 'package:adan_russia/preferences.dart';
// import 'package:get/get.dart';
// // import 'dart:ui' as ui;
// import 'dart:io';

// class AboutWidget extends StatefulWidget {
//   @override
//   _AboutWidgetState createState() => _AboutWidgetState();
// }

// class _AboutWidgetState extends State<AboutWidget> {
//   // Replace these with your app details
//   String appName = "Your App Name";
//   String playStoreUrl =
//       "https://play.google.com/store/apps/details?id=your.package.name";
//   String appShareMessage = "Check out $APP_NAME - A fantastic app for ...";
//   String supportEmail = "rwsoftware59@gmail.com";

//   // Function to open a URL
//   Future<void> _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("About $appName"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               "$appName - Version 1.0.0",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Text(
//               "We appreciate your feedback! Let us know how we're doing.",
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: () {
//                 // Open Play Store for rating
//                 _launchURL(playStoreUrl);
//               },
//               child: Text("Rate $appName on Play Store"),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Share the app
//                 Share.share(appShareMessage);
//               },
//               child: Text("Share $appName"),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Open email for support/questions

//                 // _launchURL('mailto:$supportEmail');
//               },
//               child: Text("Ask Questions / Get Support"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:adan_russia/constatnts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  // Replace these with your app details
  String appName = "Adhan Russia";
  String playStoreUrl =
      "https://play.google.com/store/apps/details?id=com.rehamnia.adan_russia";
  String appShareMessage = "Check out $APP_NAME - A fantastic app for ...";
  String supportEmail = "rehamnia.dev@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BACKGROUND_SCREEN,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$appName - V 1.0.2",
                style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Amiri'),
              ),
              const SizedBox(height: 50),
              Text(
                "aboutText".tr,
                style: const TextStyle(
                    fontFamily: 'Amiri',
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              myButton(Icons.mail_rounded, "askBtn".tr, () async {
                final url = Uri.parse(
                    'mailto:$supportEmail?subject=Question about Adhan Russia&body=Dear app developers');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
                try {} catch (e) {
                  EasyLoading.showError("internetError".tr);
                }
                EasyLoading.dismiss();
              }),
              SizedBox(height: 32),
              myButton(Icons.rate_review_rounded, "rateBtn".tr, () async {
                // Open Play Store for rating
                await _launchURL(playStoreUrl);
              }),
              // ElevatedButton(
              //   onPressed: () {
              //     // Share the app
              //     // Share.share(appShareMessage);
              //   },
              //   child: Text("Share $appName"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// void _launchURL() async {
//   final Uri params = Uri(
//     scheme: 'mailto',
//     path: 'my.mail@example.com',
//   );
//   String url = params.toString();
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     print('Could not launch $url');
//   }
// }

// Function to open a URL
Future<void> _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget myButton(IconData iconData, String text, VoidCallback onPressed) {
  return Center(
    child: TextButton.icon(
      onPressed: onPressed,
      icon:
          Icon(color: Colors.black, iconData), // Replace with your desired icon
      label: Text(
        text,
        style: const TextStyle(
            fontFamily: 'Amiri',
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold),
      ),
      style: TextButton.styleFrom(
        backgroundColor: MAIN_COLOR, // Set the background color
      ),
    ),
  );
}

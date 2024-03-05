import 'package:adan_russia/controllers.dart';
import 'package:adan_russia/screens/about_page.dart';

import 'package:adan_russia/screens/calendar_screen2.dart';

import 'package:adan_russia/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  final BottomNavigationController _controller =
      Get.put(BottomNavigationController());
  // Initialize the controller
  final List<Widget> pages = [
    const PrayerScreen(),
    SettingsScreen(),
    AboutPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[_controller.selectedIndex.value]),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_accessibility_rounded),
            label: "settings".tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_notifications_rounded),
            label: 'about'.tr,
          ),
        ],
        currentIndex: _controller.selectedIndex.value,
        onTap: (index) {
          setState(() {
            _controller.changePage(index);
          });
        },
      ),
    );
  }
}

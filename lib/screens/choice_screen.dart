import 'package:adan_russia/components.dart';
import 'package:adan_russia/utils/utils_location.dart';
import 'package:adan_russia/utils_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoiceScreen extends StatefulWidget {
  const ChoiceScreen({super.key});

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/back1.jpg'), // Replace with your image asset
                  fit: BoxFit.cover,
                ),
              ),
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Age')),
                  DataColumn(label: Text('Country')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('John Doe')),
                    DataCell(Text('28')),
                    DataCell(Text('USA')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Jane Smith')),
                    DataCell(Text('35')),
                    DataCell(Text('Canada')),
                  ]),
                ],
              ),
            ),

            ChoiceButton(
              title: ' Default Mode',
              description:
                  "Calculate the prayer time based on different global used parameters (you will be able to customize them soon in app parameters)",
              onPressed: () async {
                // Start loading
                setState(() {
                  isLoading = true;
                });
                try {
                  await getCoordinates();
                  setState(() {
                    isLoading = false;
                  });
                  Get.to(() => MyBottomNavigationBar());
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 16.0), // Add some spacing between buttons
            ChoiceButton(
              title: 'Custom Mode (more accurate)',
              description:
                  "Bsed on the calendars used in the russian mosques which has been issued from ....., for now it's limited to 'Nizhny Novgorod' city, help us with your city calendars so we'll covers more cities",
              onPressed: () async {
                // Start loading
                setState(() {
                  isLoading = true;
                });
                try {
                  await checkFirstInstallation();
                  setState(() {
                    isLoading = false;
                  });
                  Get.to(() => MyBottomNavigationBar());
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  const ChoiceButton({
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16.0),
        // primary: Colors.blue, // Set button color
        // onPrimary: Colors.white, // Set text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Add rounded corners
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            description,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

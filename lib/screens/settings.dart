import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/utils/utils_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MaterialApp(
    home: SettingsScreen(),
    theme: ThemeData(primarySwatch: MAIN_COLOR1),
  ));
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Radio choices
  String selectedRadio = 'Option 1';

  // Checkbox options
  bool enableFeature1 = false;
  bool enableFeature2 = true;

  // Other options
  double sliderValue = 50.0;

  // Current location
  String currentLocation = 'Unknown';

  // Loading indicator
  bool isLoading = false;

  // Application language
  String currentLanguage = 'English';
  // Function to save the settings
  void saveSettings() {
    // Implement your logic to save the settings here
    print('Settings saved!');
  }

  // Function to get the current location
  Future<void> updateLocation() async {
    try {
      setState(() {
        isLoading = true;
      });

      simulateAsyncFunction();

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation =
            'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
        isLoading = false;
      });
    } catch (e) {
      print('Error obtaining location: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: currentLanguage,
                onChanged: (String? newValue) {
                  changeLanguage(newValue!);
                },
                items: <String>['English', 'Spanish', 'French', 'German']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Text(
                'Adhan Time Mode',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              RadioListTile(
                title: Text('Option 1'),
                value: 'Option 1',
                groupValue: selectedRadio,
                onChanged: (value) {
                  setState(() {
                    selectedRadio = "value";
                  });
                },
              ),
              RadioListTile(
                title: Text('Option 2'),
                value: 'Option 2',
                groupValue: selectedRadio,
                onChanged: (value) {
                  setState(() {
                    selectedRadio = "value";
                  });
                },
              ),
              SizedBox(height: 16),
              Text(
                'Checkbox Options:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              CheckboxListTile(
                title: Text('Enable Feature 1'),
                value: enableFeature1,
                onChanged: (value) {
                  setState(() {
                    enableFeature1 = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Enable Feature 2'),
                value: enableFeature2,
                onChanged: (value) {
                  setState(() {
                    enableFeature2 = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await getCoordinates();
                },
                child:
                    isLoading ? CircularProgressIndicator() : Text('Location'),
              ),
              SizedBox(height: 8),
              Text('Current Location: $currentLocation'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  saveSettings();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> simulateAsyncFunction() async {
  print('Start of the asynchronous function');

  // Simulating an asynchronous operation with a delay
  await Future.delayed(Duration(seconds: 5));

  print('After delay of 2 seconds');

  // Simulating another asynchronous operation
  await Future.delayed(Duration(seconds: 1));

  print('End of the asynchronous function');
}

changeLanguage(String? s) {}

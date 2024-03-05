import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final List<String> buttonLabels = [
    'Adan notification',
    'Prayer notification',
    'Other notification'
  ];
  final List<bool> buttonStates = [true, true, true];

  // Handles changes
  void onSwitchChanged(int index, bool value) {
    // You can execute your function here with the updated index and value
    print('Switch at index $index changed to $value');
    // Add your custom logic or function call here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Awesome Page 1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            buttonLabels.length,
            (index) => Row(
              children: [
                Expanded(
                  child: Text(
                    buttonLabels[index],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Switch(
                  value: buttonStates[index],
                  onChanged: (value) {
                    setState(() {
                      buttonStates[index] = value;
                    });
                    // Call the callback function when the switch changes
                    onSwitchChanged(index, value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

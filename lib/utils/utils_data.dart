import 'dart:convert';
import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/preferences.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:quiver/time.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:path_provider/path_provider.dart';

Future<void> downloadCalendarData(String city) async {
  try {
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref();

    final calendarRef = storageRef.child(COLUD_PATH);

    //Schema : year[month[day[prayer]]]
    List<List<List<String>>> yearlyData = [];

    // const oneMegabyte = 1024 * 1024;  ... .getData(oneMegabyte); ....//data limit
    final Uint8List? data = await calendarRef.getData();
    PdfDocument document = PdfDocument(inputBytes: data);

    //save local pdf file for user clarity
    savePdfCalendar(data);

    //loop through pages to extract data...
    for (int page = 0; page < 12; page++) {
      String text =
          PdfTextExtractor(document).extractText(startPageIndex: page);
      //save data without metadata
      text = text.split("СОЛЦАНАЧАЛО")[1];

      //get list of raws
      List<String> raws = getTableRows(text, page + 1);
      List<List<String>> monthlyTimes = [];
      for (String raw in raws) {
        monthlyTimes.add(getRowTimes(raw));
      }

      yearlyData.add(monthlyTimes);
    }
    document.dispose();

    String jsonData = jsonEncode(yearlyData);
    saveYearlyData(jsonData);
  } catch (e) {
    print('Failed to download files:$e');
    throw Exception(
        'Failed to download necessary files:check your internet conncetion');
  }
}

void savePdfCalendar(Uint8List? document) async {
  try {
    // Get the document directory using path_provider
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;

    // Specify the file path where you want to save the PDF
    String filePath = '$documentPath/$YEARLY_PDF_FILE_NAME';

    // Save the PDF to the specified file path
    File file = File(filePath);
    await file.writeAsBytes(document!);
    print('PDF saved to: $filePath');
  } catch (e) {
    print('savePdfCalendar:$e');
  }
}

List<String> getTableRows(String text, month) {
  //This function separate the page data [specificallly the tabular data by russian_day] and doesn't exeed the table data

  //Regex tha math exactly 2 russian characters (signify the begining of line in our case)
  RegExp russianDaysRegex = RegExp(r'[а-яА-Я]{2}');

  DateTime now = DateTime.now();
  int daysLimit = daysInMonth(now.year, month);

  List<String> days = text.split(russianDaysRegex).sublist(1, daysLimit + 1);

  return days;
}

List<String> getRowTimes(String data) {
  //Regex of HH:MM or H:MM used to match prayer times from data raw
  RegExp timePattern = RegExp(r'(\d{1,2}:\d{2})');

  // Extract times from the input string
  Iterable<RegExpMatch> matches = timePattern.allMatches(data);

  // Convert matches to a list of strings
  List<String> times = matches.map((match) => match.group(0)!).toList();
  //Remove the third time (it's not necessary)
  times.removeAt(2);

  return times;
}

void saveYearlyData(String data) async {
  final directory = await getApplicationDocumentsDirectory();
  File file = File('${directory.path}/$YEARLY_JSON_FILE_NAME');
  file.writeAsString(data);
}

Future<List<List<List<String>>>> loadYearlyData() async {
  List<List<List<String>>> data = [];
  try {
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$YEARLY_JSON_FILE_NAME');
    // Read the file
    final contents = await file.readAsString();
    List<dynamic> loadedData = jsonDecode(contents);

    //converting the loaded data into the desired type
    final List<List<List<String>>> decodedData = loadedData
        .map((outerList) => (outerList as List<dynamic>)
            .map((middleList) => (middleList as List<dynamic>)
                .map((innerList) => (innerList as String).toString())
                .toList())
            .toList())
        .toList();

    return decodedData;
  } catch (e) {
    print('loadYearlyData:$e');
    return data;
  }
}

void listLocalFiles() async {
  var appDocDir = await getApplicationDocumentsDirectory();
  // List the files in the documents directory
  var files = Directory(appDocDir.path).listSync();

  // Print the names of the files
  for (var file in files) {
    print("File Name: ${file.uri.pathSegments.last}");
  }
}

Future<void> checkFirstInstallation() async {
  //Check first installation by year, because the download happens once by year by ignoring location for now
  final PreferencesController _preferencesController =
      Get.find<PreferencesController>();
  String? year = _preferencesController.calendarYear.value;
  String currentYear = DateTime.now().year.toString();
  if (year == '' || year != currentYear) {
    await downloadCalendarData("Nizhny_Novgorod");
    _preferencesController.updatePreference("calendarYear", currentYear);
  }
}

Future<List<int>> getAsset(String name) async {
  final ByteData data = await rootBundle.load('assets/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

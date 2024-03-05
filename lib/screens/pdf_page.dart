import 'package:adan_russia/constatnts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewerPage extends StatefulWidget {
  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String pdfPath = ""; // Replace with the actual path of your PDF file
  int currentPage = 0;
  int totalPage = 0;

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<void> loadPDF() async {
    // Use path_provider to get the document directory
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    // Concatenate the directory path and PDF file name
    final fullPath = '$path/$YEARLY_PDF_FILE_NAME';

    // Update the state with the PDF path
    setState(() {
      pdfPath = fullPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pdfPath.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : PDFView(
              filePath: pdfPath,
              autoSpacing: true,
              pageSnap: true,
              swipeHorizontal: true,
              fitEachPage: true,
              defaultPage: DateTime.now().month - 1,
              onRender: (pages) {
                setState(() {
                  totalPage = pages!;
                });
              },
              onPageChanged: (page, total) {
                setState(() {
                  currentPage = page! + 1;
                });
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 20.0,
          child: Center(
            child: Text(
              '${GREGORIAN_MONTHS[currentPage]} ($currentPage/$totalPage)',
              style: const TextStyle(fontSize: 17.0),
            ),
          ),
        ),
      ),
    );
  }
}

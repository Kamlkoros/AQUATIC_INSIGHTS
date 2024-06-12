import 'dart:io';

import 'package:aquatic_insights/global_variables.dart';
import 'package:aquatic_insights/screens/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path/path.dart' as path;

class MainScreen extends StatefulWidget {
  MainScreen(
      {super.key, required this.downloading, required this.pdfAvailable});
  bool pdfAvailable;
  bool downloading;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Directory? pdfDirectory;

  Future<List<String>> pdfReader(String date) async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    pdfDirectory = Directory(path.join(documentDirectory.path, 'pdfs'));
    var file = File(path.join(pdfDirectory!.path, '$date.pdf'));
    if (!file.existsSync()) {
      return Future.value([]);
    }
    Uint8List bytes = await file.readAsBytes();
    final List<String> riverData = [];
    final PdfDocument document = PdfDocument(inputBytes: bytes);
    String content = PdfTextExtractor(document).extractText();
    List<String> lines = content.split('\n');
    Map<String, List<int>> riverLines = {
      'INDUS @ TARBELA': [5, 12, 15, 19],
      'KABUL @ NOWSHERA': [8],
      'KALABAGH': [30, 37, 45],
      'CHASHMA': [27, 34, 41, 49, 53, 57],
      'TAUNSA': [62, 67, 75, 83, 91],
      'Guddu': [71, 79, 87],
      'Sukkar': [101, 109, 118],
      'Kotri': [97, 105, 114],
      'JHELUM @ MANGLA': [129, 136, 139, 144],
      'CHENAB @ MARALA': [125, 132],
      'PANJNAD': [158, 163],
    };

    for (var river in riverLines.entries) {
      for (var lineIndex in river.value) {
        riverData.add(lines[lineIndex]);
      }
    }
    return riverData;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.pdfAvailable);
    print(widget.downloading);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Indus Water Tracker: Daily Reports'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: widget.downloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : !widget.pdfAvailable
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 60.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Check your internet'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildFutures().map((pair) {
                      return FutureBuilder<List<String>>(
                        future: pair.future as Future<List<String>>?,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<String>> snapshot) {
                           if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<String>? riverdata = snapshot.data;
                            if (riverdata != null && riverdata.isNotEmpty) {
                              if (indus.dataLists['LEVEL']!.length <
                                  (availableDays.isEmpty
                                      ? 10
                                      : availableDays.length)) {
                                indus.dataLists['LEVEL']!.add(riverdata[0]);
                                indus.dataLists['DEAD LEVEL']!
                                    .add(riverdata[1]);
                                indus.dataLists['MEAN INFLOW']!
                                    .add(riverdata[2]);
                                indus.dataLists['MEAN OUTFLOW']!
                                    .add(riverdata[3]);
                                kabul.dataLists['MEAN DISCHARGE']!
                                    .add(riverdata[4]);
                                kalabagh.dataLists['U/S DISCHARGE']!
                                    .add(riverdata[5]);
                                kalabagh.dataLists['D/S DISCHARGE']!
                                    .add(riverdata[6]);
                                kalabagh.dataLists['Thal']!.add(riverdata[7]);
                                chashma.dataLists['LEVEL']!.add(riverdata[8]);
                                chashma.dataLists['DEAD LEVEL']!
                                    .add(riverdata[9]);
                                chashma.dataLists['MEAN INFLOW']!
                                    .add(riverdata[10]);
                                chashma.dataLists['MEAN OUTFLOW']!
                                    .add(riverdata[11]);
                                chashma.dataLists['CJ LINK']!
                                    .add(riverdata[12]);
                                chashma.dataLists['CRBC']!.add(riverdata[13]);
                                taunsa.dataLists['U/S DISCHARGE']!
                                    .add(riverdata[14]);
                                taunsa.dataLists['D/S DISCHARGE']!
                                    .add(riverdata[15]);
                                taunsa.dataLists['T-P LINK']!
                                    .add(riverdata[16]);
                                taunsa.dataLists['MUZAFARGHAR CANAL']!
                                    .add(riverdata[17]);
                                taunsa.dataLists['DERA GHAZI KHAN CANAL']!
                                    .add(riverdata[18]);
                                guddu.dataLists['U/S DISCHARGE']!
                                    .add(riverdata[19]);
                                guddu.dataLists['D/S DISCHARGE']!
                                    .add(riverdata[20]);
                                guddu.dataLists['CANAL W/dls']!
                                    .add(riverdata[21]);
                                sukkar.dataLists['U/S DISCHARGE']!
                                    .add(riverdata[22]);
                                sukkar.dataLists['D/S DISCHARGE']!
                                    .add(riverdata[23]);
                                sukkar.dataLists['CANAL W/dls']!
                                    .add(riverdata[24]);
                                kotri.dataLists['U/S DISCHARGE']!
                                    .add(riverdata[25]);
                                kotri.dataLists['D/S DISCHARGE']!
                                    .add(riverdata[26]);
                                kotri.dataLists['CANAL W/dls']!
                                    .add(riverdata[27]);
                                jhelum.dataLists['LEVEL']!.add(riverdata[28]);
                                jhelum.dataLists['DEAD LEVEL']!
                                    .add(riverdata[29]);
                                jhelum.dataLists['MEAN INFLOW']!
                                    .add(riverdata[30]);
                                jhelum.dataLists['MEAN OUTFLOW']!
                                    .add(riverdata[31]);
                                chenab.dataLists['MEAN U/S DISCHARGE']!
                                    .add(riverdata[32]);
                                chenab.dataLists['MEAN D/S DISCHARGE']!
                                    .add(riverdata[33]);
                                panjnad.dataLists['U/S DISCHARGE']!
                                    .add(riverdata[34]);
                                panjnad.dataLists['D/S DISCHARGE']!
                                    .add(riverdata[35]);
                              }
                            } else {
                              return const SizedBox();
                            }
                            return Card(
                              color: Colors.grey[800],
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: const Icon(Icons.date_range,
                                    color: Colors.white),
                                title: Text(
                                  'Daily Data ${pair.date}',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PdfViewer(
                                      riverData: riverdata,
                                      pdfPath: File(path.join(
                                              pdfDirectory!.path,
                                              '${pair.date}.pdf'))
                                          .absolute
                                          .path,
                                      datetime: pair.date,
                                    ),
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    color: Colors.white),
                              ),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
    );
  }

  List<Pair<String, Future<List<String>>>> _buildFutures() {
    List<Pair<String, Future<List<String>>>> futures = [];
    Future<List<String>> previousFuture =
        Future.value([]); // Start with a completed future
    for (var date in availableDays) {
      previousFuture = previousFuture.then((_) => pdfReader(date));
      futures.add(Pair(date, previousFuture));
    }
    return futures;
  }
}

class Pair<Date, Future> {
  final Date date;
  final Future future;

  Pair(this.date, this.future);
}

import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:aquatic_insights/global_variables.dart';
import 'package:aquatic_insights/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _downloading = true;
  bool pdfAvailable = false;

  @override
  void initState() {
    super.initState();
    downloadAllPdfs().then((_) {
      setState(() {
        _downloading = false;
      });
    });
    cleanUpOldPdfs();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      fetchAll();
    });
  }

  Future<void> fetchAll() async {
    FlutterDisplayMode.setHighRefreshRate();
    setState(() {});
  }

  Future<void> cleanUpOldPdfs() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var pdfDirectory = Directory(path.join(documentDirectory.path, 'pdfs'));

    if (!pdfDirectory.existsSync()) {
      return;
    }

    final cutoffDate = DateTime.now().subtract(const Duration(days: 31));
    var files = pdfDirectory.listSync();

    var filesToDelete = files.where((file) {
      var fileName = path.basenameWithoutExtension(file.path);
      try {
        var fileDate = DateFormat('dd-MM-yyyy').parse(fileName);
        return fileDate.isBefore(cutoffDate);
      } catch (e) {
        return false;
      }
    });

    for (var file in filesToDelete) {
      file.deleteSync();
    }
  }

  Future<void> downloadAllPdfs() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var pdfDirectory = Directory(path.join(documentDirectory.path, 'pdfs'));
    for (String date in lastTwentyDays) {
      String url = 'http://pakirsa.gov.pk/Doc/Data$date.pdf';

      if (!pdfDirectory.existsSync()) {
        pdfDirectory.createSync(recursive: true);
      }
      var file = File(path.join(pdfDirectory.path, '$date.pdf'));
      if (!file.existsSync()) {
        try {
          var response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            await file.writeAsBytes(response.bodyBytes);
          }
        } on SocketException catch (_) {
          print('No Internet connection');
          // Handle the exception here. You might want to show a notification to the user, for example.
        }
      }
    }

    var fileNames = pdfDirectory
        .listSync()
        .map((fileSystemEntity) {
          var fileName = path.basename(fileSystemEntity.path);
          if (fileName.length <= 10) {
            return '';
          } else {
            return fileName.substring(0, 10);
          }
        })
        .where((fileName) => fileName.isNotEmpty)
        .toList();

    fileNames.sort((a, b) {
      DateFormat format = DateFormat("dd-MM-yyyy");
      DateTime dateA = format.parse(a);
      DateTime dateB = format.parse(b);
      return dateA.compareTo(dateB);
    });
    availableDays.addAll(fileNames.reversed);
    if (availableDays.isNotEmpty) {
      pdfAvailable = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: MainScreen(
        pdfAvailable: pdfAvailable,
        downloading: _downloading,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

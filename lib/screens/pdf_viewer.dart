import 'package:aquatic_insights/screens/graph_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:share/share.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({
    Key? key,
    required this.pdfPath,
    required this.datetime,
    required this.riverData,
  }) : super(key: key);

  final String pdfPath;
  final String datetime;
  final List<String> riverData;

  @override
  State<PdfViewer> createState() => _PDFViewerCachedFromUrlState();
}

class _PDFViewerCachedFromUrlState extends State<PdfViewer> {
  bool markerToggleOn = true;

  bool showPdf = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            Text(widget.datetime, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: <Widget>[
          showPdf
              ? IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Share.shareFiles([widget.pdfPath]);
                  },
                )
              : TextButton(
                  onPressed: () {
                    setState(() {
                      markerToggleOn = !markerToggleOn;
                    });
                  },
                  child: const Text('Data Points'))
        ],
      ),
      body: showPdf
          ? const PDF().fromPath(widget.pdfPath)
          : GraphViewer(markerToggleOn: markerToggleOn),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showPdf = !showPdf;
          });
        },
        child: Icon(showPdf ? Icons.bar_chart : Icons.picture_as_pdf),
      ),
    );
  }
}

class ChartData {
  final String date;
  final double data;

  ChartData(this.date, this.data);
}

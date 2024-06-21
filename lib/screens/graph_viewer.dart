import 'dart:math';

import 'package:aquatic_insights/global_variables.dart';
import 'package:aquatic_insights/screens/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphViewer extends StatelessWidget {
  GraphViewer({super.key, required this.markerToggleOn});
  final bool markerToggleOn;

  final List<dynamic> riverDataList = [
    indus,
    kalabagh,
    kabul,
    chashma,
    taunsa,
    guddu,
    sukkar,
    kotri,
    jhelum,
    chenab,
    panjnad,
  ];

  final Map<String, Color> colorMap = {
    'IndusData': Colors.red,
    'KalabaghData': Colors.green,
    'KabulData': Colors.blue,
    'ChashmaData': Colors.yellow,
    'TaunsaData': Colors.teal,
    'GudduData': Colors.orange,
    'SukkarData': Colors.deepPurple,
    'KotriData': Colors.pink,
    'JhelumData': Colors.purple,
    'ChenabData': Colors.cyan,
    'PanjnadData': Colors.amber,
  };

  SfCartesianChart buildChart(dynamic data, String title) {
    int currentdays = 30;
    if(availableDays.length < currentdays){
      currentdays = availableDays.length;
    }
    List<String> dataList = List<String>.from(data.getData(title)).take(currentdays).toList();
    
    String className = data.runtimeType.toString();

    List<ChartData> chartData = [];
    double minData = double.infinity;
    double maxData = double.negativeInfinity;

    for (int index = 0; index < currentdays; index++) {
      String day = availableDays[currentdays-1 - index];
      int dataIndex = dataList.length - 1 - index;
      if (dataIndex >= 0 && dataIndex < dataList.length) {
        double dataValue = double.parse(dataList[dataIndex]);
        chartData.add(
          ChartData(
            day,
            dataValue,
          ),
        );
        if (dataValue < minData) {
          minData = dataValue;
        }
        if (dataValue > maxData) {
          maxData = dataValue;
        }
      }
    }

    double range = maxData - minData;
    double buffer;

    if (range == 0) {
      buffer = maxData * 0.1;
    } else {
      buffer = range * 0.1;
    }

    return SfCartesianChart(
      title: ChartTitle(text: '               $title'),
      enableAxisAnimation: true,
      primaryXAxis: const CategoryAxis(
        title: AxisTitle(text: 'Date'),
        labelStyle: TextStyle(color: Colors.blue, fontSize: 12),
      ),
      primaryYAxis: NumericAxis(
        minimum: max(0, minData - buffer),
        maximum: maxData + buffer,
        numberFormat: NumberFormat("#.##"),
      ),

      series: <LineSeries<ChartData, String>>[
        LineSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.date,
          yValueMapper: (ChartData data, _) => data.data,
          color: colorMap.containsKey(className)
              ? colorMap[className]
              : Colors.red, // Change the line color
          width: 2, // Change the line width
          markerSettings:
              MarkerSettings(isVisible: markerToggleOn), // Show markers
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        canShowMarker: true,
        format: 'point.x : point.y',
      ), // Enable tooltips
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          height: 50.0, // Set a height for the container
          child: ListView.builder(
            scrollDirection:
                Axis.horizontal, // Make the list scroll horizontally
            itemCount: colorMap.keys.length,
            itemBuilder: (BuildContext context, int index) {
              String colorKey = colorMap.keys.elementAt(index);
              String textKey = colorKey.substring(0, colorKey.length - 4);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        color: colorMap[colorKey],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Text(textKey),
                  ],
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: riverDataList.length,
            itemBuilder: (BuildContext context, int outerIndex) {
              var data = riverDataList[outerIndex];
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.dataLists.keys.length,
                itemBuilder: (BuildContext context, int innerIndex) {
                  String title = data.dataLists.keys.elementAt(innerIndex);
                  return buildChart(data, title);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

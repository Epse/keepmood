import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../sentiment.dart';

//FIXME: For some insane reason this gives a very happy average...

class MonthlyMoodChart extends StatelessWidget {
  final List<charts.Series<TimeSeriesSentimentAverage, DateTime>> seriesList;
  final bool animate;

  MonthlyMoodChart(this.seriesList, this.animate);

  factory MonthlyMoodChart.fromSentimentRecordingList(List<SentimentRecording> inList,
      [bool animate]) {
    List<TimeSeriesSentimentAverage> data = new List<TimeSeriesSentimentAverage>();

    if (inList == null) {
      inList = new List<SentimentRecording>();
    }
    int firstIndexThisDay = inList.length - 1;
    for (var i = inList.length - 1; i >= 0; i--) {
      if (i != 0) {
        if (inList[i].time.difference(inList[i-1].time).inDays > 0) {
          firstIndexThisDay = i;
          // Calculate the average of the last day
          final int num = firstIndexThisDay - (i - 1);
          if (firstIndexThisDay == (i-1)) {
            data.add(new TimeSeriesSentimentAverage(inList[i-1].time, inList[i-1].sentiment.index.toDouble()));
          }
          if (num > 0) {
            double sum = 0.0;
            for (int j = i-1; j <= firstIndexThisDay; j++) {
              sum += inList[j].sentiment.index;
            }
            data.add(new TimeSeriesSentimentAverage(inList[firstIndexThisDay].time, sum/num));
          }
        }
      } else {
        data.add(new TimeSeriesSentimentAverage(inList[i].time, inList[i].sentiment.index.toDouble()));
      }
    }

    final series = [
      new charts.Series<TimeSeriesSentimentAverage, DateTime>(
          id: "Mood",
          data: data,
          domainFn: (TimeSeriesSentimentAverage s, _) => s.time,
          measureFn: (TimeSeriesSentimentAverage s, _) => s.sentiment)
    ];

    return new MonthlyMoodChart(series, animate);
  }

  @override
  Widget build(BuildContext context) {
    final staticTicks = <charts.TickSpec<double>>[
      new charts.TickSpec(0.0, label: 'Very unhappy'),
      new charts.TickSpec(1.0, label: 'Unhappy'),
      new charts.TickSpec(2.0, label: "Meh"),
      new charts.TickSpec(3.0, label: "Happy"),
      new charts.TickSpec(4.0, label: "Very happy")
    ];
    return new Column(children: <Widget>[
      ListTile(title: Text("This month"),),
      // This should be inside the ListTile, but that failed horribly..
      Container(
          height: 200.0,
          padding: const EdgeInsets.all(16.0),
          child: charts.TimeSeriesChart(
            seriesList,
            animate: animate,
            primaryMeasureAxis: new charts.NumericAxisSpec(
              showAxisLine: false,
              tickProviderSpec:
              new charts.StaticNumericTickProviderSpec(staticTicks),
            ),
          )),
      Divider(),
    ],);
  }
}

class TimeSeriesSentimentAverage {
  final DateTime time;
  final double sentiment;

  TimeSeriesSentimentAverage(this.time, this.sentiment);
}

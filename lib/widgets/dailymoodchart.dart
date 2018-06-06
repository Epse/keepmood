import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../sentiment.dart';

class DailyMoodChart extends StatelessWidget {
  final List<charts.Series<TimeSeriesSentiment, DateTime>> seriesList;
  final bool animate;

  DailyMoodChart(this.seriesList, this.animate);

  factory DailyMoodChart.fromSentimentRecordingList(List<SentimentRecording> inList,
      [bool animate]) {
    List<TimeSeriesSentiment> data = new List<TimeSeriesSentiment>();

    if (inList == null) {
      inList = new List<SentimentRecording>();
    }
    for (var recording in inList) {
      data.add(new TimeSeriesSentiment.fromSentimentRecording(recording));
    }

    final series = [
      new charts.Series<TimeSeriesSentiment, DateTime>(
          id: "Mood",
          data: data,
          domainFn: (TimeSeriesSentiment s, _) => s.time,
          measureFn: (TimeSeriesSentiment s, _) => s.sentiment)
    ];

    return new DailyMoodChart(series, animate);
  }

  @override
  Widget build(BuildContext context) {
    // FIXME: why the fuck does this show up on the emulator or on-device debugging (even release mode)
    // but is not visible when installing an apk?
    final staticTicks = <charts.TickSpec<int>>[
      new charts.TickSpec(0, label: 'Very unhappy'),
      new charts.TickSpec(1, label: 'Unhappy'),
      new charts.TickSpec(2, label: "Meh"),
      new charts.TickSpec(3, label: "Happy"),
      new charts.TickSpec(4, label: "Very happy")
    ];
    return new Column(children: <Widget>[
      ListTile(title: Text("Today"),),
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
            domainAxis: new charts.DateTimeAxisSpec(
                showAxisLine: true, renderSpec: new charts.NoneRenderSpec()),
          )),
      Divider(),
    ],);
  }
}

class TimeSeriesSentiment {
  final DateTime time;
  final int sentiment;

  TimeSeriesSentiment(this.time, this.sentiment);

  TimeSeriesSentiment.fromSentimentRecording(SentimentRecording recording)
      : time = recording.time,
        sentiment = recording.sentiment.index;
}

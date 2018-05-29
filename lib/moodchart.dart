import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'sentiment.dart';

class MoodChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  MoodChart(this.seriesList, this.animate);

  factory MoodChart.fromSentimentRecordingList(List<SentimentRecording> inList, [bool animate]) {
    List<TimeSeriesSentiment> data = new List<TimeSeriesSentiment>();

    for (var recording in inList) {
      data.add(new TimeSeriesSentiment.fromSentimentRecording(recording));
    }
    
    final series = [new charts.Series<TimeSeriesSentiment, DateTime>(
      id: "Mood",
      data: data,
      domainFn: (TimeSeriesSentiment s, _) => s.time,
      measureFn: (TimeSeriesSentiment s, _) => s.sentiment
    )];
    
    return new MoodChart(series, animate);
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: charts.TimeSeriesChart(
      seriesList,
      animate: animate,
    ));
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
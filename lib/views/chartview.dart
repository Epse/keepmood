import 'package:flutter/material.dart';

import '../widgets/dailymoodchart.dart';
import '../sentiment.dart';

class ChartView extends StatelessWidget {
  final List<SentimentRecording> recordings;
  final List<SentimentRecording> today;

  ChartView({Key key, @required this.recordings})
      : today = _todayRecordings(recordings),
        super(key: key);

  static List<SentimentRecording> _todayRecordings(List<SentimentRecording> x) {
    List<SentimentRecording> y = new List<SentimentRecording>();
    for (var r in x) {
      if (new DateTime.now().difference(r.time).inDays < 1) {
        y.add(r);
      }
    }
    return y;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Charts"),
        ),
        body: ListView(children: <Widget>[
          new DailyMoodChart.fromSentimentRecordingList(today, false)
        ]));
  }
}

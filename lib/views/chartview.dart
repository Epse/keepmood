import 'package:flutter/material.dart';

import '../widgets/dailymoodchart.dart';
import '../widgets/monthlymoodchart.dart';
import '../moodstorage.dart';
import '../sentiment.dart';

class ChartView extends StatefulWidget {
  final MoodStorage storage;

  ChartView({Key key, @required this.storage}) : super(key: key);

  @override
  createState() => new ChartViewState(storage);
}

class ChartViewState extends State<ChartView> {
  final MoodStorage storage;
  List<SentimentRecording> today;

  void _getToday() async {
    final temp =  await storage.getRecordingsSinceDay(new DateTime.now());
    setState(() {
      today = temp;
    });
  }

  @override
  ChartViewState(this.storage) {
    _getToday();
  }

  bool notNull(Object o) => o != null;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Charts"),
        ),
        body: ListView(children: <Widget>[
            (today != null) ? new DailyMoodChart.fromSentimentRecordingList(today, false) : null,
          //new MonthlyMoodChart.fromSentimentRecordingList(recordings, false)
        ].where(notNull).toList()));
  }
}

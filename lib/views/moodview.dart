import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../sentiment.dart';
import '../widgets/moodselector.dart';
import '../widgets/moodevent.dart';
import '../moodstorage.dart';
import 'chartview.dart';

class MoodView extends StatefulWidget {
  @override
  createState() => new MoodViewState();
}

class MoodViewState extends State<MoodView> {
  final MoodStorage storage = new MoodStorage();
  List<SentimentRecording> _sentimentList;

  Future<Null> fillRecordingList() async {
    var list = await storage.getAllRecordings();
    setState(() {
      _sentimentList = list;
    });
  }

  @override
  void initState() {
    super.initState();
    fillRecordingList();
  }

  void _newSentiment(SentimentRecording recording) async {
    recording = await storage.insert(recording);
    // TODO: This is not at all very optimised...
    var recordings = await storage.getAllRecordings();
    setState(() {
      _sentimentList = recordings;
    });
  }

  void _deleteRecording(int id) async {
    await storage.delete(id);
    // TODO: optimize the shit out of this please
    fillRecordingList();
  }

  @override
  Widget build(BuildContext context) {
    Column column = new Column(
      children: <Widget>[
        MoodSelector(
          onSelected: _newSentiment,
        ),
      ],
    );

    var formatter = new DateFormat('EEEE yyyy-MM-dd');

    if (_sentimentList != null) {
      DateTime lastTime = DateTime.now().add(new Duration(days: 2));
      for (var recording in _sentimentList.reversed) {
        if (new DateTime(lastTime.year, lastTime.month, lastTime.day).difference(recording.time).inDays > 0) {
          column.children.add(new Text(formatter.format(recording.time)));
        }
        lastTime = recording.time;
        column.children.add(new MoodEvent(
          recording: recording,
          onDelete: _deleteRecording,
        ));
      }
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('KeepMood'),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.show_chart),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            new ChartView(storage: storage,)));
              })
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[column],
      ),
    );
  }

  @override
  void dispose() {
    storage.close();
    super.dispose();
  }
}

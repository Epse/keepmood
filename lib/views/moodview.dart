import 'dart:async';

import 'package:flutter/material.dart';

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

    if (_sentimentList != null) {
      for (var recording in _sentimentList.reversed) {
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
          new IconButton(icon: Icon(Icons.show_chart), onPressed: () {
            Navigator.push(context, new MaterialPageRoute(builder: (context) => new ChartView()));
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

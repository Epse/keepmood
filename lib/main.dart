import 'dart:async';

import 'package:flutter/material.dart';

import 'sentiment.dart';
import 'widgets/moodselector.dart';
import 'widgets/moodevent.dart';
import 'moodstorage.dart';
import 'widgets/moodchart.dart';

void main() => runApp(new KeepMood());

class KeepMood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'KeepMood',
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('KeepMood'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              MoodView(),
            ],
          ),
        ),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ));
  }
}

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
        column.children.add(new MoodEvent(recording: recording, onDelete: _deleteRecording,));
      }
    }
    return column;
  }

  @override
  void deactivate() async {
    await storage.close();
    super.deactivate();
  }
}


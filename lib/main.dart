import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

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

class MoodStorage {
  final String _table = "Moods";
  Database database;

  Future initDatabase() async => database = await _localDb;

  Future<Directory> get _localPath async {
    return await getApplicationDocumentsDirectory();
  }

  Future<String> get _localFile async {
    return p.join((await _localPath).path, "mood.db");
  }

  Future<Database> get _localDb async {
    return openDatabase(await _localFile, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE $_table (id INTEGER PRIMARY KEY, sentiment TEXT, timestamp TEXT);");
    });
  }

  Future<SentimentRecording> insert(final SentimentRecording recording) async {
    if (database == null) {
      await initDatabase();
    }
    recording.id = await database.insert(_table, recording.toMap());
    return recording;
  }

  Future<SentimentRecording> getRecording(final int id) async {
    if (database == null) {
      await initDatabase();
    }
    List<Map> maps = await database.query(_table,
        columns: ["id", "sentiment", "timestamp"],
        where: "id = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return new SentimentRecording.fromMap(maps.first);
    }
    return null;
  }

  Future<List<SentimentRecording>> getAllRecordings() async {
    if (database == null) {
      await initDatabase();
    }
    List<Map> maps =
        await database.query(_table, columns: ["id", "sentiment", "timestamp"]);
    List<SentimentRecording> list = new List<SentimentRecording>();
    for (var map in maps) {
      list.add(new SentimentRecording.fromMap(map));
    }
    return list;
  }

  Future update(final SentimentRecording recording) async {
    if (database == null) {
      await initDatabase();
    }
    return await database.update(_table, recording.toMap(),
        where: "id = ?", whereArgs: [recording.id]);
  }

  Future close() async => database.close();
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

  void _newSentiment(Sentiment sentiment) async {
    SentimentRecording recording =
        new SentimentRecording(sentiment, new DateTime.now());
    await storage.insert(recording);
    var recordings = await storage.getAllRecordings();
    setState(() {
      _sentimentList = recordings;
    });
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
        column.children.add(new Card(
            child: ListTile(
          title: Text(sentimentString(recording.sentiment)),
          subtitle: Text(recording.time.toString()),
        )));
      }
    }

    return column;
  }
}

class MoodEvent extends StatelessWidget {
  MoodEvent({Key key, @required this.recording}) : super(key: key);

  final SentimentRecording recording;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            title: Text(sentimentString(recording.sentiment)),
            subtitle: Text(recording.time.toIso8601String())));
  }
}

class MoodSelector extends StatelessWidget {
  MoodSelector({Key key, @required this.onSelected}) : super(key: key);

  final ValueChanged<Sentiment> onSelected;

  void _handleTapVeryUnhappy() {
    onSelected(Sentiment.veryUnhappy);
  }

  void _handleTapUnhappy() {
    onSelected(Sentiment.unhappy);
  }

  void _handleTapNeutral() {
    onSelected(Sentiment.neutral);
  }

  void _handleTapHappy() {
    onSelected(Sentiment.happy);
  }

  void _handleTapVeryHappy() {
    onSelected(Sentiment.veryHappy);
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: Container(
            child: Column(
      children: <Widget>[
        ListTile(title: Text("How do you feel?")),
        ButtonTheme.bar(
            child: ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
                onPressed: _handleTapVeryUnhappy,
                icon: Icon(Icons.sentiment_very_dissatisfied),
                iconSize: 40.0,
                color: Colors.red),
            IconButton(
                onPressed: _handleTapUnhappy,
                icon: Icon(Icons.sentiment_dissatisfied),
                iconSize: 40.0,
                color: Colors.orange),
            IconButton(
                onPressed: _handleTapNeutral,
                icon: Icon(Icons.sentiment_neutral),
                iconSize: 40.0,
                color: Colors.blueGrey),
            IconButton(
                onPressed: _handleTapHappy,
                icon: Icon(Icons.sentiment_satisfied),
                iconSize: 40.0,
                color: Colors.blue),
            IconButton(
                onPressed: _handleTapVeryHappy,
                icon: Icon(Icons.sentiment_very_satisfied),
                iconSize: 40.0,
                color: Colors.green),
          ],
        )),
      ],
    )));
  }
}

enum Sentiment { veryUnhappy, unhappy, neutral, happy, veryHappy }

class SentimentRecording {
  // id is not final because it can be set after insertion into database
  int id;
  final DateTime time;
  final Sentiment sentiment;

  SentimentRecording(this.sentiment, this.time, [this.id]);

  SentimentRecording.fromMap(Map map)
      : id = map["id"],
        time = DateTime.parse(map["timestamp"]),
        sentiment = parseSentiment(map["sentiment"]);

  Map toMap() {
    // Damn those type annotations.. You need them or it fails
    Map<String, dynamic> map = {
      "timestamp": time.toIso8601String(),
      "sentiment": sentimentString(sentiment)
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}

String sentimentString(Sentiment sentiment) {
  switch (sentiment) {
    case Sentiment.happy:
      return "Happy";
      break;
    case Sentiment.veryHappy:
      return "Very Happy";
      break;
    case Sentiment.unhappy:
      return "Unhappy";
      break;
    case Sentiment.veryUnhappy:
      return "Very Unhappy";
      break;
    default:
      return "Meh!";
      break;
  }
}

Sentiment parseSentiment(String string) {
  switch (string) {
    case "Very Unhappy":
      return Sentiment.veryUnhappy;
      break;
    case "Unhappy":
      return Sentiment.unhappy;
      break;
    case "Happy":
      return Sentiment.happy;
      break;
    case "Very Happy":
      return Sentiment.veryHappy;
      break;
    default:
      return Sentiment.neutral;
  }
}

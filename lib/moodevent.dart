import 'package:flutter/material.dart';
import 'sentiment.dart';

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


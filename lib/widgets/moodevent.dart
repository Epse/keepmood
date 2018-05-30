import 'package:flutter/material.dart';
import '../sentiment.dart';

class MoodEvent extends StatelessWidget {
  MoodEvent({Key key, @required this.recording, @required this.onDelete})
      : super(key: key);

  final SentimentRecording recording;
  final ValueSetter<int> onDelete;
  void _delete() => onDelete(recording.id);

  @override
  Widget build(BuildContext context) {
    return Card(
          child: Column(children: <Widget>[ListTile(
              title: Text(sentimentString(recording.sentiment)),
              subtitle: Text(recording.comment)),
      new ButtonTheme.bar(
        child: new ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text("Delete"),
              onPressed: _delete,
            )
          ],
        )
      )
    ]));
  }
}

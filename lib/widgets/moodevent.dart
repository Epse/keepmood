import 'package:flutter/material.dart';
import '../sentiment.dart';

class MoodEvent extends StatelessWidget {
  MoodEvent({Key key, @required this.recording, @required this.onDelete})
      : super(key: key);

  final SentimentRecording recording;
  final ValueSetter<int> onDelete;
  void _delete() => onDelete(recording.id);

  bool notNull(Object o) => o != null;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
            children: <Widget>[
      ListTile(
          title: Text(sentimentString(recording.sentiment)),
          subtitle: Text(
              recording.time.difference(new DateTime.now()).inDays.toString() +
                  " Days ago")),
      (recording.comment != "") ? new Text(recording.comment) : null,
      new ButtonTheme.bar(
          child: new ButtonBar(
        children: <Widget>[
          FlatButton(
            child: Text("Delete"),
            onPressed: _delete,
          )
        ],
      ))
    ].where(notNull).toList()));
  }
}

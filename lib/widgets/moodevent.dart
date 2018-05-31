import 'package:flutter/material.dart';
import '../sentiment.dart';

class MoodEvent extends StatelessWidget {
  MoodEvent({Key key, @required this.recording, @required this.onDelete})
      : super(key: key);

  final SentimentRecording recording;
  final ValueSetter<int> onDelete;
  void _delete() => onDelete(recording.id);

  bool notNull(Object o) => o != null;

  String timeDifferenceString(DateTime time) {
    int days = new DateTime.now().difference(time).inDays;
    if (days == 0) {
      int hours = new DateTime.now().difference(time).inHours;
      if (hours == 1) {
        return hours.toString() + " hour ago";
      }
      if (hours > 1) {
        return hours.toString() + " hours ago";
      }
      int minutes = new DateTime.now().difference(time).inMinutes;
      if (minutes == 1) {
        return minutes.toString() + " minute ago";
      }
      return minutes.toString() + " minutes ago";
    }
    if (days == 1) {
      return days.toString() + " day ago";
    }
    return days.toString() + " days ago";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
            children: <Widget>[
      ListTile(
          title: Text(sentimentString(recording.sentiment)),
          subtitle: Text(timeDifferenceString(recording.time))),
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

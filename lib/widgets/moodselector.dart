import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../sentiment.dart';

class MoodSelector extends StatelessWidget {
  MoodSelector({Key key, @required this.onSelected}) : super(key: key);

  final ValueSetter<SentimentRecording> onSelected;
  String comment = "";
  TextEditingController controller = new TextEditingController();

  void _handleSentiment(Sentiment sentiment) {
    onSelected(new SentimentRecording(sentiment, new DateTime.now(),
        comment: comment));
    controller = new TextEditingController();
  }

  void _commentChanged(String newComment) {
    comment = newComment;
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: Container(
            child: Column(
      children: <Widget>[
        ListTile(
            title: Text("How do you feel?"),
            subtitle: TextField(
              controller: controller,
              onChanged: _commentChanged,
              decoration: new InputDecoration(
                hintText: "Comment",
              ),
            )),
        ButtonTheme.bar(
            child: ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
                onPressed: () => _handleSentiment(Sentiment.veryUnhappy),
                icon: Icon(Icons.sentiment_very_dissatisfied),
                iconSize: 40.0,
                color: Colors.red),
            IconButton(
                onPressed: () => _handleSentiment(Sentiment.unhappy),
                icon: Icon(Icons.sentiment_dissatisfied),
                iconSize: 40.0,
                color: Colors.orange),
            IconButton(
                onPressed: () => _handleSentiment(Sentiment.neutral),
                icon: Icon(Icons.sentiment_neutral),
                iconSize: 40.0,
                color: Colors.blueGrey),
            IconButton(
                onPressed: () => _handleSentiment(Sentiment.happy),
                icon: Icon(Icons.sentiment_satisfied),
                iconSize: 40.0,
                color: Colors.blue),
            IconButton(
                onPressed: () => _handleSentiment(Sentiment.veryHappy),
                icon: Icon(Icons.sentiment_very_satisfied),
                iconSize: 40.0,
                color: Colors.green),
          ],
        )),
      ],
    )));
  }
}

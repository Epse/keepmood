import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'sentiment.dart';

class MoodSelector extends StatelessWidget {
  MoodSelector({Key key, @required this.onSelected}) : super(key: key);

  final ValueSetter<Sentiment> onSelected;

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
        ListTile(
          title: Text("How do you feel?"),
        ),
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

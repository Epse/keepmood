import 'package:flutter/material.dart';

import 'views/moodview.dart';

void main() => runApp(new KeepMood());

class KeepMood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'KeepMood',
        home: new MoodView(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ));
  }
}


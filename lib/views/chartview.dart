import 'package:flutter/material.dart';

import '../widgets/moodchart.dart';
import '../moodstorage.dart';

class ChartView extends StatefulWidget {
  @override
  createState() => new ChartViewState();
}

class ChartViewState extends State<ChartView> {
  final MoodStorage storage = new MoodStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Charts"),
      ),
      body: Center(child: Text("Test"))
    );
  }

  @override
  void dispose() {
    storage.close();
    super.dispose();
  }
}

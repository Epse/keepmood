import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import 'sentiment.dart';

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
              "CREATE TABLE $_table (id INTEGER PRIMARY KEY, sentiment TEXT, comment TEXT, timestamp TEXT);");
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
        columns: ["id", "sentiment", "comment", "timestamp"],
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
    await database.query(_table, columns: ["id", "sentiment", "comment", "timestamp"]);
    List<SentimentRecording> list = new List<SentimentRecording>();
    for (var map in maps) {
      list.add(new SentimentRecording.fromMap(map));
    }
    return list;
  }

  Future<List<SentimentRecording>> getRecordingsSinceMonth(DateTime start) async {
    if (database == null) {
      await initDatabase();
    }
    List<Map> maps =
        await database.query(_table, columns: ["id", "sentiment", "comment", "timestamp"],
        where: "timestamp > date(?, 'start of month')", whereArgs: [start.toIso8601String()]);

    List<SentimentRecording> list = new List<SentimentRecording>();
    if (maps == null) {
      return list;
    }
    for (var map in maps) {
      list.add(new SentimentRecording.fromMap(map));
    }
    return list;
  }

  Future<List<SentimentRecording>> getRecordingsSinceDay(DateTime start) async {
    if (database == null) {
      await initDatabase();
    }
    List<Map> maps =
    await database.query(_table, columns: ["id", "sentiment", "comment", "timestamp"],
        where: "timestamp > date(?, 'start of day')", whereArgs: [start.toIso8601String()]);

    List<SentimentRecording> list = new List<SentimentRecording>();
    if (maps == null) {
      return list;
    }
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

  Future<int> delete(final int id) async {
    if (database == null) {
      await initDatabase();
    }
    return await database.delete(_table, where: "id = ?", whereArgs: [id]);
  }

  Future close() async {
    if (database != null) {
      await database.close();
      return;
    }
    return;
  }
}


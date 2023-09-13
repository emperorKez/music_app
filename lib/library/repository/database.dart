// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:core';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  //  late Database _db;

  Future initializeDb() async {
    // Directory appDir = await getApplicationDocumentsDirectory();
    String dir = await getDatabasesPath();
    String dbpath = join(dir, 'database.db');

    return await openDatabase(dbpath, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE played_count (id INTEGER PRIMARY KEY, song_id INTEGER, count INTEGER)');
  }

  // Update played count record
  void updatePlayedCount({required int songId}) async {
    final Database db = await initializeDb();
    List<Map<String, dynamic>> maps = await db.query('played_count',
        columns: ['count', 'song_id'], where: '${"song_id"} = ?', whereArgs: [songId]);
    
    if (maps.isNotEmpty) {
      PlayedCountData existingData = PlayedCountData.fromMap(maps.first);
      int newCount = existingData.count + 1;
      await db.update('played_count', {'count': newCount},
          where: '${"song_id"} = ?', whereArgs: [songId]);
    } else {
      await db.insert('played_count', {'song_id': songId, 'count': 1});
    }
  }

  Future<List<PlayedCountData>>? fetchCountData() async {
    final Database db = await initializeDb();
    var data = await db.query('played_count',
        columns: ['count', 'song_id'], orderBy: 'count DESC');
    List<PlayedCountData> playedCountList = [];
    for (var item in data) {
      playedCountList.add(PlayedCountData.fromMap(item));
    }
    return playedCountList;
  }
}

class PlayedCountData {
  int songId;
  int count;
  PlayedCountData({
    required this.songId,
    required this.count,
  });

  factory PlayedCountData.fromMap(Map<String, dynamic> data) =>
      PlayedCountData(count: data['count'], songId: data['song_id']);

  Map<String, dynamic> toMap() => {
        "song_id": songId,
        "count": count,
      };
}

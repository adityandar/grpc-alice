// ignore_for_file: unnecessary_new

import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'package:grpc_alice/src/log_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    final documentsDirectory = Platform.isIOS ? await getApplicationSupportDirectory() : await getExternalStorageDirectory();
    String path = join(documentsDirectory!.path, "DblogGrpc.db");
    // print("db path $path");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute("CREATE TABLE log(id INTEGER PRIMARY KEY, stack TEXT, created_at DateTime, type TEXT, ref TEXT)");
    // print("Created tables");
  }

  Future<void> saveLogModel(LogModel log) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      var _data =
          'INSERT INTO log(stack, created_at, type, ref) VALUES(\'${log.stack}\', \'${log.createdAt!.toIso8601String()}\', \'${log.type}\', \'${log.ref}\')';
      // print(_data);
      return await txn.rawInsert(_data);
    });
  }

  Future<List<LogModel>> getLogModels() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM log  order by created_at desc limit 100');
    // print("list $list");
    List<LogModel> logs = [];
    for (int i = 0; i < list.length; i++) {
      logs.add(
          LogModel(id: list[i]["id"], type: list[i]["type"], ref: list[i]["ref"], stack: list[i]["stack"], createdAt: DateTime.parse(list[i]["created_at"])));
    }
    // print(logs.length);
    return logs;
  }
}

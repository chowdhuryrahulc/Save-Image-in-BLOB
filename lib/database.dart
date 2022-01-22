// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:save_image_in_blob/pictureModalClass.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? _db;
  static String ID = 'id';
  static String NAME = 'photoName';
  static String TABLE = 'PhotoTable';
  static String DB_NAME = 'photos.db';

  Future<Database> get db async {
    if (null != _db) {
      return _db!;
    }
    _db = await initDB();
    return _db!;
  }

  initDB() async {
    io.Directory docomentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(docomentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Picture($ID INTEGER, picture BLOB )");
  }

  Future<Picture> savePicture(Picture picture) async {
    var dbClient = await db;
    picture.id = await dbClient.insert("Picture", picture.toMap());
    return picture;
  }

  Future<List<Picture>> getPictures() async {
    var dbClient = await db;
    List<Map<String, dynamic>> list =
        await dbClient.rawQuery('SELECT * FROM Picture');
    List<Picture> pictures = [];
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        pictures.add(Picture.fromMap(list[i]));
      }
    }
    return pictures;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}

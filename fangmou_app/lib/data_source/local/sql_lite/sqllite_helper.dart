import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../utils/constants/constants.dart';

class SqfliteHelper {
  static final _databaseName = "fangmou_database.db";
  static final _databaseVersion = 3;

  // 单例模式
  static Database? _database;

  static Database get database {
    return _database!;
  }

  static Future<void> initDatabase() async {
    // 在app路径下创建数据文件
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    logger.d(documentsDirectory);

    if (Platform.isWindows) {
      sqfliteFfiInit(); // 初始化 FFI
      databaseFactory = databaseFactoryFfi; // 设置数据库工厂
    }

    _database = await openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // 创建表
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE note_basic_message (
  id String PRIMARY KEY,
  deletion_flag BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL,
  last_update_at TIMESTAMP NOT NULL,
  deleted_at TIMESTAMP NOT NULL,
  title TEXT NOT NULL,
  excerpt TEXT NOT NULL,
  note_type INTEGER NOT NULL
)
''');

    await db.execute('''
CREATE TABLE note_main (
  id String PRIMARY KEY,
  deletion_flag BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL,
  last_update_at TIMESTAMP NOT NULL,
  deleted_at TIMESTAMP NOT NULL,
  main TEXT NOT NULL
)
''');

    await db.execute(createTableTemplateRecord);
  }

  // 数据库升级
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 2) {
      await db.execute(createTableTemplateRecord);
    }
  }


 static String get createTableTemplateRecord=>'''
CREATE TABLE template_record (
  id TEXT(32) NOT NULL  ,
  times INTEGER NOT NULL DEFAULT 0 ,
  last TEXT NOT NULL  
);
  ''';
}

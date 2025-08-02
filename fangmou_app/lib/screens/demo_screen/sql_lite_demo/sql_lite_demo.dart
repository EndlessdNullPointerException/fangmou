import 'package:fangmou_app/model/note_model/note_basic_message.dart';
import 'package:fangmou_app/utils/data_generator_utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../../../data_source/local/sql_lite/note_local.dart';
import '../../../data_source/local/sql_lite/sqllite_helper.dart';
import '../../../utils/constants/constants.dart';

class SqlLiteDemo extends StatefulWidget {
  const SqlLiteDemo({super.key});

  @override
  State<StatefulWidget> createState() => SqlLiteDemoState();
}

class SqlLiteDemoState extends State<SqlLiteDemo> {
  final noteLocal = GetIt.I.get<NoteLocal>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              Database db = SqfliteHelper.database;

              // 查询所有用户
              List<Map<String, Object?>> list = await db.query('note_basic_message');

              for (final item in list) {
                NoteBasicMessage note = NoteBasicMessage.fromJson(item);
                logger.d('┏━━━━━━━━━━━━━━━${note.id}━━━━━━━━━━━━━━━━━┓');
                logger.d(note.title);
                logger.d(note.excerpt);
                logger.d('┗━━━━━━━━━━━━━━━${note.id}━━━━━━━━━━━━━━━━━┛');
              }
              logger.d(list.length);
            },
            child: Text("查询"),
          ),
          ElevatedButton(
            onPressed: () async {
              String id = generateUuid32();
              String now = DateTime.now().toIso8601String();
              String main = generateRandomString(500, 1000);
              String excerpt = main.length > 300 ? main.substring(0, 300).trimRight() : main;
              String title = generateRandomString(10, 20);
              int noteType = 0;

              await noteLocal.insertOrUpdateNote(
                id: id,
                now: now,
                excerpt: excerpt,
                title: title,
                noteType: noteType,
                main: main,
              );
            },
            child: Text("插入"),
          ),
          ElevatedButton(
            onPressed: () async {
              Database db = SqfliteHelper.database;

              logger.d('┏━━━━━━━━━━━━━━━━根据 id 获取━━━━━━━━━━━━━━━━┓');
              List<Map<String, Object?>>? list = await db.query(
                'note_basic_message',
                where: 'id = ?',
                whereArgs: ['b07ceff0e3fe4c61ba4f112fefd59550'],
              );

              if (list.isNotEmpty) {
                NoteBasicMessage note = NoteBasicMessage.fromJson(list[0]);
                logger.d('┏━━━━━━━━━━━━━━━${note.id}━━━━━━━━━━━━━━━━━┓');
                logger.d(note.title);
                logger.d(note.excerpt);
                logger.d('┗━━━━━━━━━━━━━━━${note.id}━━━━━━━━━━━━━━━━━┛');
              }

              logger.d('┗━━━━━━━━━━━━━━━━根据 id 获取━━━━━━━━━━━━━━━━┛');
            },
            child: Text("根据 id 获取"),
          ),
          ElevatedButton(
            onPressed: () async {
              Database db = SqfliteHelper.database;

              logger.d('┏━━━━━━━━━━━━━━━━根据 id 修改━━━━━━━━━━━━━━━━┓');
              await db.update(
                'note_basic_message',
                {"title": "临江仙", "excerpt": "滚滚长江东逝水，浪花淘尽英雄。是非成败转头空。青山依旧在，几度夕阳红。白发渔樵江渚上，惯看秋月春风。一壶浊酒喜相逢。古今多少事，都付笑谈中。"},
                where: 'id = ?',
                whereArgs: ['b07ceff0e3fe4c61ba4f112fefd59550'],
              );
              logger.d('┗━━━━━━━━━━━━━━━━根据 id 修改━━━━━━━━━━━━━━━━┛');
            },
            child: Text("根据 id 修改"),
          ),
          ElevatedButton(
            onPressed: () async {
              Database db = SqfliteHelper.database;

              logger.d('┏━━━━━━━━━━━━━━━━根据 id 删除━━━━━━━━━━━━━━━━┓');
              int? result = await db.delete(
                'note_basic_message',
                where: 'id = ?',
                whereArgs: ['b07ceff0e3fe4c61ba4f112fefd59550'],
              );
              logger.d(result);
              logger.d('┗━━━━━━━━━━━━━━━━根据 id 删除━━━━━━━━━━━━━━━━┛');
            },
            child: Text("根据 id 删除"),
          ),
        ],
      ),
    );
  }
}

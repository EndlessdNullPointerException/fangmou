import 'package:fangmou_app/data_source/local/sql_lite/sqllite_helper.dart';
import 'package:fangmou_app/model/note_model/note_basic_message.dart';
import 'package:fangmou_app/model/note_model/note_main.dart';

class NoteLocal {
  Future<NoteBasicMessage> getNoteBasicMessageById(String id) async {
    NoteBasicMessage? result = NoteBasicMessage.defaultValue();

    List<Map<String, Object?>> noteBasicMessageMapList = await SqfliteHelper.database.query(
      'note_basic_message',
      where: 'id = ? AND deletion_flag != "true"',
      whereArgs: [id],
      columns: [
        "id AS id",
        "created_at AS createdAt",
        "last_update_at AS lastUpdateAt",
        "title AS title",
        "excerpt AS excerpt",
        "note_type AS noteType",
      ],
    );

    if (noteBasicMessageMapList.isNotEmpty) {
      result = NoteBasicMessage.fromJson(noteBasicMessageMapList[0]);
    }

    return result;
  }

  Future<NoteMain> getNoteMainById(String id) async {
    NoteMain? result = NoteMain.defaultValue();

    List<Map<String, Object?>> noteMainMapList = await SqfliteHelper.database.query(
      'note_main',
      where: 'id = ? AND deletion_flag != "true"',
      whereArgs: [id],
      columns: ["id AS id", "created_at AS createdAt", "last_update_at AS lastUpdateAt", "main AS main"],
    );

    if (noteMainMapList.isNotEmpty) {
      result = NoteMain.fromJson(noteMainMapList[0]);
    }

    return result;
  }

  Future<List<NoteBasicMessage>> getNoteBasicMessageList({
    String? sortBy,
    String? sortDirection,
    String? keyword,
  }) async {
    List<NoteBasicMessage> result = [];

    String keywordSQL = keyword != null && keyword.isNotEmpty ? " AND (title LIKE ? OR excerpt LIKE  ?)" : "";

    // 查询所有用户
    List<Map<String, Object?>> noteBasicMessageMapList = await SqfliteHelper.database.query(
      'note_basic_message',
      columns: [
        "id AS id",
        "created_at AS createdAt",
        "last_update_at AS lastUpdateAt",
        "title AS title",
        "excerpt AS excerpt",
        "note_type AS noteType",
      ],
      where: 'deletion_flag != "true"$keywordSQL',
      whereArgs: keywordSQL.isNotEmpty ? ["%$keyword%", "%$keyword%"] : null,
      orderBy: sortBy != null && sortDirection != null ? "$sortBy $sortDirection" : null,
    );

    for (final item in noteBasicMessageMapList) {
      NoteBasicMessage noteBasicMessage = NoteBasicMessage.fromJson(item);
      result.add(noteBasicMessage);
    }

    return result;
  }

  /// 插入或更新数据，并返回相关数据
  Future<void> insertOrUpdateNote({
    required String id,
    required String now,
    required String excerpt,
    required String title,
    required int noteType,
    required String main,
  }) async {
    await SqfliteHelper.database
        .transaction((txn) async {
          await txn.rawInsert('''
      INSERT INTO note_basic_message(id, created_at,last_update_at,deleted_at,title,excerpt,note_type)
      VALUES (?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(id) DO UPDATE SET last_update_at = ?,title= ?,excerpt= ?,note_type= ?
    ''', [id, now, now, now, title, excerpt, noteType] + [now, title, excerpt, noteType]);

          await txn.rawInsert('''
      INSERT INTO note_main(id, created_at,last_update_at,deleted_at,main)
      VALUES (?, ?, ?, ?, ?)
      ON CONFLICT(id) DO UPDATE SET last_update_at = ?, main = ?
    ''', [id, now, now, now, main] + [now, main]);
        })
        .catchError((error) {
          throw error.toString();
        });
  }

  Future<void> logicDeleteById(List<String> deleteIdList) async {
    String conditionPosition = "?${",?" * (deleteIdList.length - 1)}";

    await SqfliteHelper.database.transaction((txn) async {
      String now = DateTime.now().toIso8601String();
      await txn.update(
        'note_basic_message',
        {"deletion_flag": "true", "deleted_at": now},
        where: 'id in ($conditionPosition)',
        whereArgs: deleteIdList,
      );
      await txn.update(
        'note_main',
        {"deletion_flag": "true", "deleted_at": now},
        where: 'id in ($conditionPosition)',
        whereArgs: deleteIdList,
      );
    });
  }

  Future<void> deleteByDeletionFlag(List<String> deleteIdList) async {
    await SqfliteHelper.database.transaction((txn) async {
      await txn.delete('note_basic_message', where: 'deletion_flag = true');
      await txn.delete('note_main', where: 'deletion_flag = true');
    });
  }
}

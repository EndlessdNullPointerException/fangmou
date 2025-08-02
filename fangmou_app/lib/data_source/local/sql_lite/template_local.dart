import 'package:fangmou_app/data_source/local/sql_lite/sqllite_helper.dart';

typedef GetById = Future<Map<String, dynamic>> Function(String);

class TemplateLocal {
  // 根据 id 更新数据
  updateById(String id) async {
    // 查询旧数据
    List<Map<String, dynamic>> old = await SqfliteHelper.database.query(
      "template_record",
      where: "id = ?",
      whereArgs: [id],
      columns: ["times"],
    );
    int times = old[0]["times"] + 1;

    return await SqfliteHelper.database.update("template_record", {"times": times}, where: "id = ?", whereArgs: [id]);
  }

  // 根据 id 查询 template_record，如果对应的template_record不存在，则创建一条对应的补 template_record 数据，并返回这条新创建的数据
  Future<Map<String, Object?>> queryAndDataComplete(String id) async {
    getById(String id) async {
      return await SqfliteHelper.database.query("template_record", where: "id = ?", whereArgs: [id]);
    }

    List<Map<String, dynamic>> list = await getById(id);

    if (list.isEmpty) {
      String dateTime = DateTime.now().toIso8601String();
      SqfliteHelper.database.insert("template_record", {"id": id, "last": dateTime, "times": 0});
      list = await getById(id);
    }

    return list.first;
  }
}

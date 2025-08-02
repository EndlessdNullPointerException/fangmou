// 一个安全创建文件并写入内容的函数

import 'dart:io';

import 'constants/constants.dart';

Future<void> safeCreateFile(Map<String, String> pathContentMap) async {
  try {
    for (String path in pathContentMap.keys) {
      String content = pathContentMap[path]!;
      // 1. 根据给定的路径创建一个 File 对象
      final file = File(path);

      // 2. 获取该文件所在的目录 (file.parent)
      final directory = file.parent;

      // 3. 检查目录是否存在
      if (!await directory.exists()) {
        // 4. 如果目录不存在，则使用 recursive: true 递归创建所有父目录
        logger.d('目录不存在，正在创建: ${directory.path}');
        await directory.create(recursive: true);
      }

      // 5. 现在可以安全地向文件写入内容了
      //    writeAsString 会自动创建文件（如果文件本身不存在）
      await file.writeAsString(content);
    }
  } catch (e) {
    logger.e('发生错误: $e');
    rethrow;
  }
}

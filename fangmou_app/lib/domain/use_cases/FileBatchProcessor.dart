import 'dart:io';

import 'package:fangmou_app/utils/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import '../../utils/platform/windows/file_utils.dart';

class FileBatchProcessor {
  // 根据文件前缀重新整理文件夹
  fileBatchRemoveByPrefix(String directoryPath, WidgetRef ref) async {
    logger.d("选择的文件夹路径: $directoryPath");
    List<Directory> subDirectories = await FileUtils.getSubDirectories(directoryPath);

    // 处理路径逻辑
    if (subDirectories.isNotEmpty) {
      Map<String, List<Directory>> prefixMap = {};

      for (var dir in subDirectories) {
        var fullPath = dir.path;
        var thePath = path.basename(dir.path);
        logger.d('子文件夹完整路径: $fullPath');
        logger.d("子文件夹路径: $thePath");
        int index = thePath.indexOf("]");
        if (index != -1) {
          String prefix = thePath.substring(0, index + 1);
          logger.d("前缀为: $prefix");
          if (prefix != thePath) {
            if (prefixMap.containsKey(prefix)) {
              prefixMap[prefix]?.add(dir);
            } else {
              prefixMap[prefix] = [dir];
            }
          } else {
            logger.d("前缀等于要移动的文件夹，不进行操作");
          }
        }
      }

      if (prefixMap.isNotEmpty) {
        for (var prefix in prefixMap.keys) {
          // 拼接完整路径
          final fullPath = '${directoryPath.endsWith('/') ? directoryPath : '$directoryPath/'}$prefix';

          // 创建 Directory 对象
          final directory = Directory(fullPath);

          // 创建目录（recursive: true 可自动创建父级目录）
          await directory.create(recursive: true);

          for (Directory dir in prefixMap[prefix]!) {
            var thePath = path.basename(dir.path);
            var targetPath = "${directory.path}/$thePath";
            logger.d("进行移动，目标文件夹为:$targetPath");
            await dir.rename(targetPath);
          }
        }
      }
    }
  }
}

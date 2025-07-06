import 'dart:io';

import 'package:fangmou_app/screens/function_directory_screen/model/process_mode.dart';
import 'package:fangmou_app/utils/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import '../../utils/platform/windows/file_utils.dart';

class FileBatchProcessor {
  // 根据文件前缀重新整理文件夹
  fileBatchRemoveByPrefix(String directoryPath, WidgetRef ref, ProcessMode processMode) async {
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

        String prefix = "";
        switch (processMode) {
          case ProcessMode.manga:
            prefix = prefixManga(thePath);
            break;
          case ProcessMode.photography:
            prefix = prefixPhotography(thePath);
            break;
        }

        logger.d("前缀为: $prefix");
        if (prefix.isNotEmpty) {
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

  String prefixManga(String path) {
    int leftBracketIndex = path.indexOf("[");
    int rightBracketIndex = path.indexOf("]") + 1;
    return leftBracketIndex != -1 && rightBracketIndex != -1 ? path.substring(leftBracketIndex, rightBracketIndex) : "";
  }

  String prefixPhotography(String path) {
    if (path == "梓末－私密助理") {
      logger.d("-------------");
      logger.d(path.indexOf("－"));
      logger.d(path.indexOf("-"));
      logger.d("-------------");
    }

    trimSpace(String s, i) {
      s = path.substring(0, i);
      while (true) {
        if (s.endsWith(" ")) {
          s = s.trimRight();
        } else {
          break;
        }
      }
      return s;
    }

    int index = path.indexOf("-");
    if (index != -1) {
      return trimSpace(path, index);
    }

    index = path.indexOf("－");
    if (index != -1) {
      return trimSpace(path, index);
    }

    index = path.indexOf(" ");
    if (index != -1) {
      return trimSpace(path, index);
    }

    index = path.indexOf("_");
    if (index != -1) {
      return trimSpace(path, index);
    }

    return "";
  }
}

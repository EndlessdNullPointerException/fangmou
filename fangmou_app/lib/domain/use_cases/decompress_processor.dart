import 'dart:io';

import 'package:fangmou_app/utils/constants/constants.dart';
import 'package:fangmou_app/utils/platform/windows/file_utils.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;

import '../../repositories/local/ArchiveFilePasswordList.dart';

class DecompressProcessor {
  static const List<String> compressFileType = ['.7z', '.zip', '.rar', '.part1.rar', '.rar.001', '.7z.001', '.zip.001', '.z01'];

  // 获取指定文件夹下的所有压缩文件（7z、zip、rar）
  // 通过参数可以设置是否包含后代目录
  Future<List<File>> getCompressedFiles(String directoryPath, bool recursive) async {
    final dir = Directory(directoryPath);

    // 检查目录是否存在
    if (!await dir.exists()) {
      logger.d("目录不存在: $directoryPath");
      return [];
    }

    final List<File> compressedFiles = [];
    try {
      final fileList = dir.list(recursive: recursive);

      // 监听目录中的文件系统实体
      await for (final entity in fileList) {
        if (entity is File) {
          final File file = entity;

          // 将符合类型的文件添加到待解压列表
          for (String extension in compressFileType) {
            final filePath = file.path.toLowerCase();

            if (filePath.endsWith(extension)) {
              // region <- Logic:对分卷的 rar 格式以及 zip 格式文件进行去重处理 ->

              // 除去rar格式的分卷文件
              if (filePath.endsWith("rar") && filePath.contains("part")) {
                final num = filePath.substring(filePath.lastIndexOf("part") + 4, filePath.lastIndexOf("rar") - 1);
                if (int.parse(num) > 1) {
                  continue;
                }
              }

              // 如果当前文件后缀为 z01，查找在相同路径下，是否存在文件名相同，且后缀不同zip文件
              // 如果存在，z01 文件将不进入解压序列
              if (filePath.endsWith("z01")) {
                final zipList = Directory(file.parent.path).list();
                bool flag = false;
                await for (FileSystemEntity f in zipList) {
                  logger.d("====st======");
                  logger.d(f.path.split(".").first.toLowerCase());
                  logger.d(filePath.split(".").first);
                  logger.d(p.extension(f.path.toLowerCase()));
                  logger.d(p.extension(f.path.toLowerCase()) == "zip");
                  logger.d("=====ed=====");

                  if (f.path.split(".").first.toLowerCase() == filePath.split(".").first && p.extension(f.path.toLowerCase()) == ".zip") {
                    flag = true;
                    break;
                  }
                }
                if (flag) {
                  continue;
                }
              }

              // endregion <- Logic:对分卷的 rar 格式以及 zip 格式文件进行去重处理 ->
              compressedFiles.add(file);
            }
          }
        }
      }
    } catch (e) {
      logger.d("读取目录出错: $e");
    } finally {}

    return compressedFiles;
  }

  // 执行解压操作
  Future<void> extractArchive(File compressedFile, List<String> passwordList) async {
    String path = compressedFile.path.split('.').first;
    String temporaryDirectory = "${compressedFile.parent.path}\\${FileUtils.generateRandomTemporaryDirectory(compressedFile)}";

    try {
      // 列出目录内容（不递归）
      final List<FileSystemEntity> entities = await compressedFile.parent.list().toList();

      // region  删除分卷压缩文件的预处理
      List<File> deleteFileList = [];
      for (FileSystemEntity entity in entities) {
        if (entity is File) {
          File f = entity;
          if (f.path.split(".").first == compressedFile.path.split(".").first) {
            deleteFileList.add(f);
          }
        }
      }
      // endregion

      // region <- Logic: 使用密码表解压文件->
      int i = 0;
      for (String password in passwordList) {
        i++;
        String result = await executeExtract(compressedFile.path, temporaryDirectory, password);

        if (result == "success") break;

        if (result == "wrongPassword" && i == passwordList.length) throw "无可用密码";
        if (result == "wrongPassword") continue;

        throw result;
      }
      // endregion <- Logic: 使用密码表解压文件->

      // region <- Logic:修改目录结构 ->
      // 如果出现重复目录，则在重复目录后添加后缀
      // 如果文件夹下只含有一个文件夹，且不包含其他文件，则将这两个文件夹合并
      // 如果文件夹下只含有一个文件直接将文件放到压缩文件所在的目录
      if (Directory(path).existsSync()) {
        logger.d(path);
        path = "$path-${FileUtils.generateRandomTemporaryDirectory(compressedFile)}";
      }

      final Map<String, dynamic> flagPath = await notSingleFolder(temporaryDirectory);

      if (flagPath["result"] == "isFile") {
        final insideFile = flagPath["file"];
        String insideFileName = insideFile.path.split('\\').last;

        final List<FileSystemEntity> entities = await compressedFile.parent.list().toList();
        if (uniqueFileName(entities, insideFile)) {
          await flagPath["file"].rename("${compressedFile.parent.path}\\$insideFileName");
        } else {
          await flagPath["file"].rename("${compressedFile.parent.path}\\${FileUtils.generateRandomTemporaryDirectory(compressedFile)}-$insideFileName");
        }
      } else if (flagPath["result"] == "isDirectory") {
        await Directory(flagPath["directory"]).rename(path);
      } else {
        await Directory(temporaryDirectory).rename(path);
      }
      // endregion <- Logic:修改目录结构 ->

      // region <- Logic:删除解压成功的文件 ->
      // 删除解压成功的文件，dart 删除无法找回，所以解压前必须备份
      if (compressedFile.path.endsWith('.7z')) {
        compressedFile.deleteSync();
      } else {
        for (File file in deleteFileList) {
          file.deleteSync();
        }
      }
      // endregion <- Logic:删除解压成功的文件 ->
    } catch (e) {
      logger.d("解压失败");
      logger.e(e);
      throw Exception("解压失败");
    } finally {
      logger.d("解压结束");
      // region <- Logic:删除创建的临时文件夹 ->
      if (Directory(temporaryDirectory).existsSync()) {
        Future.delayed(const Duration(microseconds: 500));
        Directory(temporaryDirectory).deleteSync(recursive: true);
      }
      // endregion <- Logic:删除创建的临时文件夹 ->
    }
  }

  // 使用 process-on 执行 7-zip 解压命令
  Future<String> executeExtract(String compressedFilePath, String outputPath, String password, {bool notArchive = false}) async {
    try {
      List<String> args;
      if (notArchive) {
        args = ['x', '-t#', compressedFilePath, '-o$outputPath', '-i!*.zip', '-p$password'];
      } else {
        args = ['x', '-y', compressedFilePath, '-o$outputPath', '-p$password'];
      }

      // 执行的解压命令
      logger.d("${FileUtils.executable_7z.path} ${args.join(" ")}");

      final result = await Process.run(FileUtils.executable_7z.path, args, runInShell: true);

      // 获取退出状态码
      final exitCode = result.exitCode;
      final String errorMessage = result.stderr;

      // 根据状态码处理结果
      if (exitCode == 0) {
        logger.d('解压成功');
        return "success";
      }

      if (errorMessage.contains("Wrong password")) {
        logger.d("解压密码:$password错误");
        logger.d(result.stderr);
        return "wrongPassword";
      }
      if (errorMessage.contains("Is not archive")) {
        return executeExtract(compressedFilePath, outputPath, password, notArchive: true);
      }

      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e);
    }
  }

  // 检查指定文件夹下是否只含有一个文件夹或文件，且不包含其他文件
  Future<Map<String, dynamic>> notSingleFolder(String path) async {
    try {
      final dir = Directory(path);
      // 列出目录内容（不递归）
      final List<FileSystemEntity> entities = await dir.list().toList();

      if (entities.length > 1 || entities.isEmpty) {
        return {"result": "default"};
      } else {
        String path = entities.first.path;
        if (await FileSystemEntity.isFile(path)) {
          return {"result": "isFile", "file": entities.first};
        } else {
          return {"result": "isDirectory", "directory": path};
        }
      }
    } catch (e) {
      logger.e('检查出错: $e');
      return {"result": "error"}; // 权限错误等异常情况，视为不符合条件
    }
  }

  // 将新的解压密码保存到本地
  Future<bool> savePassword(List<String> passwordList) async {
    // 获取 Box
    final box = Hive.box<ArchiveFilePasswordList>('ArchiveFilePasswordList');

    box.put('ArchiveFilePasswordList', ArchiveFilePasswordList(passwordList: passwordList)); // 对象

    return false;
  }

  bool uniqueFileName(List<FileSystemEntity> entities, File file) {
    for (FileSystemEntity entity in entities) {
      if (entity is File) {
        File f = entity;
        if (f.path.split('\\').last == file.path.split('\\').last) {
          return false;
        }
      }
    }
    return true;
  }

  // 从本地获取解压密码
  Future<List<String>> getPassword() async {
    // 获取 Box
    final box = Hive.box<ArchiveFilePasswordList>('ArchiveFilePasswordList');

    // 读取数据
    final data = box.get('ArchiveFilePasswordList')?.passwordList;

    if (data == null) {
      return [];
    }
    return data;
  }
}

import 'dart:convert';
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
  Future<List<File>> getCompressedFiles(String directoryPath, {required bool decompressAllTypeFile, required bool decompressDescendantFolder}) async {
    final dir = Directory(directoryPath);

    // 检查目录是否存在
    if (!await dir.exists()) {
      logger.d("目录不存在: $directoryPath");
      return [];
    }

    final List<File> compressedFiles = [];
    try {
      final fileList = dir.list(recursive: decompressDescendantFolder);

      // 监听目录中的文件系统实体
      await for (final entity in fileList) {
        if (entity is File) {
          final File file = entity;

          if (decompressAllTypeFile) {
            compressedFiles.add(file);
          } else {
            // 将符合类型的文件添加到待解压列表

            final filePath = file.path.toLowerCase();

            // region <- Logic:对分卷的 rar 格式以及 zip 格式文件进行去重处理 ->

            // 除去rar格式的分卷文件
            if (filePath.endsWith("rar") && filePath.contains("part")) {
              try {
                final num = int.parse(filePath.substring(filePath.lastIndexOf("part") + 4, filePath.lastIndexOf("rar") - 1));
                if (num > 1) {
                  continue;
                }
              } catch (e) {
                logger.d(e);
              }
            }

            // 除去 7z格式的分卷文件
            if (filePath.contains(".7z.")) {
              try {
                final num = int.parse(filePath.split(".").last);
                if (num > 1) {
                  continue;
                }
              } catch (e) {
                logger.d(e);
              }
            }

            // 如果当前文件后缀为 z01，查找在相同路径下，是否存在文件名相同，且后缀不同zip文件
            // 如果存在，z01 文件将不进入解压序列
            if (filePath.endsWith("z01")) {
              final allFileList = Directory(file.parent.path).list();
              bool flag = false;
              await for (FileSystemEntity f in allFileList) {
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

            for (final extension in compressFileType) {
              if (filePath.endsWith(extension)) {
                compressedFiles.add(file);
              }
            }
          }
        }
      }
    } catch (e) {
      logger.d("读取目录出错: $e");
    }

    return compressedFiles;
  }

  // 执行解压操作
  Future<void> extractArchive(File compressedFile, List<String> passwordList, bool deleteOriginFile, bool decompressDescendantFolder) async {
    String fileName = compressedFile.path.replaceFirst("${compressedFile.parent.path}\\", "");
    String filePathWithoutSuffix = fileName.split('.').first;

    String temporary = FileUtils.generateRandomTemporaryDirectory(compressedFile);
    String temporaryDirectory = "${compressedFile.parent.path}\\$temporary";
    Directory(temporaryDirectory).create(recursive: true);

    try {
      // 创建临时解压文件夹
      Directory(temporaryDirectory).create(recursive: true);

      // 列出目录内容（不递归）
      final List<FileSystemEntity> entities = await compressedFile.parent.list().toList();

      // region <- Logic:删除分卷压缩文件的预处理 ->

      // 将同一目录下，文件名相同（不包括后缀部分）的所有文件，列为需要删除的文件
      List<File> deleteFileList = [];
      if (deleteOriginFile) {
        for (FileSystemEntity entity in entities) {
          if (entity is File) {
            String entityName = entity.path.replaceFirst("${entity.parent.path}\\", "");
            String entityNameWithoutSuffix = entityName.split('.').first;
            if (entityNameWithoutSuffix == filePathWithoutSuffix) {
              deleteFileList.add(entity);
            }
          }
        }
      }
      // endregion <- Logic:删除分卷压缩文件的预处理 ->

      // region <- Logic: 使用密码表解压文件->
      int i = 0;

      // 添加空密码
      passwordList.insert(0, "");
      for (String password in passwordList) {
        i++;
        //String result = await executeExtract(compressedFile.parent.path, fileName, temporary, password);
        String result = await executeExtractBandiZip(compressedFile.parent.path, fileName, temporary, password);

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

      final Map<String, dynamic> flagPath = await notSingleFolder(temporaryDirectory);

      String finalOutputPath = "";

      if (flagPath["result"] == "isFile") {
        // region <- Logic:解压后得到的是一个单独的文件 ->

        final insideFile = flagPath["file"];
        String insideFileName = insideFile.path.split('\\').last;

        final List<FileSystemEntity> entities = await compressedFile.parent.list().toList();

        // 将文件从临时文件夹中移出
        if (uniqueFileName(entities, insideFile)) {
          await flagPath["file"].rename("${compressedFile.parent.path}\\$insideFileName");
        } else {
          // 如果文件夹中已有同名文件，添加后缀进行区分
          await flagPath["file"].rename("${compressedFile.parent.path}\\$temporary-$insideFileName");
        }
        // endregion <- Logic:解压后得到的是一个单独的文件的处理 ->
      } else if (flagPath["result"] == "isDirectory") {
        // region <- Logic: 解压后得到的是一个单独的文件夹->
        String directory = flagPath["directory"];

        // 将文件夹从临时文件中取出
        String directoryWithoutTemporary = directory.replaceFirst("$temporary\\", "");

        // 如果存在同名文件夹，则添加后缀
        if (Directory(directoryWithoutTemporary).existsSync()) {
          directoryWithoutTemporary = "$directoryWithoutTemporary-$temporary";
        }
        await Directory(directory).rename(directoryWithoutTemporary);
        // endregion <- Logic: 解压后得到的是一个单独的文件夹->
        finalOutputPath = directoryWithoutTemporary;
      } else {
        // region <- Logic: 解压后得到的是多个文件夹或文件->
        // 存在同名文件夹时，添加后缀
        var outPutDirectory = "${compressedFile.parent.path}\\$filePathWithoutSuffix";
        if (Directory(outPutDirectory).existsSync()) {
          outPutDirectory = "$outPutDirectory-$temporary";
        }
        // 将临时文件夹该名，新文件名为去除后缀的压缩文件夹名
        logger.d("┏━━━━━━━━━━━━━━━━━━━━outPutDirectory━━━━━━━━━━━━━━━━━━━━┓");
        logger.d(outPutDirectory);
        logger.d("┗━━━━━━━━━━━━━━━━━━━━outPutDirectory━━━━━━━━━━━━━━━━━━━━┛");
        await Directory(temporaryDirectory).rename(outPutDirectory);
        // endregion <- Logic: ->
        finalOutputPath = outPutDirectory;
      }

      // region <- Logic:多级解压合并同名目录 ->
      // 前提条件1：开启多级解压
      // 前提条件2: 压缩文件所在目录的目录名，和压缩文件解压完成后得到的目录名相同
      // 前提条件3: 压缩文件所在目录的目录下，只有该压缩文件
      if (decompressDescendantFolder && finalOutputPath.isNotEmpty) {
        final parent = Directory(finalOutputPath).parent;

        final List<FileSystemEntity> entities = await parent.list().toList();

        var onlyDecompressFileFlag = true;

        // 如果父目录下存在[压缩文件本身(包括分卷压缩文件)、临时解压目录、解压后文件目录]之外的文件或文件夹
        // 那么不进行重命名操作
        for (final entity in entities) {
          var compressedFileFlag = false;

          for (final deleteFile in deleteFileList) {
            if (deleteFile.path == entity.path) {
              compressedFileFlag = true;
              break;
            }
          }

          if (compressedFileFlag || entity.path == finalOutputPath || entity.path == temporaryDirectory) {
            continue;
          }
          onlyDecompressFileFlag = false;
          break;
        }

        if (onlyDecompressFileFlag) {
          final List<FileSystemEntity> list = await Directory(finalOutputPath).list().toList();

          for (FileSystemEntity entity in list) {
            final entityFileName = entity.path.replaceAll("${entity.parent.path}\\", "");
            final newPath = "${parent.path}\\$entityFileName";
            await entity.rename(newPath);
          }
          final List<FileSystemEntity> listAfterMove = await Directory(finalOutputPath).list().toList();
          if (listAfterMove.isEmpty) {
            Directory(finalOutputPath).deleteSync();
          }
        }
      }

      // endregion <- Logic:多级解压合并同名目录 ->

      // endregion <- Logic:修改目录结构 ->

      // region <- Logic:删除解压成功的文件 ->
      // 删除解压成功的文件，dart 删除无法找回，所以解压前必须备份
      if (deleteOriginFile) {
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
  Future<String> executeExtract(
    String compressedFileDirectory,
    String compressedFileName,
    String outputPath,
    String password, {
    bool notArchive = false,
  }) async {
    try {
      List<String> args;

      if (notArchive) {
        args = ['x', '-t#', compressedFileName, "-o$outputPath", '-i!*.zip', "-p$password"];
      } else {
        args = ['x', '-y', compressedFileName, "-o$outputPath", "-p$password"];
      }

      // 执行的解压命令
      String command = '${FileUtils.executable_7z.path} x -y "$compressedFileName" -o"$outputPath" -p"$password"';
      logger.d(command);

      final result = await Process.run(FileUtils.executable_7z.path, args, runInShell: false, workingDirectory: compressedFileDirectory);

      // 获取退出状态码
      final exitCode = result.exitCode;
      final String errorMessage = result.stderr;
      logger.d(result.stdout);

      // 根据状态码处理结果
      if (exitCode == 0) {
        logger.d('解压成功');
        return "success";
      }

      if (errorMessage.contains("Wrong password") || errorMessage.contains("Empty file path")) {
        logger.d("解压密码:$password错误");
        logger.d(result.stderr);
        return "wrongPassword";
      }
      if (errorMessage.contains("Is not archive") && !notArchive) {
        return executeExtract(compressedFileDirectory, compressedFileName, outputPath, password, notArchive: true);
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
    try {
      // 获取 Box
      final box = Hive.box<ArchiveFilePasswordList>('ArchiveFilePasswordList');
      box.put('ArchiveFilePasswordList', ArchiveFilePasswordList(passwordList: passwordList)); // 对象
      return true;
    } catch (e) {
      return false;
    }
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


  // 使用 bandizip 进行解压
  Future<String> executeExtractBandiZip(String compressedFileDirectory,
      String compressedFileName,
      String outputPath,
      String password) async {
    try {
      List<String> args;

      args = ['x', '-y', '-p:$password', '-o:$outputPath', compressedFileName];

      logger.d('-o:"$compressedFileDirectory\\$outputPath"');
      logger.d('"$compressedFileDirectory\\$compressedFileName"');

      // 执行的解压命令
      String command = 'bz.exe x -y -p:"$password" -o:"$outputPath" "$compressedFileName"';
      logger.d(command);

      final result = await Process.run("bz.exe", args, runInShell: true, workingDirectory: compressedFileDirectory, stderrEncoding: utf8,stdoutEncoding: utf8);

      // 获取退出状态码
      final exitCode = result.exitCode;
      final String stderr = result.stderr;
      final String stdout =result.stdout;
      logger.d("┏━━━━━━━━━━━━━━━━result━━━━━━━━━━━━━━━━━━┓");
      logger.d(exitCode);
      logger.d(stderr);
      logger.d(stdout);
      logger.d("┗━━━━━━━━━━━━━━━━result━━━━━━━━━━━━━━━━━━┛");
      // 根据状态码处理结果
      if (exitCode == 0) {
        logger.d('解压成功');
        return "success";
      }

      if (stdout.contains("Invalid Password")) {
        logger.d("解压密码:$password错误");
        logger.d(result.stderr);
        return "wrongPassword";
      }

      throw Exception(stdout);
    } catch (e) {
      throw Exception(e);
    }
  }
}

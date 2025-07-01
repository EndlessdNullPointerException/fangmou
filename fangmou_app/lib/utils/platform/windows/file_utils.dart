import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import '../../constants/constants.dart';

class FileUtils {
  static late File executable_7z;

  static Future<void> initialize7z() async {
    // 获取应用文档目录
    final appDocDir = await getApplicationDocumentsDirectory();

    // 确定可执行文件路径
    final executablePath = Platform.isWindows ? '${appDocDir.path}\\7z.exe' : '${appDocDir.path}/7z';

    final executableFile = File(executablePath);

    // 首次启动时复制可执行文件
    if (!await executableFile.exists()) {
      // 从资源中加载
      final assetPath = Platform.isWindows ? 'assets/7zip/windows/7z.exe' : 'assets/7zip/linux/7z';

      final data = await rootBundle.load(assetPath);
      await executableFile.writeAsBytes(data.buffer.asUint8List(), flush: true);

      // Linux 需要执行权限
      if (Platform.isLinux) {
        await Process.run('chmod', ['+x', executablePath]);
      }
    }
    executable_7z = executableFile;
  }

  // 测试 7z 功能
  static Future<void> test7zFunctionality() async {
    try {
      final tempDir = await getTemporaryDirectory();

      final testDir = Directory('${tempDir.path}\\7z_test');

      if (await testDir.exists()) await testDir.delete(recursive: true);
      await testDir.create();

      // 被压缩文件
      final testFile = File('${testDir.path}\\test.txt');
      await testFile.writeAsString('7z功能测试内容');

      // 创建压缩文件
      final testZipPath = '${tempDir.path}\\test.zip';

      logger.d("tempDir.path:$tempDir.path");
      logger.d("testZipPath:$testZipPath");
      logger.d("testDirPath:${testDir.path}");

      List<String> args = ['a', testZipPath, testFile.path];

      final createResult = await Process.run(FileUtils.executable_7z.path, args);

      logger.d("执行命令:${FileUtils.executable_7z.path} ${args.join(" ")}");

      if (createResult.exitCode != 0) {
        throw Exception('测试压缩失败: ${createResult.stderr}');
      }

      final extractDir = Directory('${tempDir.path}/extracted');
      if (await extractDir.exists()) await extractDir.delete(recursive: true);
      await extractDir.create();

      final extractResult = await Process.run(FileUtils.executable_7z.path, ['x', testZipPath, '-o${extractDir.path}', '-y']);

      if (extractResult.exitCode != 0) {
        throw Exception('测试解压失败: ${extractResult.stderr}');
      }

      final extractedFile = File('${extractDir.path}/test.txt');
      if (!await extractedFile.exists()) {
        throw Exception('测试文件未找到');
      }

      final content = await extractedFile.readAsString();
      if (content != '7z功能测试内容') {
        throw Exception('文件内容验证失败');
      }

      await testDir.delete(recursive: true);
      await extractDir.delete(recursive: true);
      await File(testZipPath).delete();
    } catch (e) {
      throw Exception('7z功能测试失败: $e');
    }
  }

  // 生成随机的临时文件夹
  static String generateRandomTemporaryDirectory(File file) {
    final String temporaryPathParam = "${DateTime.now().millisecondsSinceEpoch}-${file.uri.toString().split('/').last}";
    return md5.convert(utf8.encode(temporaryPathParam)).toString();
  }

  // 获取指定路径下的所有子文件夹信息
  static Future<List<Directory>> getSubDirectories(String parentPath) async {
    final dir = Directory(parentPath);
    List<Directory> folders = [];

    try {
      // 列出目录内容（不递归）
      final entities = await dir.list().toList();

      for (var entity in entities) {
        if (entity is Directory) {
          folders.add(entity);
        }
      }
    } catch (e) {
      logger.e("获取目录失败: $e");
    }

    return folders;
  }
}

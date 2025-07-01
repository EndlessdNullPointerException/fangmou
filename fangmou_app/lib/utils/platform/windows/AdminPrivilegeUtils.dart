import 'dart:io';

import 'package:process_run/process_run.dart';
import 'package:win32/win32.dart';

import '../../constants/constants.dart';

class PlatformUtils {
  // 检查管理员权限
  static Future<bool> isWindowsAdmin() async {
    // 检查当前平台是否为 Windows
    if (!Platform.isWindows) {
      logger.e("此功能仅支持 Windows 平台");
      return false;
    }

    try {
      // 执行 PowerShell 命令
      final result = await run('powershell', [
        '-Command',
        r'$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator); Write-Output $isAdmin',
      ], verbose: false);

      // 解析输出结果
      final output = result.stdout.toString().trim();
      final isAdmin = output.toLowerCase() == 'true';

      logger.d(isAdmin ? "已获得管理员权限" : "未获得管理员权限");
      return isAdmin;
    } catch (e) {
      logger.e("检查失败: ${e.toString()}");
    }

    return false;
  }

  // 获取当前进程ID
  static int getCurrentProcessId() {
    return GetCurrentProcessId();
  }

  // 检查同名进程是否已在运行
  static bool isAlreadyRunning() {
    final currentPid = getCurrentProcessId();
    final processName = Platform.resolvedExecutable.split('\\').last.toLowerCase();

    try {
      final result = Process.runSync('tasklist', ['/FI', 'IMAGENAME eq $processName']);
      if (result.exitCode != 0) return false;

      final output = result.stdout.toString();
      final lines = output.split('\n');

      int count = 0;
      for (final line in lines) {
        if (line.toLowerCase().contains(processName)) {
          final pid = int.tryParse(line.split(RegExp(r'\s+'))[1] ?? '0');
          if (pid != currentPid) {
            count++;
            if (count >= 1) return true; // 发现其他进程实例
          }
        }
      }
    } catch (e) {
      logger.d('进程检查错误: $e');
    }
    return false;
  }
}

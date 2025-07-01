import 'package:flutter/services.dart';

class AdminChecker {
  static const MethodChannel _channel = MethodChannel('admin_checker');

  /// 检查当前程序是否以Windows管理员权限运行
  ///
  /// 返回值:
  ///   `true` - 程序以管理员权限运行
  ///   `false` - 程序没有管理员权限
  static Future<bool> isWindowsAdmin() async {
    try {
      final bool result = await _channel.invokeMethod('isWindowsAdmin');
      return result;
    } on PlatformException catch (e) {
      // 处理平台异常
      print("Failed to check admin status: ${e.message}");
      return false;
    }
  }
}
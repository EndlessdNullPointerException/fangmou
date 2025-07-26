// locator.dart
import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart'; // 用于时间格式化
import 'package:logger/logger.dart';

import '../data_source/local/note_local.dart';
import '../domain/use_cases/decompress_processor.dart';
import '../domain/use_cases/file_batch_processor.dart';
import '../utils/constants/constants.dart';

void setupDomainUserCase() {
  // region 文件处理
  getIt.registerLazySingleton<FileBatchProcessor>(() => FileBatchProcessor());
  getIt.registerLazySingleton<DecompressProcessor>(() => DecompressProcessor());
  // endregion

  // region  本地数据获取
  getIt.registerLazySingleton<NoteLocal>(
        () => NoteLocal(), // 使用异步工厂
  );
  // endregion

  // 注册全局导航键
  getIt.registerSingleton<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>(debugLabel: 'root'));
}

void setupLocator() {
  // 注册服务（示例）
  // getIt.registerSingleton<AuthService>(AuthService());
  // getIt.registerLazySingleton<ApiService>(() => ApiService());
  // getIt.registerFactory<DataModel>(() => DataModel());

  // 注册 Logger
  getIt.registerLazySingleton<Logger>(() => Logger(printer: CustomPrinter()));
}

// 自定义打印机（例如：添加时间戳）
class CustomPrinter extends LogPrinter {
  final bool colors; // 是否启用颜色
  final String tag; // 自定义标签

  CustomPrinter({this.colors = true, this.tag = 'APP'});

  @override
  List<String> log(LogEvent event) {
    // 1. 获取时间戳
    final time = DateFormat('HH:mm:ss.SSS').format(DateTime.now());

    // 2. 定义颜色
    final color = _getLevelColor(event.level);
    final message = event.message;

    // 3. 拼接日志内容
    final logLine = '$time [$tag] [${_getLevelString(event.level)}]: $message';

    // 4. 应用颜色（仅终端支持）
    return colors ? [color(logLine)] : [logLine];
  }

  // 获取日志级别对应的颜色
  AnsiPen _getLevelColor(Level level) {
    switch (level) {
      case Level.debug:
        return AnsiPen()..green();
      case Level.info:
        return AnsiPen()..blue();
      case Level.warning:
        return AnsiPen()..yellow();
      case Level.error:
        return AnsiPen()..red();
      default:
        return AnsiPen()..white();
    }
  }

  // 获取日志级别字符串
  String _getLevelString(Level level) {
    return level.toString().split('.').last.toUpperCase();
  }
}
